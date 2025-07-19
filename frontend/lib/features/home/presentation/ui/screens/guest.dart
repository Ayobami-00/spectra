import 'dart:convert';

import 'package:frontend/core/DI/di.dart';
import 'package:frontend/core/index.dart';
import 'package:frontend/features/session/data/models/message.dart';
import 'package:frontend/features/session/index.dart';
import 'package:frontend/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show window;

import '../widgets/shimmer.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'companion_mode.dart';
import 'guest.dart';
import 'package:frontend/core/app_event_tracking/app_event_tracking.dart';

class GuestScreenTheme {
  // Colors
  static const backgroundColor = Color(0xFF0A0A0A);
  static const cardBackgroundColor = Color(0xFF111111);
  static const inputBackgroundColor = Color(0xFF1A1A1A);
  static final borderColor = Colors.grey[850]!;
  static final accentColor = Colors.greenAccent[700]!;

  // Text Styles
  static final messageStyle = GoogleFonts.inter(
    fontSize: 16,
    height: 1.5,
    color: Colors.white,
  );

  static final hintStyle = GoogleFonts.inter(
    fontSize: 15,
    color: Colors.grey[500],
  );

  static final chipStyle = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: accentColor,
  );
}

class GuestScreen extends StatefulWidget {
  final String sessionId;
  final String message;

  const GuestScreen({
    super.key,
    required this.sessionId,
    required this.message,
  });

  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  final ValueNotifier<bool> _isCompanionMode = ValueNotifier(false);
  final TextEditingController _taskController = TextEditingController();
  final ValueNotifier<List<String>> _suggestedActions =
      ValueNotifier<List<String>>([]);
  final ValueNotifier<bool> _isAiTyping = ValueNotifier<bool>(false);
  final ValueNotifier<List<Message>> _messages =
      ValueNotifier<List<Message>>([]);
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isReceivingStream = ValueNotifier<bool>(false);
  late final String initialMessage;

  @override
  void initState() {
    super.initState();
    initialMessage = widget.message;
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    final sessionCubit = locator<SessionCubit>();
    final sessionId = widget.sessionId;

    // 1. Load previous messages
    await _loadMessages();
    if (!mounted) return;

    // 2. Connect to websocket
    await _connectWebSocketWithRetry(sessionCubit);
    if (!mounted) return;

    // 3. Set up websocket listener
    sessionCubit.webSocketService.stream?.listen((message) {
      print('message: $message');
      if (!mounted) return;
      _handleSocketMessage(message);
    });

    // 4. Send initial message if present
    if (initialMessage.isNotEmpty) {
      // Add message to UI immediately
      _messages.value = [
        Message(
          text: initialMessage,
          isUser: true,
          isComplete: true,
        ),
        ..._messages.value,
      ];

      // Send to websocket
      sessionCubit.webSocketService.sendMessage(
        jsonEncode(
          {
            "role": "assistant",
            "content": initialMessage,
          },
        ),
      );

      // Send via API
      await sessionCubit.createMessageLogic(
        sessionId: sessionId,
        content: initialMessage,
        role: AppConstants.userMessageRole,
      );

      // Clear the initial message from URL
      if (mounted) {
        final uri = Uri.parse(window.location.href);
        final newQueryParams = Map<String, String>.from(uri.queryParameters)
          ..remove('message');
        final newUri = uri.replace(queryParameters: newQueryParams);
        window.history.pushState({}, '', newUri.toString());
      }
    }
  }

