import 'dart:io';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/services.dart';
import 'package:foxxi/env.dart';
import 'package:foxxi/providers/theme_provider.dart';
import 'package:foxxi/providers/user_provider.dart';
import 'package:foxxi/utils.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart' as prov;
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../providers/wallet_address.dart';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:provider/provider.dart' as prov;
import 'package:web3dart/web3dart.dart';

class WalletWeb extends StatefulWidget {
  const WalletWeb({super.key});

  @override
  _WalletWebState createState() => _WalletWebState();
}

class _WalletWebState extends State<WalletWeb>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool isAuth = false;
  late Animation<double> animation;
  String rpcUrl = 'https://rpc.ankr.com/eth';
  String? privateKey;

  @override
  void initState() {
    initPlatformState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );

    super.initState();
  }

  String? readPrivateKey() {
    prov.Provider.of<WalletAddressProvider>(context, listen: false)
        .readPrivateKey()
        ?.then((value) {
      setState(() {
        privateKey = value;
      });
    });
    return privateKey;
  }

  Future<void> initPlatformState() async {
    Uri redirectUrl;
    if (Platform.isAndroid) {
      redirectUrl = Uri.parse('w3a://com.example.foxxi/auth');

      dev.log(redirectUrl.toString(), name: 'REDIRECT URL');
    } else if (Platform.isIOS) {
      redirectUrl = Uri.parse('com.example.foxxi://openlogin');

      // com.example.w3aflutter://openlogin
    } else {
      throw UnKnownException('Unknown platform');
    }

    await Web3AuthFlutter.init(Web3AuthOptions(
        clientId: web3authApi,
        network: Network.testnet,
        redirectUrl: redirectUrl));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = prov.Provider.of<ThemeProvider>(context).isDarkMode;

    final walletAddressProvider =
        prov.Provider.of<WalletAddressProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      body: (walletAddressProvider.walletAddress == null)
          ? StickyHeader(
              header: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 16, top: 16),
                    height: 100,
                    // width: MediaQuery.of(context).size.width * 0.1,
                    child: CircleAvatar(
                      backgroundColor:
                          Colors.purpleAccent.shade100.withOpacity(0.4),
                      child: IconButton(
                        // iconSize: 20,
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          // size: 15,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Connect Wallet',
                          style: TextStyle(
                              fontFamily: 'InstagramSans',
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color:
                                  isDark ? Colors.grey.shade100 : Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Note - Use only one Google Account to Sign Up the Wallet',
                          style: TextStyle(
                              fontFamily: 'InstagramSans',
                              fontSize: 15,
                              color:
                                  isDark ? Colors.grey.shade100 : Colors.black),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Stack(children: <Widget>[
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.lightBlue.shade100
                                                .withOpacity(0.4),
                                            Colors.purpleAccent.shade100
                                                .withOpacity(0.4),
                                          ],
                                          stops: const [0, 1],
                                          begin:
                                              const AlignmentDirectional(1, 0),
                                          end:
                                              const AlignmentDirectional(-1, 0),
                                          // color: Colors.purpleAccent.shade100.withOpacity(
                                          // 0.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.all(16.0),
                                      textStyle: TextStyle(
                                          fontSize: 20,
                                          color: isDark
                                              ? Colors.grey.shade100
                                              : Colors.black),
                                    ),
                                    onPressed: () async {
                                      final response =
                                          await Web3AuthFlutter.login(
                                              LoginParams(
                                                  loginProvider:
                                                      Provider.google));

                                      Credentials _credentials =
                                          EthPrivateKey.fromHex(
                                              response.privKey!);
                                      walletAddressProvider.setPrivateKey(
                                        privateKey: response.privKey.toString(),
                                      );
                                      walletAddressProvider.setAddress(
                                          _credentials.address.toString());
                                      dev.log(_credentials.address.toString(),
                                          name: 'Wallet Address');

                                      setState(() {
                                        readPrivateKey();
                                      });
                                    },
                                    child: const Text('Connect'),
                                  ),
                                ]),
                              ],
                            ),
                          )
                        ],
                      ),
                    ]),
              ),
            )
          : Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.only(left: 16, top: 16),
                      height: 100,
                      // width: MediaQuery.of(context).size.width * 0.1,
                      child: CircleAvatar(
                        backgroundColor:
                            Colors.purpleAccent.shade100.withOpacity(0.4),
                        child: IconButton(
                          // iconSize: 20,
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            // size: 15,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Connect Wallet',
                      style: TextStyle(
                          fontFamily: 'InstagramSans',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.grey.shade100 : Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'You are about to see your Private Key\nMake sure you are Alone !!!',
                      style: TextStyle(
                        color: isDark ? Colors.grey.shade100 : Colors.black,
                        fontFamily: 'InstagramSans',
                        fontSize: 15,
                      ),
                    ),
                  ),
                  CircularRevealAnimation(
                    centerAlignment: Alignment.bottomRight,
                    animation: animation,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        privateKey.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: (walletAddressProvider.walletAddress != null)
          ? Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height / 9),
              child: FloatingActionButton(
                  backgroundColor:
                      Colors.purpleAccent.shade100.withOpacity(0.4),
                  onPressed: () async {
                    readPrivateKey();
                    final LocalAuthentication auth = LocalAuthentication();
                    if (isAuth == false) {
                      try {
                        final bool didAuthenticate = await auth.authenticate(
                            localizedReason:
                                'Please authenticate to see Private Key',
                            options: const AuthenticationOptions(
                                useErrorDialogs: false));
                        isAuth = didAuthenticate;
                        if (isAuth == true) {
                          if (animationController.status ==
                                  AnimationStatus.forward ||
                              animationController.status ==
                                  AnimationStatus.completed) {
                            animationController.reverse();
                          } else {
                            animationController.forward();
                          }
                        }
                      } on PlatformException catch (e) {
                        if (e.code == auth_error.notAvailable) {
                          showSnackBar(context, 'Enroll Passcode to View ');
                        }
                        if (e.code == auth_error.passcodeNotSet) {
                          showSnackBar(context, 'Enroll passcode in Security');
                        }
                        if (e.code == auth_error.notEnrolled) {
                          showSnackBar(context, 'Enroll Biometric Security');
                        }
                        if (e.code == auth_error.permanentlyLockedOut) {
                          showSnackBar(
                              context, 'You are locked out of this device');
                        }
                        if (e.code == auth_error.otherOperatingSystem) {
                          showSnackBar(context, 'Unsupported OS');
                        }
                      }
                    } else if (animationController.status ==
                            AnimationStatus.forward ||
                        animationController.status ==
                            AnimationStatus.completed) {
                      animationController.reverse();
                      isAuth = false;
                    }
                  },
                  child: const Icon(Icons.warning)),
            )
          : const SizedBox(),
    );
    // Your page
  }
}
