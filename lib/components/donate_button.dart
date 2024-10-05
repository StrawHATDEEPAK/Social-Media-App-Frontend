import 'package:flutter/material.dart';
import 'package:foxxi/models/donate_controller.dart';
import 'package:foxxi/models/feed_post_model.dart';
import 'package:foxxi/providers/theme_provider.dart';
import 'package:foxxi/providers/user_provider.dart';
import 'package:foxxi/providers/wallet_address.dart';
import 'package:foxxi/screens/wallet_screen.dart';
import 'package:foxxi/utils.dart';
import 'package:provider/provider.dart' as prov;

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev;

class DonateButton extends StatefulWidget {
  final FeedPostModel post;
  DonateButton({super.key, required this.post});

  @override
  State<DonateButton> createState() => _DonateButtonState();
}

class _DonateButtonState extends State<DonateButton> {
  String? privateKey;
  @override
  void initState() {
    super.initState();
    readPrivateKey();
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

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final userProvider = Provider.of<UserProvider>(context, listen: true).user;
    final walletAddressProvider =
        Provider.of<WalletAddressProvider>(context, listen: true);
    return Expanded(
      child: Align(
        alignment: Alignment.bottomRight,
        child: IconButton(
            iconSize: 40,
            icon: const Icon(
              Icons.attach_money_rounded,
              color: Color(0xffec9f05),
            ),
            onPressed: () {
              showMaterialModalBottomSheet<void>(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                context: context,
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Donate',
                            style: TextStyle(
                                color: isDark
                                    ? Colors.grey.shade400
                                    : Colors.black,
                                fontFamily: 'InstagramSans',
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                  widget.post.author.image.toString()),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      widget.post.author.name.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.grey.shade300
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                      '@${widget.post.author.username.toString()}',
                                      style: TextStyle(
                                        fontFamily: 'InstagramSans',
                                        color: isDark
                                            ? Colors.grey.shade200
                                            : Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              // const Padding(
                              //   padding: EdgeInsets.only(
                              //     left: 8,
                              //   ),
                              //   child: Text(
                              //     'Feb 6',
                              //     style: TextStyle(
                              //       color: Colors.grey,
                              //     ),
                              //   ),
                              // )
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Token Amount',
                          ),
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
                                            const Color(0xffff4e00)
                                                .withOpacity(0.4),
                                            const Color(0xffec9f05)
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
                                      foregroundColor:
                                          isDark ? Colors.black : Colors.white,
                                      padding: const EdgeInsets.all(16.0),
                                      textStyle: const TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () {
                                      if (_controller.text.isNotEmpty) {
                                        double amount =
                                            double.parse(_controller.text);
                                        dev.log(amount.toString());
                                        dev.log('---');
                                        // dev.log(walletAddressProvider
                                        //         .walletAddress!);

                                        if (walletAddressProvider
                                                .walletAddress ==
                                            null) {
                                          showSnackBar(context,
                                              'Connect your Wallet to Donate !!!');
                                          Navigator.pop(context);
                                        } else if (widget
                                                .post.author.walletAddress ==
                                            'undefined') {
                                          showSnackBar(context,
                                              'Ask ${widget.post.author.name} to set their Receiving Wallet Address !!!');
                                          Navigator.pop(context);
                                        } else {
                                          readPrivateKey();
                                          if (privateKey != null) {
                                            try {
                                              DonateController()
                                                  .donate(
                                                      privateKey!,
                                                      walletAddressProvider
                                                          .walletAddress!,
                                                      widget.post.author
                                                          .walletAddress,
                                                      amount)
                                                  .then((String result) {
                                                showSnackBar(context,
                                                    'Transaction added to Pending Transaction List !! ');

                                                Navigator.pop(context);
                                              });
                                            } catch (e) {
                                              showSnackBar(context,
                                                  'Unexpected error occured !! ');
                                              Navigator.pop(context);
                                            }
                                          }
                                        }
                                      } else if (_controller.text.isEmpty) {
                                        showSnackBar(
                                            context, 'Field Cannot be Empty');
                                      }
                                    },
                                    child: const Text('Donate'),
                                  ),
                                ]),
                              ],
                            ),
                          )
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          if (walletAddressProvider.walletAddress != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const WalletWeb()));
                          } else {
                            showSnackBar(context, 'Connect your Wallet');
                          }
                        },
                        child: const Text(
                          'Donate Screen',
                          style: TextStyle(
                            color: Color(0xffff4e00),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