  void _handleSocketMessage(String socketMessage) {
    if (!mounted) return;

    final data = jsonDecode(socketMessage);

    // Handle suggestions if the message has a type field
    if (data.containsKey('type') && data['type'] == 'suggestions') {
      AppEventTrackingAnalyticsService.logEvent('suggestions_received', {
        'count': data['suggestions']?.length ?? 0,
      });
      if (data['suggestions'] is List) {
        _suggestedActions.value = List<String>.from(data['suggestions']);
      }
      return; // Exit early as this was a suggestions message
    }

    // Handle regular chat messages (no type field)
    final message = Message.fromJson(data);

    // Handle stream end
    if (!message.isUser && message.text == "DONE") {
      _isReceivingStream.value = false;
      return;
    }

    final currentMessages = List<Message>.from(_messages.value);

    // Stream starts with an empty assistant message
    if (message.isUser) {
      // Add new user message at the beginning of the list
      currentMessages.insert(0, message);
      _isReceivingStream.value = false;
    } else if (!message.isUser &&
        message.text.isEmpty &&
        !_isReceivingStream.value) {
      _isReceivingStream.value = true;
      currentMessages.insert(
        0,
        Message(
          text: '',
          isUser: false,
          isComplete: false,
        ),
      );
    } else if (!message.isUser && _isReceivingStream.value) {
      // Append to existing message
      if (currentMessages.isNotEmpty) {
        currentMessages[0] = Message(
          text: currentMessages[0].text + message.text,
          isUser: false,
          isComplete: false,
        );
      }
    } else if (message.isUser) {
      _isReceivingStream.value = false;
      if (currentMessages.isNotEmpty) {
        currentMessages[0] = Message(
          text: currentMessages[0].text + message.text,
          isUser: true,
          isComplete: false,
        );
      }
    }

    _messages.value = currentMessages;

    Future.delayed(const Duration(seconds: 2), () {
      if (data.containsKey('has_reached_limit') &&
          data['has_reached_limit'] == true) {
        if (_isCompanionMode.value) {
          _isCompanionMode.value = false;
        }
      }
    });
  }

  Future<void> _connectWebSocketWithRetry(SessionCubit sessionCubit,
      [int retryCount = 0]) async {
    try {
      if (!sessionCubit.webSocketService.isConnected) {
        sessionCubit.webSocketService.connect(widget.sessionId);
      }
    } catch (e) {
      if (mounted && retryCount < 3) {
        // Retry up to 3 times
        await Future.delayed(Duration(
            seconds: math.pow(2, retryCount).toInt())); // Exponential backoff
        _connectWebSocketWithRetry(sessionCubit, retryCount + 1);
      }
    }
  }

  @override
  void dispose() {
    final sessionCubit = locator<SessionCubit>();
    sessionCubit.disconnectWebSocket();
    _suggestedActions.dispose();
    _isAiTyping.dispose();
    _messages.dispose();
    _taskController.dispose();
    _isLoading.dispose();
    _isReceivingStream.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    _isLoading.value = true;
    final sessionCubit = locator<SessionCubit>();
    final messages = await sessionCubit.getMessagesLogic(widget.sessionId);

    if (!mounted) return;

    _messages.value = messages
        .map((msg) => Message(
              text: msg.content,
              isUser: msg.role.toLowerCase() == 'user',
            ))
        .toList();

    _isLoading.value = false;
  }

  void _startAiResponse() async {
    _isAiTyping.value = true;

    final sessionCubit = locator<SessionCubit>();
    final success = await sessionCubit.createMessageLogic(
      sessionId: widget.sessionId,
      content: _taskController.text,
      role: 'user',
    );

    if (success && mounted) {
      _isAiTyping.value = false;
      _taskController.clear();
      // No need to manually load messages as they'll come through WebSocket
    }
  }

  void _updateSuggestedActions(String text) {
    _suggestedActions.value = text.isEmpty
        ? []
        : [
            'Export to PDF',
            'Create quick flashcards',
            'Send summary to mail',
            'Export to DOC',
          ];
  }

