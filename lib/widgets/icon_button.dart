import 'package:flutter/material.dart';
import 'package:thinking_capp/widgets/pressed_builder.dart';

class MyIconButton extends StatelessWidget {
  final IconData icon;
  final Function() onPressed;

  const MyIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PressedBuilder(
      onPressed: onPressed,
      builder: (pressed) => AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(pressed ? 0.1 : 0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Icon(icon, color: Colors.black, size: 20),
        ),
      ),
    );
  }
}
