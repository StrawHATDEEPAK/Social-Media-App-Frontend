import 'package:foxxi/models/feed_post_model.dart';
// import 'package:instagram_app/models/post.dart';
import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {
  // Post _post = Post(
  //     caption: '',
  //     author: ,
  //     hashtags: [],
  //     likes: [],
  //     comments: [],
  //     updatedAt: '',
  //     createdAt: '',
  //     reposts: 0,
  //     media: '',
  //     gifLink: '',
  //     twitterId: '',
  //     reports: [],
  //     originalPostId: '');
  //
  // // bool _isLoading = true;
  // // Bool get isLoading => _isLoading;
  // Post get post => _post;

  List<FeedPostModel> _postList = [];
  List<FeedPostModel> _trendingPostsList = [];
  late FeedPostModel _postById;

  List<FeedPostModel> get postList => _postList;
  List<FeedPostModel> get trendingPostsList => _trendingPostsList;
  FeedPostModel get postById => _postById;

  void setList(List<FeedPostModel> list) {
    _postList = list;
    notifyListeners();
  }

  void setPostById(String post) {
    _postById = FeedPostModel.fromJson(post);
    notifyListeners();
  }

  void setTrendingPostsList(List<FeedPostModel> list) {
    _trendingPostsList = list;
    notifyListeners();
  }
}
