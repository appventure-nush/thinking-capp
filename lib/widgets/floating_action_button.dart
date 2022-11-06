import 'package:flutter/material.dart';
import 'package:thinking_capp/colors/palette.dart';

import 'default_feedback.dart';

class MyFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final bool loading;
  final Function() onPressed;

  const MyFloatingActionButton({
    Key? key,
    required this.icon,
    this.loading = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultFeedback(
      disabled: loading,
      onPressed: onPressed,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: loading ? Palette.black2 : Palette.primary,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Palette.black.withOpacity(0.4),
              blurRadius: 20,
            ),
          ],
        ),
        child: Center(
          child: loading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  icon,
                  color: Colors.black,
                ),
        ),
      ),
    );
  }
}
