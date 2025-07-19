import 'package:frontend/core/index.dart';
import 'package:frontend/features/session/presentation/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPageConstants {
  // Colors
  static const backgroundColor = Color(0xFF0A0A0A);
  static const cardBackgroundColor = Color(0xFF111111);
  static const inputBackgroundColor = Color(0xFF1A1A1A);
  static final borderColor = Colors.grey[850]!;
  static final textColorPrimary = Colors.white;
  static final textColorSecondary = Colors.grey[400];
  static final accentColor = Colors.greenAccent[700]!;

  // Dimensions
  static const headerHeight = 72.0;
  static const maxContentWidth = 720.0;
  static const defaultPadding = 24.0;
  static const defaultSpacing = 48.0;
  static const borderRadius = 16.0;
  static const buttonBorderRadius = 8.0;

  // Text Styles
  static final headerStyle = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textColorPrimary,
    letterSpacing: -0.5,
  );

  static final titleStyle = GoogleFonts.inter(
    fontSize: 48,
    height: 1.2,
    fontWeight: FontWeight.bold,
    color: textColorPrimary,
  );

  static final subtitleStyle = GoogleFonts.inter(
    fontSize: 20,
    height: 1.6,
    color: textColorPrimary.withOpacity(0.9),
    fontWeight: FontWeight.w500,
  );

  static final bodyStyle = GoogleFonts.inter(
    fontSize: 16,
    height: 1.6,
    color: textColorSecondary,
  );

  // Demo conversations
  static final demoConversations = [
    DemoConversation(
      userMessage: "I need to prepare for my history exam next week.",
      aiResponse:
          "I can help you prepare effectively. Would you like me to:\n\n"
          "• Create flashcards from your study materials\n"
          "• Generate a practice quiz\n"
          "• Set up a study schedule with reminders\n"
          "• Export study materials as PDF or Word doc",
    ),
    // ... other conversations ...
  ];

  // Tools
  static final tools = [
    ToolItem(Icons.school_outlined, 'Flashcards'),
    ToolItem(Icons.quiz_outlined, 'Quiz'),
    ToolItem(Icons.calendar_today_outlined, 'Schedule'),
    ToolItem(Icons.notifications_outlined, 'Reminders'),
    ToolItem(Icons.picture_as_pdf_outlined, 'Export PDF'),
    ToolItem(Icons.email_outlined, 'Send Email'),
    ToolItem(Icons.description_outlined, 'Export Doc'),
    ToolItem(Icons.share_outlined, 'Share'),
  ];
}

class ToolItem {
  final IconData icon;
  final String label;

  const ToolItem(this.icon, this.label);
}

class DemoConversation {
  final String userMessage;
  final String aiResponse;

  const DemoConversation({
    required this.userMessage,
    required this.aiResponse,
  });
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  final TextEditingController _taskController = TextEditingController();
  late List<AnimationController> _floatingControllers;
  late List<Animation<double>> _floatingAnimations;

  // Add gradient colors
  final undoneColor = Colors.redAccent[700]!;
  final doneColor = Colors.greenAccent[700]!;

  // Add list of vibrant colors
  final List<Color> iconColors = [
    Colors.greenAccent[700]!,
    Colors.blueAccent[700]!,
    Colors.purpleAccent[700]!,
    Colors.orangeAccent[700]!,
    Colors.cyanAccent[700]!,
    Colors.pinkAccent[700]!,
    Colors.tealAccent[700]!,
    Colors.amberAccent[700]!,
  ];

  // Add these controllers
  late AnimationController _loadingController;
  late Animation<Color?> _colorAnimation;
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  // Add these state variables
  final ValueNotifier<String?> _taskLink = ValueNotifier<String?>(null);
  final ValueNotifier<bool> _isCompleted = ValueNotifier<bool>(false);

  final List<String> _taskExamples = [
    "Help me plan my sister's birthday party",
    "Create a workout plan for beginners",
    "Design a study schedule for finals",
    "Organize a weekend trip with friends",
    "Plan a healthy meal prep routine",
    "Create a monthly budget plan",
    "Help me declutter my room",
    "Design a morning routine",
    "Plan a family game night",
    "Create a reading list for summer",
  ];

  late List<AnimationController> _taskAnimationControllers;
  late List<Animation<double>> _taskOpacityAnimations;
  int _currentTaskIndex = 0;

  // Add new constants for action chips
  final List<ActionChip> _actionChips = [
    ActionChip(
      icon: Icons.calendar_today_outlined,
      label: 'Schedule Meeting',
      color: Colors.blueAccent[700]!,
    ),
    ActionChip(
      icon: Icons.school_outlined,
      label: 'Create Flashcards',
      color: Colors.purpleAccent[700]!,
    ),
    ActionChip(
      icon: Icons.assignment_outlined,
      label: 'Set Goals',
      color: Colors.greenAccent[700]!,
    ),
    ActionChip(
      icon: Icons.quiz_outlined,
      label: 'Generate Quiz',
      color: Colors.orangeAccent[700]!,
    ),
    ActionChip(
      icon: Icons.notifications_outlined,
      label: 'Set Reminder',
      color: Colors.pinkAccent[700]!,
    ),
    ActionChip(
      icon: Icons.share_outlined,
      label: 'Export Chat',
      color: Colors.tealAccent[700]!,
    ),
  ];

