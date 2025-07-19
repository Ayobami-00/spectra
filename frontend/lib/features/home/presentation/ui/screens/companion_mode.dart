import 'dart:async';

import 'package:frontend/core/index.dart';
import 'package:frontend/features/session/presentation/logic/session_cubit.dart';
import 'package:frontend/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:livekit_client/src/core/room.dart';

import 'guest.dart';

class CompanionModeScreen extends StatefulWidget {
  final String sessionId;
  final ValueNotifier<List<Message>> messages;
  final ValueNotifier<bool> isReceivingStream;
  final VoidCallback onModeToggle;
  final Function(String) onMessageSent;
  final TextEditingController _messageController = TextEditingController();

  CompanionModeScreen({
    super.key,
    required this.sessionId,
    required this.messages,
    required this.isReceivingStream,
    required this.onModeToggle,
    required this.onMessageSent,
  });

  @override
  State<CompanionModeScreen> createState() => _CompanionModeScreenState();
}

class _CompanionModeScreenState extends State<CompanionModeScreen>
    with AutomaticKeepAliveClientMixin {
  late final Room _room;
  final ValueNotifier<LocalVideoTrack?> _screenShareTrack =
      ValueNotifier<LocalVideoTrack?>(null);
  LocalAudioTrack? _audioTrack;
  EventsListener<RoomEvent>? _roomListener;
  final ValueNotifier<bool> _isMuted = ValueNotifier<bool>(false);
  Timer? _keepAliveTimer;
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  bool _isFirstTranscription = true;
  String? _currentSpeaker;
  String _currentText = '';

  @override
  void initState() {
    super.initState();
    _initRoom();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _startKeepAliveTimer();
    });
  }

  String _formatMarkdownText(String rawText) {
    List<String> lines = rawText.split('\n');
    StringBuffer formattedMarkdown = StringBuffer();
    bool inCodeBlock = false;
    bool inParagraph = false;

    for (String line in lines) {
      line = line.trim();

      // Handle code block start/end with triple backticks
      if (line.startsWith('```')) {
        inCodeBlock = !inCodeBlock;
        if (inParagraph) {
          formattedMarkdown.writeln(); // Add newline before code block
          inParagraph = false;
        }
        formattedMarkdown.writeln(line);
        continue;
      }

      // If we're in a code block, preserve exact formatting
      if (inCodeBlock) {
        formattedMarkdown.writeln(line);
        continue;
      }

      // Handle headers (OpenAI often uses these for section breaks)
      if (line.startsWith('#')) {
        if (inParagraph) {
          formattedMarkdown.writeln('\n'); // Add extra newline before header
          inParagraph = false;
        }
        formattedMarkdown.writeln('$line\n');
      }
      // Handle numbered lists (common in OpenAI's structured responses)
      else if (RegExp(r'^\d+\.\s').hasMatch(line)) {
        if (inParagraph) {
          formattedMarkdown.writeln('\n');
          inParagraph = false;
        }
        formattedMarkdown.writeln('$line\n');
      }
      // Handle bullet points
      else if (line.startsWith('-')) {
        if (inParagraph) {
          formattedMarkdown.writeln('\n');
          inParagraph = false;
        }
        formattedMarkdown.writeln('$line\n');
      }
      // Handle inline code (often used for function names or short code snippets)
      else if (line.contains('`')) {
        formattedMarkdown.write(line);
        if (line.endsWith('`')) {
          formattedMarkdown.writeln();
        }
        inParagraph = true;
      }
      // Handle regular text (from STT transcription)
      else if (line.isNotEmpty) {
        if (!inParagraph && formattedMarkdown.isNotEmpty) {
          formattedMarkdown
              .writeln(); // Add newline before starting new paragraph
        }
        formattedMarkdown.write(line);
        formattedMarkdown.write(' '); // Add space between joined lines
        inParagraph = true;
      }
      // Handle empty lines (natural pauses in speech)
      else if (line.isEmpty && inParagraph) {
        formattedMarkdown.writeln('\n');
        inParagraph = false;
      }
    }

    return formattedMarkdown.toString().trimRight();
  }

  void _initRoom() {
    _room = Room();
    _roomListener = _room.createListener()
      ..on<ParticipantConnectedEvent>((event) {
        print('Agent joined: ${event.participant.identity}');
      })
      ..on<TrackSubscribedEvent>((event) {
        if (event.track is AudioTrack) {
          print('Agent audio connected');
        }
      })
      ..on<TranscriptionEvent>((event) {
        // Only process if the segment is final
        if (!event.segments.first.isFinal) return;

        final identity = event.participant.identity;
        var text = _formatMarkdownText(event.segments.first.text);
        final isAgent = identity.startsWith('agent-');
        final messagePrefix = isAgent ? '[VOICE_AGENT]' : '[VOICE_USER]';

        final lastMessage = widget.messages.value.isNotEmpty
            ? widget.messages.value.first
            : null;

        // Check if speaker has changed
        if (_currentSpeaker != identity) {
          // Send previous speaker's complete message if exists
          if (_currentText.isNotEmpty) {
            final prevPrefix = _currentSpeaker?.startsWith('agent-') == true
                ? '[VOICE_AGENT]'
                : '[VOICE_USER]';
            widget.onMessageSent('$prevPrefix $_currentText');
          }
          _currentSpeaker = identity;
          _currentText = text;
        } else {
          _currentText = '$_currentText $text';
        }

        if (!_isFirstTranscription &&
            lastMessage != null &&
            ((isAgent && !lastMessage.isUser) ||
                (!isAgent && lastMessage.isUser))) {
          // Append to existing message (for both agent and user)
          final updatedMessages = List<Message>.from(widget.messages.value);
          final updatedText = '${lastMessage.text} $text';
          updatedMessages[0] = Message(
            text: updatedText,
            isUser: !isAgent,
            isComplete: true,
          );
          widget.messages.value = updatedMessages;
        } else {
          // Create new message (for both agent and user)
          final newMessage = Message(
            text: text,
            isUser: !isAgent,
            isComplete: true,
          );
          widget.messages.value = [newMessage, ...widget.messages.value];
          _isFirstTranscription = false;
        }
      });
  }

  void _startKeepAliveTimer() {
    // Cancel existing timer if any
    _keepAliveTimer?.cancel();

    // Start new timer
    _keepAliveTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        print("Sending keep alive"); // Debug print
        widget.onMessageSent("KEEP_ALIVE");
      }
    });
  }

  Future<void> _handleScreenShare() async {
    try {
      AppEventTrackingAnalyticsService.logEvent('screen_share_started');
      _isLoading.value = true;

      if (true) {
        final token = await locator<SessionCubit>()
            .createSessionTokenLogic(widget.sessionId);

        if (token == AppConstants.maxMessagesReachedMessage) {
          widget.onModeToggle();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppConstants.maxMessagesReachedMessage),
              ),
            );
          }
          return;
        }

        if (token != null) {
          await _room.connect(
            "wss://assignme-eg0qc8no.livekit.cloud",
            token,
          );
        }
      }

      final track = await LocalVideoTrack.createScreenShareTrack(
        const ScreenShareCaptureOptions(
          params: VideoParameters(
            dimensions: VideoDimensionsPresets.h720_169,
          ),
        ),
      );

      // Add listener for when screen sharing is stopped externally
      track.addListener(() {
        if (!track.isActive && mounted) {
          _handleStopSharing(track);
        }
      });

      // Then enable microphone
      await _room.localParticipant?.setMicrophoneEnabled(true);

      // Publish screen share track
      await _room.localParticipant?.publishVideoTrack(track);

      _screenShareTrack.value = track;
      widget.isReceivingStream.value = true;

      // Ensure timer is running after screen share starts
      // _startKeepAliveTimer();
    } catch (error) {
      AppEventTrackingAnalyticsService.logEvent('screen_share_error', {
        'error': error.toString(),
      });
      print('Screen share error: $error');
      widget.isReceivingStream.value = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error.toString()}')),
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _handleStopSharing(LocalVideoTrack track) async {
    AppEventTrackingAnalyticsService.logEvent('screen_share_stopped');
    await track.stop();
    await track.dispose();
    _screenShareTrack.value = null;
    widget.isReceivingStream.value = false;
    widget.onModeToggle();
  }

  @override
  void dispose() {
    // Send final message if exists
    if (_currentText.isNotEmpty && _currentSpeaker != null) {
      final prefix = _currentSpeaker?.startsWith('agent-') == true
          ? '[VOICE_AGENT]'
          : '[VOICE_USER]';
      widget.onMessageSent('$prefix $_currentText');
    }
    print("Disposing companion mode"); // Debug print
    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;
    widget.isReceivingStream.value = false;
    _roomListener?.dispose();
    _screenShareTrack.value?.dispose();
    _room.disconnect().then((_) => _room.dispose());
    _isMuted.dispose();
    _screenShareTrack.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[850]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Companion Mode',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          // Mode Toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey[800]!,
                width: 1,
              ),
            ),
            child: InkWell(
              onTap: widget.onModeToggle,
              borderRadius: BorderRadius.circular(20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Switch to Chat Mode',
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
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey[850]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget._messageController,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                filled: true,
                fillColor: const Color(0xFF111111),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey[850]!,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.greenAccent[700]!.withOpacity(0.5),
                    width: 1,
                  ),
                ),
              ),
              onSubmitted: (text) {
                if (text.isNotEmpty) {
                  widget.onMessageSent(text);
                  widget._messageController.clear();
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              if (widget._messageController.text.isNotEmpty) {
                widget.onMessageSent(widget._messageController.text);
                widget._messageController.clear();
              }
            },
            icon: const Icon(Icons.send_rounded),
            color: Colors.greenAccent[700],
          ),
        ],
      ),
    );
  }

  Widget _buildActionArea() {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isReceivingStream,
      builder: (context, isReceiving, _) {
        return Stack(
          children: [
            RepaintBoundary(
              child: Container(
                child: _screenShareTrack.value != null
                    ? Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: VideoTrackRenderer(
                          _screenShareTrack.value!,
                          fit: RTCVideoViewObjectFit
                              .RTCVideoViewObjectFitContain,
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                    Colors.greenAccent[700]!.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.handshake_outlined,
                                size: 32,
                                color:
                                    Colors.greenAccent[700]!.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Share Your Context',
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Let Spectra see what you\'re working on to provide better assistance',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.grey[400],
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 32),
                            ValueListenableBuilder<bool>(
                              valueListenable: _isLoading,
                              builder: (context, isLoading, child) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent[700]!
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.greenAccent[700]!
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap:
                                          isLoading ? null : _handleScreenShare,
                                      borderRadius: BorderRadius.circular(8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isLoading)
                                            SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Colors.greenAccent[700]!,
                                                ),
                                              ),
                                            )
                                          else
                                            Icon(
                                              Icons.add_circle_outline,
                                              size: 16,
                                              color: Colors.greenAccent[700],
                                            ),
                                          const SizedBox(width: 8),
                                          Text(
                                            isLoading
                                                ? 'Connecting...'
                                                : 'Share Context',
                                            style: GoogleFonts.inter(
                                              color: Colors.greenAccent[700],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 32),
                            // Text(
                            //   'Your shared context helps Spectra understand and assist better',
                            //   textAlign: TextAlign.center,
                            //   style: GoogleFonts.inter(
                            //     fontSize: 13,
                            //     color: Colors.grey[600],
                            //   ),
                            // ),
                            // const SizedBox(height: 12),
                            Text(
                              'Tip: Zoom in to your screen for better assistance. Response times may vary based on connection.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
              ),
            ),
            if (_screenShareTrack.value != null) ...[
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  onPressed: () async {
                    await _screenShareTrack.value?.stop();
                    await _screenShareTrack.value?.dispose();
                    _screenShareTrack.value = null;
                    widget.isReceivingStream.value = false;
                    widget.onModeToggle();
                  },
                  icon: const Icon(Icons.stop_circle_outlined),
                  color: Colors.red[400],
                  tooltip: 'Stop sharing',
                ),
              ),
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey[850]!,
                        width: 1,
                      ),
                    ),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isMuted,
                      builder: (context, isMuted, _) {
                        AppEventTrackingAnalyticsService.logEvent(
                            'voice_state_changed', {
                          'is_muted': isMuted,
                        });
                        return IconButton(
                          onPressed: () async {
                            final enabled = await _room.localParticipant
                                ?.setMicrophoneEnabled(isMuted);
                            _isMuted.value = !isMuted;
                          },
                          icon: Icon(
                            isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                            size: 28,
                          ),
                          color: isMuted
                              ? Colors.red[400]
                              : Colors.greenAccent[700],
                          tooltip: isMuted ? 'Unmute' : 'Mute',
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Material(
      child: Container(
        color: GuestScreenTheme.backgroundColor,
        child: Row(
          children: [
            // Action Area (Left side)
            Expanded(
              flex: 7,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  border: Border(
                    right: BorderSide(
                      color: Colors.grey[850]!,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: _buildActionArea(),
                    ),
                  ],
                ),
              ),
            ),
            // Chat Area (Right side)
            Expanded(
              flex: 3,
              child: Container(
                color: const Color(0xFF0A0A0A),
                child: Column(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<List<Message>>(
                        valueListenable: widget.messages,
                        builder: (context, messageList, _) {
                          return ListView.builder(
                            reverse: true,
                            padding: const EdgeInsets.all(16),
                            itemCount: messageList.length,
                            itemBuilder: (context, index) {
                              final message = messageList[index];
                              if (message.text == "KEEP_ALIVE")
                                return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: message.isUser
                                    ? _buildUserMessage(message)
                                    : _buildAIMessage(message),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    _buildChatInput(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserMessage(Message message) {
    return Align(
      alignment: Alignment.centerRight,
      child: SelectionArea(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.greenAccent[700]!.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.greenAccent[700]!.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            message.text,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAIMessage(Message message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SelectionArea(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: GuestScreenTheme.cardBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[850]!,
              width: 1,
            ),
          ),
          child: MarkdownBody(
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
