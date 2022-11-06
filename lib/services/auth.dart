import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/user.dart';

import 'users_db.dart';

class AuthService extends GetxService {
  final _fbAuth = FirebaseAuth.instance;
  final _usersDb = Get.find<UsersDbService>();

  AppUser? _currentUser;

  bool get isSignedIn => _currentUser != null;
  AppUser get currentUser => _currentUser!;
  String get id => _currentUser!.id;

  @override
  void onReady() {
    // mainly for email verification
    _fbAuth.authStateChanges().listen((user) {
      user?.reload();
    });
  }

  Future<void> refreshCurrentUser() async {
    if (_fbAuth.currentUser != null) {
      _currentUser = await _usersDb.getUser(_fbAuth.currentUser!.uid);
    }
  }

  Future<bool> msAuth() async {
    final provider = MicrosoftAuthProvider();
    provider.addScope('openid');
    provider.addScope('email');
    provider.setCustomParameters({
      'prompt': 'consent',
      'tenant': 'organizations',
      'clientId': '10100754-7d1f-473c-95a0-50cc01e54f9c',
      'clientSecret': 'jvLnGnMhOA1tjY+5wtNwfpPI664MSti2/uWpl91uux8=',
      'redirectUri':
          'https://thinking-capp-temp.firebaseapp.com/__/auth/handler',
    });
    try {
      final creds = await FirebaseAuth.instance.signInWithProvider(provider);
      if (!(await _usersDb.hasUser(creds.user!.uid))) {
        // new user, create account
        // convert name to title case
        final formattedName = creds.user!.displayName!
            .split(RegExp(r'\s+'))
            .map((str) => str[0].toUpperCase() + str.substring(1).toLowerCase())
            .join(' ');
        _currentUser = await _usersDb.newUser(creds.user!.uid, formattedName);
      } else {
        await refreshCurrentUser();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {
    await _fbAuth.signOut();
    _currentUser = null;
  }
}
