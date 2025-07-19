import 'dart:ui';

import 'package:frontend/core/index.dart';
import 'package:frontend/features/session/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PricingPageTheme {
  // Colors
  static const backgroundColor = Color(0xFF0A0A0A);
  static const cardBackgroundColor = Color(0xFF111111);
  static final borderColor = Colors.grey[850]!;
  static final accentColor = Colors.greenAccent[700]!;

  // Text Styles
  static final titleStyle = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );

  static final subtitleStyle = GoogleFonts.inter(
    fontSize: 16,
    color: Colors.grey[400],
  );

  static final priceStyle = GoogleFonts.inter(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final featureStyle = GoogleFonts.inter(
    fontSize: 15,
    color: Colors.grey[300],
  );
}

class PricingPage extends StatelessWidget {
  const PricingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Track page view when screen loads
    AppEventTrackingAnalyticsService.logEvent(
      'pricing_page_viewed',
      {'timestamp': DateTime.now().toString()},
    );

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 900;

    return Scaffold(
      backgroundColor: PricingPageTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: PricingPageTheme.cardBackgroundColor,
        elevation: 0,
        title: Text(
          'Choose Your Plan',
          style: PricingPageTheme.titleStyle.copyWith(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 32),
          child: Column(
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: 1.0,
                child: Column(
                  children: [
                    Text(
                      'Simple Pricing',
                      style: GoogleFonts.inter(
                        fontSize: 56,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -1.0,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 34),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent[700]!.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.greenAccent[700]!.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        '🚀  Beta Launch Special: Lock in these discounted rates by subscribing early',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: Colors.greenAccent[700],
                          height: 1.5,
                          letterSpacing: -0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
              _buildPricingCards(isSmallScreen),
              const SizedBox(height: 48),
              _buildFeatureComparison(),
            ],
          ),
        ),
      ),
    );
  }

