import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:foxxi/providers/navigation_argument_data_provider.dart';

import 'package:foxxi/services/auth_service.dart';
import 'package:foxxi/screens/otp_screen.dart';
import 'package:foxxi/routing_constants.dart';
import 'package:foxxi/text_field_widget.dart';
import 'package:foxxi/utils.dart';
import 'package:provider/provider.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({
    Key? key,
  }) : super(key: key);
  static const String routeName = emailVerificationScreenRoute;

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  AuthService authService = AuthService();
  final TextEditingController _emailTextController = TextEditingController();
  final bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }

  void navigateToOtpScreen() {
    authService.emailVerification(
        context: context, email: _emailTextController.text);
    Navigator.pushNamed(context, OTPScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final miscProvider =
        Provider.of<ScreenNavigationArgumentProvider>(context, listen: false);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Container(),
              ),
              const Flexible(
                flex: 2,
                child: Hero(
                    tag: 'foxxi_logo',
                    child:
                        Image(image: AssetImage('lib/assets/foxxiLogo.png'))),
              ),
              const Center(
                child: Text(
                  'Enter Email for Verification',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldWidget(
                  isEmail: true,
                  textEditingController: _emailTextController,
                  hintText: 'Enter Email ',
                  textInputType: TextInputType.text),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    dev.log("SignUp Form Validation Passed ",
                        name: "Form Validation -frontend");
                    navigateToOtpScreen();
                    miscProvider.setEmail(_emailTextController.text);
                  } else {
                    dev.log("SignUp Form Validation Failed",
                        name: "Form Validation -frontend");
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
                      ? const Center(child: CustomLoader())
                      : const Center(child: Text("SUBMIT")),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
