import 'package:flutter/material.dart';
import 'package:thinking_capp/widgets/app_bar.dart';

class AboutView extends StatelessWidget {
  const AboutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'About this app'),
    );
  }
}
