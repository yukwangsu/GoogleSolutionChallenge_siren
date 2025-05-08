import 'package:flutter/material.dart';
import 'package:flutter_siren/screens/home_screen.dart';
import 'package:flutter_siren/screens/landing_screen.dart';
import 'package:flutter_siren/screens/signup_screen.dart';
import 'package:flutter_siren/widgets/account/input_field.dart';
import 'package:flutter_siren/widgets/account/input_title.dart';
import 'package:flutter_siren/widgets/account/next_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final TextEditingController idController =
      TextEditingController(); // id controller
  final TextEditingController pwController =
      TextEditingController(); // pw controller

  void onClickLoginButtonHandler() async {
    if (idController.text.isNotEmpty && pwController.text.isNotEmpty) {
      // call login api
      // var result = await SigninService.submitInfo(nameController.text,
      //     selectedGender, incomeController.text, selectedJob);
      const result = true;
      if (result) {
        print('success login');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LandingScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  void onClickSignupButtonHandler() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: (MediaQuery.of(context).size.height - 600) / 3),
              // 1. app logo
              const SizedBox(
                height: 183,
                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(left: 35.0),
                //       child: SvgPicture.asset('assets/icons/logo.svg'),
                //     ),
                //     const SizedBox(
                //       height: 47.0,
                //     ),
                //   ],
                // ),
              ),
              // 2. id, pw
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 46.0),
                child: Column(
                  children: [
                    // ID
                    Column(
                      children: [
                        const InputTitle(
                          title: 'ID',
                        ),
                        InputField(
                          inputController: idController,
                          isSecret: false,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),

                    // Password
                    Column(
                      children: [
                        const InputTitle(
                          title: 'Password',
                        ),
                        InputField(
                          inputController: pwController,
                          isSecret: true,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),

                    // login button
                    NextButton(
                      text: 'Log In',
                      onPressed: onClickLoginButtonHandler,
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    // signup button
                    NextButton(
                      text: 'Sign up',
                      onPressed: onClickSignupButtonHandler,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
