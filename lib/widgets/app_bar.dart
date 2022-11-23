import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/widgets/icon_button.dart';

PreferredSize MyAppBar({
  required String title,
  Map<IconData, Function()>? suffixIcons,
  Function()? onBack,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(80 + Get.mediaQuery.padding.top),
    child: Container(
      height: 80 + Get.mediaQuery.padding.top,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      decoration: BoxDecoration(
        color: Palette.black2,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          MyIconButton(
            icon: Icons.arrow_back,
            onPressed: onBack ?? () => Get.back(),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ...(suffixIcons ?? {})
              .map(
                (icon, onPressed) => MapEntry(
                  icon,
                  MyIconButton(icon: icon, onPressed: onPressed),
                ),
              )
              .values
              .toList(),
        ],
      ),
    ),
  );
}
