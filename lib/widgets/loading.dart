import 'package:flutter/material.dart';
import 'package:thinking_capp/colors/palette.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: Palette.primary,
    );
  }
}
