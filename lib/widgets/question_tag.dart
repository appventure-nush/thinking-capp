import 'package:flutter/material.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';

class QuestionTag extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Function()? onRemoved;

  const QuestionTag({
    Key? key,
    required this.label,
    required this.onPressed,
    this.onRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultFeedback(
      onPressed: onPressed,
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: Palette.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
            if (onRemoved != null) SizedBox(width: 6),
            if (onRemoved != null)
              GestureDetector(
                onTap: onRemoved,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.black,
                ),
              ),
            if (onRemoved != null) SizedBox(width: 10) else SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}
