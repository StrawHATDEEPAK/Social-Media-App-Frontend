import 'package:flutter/material.dart';
import 'package:foxxi/models/story.dart';

class StoryProvider extends ChangeNotifier {
  List<Story> _storyList = [];

  List<Story> get storyList => _storyList;

  void setStory(List<Story> storyData) {
    _storyList = storyData;
    notifyListeners();
  }
}
