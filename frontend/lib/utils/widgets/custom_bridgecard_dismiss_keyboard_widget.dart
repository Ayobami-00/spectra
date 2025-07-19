// The DismissKeybaord widget (it's reusable)
import 'package:flutter/material.dart';

/// This [Widget] fixes the issue of not being able to tap outside a
/// [TextField] to dismiss the keyboard globally across the app.
/// Isn't this beautiful!!!!
class CustomDismissKeyboardWidget extends StatelessWidget {
  final Widget child;
  const CustomDismissKeyboardWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}
