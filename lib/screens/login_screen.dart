import 'package:flutter/material.dart';
import 'package:foxxi/components/entry_Point1.dart';
import 'package:foxxi/providers/navigation_argument_data_provider.dart';
import 'package:foxxi/services/auth_service.dart';
import 'package:foxxi/screens/email_verfication_screen.dart';
import 'package:foxxi/routing_constants.dart';
import 'package:foxxi/services/user_service.dart';
import 'package:foxxi/text_field_widget.dart';
import 'package:foxxi/utils.dart';
import 'dart:developer' as dev;

import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = loginScreenRoute;
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthService authService = AuthService();
  UserService userService = UserService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<ScreenNavigationArgumentProvider>(context, listen: false);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: MediaQuery.of(context).size.width - 10,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Flexible(
                flex: 2,
                child: Hero(
                    tag: 'foxxi_logo',
                    child:
                        Image(image: AssetImage('lib/assets/foxxiLogo.png'))),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFieldWidget(
                  isEmail: true,
                  textEditingController: _emailTextController,
                  hintText: "Enter Your Email",
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 24,
              ),
              TextFieldWidget(
                  textEditingController: _passwordTextController,
                  isPassword: true,
                  hintText: "Enter Password",
                  textInputType: TextInputType.text),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    dev.log("Form Validation Passed",
                        name: "Login Screen Form Validation");

                    setState(() {
                      _isLoading = true;
                    });
                    String id =
                        await authService.getCurrentUserId(context: context);
                    // ignore: use_build_context_synchronously
                    int statusCode = await authService.signIn(
                        context: context,
                        email: _emailTextController.text,
                        password: _passwordTextController.text);

                    if (statusCode == 200 || statusCode == 201) {
                      setState(() {
                        _isLoading = false;
                      });
                      _emailTextController.clear();
                      _passwordTextController.clear();
                      if (context.mounted) {
                        Navigator.pushNamed(context, BottomNavBar.routeName,
                            arguments: id);
                      }
                    } else {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  } else {
                    dev.log("Form Validation Failed",
                        name: "Login Screen Form Validation");
                  }
                },
                child: Ink(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          4,
                        ),
                      ),
                    ),
                  ),
                  child: _isLoading
                      ? Center(
                          child: SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                color: Colors.blue.shade100,
                                strokeWidth: 2,
                              )),
                        )
                      : const Center(child: Text("Login")),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      provider.setDestination(forgotPasswordResetScreenRoute);
                      Navigator.pushNamed(
                          context, EmailVerificationScreen.routeName);
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 13,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: const Text("Don't have an account? "),
                  ),
                  GestureDetector(
                    onTap: () {
                      provider.setDestination(signUpScreenRoute);
                      Navigator.pushNamed(
                          context, EmailVerificationScreen.routeName);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