  void _handleChipDismiss(String action) {
    final currentActions = List<String>.from(_suggestedActions.value);
    currentActions.remove(action);
    _suggestedActions.value = currentActions;

    AppEventTrackingAnalyticsService.logEvent('suggestion_dismissed', {
      'action': action,
    });

    // Add a new suggestion after a delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        final currentActions = List<String>.from(_suggestedActions.value);
        final newSuggestion = _getNewSuggestion();
        if (newSuggestion != null) {
          currentActions.add(newSuggestion);
          _suggestedActions.value = currentActions;
        }
      }
    });
  }

  void _handleActionSelected(String action) {
    _taskController.text = action;
    _taskController.selection = TextSelection.fromPosition(
      TextPosition(offset: _taskController.text.length),
    );

    AppEventTrackingAnalyticsService.logEvent('suggestion_selected', {
      'action': action,
    });

    locator<NavigationService>().goNamed(pricingRoute);

    final currentActions = List<String>.from(_suggestedActions.value);
    currentActions.remove(action);

    if (currentActions.length < 5) {
      if (action.toLowerCase().contains('flashcard')) {
        currentActions.addAll([
          'Create practice questions from these flashcards',
          'Share these flashcards with your study group',
          'Schedule a review session with these cards',
        ]);
      } else if (action.toLowerCase().contains('quiz')) {
        currentActions.addAll([
          'Set a reminder for this quiz',
          'Share this quiz with classmates',
          'Create a study guide for this quiz',
        ]);
      } else if (action.toLowerCase().contains('study')) {
        currentActions.addAll([
          'Create a checklist for this study session',
          'Set up recurring study reminders',
          'Share study materials with the group',
        ]);
      }
    }
    _suggestedActions.value = currentActions;
  }

  void _handleSendMessage(String text) async {
    final sessionCubit = locator<SessionCubit>();
    // Handle voice messages
    if (text.startsWith('[VOICE_')) {
      final isAgentVoice = text.startsWith('[VOICE_AGENT]');

      final messageContent = text
          .replaceAll('[VOICE_AGENT]', '')
          .replaceAll('[VOICE_USER]', '')
          .trim();

      // // Send to websocket with appropriate role
      // sessionCubit.webSocketService.sendMessage(
      //   jsonEncode({
      //     "role": isAgentVoice ? "assistant" : "user",
      //     "content": text,
      //     "created_at": DateTime.now().toIso8601String(),
      //   }),
      // );

      // Send via API with appropriate role
      sessionCubit.createMessageLogic(
        sessionId: widget.sessionId,
        content: messageContent,
        role: isAgentVoice
            ? AppConstants.assistantMessageRole
            : AppConstants.userMessageRole,
      );
      return;
    }

    if (text.trim().isEmpty || _isReceivingStream.value) return;

    AppEventTrackingAnalyticsService.logEvent('message_sent', {
      'length': text.length,
    });

    if (text.trim().isEmpty || _isReceivingStream.value) return;

    // if (text == "KEEP_ALIVE") {
    //   sessionCubit.webSocketService.sendMessage("KEEP_ALIVE");
    //   return;
    // }

    // Handle regular messages (non-voice)
    _messages.value = [
      Message(
        text: text,
        isUser: true,
        isComplete: true,
      ),
      ..._messages.value,
    ];

    // Send to websocket
    sessionCubit.webSocketService.sendMessage(
      jsonEncode({
        "role": "user",
        "content": text,
        "created_at": DateTime.now().toIso8601String(),
      }),
    );

    // Send via API
    sessionCubit.createMessageLogic(
      sessionId: widget.sessionId,
      content: text,
      role: AppConstants.userMessageRole,
    );

    // Clear the text field
    _taskController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 900;

    return Scaffold(
      backgroundColor: GuestScreenTheme.backgroundColor,
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: _isCompanionMode,
          builder: (context, isCompanion, _) {
            if (isCompanion) {
              return CompanionModeScreen(
                sessionId: widget.sessionId,
                messages: _messages,
                isReceivingStream: _isReceivingStream,
                onModeToggle: () => _isCompanionMode.value = false,
                onMessageSent: _handleSendMessage,
              );
            }

            return Row(
              children: [
                if (!isSmallScreen)
                  SizedBox(
                    width: 300,
                    child: _buildSidebar(),
                  ),
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          AppBar(
                            backgroundColor:
                                GuestScreenTheme.cardBackgroundColor,
                            elevation: 0,
                            toolbarHeight: 56,
                            leading: isSmallScreen
                                ? IconButton(
                                    icon: const Icon(Icons.arrow_back,
                                        color: Colors.white),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  )
                                : null,
                            actions: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey[800]!,
                                    width: 1,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () => _isCompanionMode.value = true,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.smart_toy_outlined,
                                        size: 16,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Switch to Companion Mode',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              InkWell(
                                onTap: () {
                                  locator<NavigationService>()
                                      .goNamed(pricingRoute);
                                  AppEventTrackingAnalyticsService.logEvent(
                                    'pricing_nav_clicked',
                                    {'source': 'app_bar'},
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.grey[800]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.workspace_premium_rounded,
                                        size: 16,
                                        color: GuestScreenTheme.accentColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Upgrade',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: GuestScreenTheme.accentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              VerticalDivider(
                                color: Colors.grey[850],
                              ),
                              TextButton(
                                onPressed: () {
                                  locator<NavigationService>()
                                      .goNamed(pricingRoute);
                                  AppEventTrackingAnalyticsService.logEvent(
                                    'pricing_nav_clicked',
                                    {'source': 'login_button'},
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 16 : 24,
                                    vertical: 8,
                                  ),
                                ),
                                child: Text(
                                  'Log in',
                                  style: GoogleFonts.inter(
                                    fontSize: isSmallScreen ? 13 : 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: isSmallScreen ? 8.0 : 16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: GuestScreenTheme.accentColor,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: GuestScreenTheme.accentColor
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      locator<NavigationService>()
                                          .goNamed(pricingRoute);
                                      AppEventTrackingAnalyticsService.logEvent(
                                        'pricing_nav_clicked',
                                        {'source': 'signup_button'},
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isSmallScreen ? 16 : 24,
                                        vertical: 8,
                                      ),
                                    ),
                                    child: Text(
                                      'Sign up',
                                      style: GoogleFonts.inter(
                                        fontSize: isSmallScreen ? 13 : 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      isSmallScreen ? double.infinity : 800,
                                ),
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: _isLoading,
                                  builder: (context, isLoading, _) {
                                    if (isLoading) {
                                      return ListView.builder(
                                        reverse: true,
                                        padding: EdgeInsets.only(
                                          left: isSmallScreen ? 16 : 24,
                                          right: isSmallScreen ? 16 : 24,
                                          top: 16,
                                          bottom:
                                              _suggestedActions.value.isEmpty
                                                  ? 80
                                                  : 180,
                                        ),
                                        itemCount: 5,
                                        itemBuilder: (context, index) =>
                                            index.isEven
                                                ? _buildUserMessageShimmer()
                                                : _buildMessageShimmer(),
                                      );
                                    }
                                    return ValueListenableBuilder<
                                        List<Message>>(
                                      valueListenable: _messages,
                                      builder: (context, messages, _) {
                                        return ValueListenableBuilder<bool>(
                                          valueListenable: _isAiTyping,
                                          builder: (context, isTyping, _) {
                                            return ListView.builder(
                                              reverse: true,
                                              padding: EdgeInsets.only(
                                                left: isSmallScreen ? 16 : 24,
                                                right: isSmallScreen ? 16 : 24,
                                                top: 16,
                                                bottom: _suggestedActions
                                                        .value.isEmpty
                                                    ? 170
                                                    : 220,
                                              ),
                                              itemCount: messages.length +
                                                  (isTyping ? 1 : 0),
                                              itemBuilder: (context, index) {
                                                if (index == 0 && isTyping) {
                                                  return _buildAiTypingIndicator(
                                                      isSmallScreen);
                                                }
                                                final messageIndex = isTyping
                                                    ? index - 1
                                                    : index;
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 24),
                                                  child: _buildMessage(
                                                      messages[messageIndex],
                                                      isSmallScreen),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: ValueListenableBuilder<List<String>>(
                          valueListenable: _suggestedActions,
                          builder: (context, suggestedActions, _) {
                            return _buildBottomSection(isSmallScreen);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: GuestScreenTheme.cardBackgroundColor,
              border: Border(
                right: BorderSide(
                  color: GuestScreenTheme.borderColor.withOpacity(0.5),
                  width: 1,
                ),
                bottom: BorderSide(
                  color: GuestScreenTheme.borderColor.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Recent Chats',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: GuestScreenTheme.accentColor,
                    size: 20,
                  ),
                  onPressed: () {
                    locator<NavigationService>().goNamed(pricingRoute);
                    AppEventTrackingAnalyticsService.logEvent(
                      'pricing_nav_clicked',
                      {'source': 'new_chat_button'},
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: GuestScreenTheme.cardBackgroundColor,
                border: Border(
                  right: BorderSide(
                    color: GuestScreenTheme.borderColor.withOpacity(0.5),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(Conversation conversation) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: conversation.isActive
                ? GuestScreenTheme.accentColor.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: conversation.isActive
                  ? GuestScreenTheme.accentColor.withOpacity(0.2)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      conversation.title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: conversation.isActive
                            ? GuestScreenTheme.accentColor
                            : Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    _formatTimestamp(conversation.timestamp),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                conversation.lastMessage,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey[400],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

  Widget _buildMessage(Message message, bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: message.isUser
                  ? GuestScreenTheme.accentColor.withOpacity(0.1)
                  : GuestScreenTheme.cardBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: message.isUser
                    ? GuestScreenTheme.accentColor.withOpacity(0.2)
                    : GuestScreenTheme.borderColor,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Icon(
                message.isUser
                    ? Icons.person_outline
                    : Icons.smart_toy_outlined,
                size: 20,
                color: message.isUser
                    ? GuestScreenTheme.accentColor
                    : Colors.white.withOpacity(0.9),
              ),
            ),
          ),
          Expanded(
            child: SelectionArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: message.isUser
                      ? GuestScreenTheme.accentColor.withOpacity(0.08)
                      : GuestScreenTheme.cardBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(24),
                    topRight: const Radius.circular(24),
                    bottomLeft: Radius.circular(message.isUser ? 24 : 4),
                    bottomRight: Radius.circular(message.isUser ? 4 : 24),
                  ),
                  border: Border.all(
                    color: message.isUser
                        ? GuestScreenTheme.accentColor.withOpacity(0.15)
                        : GuestScreenTheme.borderColor.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: message.isUser
                    ? Text(
                        message.text,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          height: 1.6,
                          color: message.isUser
                              ? GuestScreenTheme.accentColor.withOpacity(0.9)
                              : Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : MarkdownBody(
                        data: message.text,
                        styleSheet: MarkdownStyleSheet(
                          // Paragraph text
                          p: GoogleFonts.inter(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w400,
                          ),

                          // Headers
                          h1: GoogleFonts.inter(
                            fontSize: 24,
                            height: 1.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          h2: GoogleFonts.inter(
                            fontSize: 20,
                            height: 1.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          h3: GoogleFonts.inter(
                            fontSize: 18,
                            height: 1.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          h4: GoogleFonts.inter(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),

                          // Inline code
                          code: GoogleFonts.firaCode(
                            fontSize: 14,
                            color: Colors.white,
                            backgroundColor: Colors.black.withOpacity(0.3),
                          ),

                          // Code blocks
                          codeblockDecoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey[850]!,
                              width: 1,
                            ),
                          ),
                          codeblockPadding: const EdgeInsets.all(16),

                          // Blockquotes
                          blockquote: GoogleFonts.inter(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.grey[400],
                            fontStyle: FontStyle.italic,
                          ),
                          blockquoteDecoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.grey[700]!,
                                width: 4,
                              ),
                            ),
                          ),
                          blockquotePadding: const EdgeInsets.only(left: 16),

                          // Lists
                          listBullet: GoogleFonts.inter(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          listIndent: 24,

                          // Links
                          a: GoogleFonts.inter(
                            fontSize: 15,
                            height: 1.6,
                            color: GuestScreenTheme.accentColor,
                            decoration: TextDecoration.underline,
                          ),

                          // Emphasis (italic)
                          em: GoogleFonts.inter(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.white.withOpacity(0.9),
                            fontStyle: FontStyle.italic,
                          ),

                          // Strong (bold)
                          strong: GoogleFonts.inter(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(width: message.isUser ? 60 : 20),
        ],
      ),
    );
  }

  Widget _buildAiTypingIndicator(bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: GuestScreenTheme.cardBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: GuestScreenTheme.borderColor,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.smart_toy_outlined,
                size: 20,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: GuestScreenTheme.cardBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(24),
              ),
              border: Border.all(
                color: GuestScreenTheme.borderColor.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: GuestScreenTheme.accentColor.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _buildBottomSection(bool isSmallScreen) {
    final horizontalPadding = isSmallScreen ? 12.0 : 16.0;

    return ValueListenableBuilder<bool>(
      valueListenable: _isReceivingStream,
      builder: (context, isReceiving, child) {
        return Container(
          decoration: BoxDecoration(
            color: GuestScreenTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: horizontalPadding,
                        right: horizontalPadding,
                        top: 16,
                        bottom: 16,
                      ),
                      child: Hero(
                        tag: 'chat-input',
                        flightShuttleBuilder: (
                          BuildContext flightContext,
                          Animation<double> animation,
                          HeroFlightDirection flightDirection,
                          BuildContext fromHeroContext,
                          BuildContext toHeroContext,
                        ) {
                          return AnimatedBuilder(
                            animation: animation,
                            child: toHeroContext.widget,
                            builder: (context, child) {
                              return Material(
                                color: Colors.transparent,
                                child: child,
                              );
                            },
                          );
                        },
                        child: Material(
                          color: Colors.transparent,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    textInputAction: TextInputAction.done,
                                    controller: _taskController,
                                    onSubmitted: (_) => _handleSendMessage(
                                        _taskController.text),
                                    enabled: !isReceiving,
                                    style:
                                        GuestScreenTheme.messageStyle.copyWith(
                                      fontSize: isSmallScreen ? 14 : 15,
                                      color: isReceiving
                                          ? Colors.grey
                                          : Colors.white,
                                    ),
                                    cursorColor: GuestScreenTheme.accentColor,
                                    minLines: 1,
                                    maxLines: 4,
                                    onChanged: _updateSuggestedActions,
                                    decoration: InputDecoration(
                                      hintText: 'Message Spectra...',
                                      hintStyle:
                                          GuestScreenTheme.hintStyle.copyWith(
                                        fontSize: isSmallScreen ? 14 : 15,
                                      ),
                                      filled: true,
                                      fillColor:
                                          GuestScreenTheme.cardBackgroundColor,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: GuestScreenTheme.borderColor
                                              .withOpacity(0.1),
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: GuestScreenTheme.accentColor
                                              .withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.all(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    color: GuestScreenTheme.accentColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    onPressed: isReceiving
                                        ? null
                                        : () => _handleSendMessage(
                                            _taskController.text),
                                    icon: const Icon(Icons.send_rounded),
                                    color: Colors.white,
                                    iconSize: isSmallScreen ? 18 : 20,
                                    padding: const EdgeInsets.all(8),
                                    constraints: const BoxConstraints(
                                      minWidth: 40,
                                      minHeight: 40,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_suggestedActions.value.isNotEmpty) ...[
                  AnimatedSlide(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    offset: _suggestedActions.value.isEmpty
                        ? const Offset(0, 1)
                        : Offset.zero,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _suggestedActions.value.isEmpty ? 0 : 1,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Container(
                            height: isSmallScreen ? 100 : 120,
                            padding: EdgeInsets.fromLTRB(
                                horizontalPadding, 2, horizontalPadding, 8),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: _suggestedActions.value
                                    .take(6)
                                    .map((action) =>
                                        _buildActionChip(action, isSmallScreen))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String? _getNewSuggestion() {
    // final allPossibleSuggestions = [
    //   'Create a new project timeline',
    //   'Set up automated notifications',
    //   'Generate a progress report',
    //   'Schedule a team sync',
    //   'Create a task checklist',
    //   'Set up email reminders',
    //   'Generate analytics dashboard',
    //   'Create a shared workspace',
    //   'Set milestone deadlines',
    //   'Export data as spreadsheet',
    //   'Create presentation slides',
    //   'Schedule recurring meetings',
    //   'Generate performance metrics',
    //   'Create workflow automation',
    //   'Set up task dependencies',
    //   // Add more suggestions here
    // ];

    final allPossibleSuggestions = [
      'Export to PDF',
      'Create quick flashcards',
      'Send summary to mail',
      'Export to DOC',
    ];

    // Filter out suggestions that are already showing
    final availableSuggestions = allPossibleSuggestions
        .where((suggestion) => !_suggestedActions.value.contains(suggestion))
        .toList();

    if (availableSuggestions.isEmpty) return null;

    // Return a random suggestion
    return availableSuggestions[
        math.Random().nextInt(availableSuggestions.length)];
  }

  Widget _buildActionChip(String action, bool isSmallScreen) {
    return IntrinsicWidth(
      child: InkWell(
        onTap: () => _handleActionSelected(action),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: GuestScreenTheme.accentColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: GuestScreenTheme.accentColor.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  action,
                  style: GoogleFonts.inter(
                    color: GuestScreenTheme.accentColor.withOpacity(0.9),
                    fontSize: isSmallScreen ? 12 : 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _handleChipDismiss(action),
                child: Icon(
                  Icons.close_rounded,
                  size: 12,
                  color: GuestScreenTheme.accentColor.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: GuestScreenTheme.cardBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: GuestScreenTheme.borderColor,
                width: 1.5,
              ),
            ),
            child: const ShimmerEffect(),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              height: 100,
              decoration: BoxDecoration(
                color: GuestScreenTheme.cardBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(24),
                ),
                border: Border.all(
                  color: GuestScreenTheme.borderColor.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: GuestScreenTheme.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const ShimmerEffect(),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 16,
                    width: 200,
                    decoration: BoxDecoration(
                      color: GuestScreenTheme.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const ShimmerEffect(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _buildUserMessageShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: GuestScreenTheme.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: GuestScreenTheme.accentColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: const ShimmerEffect(),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              height: 80,
              decoration: BoxDecoration(
                color: GuestScreenTheme.accentColor.withOpacity(0.08),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(4),
                ),
                border: Border.all(
                  color: GuestScreenTheme.accentColor.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 150,
                    decoration: BoxDecoration(
                      color: GuestScreenTheme.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const ShimmerEffect(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 60),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isUser;
  final bool isComplete;

  const Message({
    required this.text,
    required this.isUser,
    this.isComplete = true,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['content'] ?? '',
      isUser: json['role'] == 'user',
    );
  }
}

class Conversation {
  final String title;
  final String lastMessage;
  final DateTime timestamp;
  final bool isActive;

  const Conversation({
    required this.title,
    required this.lastMessage,
    required this.timestamp,
    required this.isActive,
  });
}
