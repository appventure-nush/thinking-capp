import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/cache.dart';
import 'package:thinking_capp/views/home/home.dart';
import 'package:thinking_capp/widgets/button.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  bool _loading = false;

  Future<void> _msAuth() async {
    // final config = Config(
    //   tenant: 'organizations',
    //   clientId: '10100754-7d1f-473c-95a0-50cc01e54f9c',
    //   clientSecret: 'jvLnGnMhOA1tjY+5wtNwfpPI664MSti2/uWpl91uux8=',
    //   scope: 'openid email',
    //   redirectUri: 'https://thinking-capp-temp.firebaseapp.com/__/auth/handler',
    //   navigatorKey: Get.key,
    // );
    // final oauth = AadOAuth(config);
    // await oauth.login();
    setState(() => _loading = true);
    final success = await Get.find<AuthService>().msAuth();
    if (success) {
      await Get.find<AppCache>().fetchData();
      Get.off(HomeView());
    }
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Spacer(flex: 4),
            Image.asset('assets/images/welcome_graphic.png'),
            Spacer(flex: 1),
            Text(
              'Thinking CAPP',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "NUS High's forum for homework help",
            ),
            SizedBox(height: 60),
            MyButton(
              text: 'Microsoft Authentication',
              loading: _loading,
              onPressed: _msAuth,
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
