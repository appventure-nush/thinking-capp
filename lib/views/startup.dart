import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/store.dart';
import 'package:thinking_capp/views/home/home.dart';
import 'package:thinking_capp/views/onboading/onboarding.dart';
import 'package:thinking_capp/views/welcome.dart';
import 'package:thinking_capp/widgets/loading.dart';

class StartupView extends StatefulWidget {
  const StartupView({Key? key}) : super(key: key);

  @override
  State<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  @override
  void initState() {
    super.initState();
    // have to wait after render to call Get.off
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAuth());
  }

  Future<void> _checkAuth() async {
    final auth = Get.find<AuthService>();
    await auth.refreshCurrentUser();
    if (auth.isSignedIn) {
      await Get.find<Store>().fetchData();
      if (auth.currentUser.followingTags.isEmpty) {
        Get.off(() => OnboardingView());
      } else {
        Get.off(() => HomeView());
      }
    } else {
      Get.off(() => WelcomeView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Loading(),
      ),
    );
  }
}
