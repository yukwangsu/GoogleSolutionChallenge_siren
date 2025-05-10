import 'package:flutter/material.dart';
import 'package:flutter_siren/screens/google_signin_screen.dart';
import 'package:flutter_siren/screens/home_screen.dart';
import 'package:flutter_siren/screens/landing_screen.dart';
import 'package:flutter_siren/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // // result == -1: error, result: 0 (fail), result: 1 (success)
  // void checkUser() async {
  //   // // *** re-login *** // //
  //   // final prefs = await SharedPreferences.getInstance();
  //   // String? id = prefs.getString('sirenId');
  //   // if (id != null) {
  //   //   await prefs.remove('sirenId');
  //   // }
  //   // // *** re-login *** // //

  //   // final result = await SigninService.checkUser();
  //   const result = 0;

  //   // wait 1.5s
  //   await Future.delayed(const Duration(milliseconds: 1500));
  //   if (result == 0) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const LoginScreen()),
  //     );
  //   } else if (result == 1) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const HomeScreen()),
  //     );
  //   }
  // }

  void checkGoogleAuth() async {
    // wait 1.5s
    await Future.delayed(const Duration(milliseconds: 1500));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthGate()),
    );
  }

  @override
  void initState() {
    super.initState();
    // checkUser();
    // gogole login
    checkGoogleAuth();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // child: SvgPicture.asset('assets/icons/logo_signin.svg'),
        child: Text('Logo'),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const LandingScreen();
        } else {
          return const GoogleSigninScreen();
        }
      },
    );
  }
}
