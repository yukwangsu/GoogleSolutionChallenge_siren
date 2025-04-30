import 'package:flutter/material.dart';
import 'package:flutter_siren/screens/home_screen.dart';
import 'package:flutter_siren/screens/signup_screen.dart';
import 'package:flutter_siren/screens/voice_screen.dart';

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

  // onClick event
  void onClickLoginButtonHandler() async {
    if (idController.text.isNotEmpty && pwController.text.isNotEmpty) {
      // call login api
      // var result = await SigninService.submitInfo(nameController.text,
      //     selectedGender, incomeController.text, selectedJob);
      const result = true;
      if (result) {
        print('success login');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
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
              SizedBox(
                height: 416,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 46.0),
                    child: Column(
                      children: [
                        // ID
                        Column(
                          children: [
                            inputTitle('ID'),
                            textField(idController),
                            const SizedBox(
                              height: 3.0,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 14.0,
                        ),
                        // Password
                        Column(
                          children: [
                            inputTitle('Password'),
                            textField(pwController),
                            const SizedBox(
                              height: 3.0,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            onClickSignupButtonHandler();
                          },
                          child: const Text('signup'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 3. login button
              SizedBox(
                height: (MediaQuery.of(context).size.height - 600) * 2 / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 31.0),
                          child: GestureDetector(
                            onTap: () {
                              //onclick button
                              onClickLoginButtonHandler();
                            },
                            child: Text(
                              'login',
                              style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: (idController.text.isNotEmpty &&
                                          pwController.text.isNotEmpty)
                                      ? Colors.black
                                      : const Color(0xFFA3A3A3)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50.0,
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

  Widget inputTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 10.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17.0),
          )
        ],
      ),
    );
  }

  Widget textField(TextEditingController controller) {
    return TextField(
      controller: controller,
      cursorColor: const Color(0xFFA3A3A3), // 커서 색상 설정
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // 둥근 테두리 설정
            borderSide: const BorderSide(color: Color(0xFFA3A3A3)), // 기본 테두리 색상
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // 둥근 테두리 유지
            borderSide:
                const BorderSide(color: Color(0xFFA3A3A3)), // 포커스 상태에서도 같은 색 유지
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 15.0,
          ) //글자와 textfield 사이에 padding
          ),
    );
  }
}
