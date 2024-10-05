import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ipfs/flutter_ipfs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foxxi/models/NFT_mint_controller.dart';
import 'package:foxxi/providers/user_provider.dart';
import 'package:foxxi/screens/airdrop_screen.dart';
import 'package:foxxi/services/user_service.dart';
import 'package:foxxi/utils.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import '../components/ipfsService.dart' as ipfs_service;
import '../providers/theme_provider.dart';
import '../providers/wallet_address.dart';
import 'dart:developer' as dev;

// import '../provider/theme_provider.dart';

class mintNFT extends StatefulWidget {
  bool haveNFT = false;

  mintNFT({super.key});
  @override
  State<mintNFT> createState() => mintNFTState();
}

class mintNFTState extends State<mintNFT> {
  final TextEditingController _controller = TextEditingController();
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    readPrivateKey();
    // imagePicker = ImagePicker();
  }

  String? uri = 'https://ipfs.io/ipfs/';
  String? image;

  var imagePicker;
  var imageNFT;
  String? privateKey;

  String? readPrivateKey() {
    Provider.of<WalletAddressProvider>(context, listen: false)
        .readPrivateKey()
        ?.then((value) {
      setState(() {
        privateKey = value;
      });
    });
    return privateKey;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final userProvider = Provider.of<UserProvider>(context, listen: true).user;
    final walletAddressProvider =
        Provider.of<WalletAddressProvider>(context, listen: true);
    return Scaffold(
            backgroundColor: isDark?Colors.grey.shade900:Colors.white,

      body: StickyHeader(
        header: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 16,top :16),
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
                ) ,
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Options",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,color: isDark?Colors.grey.shade100:Colors.black),
                ),
              ),
               Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Adjust these settings according to your needs',
                  style: TextStyle(
                    fontFamily: 'InstagramSans',
                    fontSize: 15,
                    color: isDark?Colors.grey.shade100:Colors.black
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            'Contact us to Claim Free Tokens',
                            style: TextStyle(
                              fontFamily: 'InstagramSans',
                              fontSize: 15,
                              color: isDark?Colors.grey.shade100:Colors.black
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            'Claim free tokens',
                            style: TextStyle(
                              fontFamily: 'InstagramSans',
                              fontSize: 15,
                              color: isDark?Colors.grey.shade100:Colors.black
                            ),
                          ),
                        ),
                      ]),
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
                                      begin: const AlignmentDirectional(1, 0),
                                      end: const AlignmentDirectional(-1, 0),
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
                                  textStyle:  TextStyle(fontSize: 20,color: isDark?Colors.grey.shade100:Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, AirDropScreen.routeName);
                                },
                                child: const Text('Claim'),
                              ),
                            ]),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "have NFT?",
                      style: TextStyle(
                        fontFamily: 'InstagramSans',
                        fontSize: 15,
                        color: isDark?Colors.grey.shade100:Colors.black
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoSwitch(
                      activeColor: Colors.grey.shade300,
                      thumbColor:
                          isDark ? Colors.grey.shade900 : Colors.grey.shade400,
                      value: widget.haveNFT,
                      onChanged: (bool value) {
                        setState(() {
                          widget.haveNFT = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              !widget.haveNFT
                  ?  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Upload a picture to mint a NFT and set it as your profile image',
                        style: TextStyle(
                          fontFamily: 'InstagramSans',
                          fontSize: 15,
                          color: isDark?Colors.grey.shade100:Colors.black
                        ),
                      ),
                    )
                  :  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Set your NFT as profile image here',
                        style: TextStyle(
                          fontFamily: 'InstagramSans',
                          fontSize: 15,
                          color: isDark?Colors.grey.shade100:Colors.black
                        ),
                      ),
                    ),
              !widget.haveNFT
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Image',
                            style: TextStyle(
                              fontFamily: 'InstagramSans',
                              fontSize: 15,
                              color: isDark?Colors.grey.shade100:Colors.black
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'IPFS CID',
                            style: TextStyle(
                              fontFamily: 'InstagramSans',
                              fontSize: 15,
                              color: isDark?Colors.grey.shade100:Colors.black
                            ),
                          ),
                        ),
                      ],
                    ),
              !widget.haveNFT
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            image =
                                await ipfs_service.ImagePickerService.pickImage(
                                    context);
                            if (image != null) {
                              uri = uri.toString() + image.toString();
                              setState(() {
                                imageNFT = uri;
                                uri = 'https://ipfs.io/ipfs/';
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.shade500,
                                    style: BorderStyle.solid,
                                    width: 3)),
                            // alignment: Alignment.center,
                            width: (MediaQuery.of(context).size.width / 3) - 40,
                            height: 100,
                            child: imageNFT != null
                                ? Image.network(
                                    imageNFT,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.file_upload_rounded,
                                    color: isDark
                                        ? Colors.grey.shade200
                                        : Colors.grey[800],
                                    // color: Colors.grey.shade800
                                  ),
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
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
                                    Colors.lightBlue.shade100.withOpacity(0.4),
                                    Colors.purpleAccent.shade100
                                        .withOpacity(0.4),
                                  ],
                                  stops: const [0, 1],
                                  begin: const AlignmentDirectional(1, 0),
                                  end: const AlignmentDirectional(-1, 0),
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
                              textStyle:  TextStyle(fontSize: 20,color: isDark?Colors.grey.shade100:Colors.black),
                            ),
                            onPressed: () {
                              readPrivateKey();
                              dev.log(privateKey.toString());
                              dev.log(image.toString());
                              if (!widget.haveNFT) {
                                if (privateKey != null && imageNFT != null) {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const ProgressDialog(
                                      status: 'Minting NFT',
                                    ),
                                  );
                                  try {
                                    MintController()
                                        .mint(privateKey.toString(), image!,
                                            image!)
                                        .then(
                                      (value) {
                                        if (value.contains(
                                            'Transaction Successfull !!')) {
                                          userService.updateProfileImage(
                                              context: context,
                                              image: imageNFT);
                                          Navigator.pop(context);
                                        } else {
                                          showSnackBar(
                                              context, 'Insufficient Funds');
                                          dev.log(value, name: 'Rpc Error');
                                          Navigator.pop(context);
                                        }
                                      },
                                    );
                                  } catch (e) {
                                    dev.log(e.toString());
                                    showSnackBar(context, e.toString());
                                  }
                                } else if (privateKey == null) {
                                  Fluttertoast.showToast(
                                    msg: 'Connect Wallet First',
                                  );
                                } else {
                                  showSnackBar(context, 'Image not selected');
                                }
                              } else {
                                String text = _controller.text;
                                text = 'https://ipfs.io/ipfs/$text';
      
                                userService.updateProfileImage(
                                    context: context, image: text);
                              }
                            },
                            child: const Text('Import'),
                          ),
                        ]),
                      ],
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
