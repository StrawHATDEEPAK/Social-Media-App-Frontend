import 'package:flutter/material.dart';
import 'package:foxxi/services/auth_service.dart';
import 'package:foxxi/routing_constants.dart';
import 'package:foxxi/text_field_widget.dart';
import 'dart:developer' as dev;

import 'package:foxxi/utils.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  static const String routeName = forgotPasswordEmailScreenRoute;

  const ForgotPasswordEmailScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();

  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: Container(),
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
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    dev.log("SignUp Form Validation Passed ",
                        name: "Form Validation -frontend");
                    authService.emailVerification(
                        context: context, email: _emailTextController.text);
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
                      ? const Center(
                          child: CustomLoader(),
                        )
                      : const Center(child: Text("Send Reset Code")),
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
