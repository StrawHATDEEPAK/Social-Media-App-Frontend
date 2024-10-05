import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:foxxi/models/user.dart';
import 'package:foxxi/providers/theme_provider.dart';

import '../providers/user_provider.dart';

class CustomTextField extends StatefulWidget {
  String hintext = '';

  CustomTextField({
    Key? key,
    required this.hintext,
  }) : super(key: key);
  String caption = '';
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String currentWord = '';
  List<User> searchedUsers = [];
  List<String> words = [];
  bool usernameSelected = false;
  List<Map<String, dynamic>> followerFollowingList = [];
  List<User> get users =>
      followerFollowingList.map((e) => User.fromMap(e)).toList();

  @override
  void initState() {
    getfollowerFollowingList();
    super.initState();
  }

  void getfollowerFollowingList() {
    followerFollowingList = [
      ...?Provider.of<UserProvider>(context, listen: false).user.followers,
      ...?Provider.of<UserProvider>(context, listen: false).user.following,
      ...[]
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context, listen: true).isDarkMode;

    return RawAutocomplete<User>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return [];
        } else if (users.isNotEmpty && currentWord.startsWith('@')) {
          List<User> matches = [];
          matches.addAll(users);

          matches.retainWhere((s) {
            return s.username
                .toLowerCase()
                .contains(currentWord.replaceFirst('@', '').toLowerCase());
          });
          dev.log(matches.toString(), name: 'matches');
          return matches;
        } else {
          return [];
        }
      },
      displayStringForOption: (option) {
        words.last = '@${option.username}';
        currentWord = words.last;

        return words.join(' ');
      },
      onSelected: (User selection) {},
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            onChanged: (value) {
              widget.caption = textEditingController.text;
              words = value.split(' ');
              currentWord = words.last;
              dev.log(words.toString(), name: 'Words');
              dev.log(currentWord, name: 'Current Word');
            },
            focusNode: focusNode,
            style:
                TextStyle(color: isDark ? Colors.grey.shade100 : Colors.black),
            controller: textEditingController,
            onSubmitted: (value) {
              widget.caption = value;
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: widget.hintext,
            ),
          ),
        );
      },
      optionsViewBuilder: (BuildContext context, void Function(User) onSelected,
          Iterable<User> options) {
        return Material(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            onSelected(options.elementAt(index));
                          },
                          child: Container(
                            padding: const EdgeInsets.only(right: 60),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    options.elementAt(index).image),
                              ),
                              title: Text(
                                options.elementAt(index).name,
                                style: TextStyle(
                                    color:
                                        isDark ? Colors.white : Colors.black),
                              ),
                              subtitle: Text(
                                options.elementAt(index).username,
                                style: TextStyle(
                                    color:
                                        isDark ? Colors.white : Colors.black),
                              ),
                            ),
                          ),
                        );
                      },
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}
