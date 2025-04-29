import 'package:flutter/material.dart';
import 'package:flutter_siren/screens/home_screen.dart';
import 'package:flutter_siren/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // result == -1: error, result: 0 (fail), result: 1 (success)
  void checkUser() async {
    // // *** re-login *** // //
    // final prefs = await SharedPreferences.getInstance();
    // String? id = prefs.getString('sirenId');
    // if (id != null) {
    //   await prefs.remove('sirenId');
    // }
    // // *** re-login *** // //

    // final result = await SigninService.checkUser();
    const result = 0;

    // wait 1.5s
    await Future.delayed(const Duration(milliseconds: 1500));
    if (result == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else if (result == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
          // child: SvgPicture.asset('assets/icons/logo_signin.svg'),
          ),
    );
  }
}
