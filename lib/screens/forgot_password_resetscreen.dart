import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:foxxi/screens/login_screen.dart';
import 'package:provider/provider.dart';

import 'package:foxxi/routing_constants.dart';
import 'package:foxxi/services/auth_service.dart';
import 'package:foxxi/text_field_widget.dart';
import 'package:foxxi/utils.dart';

import '../providers/navigation_argument_data_provider.dart';

class ForgotPasswordResetScreen extends StatefulWidget {
  static const String routeName = forgotPasswordResetScreenRoute;

  const ForgotPasswordResetScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordResetScreen> createState() =>
      _ForgotPasswordResetScreenState();
}

class _ForgotPasswordResetScreenState extends State<ForgotPasswordResetScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  @override
  void dispose() {
    _passwordTextController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final miscProvider =
        Provider.of<ScreenNavigationArgumentProvider>(context, listen: false);
    final String email = miscProvider.email;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 9,
              right: MediaQuery.of(context).size.height / 20,
              left: MediaQuery.of(context).size.height / 20),
          width: double.infinity,
          child: Column(
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
              const Center(child: Text('Password Reset')),
              const SizedBox(
                height: 24,
              ),
              TextFieldWidget(
                  isPassword: true,
                  textEditingController: _passwordTextController,
                  hintText: 'Enter Password ',
                  textInputType: TextInputType.text),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    dev.log("Reset Password Form Validation Passed ",
                        name: "Form Validation -frontend");
                    authService
                        .resetPassword(
                            context: context,
                            email: email,
                            password: _passwordTextController.text)
                        .then((value) {
                      if (value == 200 || value == 204 || value == 201) {
                        Navigator.pushNamed(context, LoginScreen.routeName);
                      }
                    });
                    // Navigator.pushNamed(context, LoginScreen.routeName);
                  } else {
                    dev.log("Reset Password Form Validation Failed",
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
                      : const Center(
                          child: Text("Reset Password"),
                        ),
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
