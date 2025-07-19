import 'package:frontend/features/authentication/domain/params/index.dart';
import 'package:frontend/features/authentication/presentation/index.dart';
import 'package:frontend/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart'
    as intl_phone_number_input;
import 'package:frontend/core/index.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:math' as math;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscureValue = true;
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isValidatingUsername = false;
  bool _isValidatingEmail = false;

  Future<String?> _validateUsername(String? username) async {
    if (username == null || username.isEmpty) {
      return 'Username is required';
    }

    setState(() => _isValidatingUsername = true);

    try {
      final result =
          await locator<AuthenticationCubit>().getUserByUsernameLogic(username);
      if (result) {
        return 'Username already exists';
      }
    } finally {
      setState(() => _isValidatingUsername = false);
    }

    return null;
  }

  Future<String?> _validateEmail(String? email) async {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }

    if (!email.contains('@')) {
      return 'Invalid email format';
    }

    setState(() => _isValidatingEmail = true);

    try {
      final result =
          await locator<AuthenticationCubit>().getUserByEmailLogic(email);
      if (result) {
        return 'Email already exists';
      }
    } finally {
      setState(() => _isValidatingEmail = false);
    }

    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    // Check for at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one number
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent[700]!.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: Colors.greenAccent[700],
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Create Account',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fill in your details to get started',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Form Fields
            _buildTextField(
              controller: _usernameController,
              label: 'Username',
              prefixIcon: Icon(Icons.person_outline, color: Colors.grey[400]),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Username is required';
                return null;
              },
            ),
            const SizedBox(height: 20),

            _buildTextField(
              controller: _emailController,
              label: 'Email',
              prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[400]),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Invalid email format';
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            _buildTextField(
              controller: _passwordController,
              label: 'Password',
              prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]),
              obscureText: _obscureValue,
              validator: (v) => v!.length < 8 ? 'Password too short' : null,
              suffix: IconButton(
                icon: Icon(
                  _obscureValue ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey[400],
                  size: 20,
                ),
                onPressed: () => setState(() => _obscureValue = !_obscureValue),
              ),
            ),
            const SizedBox(height: 32),

            // Sign up button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Complete Account',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Terms and Privacy
            const SizedBox(height: 24),
            Center(
              child: Text.rich(
                TextSpan(
                  text: 'By signing up, you agree to our ',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                  children: [
                    TextSpan(
                      text: 'Terms',
                      style: TextStyle(
                        color: Colors.greenAccent[700],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: Colors.greenAccent[700],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffix,
    Widget? prefixIcon,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(
          color: Colors.grey[400],
          fontSize: 14,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffix ??
            (_isValidatingUsername || _isValidatingEmail
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.greenAccent[700]!.withOpacity(0.5),
                        ),
                      ),
                    ),
                  )
                : null),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[800]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[800]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.greenAccent[700]!),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        filled: true,
        fillColor: Colors.grey[900]!.withOpacity(0.5),
        contentPadding: const EdgeInsets.all(16),
      ),
      validator: (value) {
        if (label == 'Password') {
          return _validatePassword(value);
        } else if (label == 'Username') {
          if (_isValidatingUsername) return 'Checking username...';
          _validateUsername(value).then((error) {
            if (error != null) _formKey.currentState?.validate();
          });
          return null;
        } else if (label == 'Email') {
          if (_isValidatingEmail) return 'Checking email...';
          _validateEmail(value).then((error) {
            if (error != null) _formKey.currentState?.validate();
          });
          return null;
        }
        return validator?.call(value);
      },
      onChanged: onChanged,
    );
  }

  void _handleSignUp() async {
    if (_usernameController.text.isEmpty || _emailController.text.isEmpty) {
      return;
    }

    final params = RegisterParam(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    final result = await locator<AuthenticationCubit>().registerLogic(params);
    if (result == true) {
      // Handle successful registration
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
