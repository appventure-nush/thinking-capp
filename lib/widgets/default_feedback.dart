import 'package:flutter/material.dart';

import 'pressed_builder.dart';

class DefaultFeedback extends StatelessWidget {
  final double pressedOpacity;
  final bool disabled;
  final Function() onPressed;
  final Widget child;

  const DefaultFeedback({
    Key? key,
    this.pressedOpacity = 0.8,
    this.disabled = false,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PressedBuilder(
      onPressed: () {
        if (!disabled) onPressed();
      },
      animationDuration: 100,
      builder: (pressed) => AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: pressed && !disabled ? pressedOpacity : 1,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 100),
          scale: pressed && !disabled ? 0.98 : 1,
          child: child,
        ),
      ),
    );
  }
}
