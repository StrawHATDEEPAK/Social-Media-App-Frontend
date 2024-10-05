import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foxxi/services/auth_service.dart';
import 'package:foxxi/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:foxxi/providers/user_provider.dart';
import 'package:foxxi/services/user_service.dart';
import 'package:foxxi/widgets/textfield_widget_2.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../providers/theme_provider.dart';

// import 'package:flutter/material.dart';
class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  // const ProfileSettings
// ({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _bioTextController = TextEditingController();
  final TextEditingController _walletAddressTextController =
      TextEditingController();
  UserService userService = UserService();
  var _imageProfile;
  var _imageCover;
  XFile? image;
  XFile? coverImage;

  var imagePicker;
  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  void dispose() {
    _bioTextController.dispose();
    _nameTextController.dispose();
    _usernameTextController.dispose();
    _walletAddressTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final userProvider = Provider.of<UserProvider>(context, listen: true).user;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      body: StickyHeader(
        header: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, top: 16),
              height: 100,
              // width: MediaQuery.of(context).size.width * 0.1,
              child: CircleAvatar(
                backgroundColor: Colors.purpleAccent.shade100.withOpacity(0.4),
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
          child: Container(
            padding: EdgeInsets.only(
              // top: MediaQuery.of(context).padding.top,
              bottom: MediaQuery.of(context).padding.bottom + 100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Profile",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: isDark ? Colors.grey.shade100 : Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "This information will be displayed publicly so be careful what you share",
                    style: TextStyle(
                        fontFamily: 'InstagramSans',
                        fontSize: 15,
                        color: isDark ? Colors.grey.shade100 : Colors.black),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Image',
                          style: TextStyle(
                              fontFamily: 'InstagramSans',
                              fontSize: 15,
                              color:
                                  isDark ? Colors.grey.shade100 : Colors.black),
                        ),
                        GestureDetector(
                          onTap: () async {
                            image = await imagePicker.pickImage(
                                source: ImageSource.gallery);
                            if (image?.path != null) {
                              setState(() {
                                _imageProfile = File(image!.path);
                              });
                            }
                          },
                          child: Container(
                            // padding: EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.shade500,
                                    style: BorderStyle.solid,
                                    width: 3)),
                            width: MediaQuery.of(context).size.width / 3 - 20,
                            height: 100,
                            child: _imageProfile != null
                                ? Image.file(
                                    _imageProfile,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.file_upload_rounded,
                                    color: isDark
                                        ? Colors.grey.shade200
                                        : Colors.grey[800],
                                  ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Cover Image',
                          style: TextStyle(
                              fontFamily: 'InstagramSans',
                              fontSize: 15,
                              color:
                                  isDark ? Colors.grey.shade100 : Colors.black),
                        ),
                        GestureDetector(
                          onTap: () async {
                            coverImage = await imagePicker.pickImage(
                                source: ImageSource.gallery);
                            if (coverImage?.path != null) {
                              setState(() {
                                _imageCover = File(coverImage!.path);
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.shade500,
                                    style: BorderStyle.solid,
                                    width: 3)),
                            width:
                                (2 * (MediaQuery.of(context).size.width) / 3) -
                                    20,
                            height: 100,
                            child: _imageCover != null
                                ? Image.file(
                                    _imageCover,
                                    fit: BoxFit.fitWidth,
                                  )
                                : Icon(
                                    Icons.upload_rounded,
                                    color: isDark
                                        ? Colors.grey.shade200
                                        : Colors.grey[800],
                                  ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                TextFieldWidget2(
                  controller: _nameTextController,
                  headingText: 'Full Name',
                  hintText: userProvider.name,
                ),
                TextFieldWidget2(
                  controller: _usernameTextController,
                  headingText:
                      'Username on Twitter (Cannot be changed once set)',
                  hintText: userProvider.twitterUsername.isEmpty
                      ? 'You cannot change this later'
                      : userProvider.twitterUsername,
                ),
                TextFieldWidget2(
                  controller: _walletAddressTextController,
                  headingText: 'Wallet Address',
                  hintText: userProvider.walletAddress,
                ),
                TextFieldWidget2(
                  controller: _bioTextController,
                  headingText: 'Bio',
                  hintText: userProvider.bio,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                userService
                                    .updateProfile(
                                        context: context,
                                        bio: _bioTextController.text,
                                        coverImagePath: coverImage?.path == null
                                            ? null
                                            : coverImage!.path,
                                        imagePath: image?.path == null
                                            ? null
                                            : image!.path,
                                        name: _nameTextController.text,
                                        username: _usernameTextController.text,
                                        walletAddress:
                                            _walletAddressTextController.text)
                                    .then((value) {
                                  if (value == 200) {
                                    _bioTextController.clear();
                                    _nameTextController.clear();
                                    _usernameTextController.clear();
                                    _walletAddressTextController.clear();
                                    showSnackBar(context, 'Profile Updated');
                                    userService.getCurrentUserData(
                                        context: context, id: userProvider.id);
                                  }
                                });
                              },
                              child: const Text('Update'),
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
      ),
    );
  }
}
