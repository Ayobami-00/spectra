import 'package:flutter/material.dart';

enum AuthenticationType { email, phone, social }

class AuthenticationParams {
  final AuthenticationType type;
  final Map<String, dynamic> params;

  AuthenticationParams({
    required this.type,
    required this.params,
  });
}

class AuthenticationBasePage extends StatefulWidget {
  final AuthenticationParams params;

  const AuthenticationBasePage({super.key, required this.params});

  @override
  State<AuthenticationBasePage> createState() => _AuthenticationBasePageState();
}

class _AuthenticationBasePageState extends State<AuthenticationBasePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