  late final AnimationController _demoController;
  final ValueNotifier<int> _currentDemoIndex = ValueNotifier<int>(0);
  final ValueNotifier<bool> _isTyping = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _userStartedTyping = ValueNotifier<bool>(false);

  final ValueNotifier<bool> _isCreatingSession = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    // Initialize animations
    _floatingControllers = List.generate(
      8,
      (index) => AnimationController(
        duration: Duration(seconds: 3 + index),
        vsync: this,
      )..repeat(reverse: true),
    );

    _floatingAnimations = _floatingControllers.map((controller) {
      return Tween<double>(
        begin: -15.0,
        end: 15.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();

    // Initialize loading animation
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _colorAnimation = ColorTween(
      begin: undoneColor,
      end: doneColor,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));

    _taskAnimationControllers = List.generate(
      1,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      ),
    );

    _taskOpacityAnimations = _taskAnimationControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();

    // Start animations after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _startTaskAnimations();
    });

    _demoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && !_userStartedTyping.value) {
          _currentDemoIndex.value = (_currentDemoIndex.value + 1) %
              LandingPageConstants.demoConversations.length;
          _isTyping.value = false;
          _startTypingAnimation();
        }
      });

    _startTypingAnimation();

    // Add listener to text controller
    _taskController.addListener(() {
      if (_taskController.text.isNotEmpty && !_userStartedTyping.value) {
        _userStartedTyping.value = true;
        _isTyping.value = false;
        _demoController.stop();
      } else if (_taskController.text.isEmpty && _userStartedTyping.value) {
        _userStartedTyping.value = false;
        _startTypingAnimation();
      }
      // Force rebuild to show updated text
      setState(() {});
    });
  }

  void _startTaskAnimations() {
    for (var i = 0; i < _taskAnimationControllers.length; i++) {
      Future.delayed(Duration(seconds: i * 2), () {
        if (!mounted) return;
        _animateTask(i);
      });
    }
  }

  void _animateTask(int index) {
    if (!mounted) return;

    _taskAnimationControllers[index].reset();
    _taskAnimationControllers[index].forward().then((_) {
      if (!mounted) return;
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!mounted) return;
        _taskAnimationControllers[index].reverse().then((_) {
          if (!mounted) return;
          setState(() {
            _currentTaskIndex = (_currentTaskIndex + 1) % _taskExamples.length;
          });
          if (mounted) {
            _animateTask(index);
          }
        });
      });
    });
  }

  void _startTypingAnimation() {
    if (_userStartedTyping.value) return;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && !_userStartedTyping.value) {
        _isTyping.value = true;
        _demoController.forward(from: 0);
      }
    });
  }

  @override
  void dispose() {
    // Make sure to cancel any pending animations
    for (var controller in _taskAnimationControllers) {
      controller.stop();
      controller.dispose();
    }
    _taskController.dispose();
    _isLoading.dispose();
    for (var controller in _floatingControllers) {
      controller.dispose();
    }
    _loadingController.dispose();
    _taskLink.dispose();
    _isCompleted.dispose();
    _demoController.dispose();
    _currentDemoIndex.dispose();
    _isTyping.dispose();
    _userStartedTyping.dispose();
    _isCreatingSession.dispose();
    super.dispose();
  }

  // Replace _handleShare method with this WhatsApp-specific version
  void _handleWhatsAppShare() {
    if (_taskLink.value != null) {
      final whatsappUrl = _taskLink.value!;
      launchUrl(Uri.parse(whatsappUrl));
    }
  }

  Future<void> _navigateToGuestScreen(String query) async {
    setState(() => _isCreatingSession.value = true);

    try {
      const isPublic = true;
      final response =
          await locator<SessionCubit>().createSessionLogic(isPublic);

      if (response.hasError) {
        setState(() => _isCreatingSession.value = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Unknown error')),
        );
        return;
      }

      if (!mounted || response.hasError) return;

      final sessionId = response.session?.id ?? '';

      AppEventTrackingAnalyticsService.setUserId(sessionId);
      AppEventTrackingAnalyticsService.logEvent('session_created', {
        'is_public': isPublic,
        'initial_query': query,
      });

      locator<NavigationService>().goNamed(
        guestRoute,
        queryParameters: {
          'sessionId': sessionId,
          'message': _taskController.text,
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create session: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreatingSession.value = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LandingPageConstants.backgroundColor,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: LandingPageConstants.headerHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: LandingPageConstants.defaultPadding,
      ),
      color: LandingPageConstants.backgroundColor,
      child: Row(
        children: [
          Row(
            children: [
              Text('Spectra', style: LandingPageConstants.headerStyle),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: LandingPageConstants.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: LandingPageConstants.accentColor.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  'BETA',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: LandingPageConstants.accentColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          // _buildSocialButton(),
          // _buildAuthButtons(),
        ],
      ),
    );
  }

  Widget _buildSocialButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse('https://x.com/assignmeai')),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                Icons.alternate_email,
                size: 16,
                color: LandingPageConstants.textColorPrimary,
              ),
              const SizedBox(width: 6),
              Text(
                'assignmeai',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: LandingPageConstants.textColorPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButtons() {
    return Row(
      children: [
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: LandingPageConstants.textColorPrimary,
            padding: const EdgeInsets.symmetric(
              horizontal: LandingPageConstants.defaultPadding,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                LandingPageConstants.buttonBorderRadius,
              ),
            ),
          ),
          child: Text(
            'Log in',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: LandingPageConstants.textColorSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        _buildSignUpButton(),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      decoration: BoxDecoration(
        color: LandingPageConstants.accentColor,
        borderRadius: BorderRadius.circular(
          LandingPageConstants.buttonBorderRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: LandingPageConstants.accentColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: LandingPageConstants.textColorPrimary,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: LandingPageConstants.defaultPadding,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              LandingPageConstants.buttonBorderRadius,
            ),
          ),
        ),
        child: Text(
          'Sign up',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
            maxWidth: LandingPageConstants.maxContentWidth),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: LandingPageConstants.defaultPadding),
              child: Column(
                children: [
                  Text(
                    'Chat, Connnect and Create',
                    style: LandingPageConstants.titleStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: LandingPageConstants.defaultSpacing),
                  Column(
                    children: [
                      Text(
                        'Your very helpful AI companion.',
                        style: LandingPageConstants.subtitleStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Chat with AI to perform tasks and more. Enable companion mode for real-time video/audio support.',
                        style: LandingPageConstants.bodyStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: LandingPageConstants.defaultSpacing),
                  _buildChatDemo(),
                  const SizedBox(height: LandingPageConstants.defaultSpacing),
                  _buildToolsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatDemo() {
    return ValueListenableBuilder<int>(
      valueListenable: _currentDemoIndex,
      builder: (context, currentIndex, _) {
        final currentDemo =
            LandingPageConstants.demoConversations[currentIndex];

        return ClipRRect(
          borderRadius:
              BorderRadius.circular(LandingPageConstants.borderRadius),
          child: Container(
            decoration: BoxDecoration(
              color: LandingPageConstants.cardBackgroundColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: _userStartedTyping,
                  builder: (context, isUserTyping, _) {
                    return _buildDemoMessage(
                      isUserTyping
                          ? _taskController.text
                          : currentDemo.userMessage,
                      isUser: true,
                    );
                  },
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _isTyping,
                  builder: (context, isTyping, _) {
                    if (isTyping) {
                      return _buildDemoMessage(
                        currentDemo.aiResponse,
                        isUser: false,
                        isTyping: true,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: LandingPageConstants.borderColor),
                    ),
                  ),
                  child: _buildChatInput(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDemoMessage(String text,
      {required bool isUser, bool isTyping = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUser
            ? LandingPageConstants.inputBackgroundColor
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(color: LandingPageConstants.borderColor),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isUser ? Colors.blue : Colors.green,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUser ? Icons.person_outline : Icons.smart_toy_outlined,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: isTyping && !isUser
                ? TypewriterAnimatedText(
                    text: text,
                    controller: _demoController,
                  )
                : Text(
                    text,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      height: 1.5,
                      fontSize: 15,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isCreatingSession,
      builder: (context, isLoading, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: LandingPageConstants.inputBackgroundColor,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      enabled: !isLoading,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty && !isLoading) {
                          _navigateToGuestScreen(value);
                        }
                      },
                      cursorColor: LandingPageConstants.accentColor,
                      decoration: InputDecoration(
                        hintText: isLoading
                            ? 'Creating session...'
                            : 'Message Spectra...',
                        hintStyle: GoogleFonts.inter(
                          color: Colors.grey[500],
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_taskController.text.isNotEmpty) {
                                _navigateToGuestScreen(_taskController.text);
                              }
                            },
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.send_rounded),
                      color: LandingPageConstants.accentColor,
                      iconSize: 20,
                      splashRadius: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildToolsSection() {
    return Wrap(
      spacing: 8,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: LandingPageConstants.tools.map((tool) {
        return _buildTool(
            tool.icon, tool.label, LandingPageConstants.accentColor);
      }).toList(),
    );
  }

  Widget _buildTool(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionChip {
  final IconData icon;
  final String label;
  final Color color;

  const ActionChip({
    required this.icon,
    required this.label,
    required this.color,
  });
}

// Add this new widget for typewriter animation
class TypewriterAnimatedText extends StatelessWidget {
  final String text;
  final Animation<double> controller;

  const TypewriterAnimatedText({
    Key? key,
    required this.text,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final int charCount = (text.length * controller.value).round();
        final displayedText = text.substring(0, charCount);

        return Text(
          displayedText,
          style: GoogleFonts.inter(
            color: Colors.white,
            height: 1.5,
            fontSize: 15,
          ),
        );
      },
    );
  }
}
