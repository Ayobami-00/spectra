import 'dart:async';

import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration typingSpeed;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.typingSpeed = const Duration(milliseconds: 15),
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayedText = '';
  Timer? _timer;
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTyping() {
    _timer = Timer.periodic(widget.typingSpeed, (timer) {
      if (_charIndex < widget.text.length) {
        setState(() {
          _displayedText = widget.text.substring(0, _charIndex + 1);
          _charIndex++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.style,
    );
  }
}
