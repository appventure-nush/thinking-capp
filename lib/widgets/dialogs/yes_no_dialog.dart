import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/widgets/button.dart';

class YesNoDialog extends StatelessWidget {
  final String title;
  final String text;

  const YesNoDialog({
    Key? key,
    required this.title,
    required this.text,
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
                padding: EdgeInsets.fromLTRB(28, 20, 28, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Palette.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(
                      child: MyButton(
                        height: 50,
                        text: 'Yes',
                        onPressed: () => Get.back(result: true),
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: MyButton(
                        height: 50,
                        text: 'No',
                        isPrimary: false,
                        onPressed: () => Get.back(result: false),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
