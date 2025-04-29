import 'package:flutter/material.dart';
import 'package:flutter_siren/screens/home_screen.dart';

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
        pwCheckController.text.isNotEmpty) {
      // call signup api
      // var result = await SigninService.submitInfo(nameController.text,
      //     selectedGender, incomeController.text, selectedJob);
      const result = true;
      if (result) {
        print('success signup');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
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
              // 1. app logo
              const SizedBox(
                height: 200,
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
              // 2. name, id, pw, pw check
              SizedBox(
                height: 500,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 46.0),
                    child: Column(
                      children: [
                        // name
                        Column(
                          children: [
                            inputTitle('Name'),
                            textField(nameController),
                            const SizedBox(
                              height: 3.0,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 14.0,
                        ),
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
                          height: 14.0,
                        ),
                        // Password check
                        Column(
                          children: [
                            inputTitle('Password check'),
                            textField(pwCheckController),
                            const SizedBox(
                              height: 3.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 3. signup button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 31.0),
                    child: GestureDetector(
                      onTap: () {
                        //onclick button
                        onClickSignupButtonHandler();
                      },
                      child: Text(
                        'signup',
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: (nameController.text.isNotEmpty &&
                                    idController.text.isNotEmpty &&
                                    pwController.text.isNotEmpty &&
                                    pwCheckController.text.isNotEmpty &&
                                    pwController.text == pwCheckController.text)
                                ? Colors.black
                                : const Color(0xFFA3A3A3)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50.0,
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
