import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/widgets/icon_button.dart';

PreferredSize MyAppBar({
  required String title,
  Map<String, Function()>? actions,
  Function()? onBack,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(80 + Get.mediaQuery.padding.top),
    child: Container(
      height: 80 + Get.mediaQuery.padding.top,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      decoration: BoxDecoration(
        color: Palette.secondary,
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
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          if (actions != null)
            MyIconButton(
              icon: Icons.menu,
              onPressed: () {},
            ),
        ],
      ),
    ),
  );
}
