import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/views/write_question/write_question.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';
import 'package:thinking_capp/widgets/pressed_builder.dart';

class HomeBottomSheet extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const HomeBottomSheet({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Palette.black2,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 20),
          _buildNavItem(Icons.view_agenda_outlined, 'Feed', 0),
          _buildNavItem(Icons.workspace_premium_outlined, 'Rankings', 1),
          _buildNavItem(Icons.settings_outlined, 'Settings', 2),
          SizedBox(width: 20),
          PressedBuilder(
            onPressed: () {
              Get.to(WriteQuestionView());
            },
            builder: (pressed) => AnimatedSlide(
              duration: const Duration(milliseconds: 100),
              offset: Offset(0, pressed ? -0.3 : -0.36),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Palette.primary,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Palette.primary.withOpacity(pressed ? 0.1 : 0.2),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.edit_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Material(
          color: Colors.transparent,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: index == currentIndex ? 1 : 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Palette.primary,
                ),
                SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: Palette.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
