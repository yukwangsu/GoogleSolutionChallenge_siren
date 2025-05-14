import 'package:flutter/material.dart';
import 'package:flutter_siren/screens/google_signin_screen.dart';
import 'package:flutter_siren/screens/home_screen.dart';
import 'package:flutter_siren/screens/landing_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_siren/services/audio_service.dart';
import 'package:flutter_siren/services/message_service.dart';
import 'package:flutter_siren/variables/variables.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void checkGoogleAuth() async {
    // await GoogleSignIn().signOut();
    // await FirebaseAuth.instance.signOut();
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Logo.png'),
          ],
        ),
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
          hasFcmToken = false;
          return const GoogleSigninScreen();
        }
      },
    );
  }
}
