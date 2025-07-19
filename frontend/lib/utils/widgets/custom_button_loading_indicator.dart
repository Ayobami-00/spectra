import 'package:frontend/utils/index.dart';
import 'package:flutter/material.dart';

class ButtonLoadingIndicator extends StatelessWidget {
  const ButtonLoadingIndicator({
    super.key,
    this.color,
    this.height,
    this.width,
  });
  final Color? color;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 15.0,
      width: width ?? 15.0,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(color ?? AppConstants.appWhite),
          strokeWidth: 1.8,
        ),
      ),
    );
  }
}
