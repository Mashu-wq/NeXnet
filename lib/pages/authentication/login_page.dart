
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:http/http.dart';
import 'package:nexnet/constants/routes.dart';
import 'package:nexnet/pages/authentication/signup_page.dart';
import 'package:nexnet/pages/authentication/widget/text_field_input.dart';
import 'package:nexnet/services/auth/auth_exceptions.dart';
import 'package:nexnet/services/auth/auth_services.dart';


class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Column(
                children: [
                  Text(
                    'NeXneT',
                    style: GoogleFonts.dancingScript(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      //color: Colors.white70,
                    ),
                  ),
                  //const Divider(height: 28),
                  const SizedBox(height: 28),
                  SizedBox(
                    child: TextFieldInput(
                      textEditingController: _emailController,
                      textInputType: TextInputType.emailAddress,
                      hintText: 'Email address',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFieldInput(
                    textEditingController: _passwordController,
                    textInputType: TextInputType.text,
                    hintText: 'Password',
                    isPassword: true,
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: () async {
                      //login
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      try {
                        await AuthService.firebase().logIn(
                          email: email,
                          password: password,
                        );
                        if (!mounted) return;
                        Navigator.of(context).popAndPushNamed(rootRoute);
                      } on UserNotFoundException {
                        "User not found";
                      } on WrongPasswordException {
                        "Wrong password";
                      } on GenericAuthException {
                        'Authentication error';
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(
                        double.infinity,
                        56,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      backgroundColor: Colors.white70,
                    ),
                    child: const Text(
                      'LogIn',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 83, 136, 162),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  RichText(
                    text: TextSpan(
                      text: 'Forgot your password?',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: const TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.w700,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


