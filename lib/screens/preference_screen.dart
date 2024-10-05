import 'package:flutter/material.dart';
import 'package:foxxi/components/entry_Point1.dart';
import 'package:foxxi/services/user_service.dart';
import 'package:foxxi/utils.dart';

class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({super.key});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  bool value = false;
  UserService userService = UserService();
  List<String> selectedPreferences = [];
  List<String> preferences = [
    'Technology',
    'Politics',
    'Sports',
    'Movies',
    'Food',
    'Travel',
    'Fashion',
    'Music',
    'Books',
    'Gaming',
    'Art',
    'Science',
    'Health',
    'Education',
    'Business',
    'Finance',
    'Entertainment',
    'Lifestyle',
    'News',
    'Weather',
  ];

  List<bool> preferencesBoolList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Preferences'),
        elevation: 0,
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: preferences.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(preferences[index]),
              trailing: Checkbox(
                value: preferencesBoolList[index],
                onChanged: (val) {
                  setState(() {
                    preferencesBoolList[index] = val!;
                  });
                  if (preferencesBoolList[index] == true) {
                    selectedPreferences.add(preferences[index]);
                  } else {
                    selectedPreferences.remove(preferences[index]);
                  }
                },
              ),
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
                              Colors.purpleAccent.shade100.withOpacity(0.4),
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
                        if (selectedPreferences.length < 3) {
                          showSnackBar(
                              context, 'Minimum 3 preferences required');
                        } else {
                          userService
                              .addPreferences(
                                  context: context,
                                  preferences: selectedPreferences)
                              .then((value) {
                            Navigator.pushNamed(
                                context, BottomNavBar.routeName);
                          });
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ]),
                ],
              ),
            )
          ],
        )
      ]),
    );
  }
}
