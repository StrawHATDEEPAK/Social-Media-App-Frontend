import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foxxi/components/custom_textfield.dart';
import 'package:foxxi/providers/theme_provider.dart';
import 'package:foxxi/services/story_service.dart';
import 'package:foxxi/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

enum Items { gallery, camera }

class AddStory extends StatefulWidget {
  // const AddPost({super.key});
  //Photo -- true Video -- false
  final bool isImage;
  const AddStory({super.key, required this.isImage});

  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  final CustomTextField _customTextField =
      CustomTextField(hintext: 'Include body for your story');
  Items? selectedMenu;

  var _image;
  File? _video;
  final picker = ImagePicker();
  XFile? pickedFile;
  VideoPlayerController? _videoPlayerController;
  StoryService storyService = StoryService();
  XFile? image;

// This funcion will helps you to pick a Video File
  _pickVideo() async {
    // ignore: deprecated_member_use
    if (selectedMenu != null) {
      pickedFile = await picker.pickVideo(
          source: (selectedMenu == Items.camera)
              ? ImageSource.camera
              : ImageSource.gallery);
      //     .then((value) {
      //   setState(() {
      //     selectedMenu = null;
      //   });
      // });
      setState(() {
        selectedMenu = null;
      });
      if (pickedFile?.path != null) {
        selectedMenu = null;
        _video = File(pickedFile!.path);
        _videoPlayerController = VideoPlayerController.file(_video!)
          ..initialize().then((_) {
            setState(() {});
            _videoPlayerController!.play();
          });
      }
    }
  }

  var imagePicker;
  @override
  void initState() {
    imagePicker = ImagePicker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      appBar: AppBar(
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: (widget.isImage == true)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Add Story',
                    style: TextStyle(
                        fontSize: 20,
                        color: isDark ? Colors.grey.shade100 : Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Caption',
                      style: TextStyle(
                          color: isDark ? Colors.grey.shade100 : Colors.black)),
                ),
                _customTextField,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Media',
                      style: TextStyle(
                          color: isDark ? Colors.grey.shade100 : Colors.black)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedMenu != null) {
                        image = await imagePicker.pickImage(
                            source: (selectedMenu == Items.camera)
                                ? ImageSource.camera
                                : ImageSource.gallery);

                        setState(() {
                          selectedMenu = null;
                        });

                        if (image != null) {
                          setState(() {
                            _image = File(image!.path);
                            selectedMenu = null;
                          });
                        }
                      }
                    },
                    child: Container(
                      // padding: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade500,
                              style: BorderStyle.solid,
                              width: 3)),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: _image != null
                          ? Image.file(
                              _image,
                              fit: BoxFit.cover,
                            )
                          : selectedMenu == null
                              ? PopupMenuButton<Items>(
                                  initialValue: selectedMenu,
                                  onSelected: (Items item) {
                                    setState(() {
                                      selectedMenu = item;
                                    });
                                  },
                                  itemBuilder: (BuildContext ctx) =>
                                      <PopupMenuEntry<Items>>[
                                        const PopupMenuItem<Items>(
                                          value: Items.gallery,
                                          child: Text('Choose from Gallery'),
                                        ),
                                        const PopupMenuItem<Items>(
                                          value: Items.camera,
                                          child: Text('Choose from camera'),
                                        ),
                                      ],
                                  child: const Icon(Icons.upload))
                              : selectedMenu == Items.camera
                                  ? const Icon(Icons.camera)
                                  : const Icon(Icons.file_copy_rounded),
                    ),
                  ),
                ),
                Padding(
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
                                  const Color(0xffff4e00).withOpacity(0.4),
                                  const Color(0xffec9f05).withOpacity(0.4),
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
                            storyService.createStories(
                                context: context,
                                caption: _customTextField.caption,
                                imageFilePath: image!.path);
                            Navigator.pop(context);
                          },
                          child: const Text('Upload'),
                        ),
                      ]),
                    ],
                  ),
                )
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Add Story',
                    style: TextStyle(
                        fontSize: 20,
                        color: isDark ? Colors.grey.shade100 : Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Caption',
                    style: TextStyle(
                        color: isDark ? Colors.grey.shade100 : Colors.black),
                  ),
                ),
                _customTextField,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Media',
                    style: TextStyle(
                        color: isDark ? Colors.grey.shade100 : Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      _pickVideo();
                    },
                    child: Container(
                      // padding: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade500,
                              style: BorderStyle.solid,
                              width: 3)),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: _video != null
                          ? _videoPlayerController!.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio:
                                      _videoPlayerController!.value.aspectRatio,
                                  child: VideoPlayer(_videoPlayerController!),
                                )
                              : Container()
                          : selectedMenu == null
                              ? PopupMenuButton<Items>(
                                  initialValue: selectedMenu,
                                  onSelected: (Items item) {
                                    setState(() {
                                      selectedMenu = item;
                                    });
                                  },
                                  itemBuilder: (BuildContext ctx) =>
                                      <PopupMenuEntry<Items>>[
                                        const PopupMenuItem<Items>(
                                          value: Items.gallery,
                                          child: Text('Choose from Gallery'),
                                        ),
                                        const PopupMenuItem<Items>(
                                          value: Items.camera,
                                          child: Text('Choose from camera'),
                                        ),
                                      ],
                                  child: const Icon(Icons.upload))
                              : selectedMenu == Items.camera
                                  ? const Icon(Icons.camera)
                                  : const Icon(Icons.file_copy_rounded),
                    ),
                  ),
                ),
                Padding(
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
                                  const Color(0xffec9f05).withOpacity(0.4),
                                  const Color(0xffff4e00).withOpacity(0.4),
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
                            if (_customTextField.caption.isNotEmpty) {
                              storyService.createStories(
                                  context: context,
                                  caption: _customTextField.caption,
                                  videoFilePath: pickedFile!.path);
                              Navigator.pop(context);
                            } else {
                              showSnackBar(context, "Field can't be empty");
                            }
                          },
                          child: const Text('Upload'),
                        ),
                      ]),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