  void _showModal(BuildContext context, String tier, bool isFree) {
    // Track when user selects a plan
    AppEventTrackingAnalyticsService.logEvent(
      'pricing_plan_selected',
      {
        'plan_type': isFree ? 'Free Plan' : '$tier Plan',
        'timestamp': DateTime.now().toString(),
      },
    );

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext context) {
        final TextEditingController emailController = TextEditingController();
        final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
        final ValueNotifier<bool> _isCompleted = ValueNotifier<bool>(false);

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Dialog(
            backgroundColor: const Color(0xFF111111),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(32),
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isFree) ...[
                    Icon(
                      Icons.rocket_launch_rounded,
                      size: 48,
                      color: Colors.greenAccent[700],
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    isFree ? 'Get Started' : 'Early Access Discount Reserved!',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (!isFree)
                    Text(
                      'Thanks for your interest in our $tier plan! Your early access discount will be automatically applied when we launch.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.grey[400],
                        height: 1.5,
                        letterSpacing: -0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 24),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isCompleted,
                    builder: (context, isCompleted, child) {
                      if (isCompleted) {
                        return Column(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 48,
                              color: Colors.greenAccent[700],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Thank you for joining our waitlist!',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.grey[400],
                                height: 1.5,
                                letterSpacing: -0.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      }

                      return ValueListenableBuilder<bool>(
                        valueListenable: _isLoading,
                        builder: (context, isLoading, child) {
                          if (isLoading) {
                            return SizedBox(
                              height: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.greenAccent[700],
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              Text(
                                'Enter your email to get join waitlist',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.grey[400],
                                  height: 1.5,
                                  letterSpacing: -0.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: emailController,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 16,
                                  letterSpacing: -0.2,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Enter your email',
                                  hintStyle: GoogleFonts.inter(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                    letterSpacing: -0.2,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFF0D0D0D),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.grey[850]!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.grey[850]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.greenAccent[700]!),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isCompleted,
                    builder: (context, isCompleted, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isCompleted
                              ? () => Navigator.of(context).pop()
                              : () async {
                                  if (emailController.text.trim().isEmpty) {
                                    return;
                                  }

                                  _isLoading.value = true;
                                  final cubit = context.read<SessionCubit>();
                                  final success =
                                      await cubit.createWaitlistLogic(
                                    emailController.text.trim(),
                                    isFree ? 'Free Plan' : '$tier Plan',
                                  );

                                  if (success) {
                                    // Track successful waitlist signup
                                    AppEventTrackingAnalyticsService.logEvent(
                                      'waitlist_signup_completed',
                                      {
                                        'plan_type':
                                            isFree ? 'Free Plan' : '$tier Plan',
                                        'timestamp': DateTime.now().toString(),
                                      },
                                    );
                                    _isLoading.value = false;
                                    _isCompleted.value = true;
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            isCompleted
                                ? 'Close'
                                : (isFree ? 'Get Started' : 'Reserve Discount'),
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Simple, Transparent Pricing',
          style: PricingPageTheme.titleStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Choose the plan that best fits your needs.\nAll plans include core features.',
          style: PricingPageTheme.subtitleStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPricingCards(bool isSmallScreen) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: [
        _buildPricingCard(
          'Free',
          0,
          'Perfect for getting started',
          ['30 AI conversations/session', 'Basic tools', 'Limited support'],
          false,
          isSmallScreen,
        ),
        _buildPricingCard(
          'Pro',
          14.99,
          'Most popular for individuals',
          [
            'Unlimited AI conversations',
            'Advanced tools',
            'Priority support',
          ],
          true,
          isSmallScreen,
          oldPrice: 24.99,
        ),
        _buildPricingCard(
          'Team',
          49.99,
          'Best for small teams',
          ['Everything in Pro', 'Team collaboration', 'Custom Features'],
          false,
          isSmallScreen,
          oldPrice: 99.99,
        ),
      ],
    );
  }

  Widget _buildPricingCard(String tier, double price, String description,
      List<String> features, bool isPopular, bool isSmallScreen,
      {double? oldPrice}) {
    return Builder(
      builder: (context) => AnimatedContainer(
        width: isSmallScreen ? double.infinity : 320,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: PricingPageTheme.cardBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPopular
                ? PricingPageTheme.accentColor
                : PricingPageTheme.borderColor,
            width: isPopular ? 2 : 1,
          ),
        ),
        duration: const Duration(milliseconds: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPopular)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: PricingPageTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Most Popular',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: PricingPageTheme.accentColor,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(tier,
                style: PricingPageTheme.titleStyle.copyWith(fontSize: 24)),
            const SizedBox(height: 8),
            Text(description, style: PricingPageTheme.subtitleStyle),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (oldPrice != null) ...[
                    Text(
                      '\$${oldPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[600],
                        letterSpacing: -0.5,
                        height: 1,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.grey[600],
                        decorationThickness: 1.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.8,
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      '/month',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[400],
                        letterSpacing: -0.2,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: PricingPageTheme.accentColor, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child:
                            Text(feature, style: PricingPageTheme.featureStyle),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showModal(context, tier, price == 0),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPopular
                      ? PricingPageTheme.accentColor
                      : PricingPageTheme.accentColor.withOpacity(0.1),
                  foregroundColor:
                      isPopular ? Colors.white : PricingPageTheme.accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  price == 0 ? 'Get Started' : 'Subscribe Now',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureComparison() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: PricingPageTheme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PricingPageTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Feature Comparison',
            style: PricingPageTheme.titleStyle.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 24),
          _buildFeatureRow('AI Conversations', ['30/session', '∞', '∞']),
          _buildFeatureRow('Tools', ['Basic', 'Advanced', 'Advanced']),
          _buildFeatureRow('Support', ['Limited', 'Priority', 'Dedicated']),
          _buildFeatureRow('Team Members', ['1', '1', 'Up to 5']),
          // _buildFeatureRow('Custom Training', ['✗', '✓', '✓']),
          _buildFeatureRow('Custom Features', ['✗', '✗', '✓']),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String feature, List<String> tiers) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(feature, style: PricingPageTheme.featureStyle),
          ),
          ...tiers.map((tier) => Expanded(
                child: Text(
                  tier,
                  style: PricingPageTheme.featureStyle,
                  textAlign: TextAlign.center,
                ),
              )),
        ],
      ),
    );
  }
}
