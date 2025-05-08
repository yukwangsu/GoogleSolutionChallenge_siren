import 'package:flutter/material.dart';
import 'package:flutter_siren/screens/landing_screen.dart';
import 'package:flutter_siren/widgets/account/input_field.dart';
import 'package:flutter_siren/widgets/account/input_title.dart';
import 'package:flutter_siren/widgets/account/next_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  final TextEditingController nameController =
      TextEditingController(); // name controller
  final TextEditingController idController =
      TextEditingController(); // id controller
  final TextEditingController pwController =
      TextEditingController(); // pw controller
  final TextEditingController pwCheckController =
      TextEditingController(); // pw check controller

  // onClick event
  void onClickSignupButtonHandler() async {
    if (nameController.text.isNotEmpty &&
        idController.text.isNotEmpty &&
        pwController.text.isNotEmpty &&
        pwCheckController.text.isNotEmpty &&
        pwController.text == pwCheckController.text) {
      // todo: call signup api
      // var signupResult = await SigninService.submitInfo(nameController.text,
      //     selectedGender, incomeController.text, selectedJob);

      // todo: call login api
      // var loginResult = await SigninService.submitInfo(nameController.text,
      //     selectedGender, incomeController.text, selectedJob);

      // test
      const signupResult = true;
      const loginResult = true;

      if (signupResult && loginResult) {
        print('success signup');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LandingScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }
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
              const SizedBox(
                height: 170,
              ),
              // 1. name, id, pw, pw check
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 46.0),
                child: Column(
                  children: [
                    // name
                    Column(
                      children: [
                        const InputTitle(
                          title: 'Name',
                        ),
                        InputField(
                          inputController: nameController,
                          isSecret: false,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 14.0,
                    ),
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
                      height: 14.0,
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
                      height: 14.0,
                    ),
                    // Password check
                    Column(
                      children: [
                        const InputTitle(
                          title: 'Password Confirm',
                        ),
                        InputField(
                          inputController: pwCheckController,
                          isSecret: true,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 60,
                    ),

                    // signup button
                    NextButton(
                      text: 'Sign up',
                      onPressed: onClickSignupButtonHandler,
                    )
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
