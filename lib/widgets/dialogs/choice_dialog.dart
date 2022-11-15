import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/widgets/button.dart';

class ChoiceDialog extends StatelessWidget {
  final String title;
  final List<String> choices;
  final String highlightedChoice;

  const ChoiceDialog({
    Key? key,
    required this.title,
    required this.choices,
    required this.highlightedChoice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 280,
          decoration: BoxDecoration(
            color: Palette.black1,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Palette.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 2),
                child: Column(
                  children: choices
                      .map((choice) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: MyButton(
                              text: choice,
                              height: 60,
                              isPrimary: choice == highlightedChoice,
                              onPressed: () => Get.back(result: choice),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
