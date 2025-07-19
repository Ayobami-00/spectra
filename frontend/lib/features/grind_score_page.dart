import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/tasks/index.dart';
import 'package:go_router/go_router.dart';

class GrindScorePage extends StatefulWidget {
  final String username;
  const GrindScorePage({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  State<GrindScorePage> createState() => _GrindScorePageState();
}

class _GrindScorePageState extends State<GrindScorePage>
    with TickerProviderStateMixin {
  late AnimationController _scoreController;
  late Animation<double> _scoreAnimation;

  // Add these for floating icons
  late List<AnimationController> _floatingControllers;
  late List<Animation<double>> _floatingAnimations;

  final double grindScore = 85.0;

  // Add list of vibrant colors like in landing page
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

  final _usernameController = TextEditingController();
  late String _username;

  @override
  void initState() {
    super.initState();
    _username = widget.username;
    _initializeAnimations();
    if (widget.username.isNotEmpty) {
      _fetchGrindScore();
    }
  }

  void _initializeAnimations() {
    _scoreController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(
      begin: 0,
      end: grindScore,
    ).animate(CurvedAnimation(
      parent: _scoreController,
      curve: Curves.easeOutCubic,
    ));

    // Smoother floating animations
    _floatingControllers = List.generate(
      8,
      (index) => AnimationController(
        duration:
            Duration(milliseconds: 2000 + (index * 500)), // Adjusted duration
        vsync: this,
      )..repeat(reverse: true),
    );

    _floatingAnimations = _floatingControllers.map((controller) {
      return Tween<double>(
        begin: -10.0, // Reduced movement range
        end: 10.0, // Reduced movement range
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut, // Smoother curve
      ));
    }).toList();

    _scoreController.forward();
  }

  void _fetchGrindScore() {
    context.read<TasksCubit>().getGrindScore(_username);
  }

  Widget _buildUsernameInput() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Check Your Grind Score',
                style: GoogleFonts.inter(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1A1A1A)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _usernameController,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your username',
                        hintStyle: GoogleFonts.inter(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: const Color(0xFF0D0D0D),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[850]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[850]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.greenAccent[700]!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_usernameController.text.isNotEmpty) {
                            setState(() {
                              _username = _usernameController.text;
                            });
                            _fetchGrindScore();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.greenAccent[700]!.withOpacity(0.15),
                          foregroundColor: Colors.greenAccent[700],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Check Score',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent[700],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: _username.isEmpty
          ? _buildUsernameInput()
          : BlocBuilder<TasksCubit, TasksState>(
              builder: (context, state) {
                if (state is TasksLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                    ),
                  );
                }

                if (state is TasksError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${state.errorMessage}',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            color: Colors.red[400],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchGrindScore,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is TasksLoaded<TaskGrindScoreResponse>) {
                  final score = state.data.grindScore?.toDouble() ?? 0;
                  final themeColor = getScoreColor(score);
                  final message = getMotivationalMessage(score, _username);

                  // Update the score animation with the actual value
                  _scoreAnimation = Tween<double>(
                    begin: 0,
                    end: state.data.grindScore?.toDouble() ?? 0,
                  ).animate(CurvedAnimation(
                    parent: _scoreController,
                    curve: Curves.easeOutCubic,
                  ));
                  _scoreController.forward(from: 0);

                  return Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 48),
                            // Username section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF111111),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.greenAccent[700]!
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.account_circle_outlined,
                                        color: Colors.greenAccent[700],
                                        size: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        '@$_username',
                                        style: GoogleFonts.inter(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 48),
                            Text(
                              'Your Grind Score',
                              style: GoogleFonts.inter(
                                fontSize: 48,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'How efficiently you complete your tasks',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                color: Colors.grey[400],
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 64),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 600),
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFF111111),
                                border:
                                    Border.all(color: const Color(0xFF1A1A1A)),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  AnimatedBuilder(
                                    animation: _scoreAnimation,
                                    builder: (context, child) {
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: 300,
                                            width: 300,
                                            child: CircularProgressIndicator(
                                              value:
                                                  _scoreAnimation.value / 100,
                                              strokeWidth: 16,
                                              backgroundColor: Colors.grey[850],
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                themeColor,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                '${_scoreAnimation.value.toInt()}',
                                                style: GoogleFonts.inter(
                                                  fontSize: 96,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF0D0D0D),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: themeColor
                                                        .withOpacity(0.3),
                                                  ),
                                                ),
                                                child: Text(
                                                  'GRIND SCORE',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: themeColor,
                                                    letterSpacing: 2,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 32),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0D0D0D),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: themeColor.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      message,
                                      style: GoogleFonts.inter(
                                        fontSize: 20,
                                        color: Colors.grey[400],
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Total Tasks: ${state.data.totalTasks ?? 0}',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(height: 64),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 48, horizontal: 24),
                              child: Column(
                                children: [
                                  const Divider(color: Color(0xFF1A1A1A)),
                                  const SizedBox(height: 24),
                                  Text(
                                    '© 2024 Spectra (Beta). All rights reserved.',
                                    style: GoogleFonts.inter(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _scoreController.dispose();
    for (var controller in _floatingControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Color getScoreColor(double score) {
    if (score >= 80) return Colors.greenAccent[700]!;
    if (score >= 60) return Colors.blueAccent[700]!;
    if (score >= 40) return Colors.orangeAccent[700]!;
    return Colors.redAccent[700]!;
  }

  String getMotivationalMessage(double score, String username) {
    final messages = {
      'excellent': [
        "🔥 You're absolutely crushing it, @$username! Keep that legendary pace!",
        "⚡️ Peak performance achieved! You're in beast mode, @$username!",
        "🌟 @$username, you're setting the gold standard! Absolutely phenomenal!",
        "🚀 Unstoppable force detected: @$username is on fire!",
        "💪 @$username's grind level: LEGENDARY! Keep dominating!",
      ],
      'good': [
        "💫 Solid work, @$username! You're building something special!",
        "🌈 @$username, you're on the right track! Keep that momentum going!",
        "⭐️ Looking strong, @$username! Your dedication is showing!",
        "🎯 @$username's got the right idea! Stay focused!",
        "✨ Great progress, @$username! You're making it happen!",
      ],
      'average': [
        "🌱 @$username, you've got potential! Let's kick it up a notch!",
        "💭 Steady progress, @$username! Time to push those boundaries!",
        "🎈 @$username, you're getting there! Let's aim even higher!",
        "🌅 New day, new opportunities! You can do this, @$username!",
        "💫 @$username, let's turn up the heat! You've got this!",
      ],
      'needs_work': [
        "🔋 @$username, time to power up! Every champion starts somewhere!",
        "🌟 @$username, today is your day to shine! Let's make it count!",
        "💪 Small steps lead to big victories, @$username! Let's get moving!",
        "🚀 @$username, your comeback story starts now! Ready for takeoff!",
        "✨ @$username, you've got untapped potential! Let's unleash it!",
      ],
    };

    final Random random = Random();
    if (score >= 80) {
      return messages['excellent']![
          random.nextInt(messages['excellent']!.length)];
    } else if (score >= 60) {
      return messages['good']![random.nextInt(messages['good']!.length)];
    } else if (score >= 40) {
      return messages['average']![random.nextInt(messages['average']!.length)];
    } else {
      return messages['needs_work']![
          random.nextInt(messages['needs_work']!.length)];
    }
  }
}
