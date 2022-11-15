import 'package:flutter/material.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/utils/animation.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';

class MyButton extends StatelessWidget {
  final String text;
  final double height;
  final bool isPrimary;
  final bool loading;
  final Function() onPressed;

  const MyButton({
    Key? key,
    required this.text,
    this.height = 70,
    this.isPrimary = true,
    this.loading = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultFeedback(
      disabled: loading,
      onPressed: onPressed,
      child: AnimatedContainer(
        duration: mediumAnimationDuration,
        height: height,
        decoration: BoxDecoration(
          color: loading
              ? Palette.black2
              : Palette.primary.withOpacity(isPrimary ? 1 : 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: loading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 3),
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: isPrimary ? Colors.black : Palette.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}
