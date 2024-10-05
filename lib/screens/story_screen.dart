import 'package:flutter/material.dart';
import 'package:foxxi/models/story.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:developer' as dev;
import 'package:flutter_carousel_slider/carousel_slider.dart';

import '../components/pinch_to_zoom.dart';
import '../providers/theme_provider.dart';

class StoryScreen extends StatefulWidget {
  List<Story> stories;
  StoryScreen({super.key, required this.stories});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  VideoPlayerController? _controller;

  late CarouselSliderController _sliderController;

  @override
  void initState() {
    intializeVideoController();
    _sliderController = CarouselSliderController();

    super.initState();
  }

  void intializeVideoController() {
    for (Story story in widget.stories) {
      if (story.media!.mediatype == 'video') {
        dev.log('Video Intializer Story Called');
        _controller = VideoPlayerController.network(story.media!.url.toString())
          ..initialize().then((_) {
            _controller?.setLooping(true);
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
      }
    }
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
    }
    _sliderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        body: SingleChildScrollView(
            child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider.builder(
            enableAutoSlider: false,
            unlimitedMode: false,
            controller: _sliderController,
            slideBuilder: (index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 16),
                          height: 100,
                          // width: MediaQuery.of(context).size.width * 0.1,
                          child: CircleAvatar(
                            backgroundColor:
                                const Color(0xffec9f05).withOpacity(0.4),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 16,
                      ).copyWith(right: 0),
                      child: Row(
                        children: <Widget>[
                          Card(
                            shape: const CircleBorder(),
                            elevation: 5,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(widget
                                  .stories[index].author.image
                                  .toString()),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.stories[index].author.name
                                        .toString(),
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.grey.shade100
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "@${widget.stories[index].author.username}"
                                        .toString(),
                                    style: const TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
                      child: Text(widget.stories[index].caption),
                    ),
                    widget.stories[index].media!.mediatype != 'video'
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              width: MediaQuery.of(context).size.width - 20,
                              child: PinchZoom(
                                resetDuration:
                                    const Duration(milliseconds: 100),
                                maxScale: 3,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  child: Image.network(
                                    widget.stories[index].media!.url.toString(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          )
                        // ? Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Container(
                        //       height: MediaQuery.of(context).size.height/2,
                        //       width: MediaQuery.of(context).size.width-20,
                        //       decoration: BoxDecoration(
                        //         borderRadius:
                        //             const BorderRadius.all(Radius.circular(30)),
                        //         // border: Border(
                        //         //     bottom:
                        //         //         BorderSide(color: Colors.black.withOpacity(1))),
                        //         image: DecorationImage(
                        //           image: NetworkImage(widget
                        //               .stories[index].media!.url
                        //               .toString()),
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //       child: DecoratedBox(child: , ),

                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 2,
                              width: MediaQuery.of(context).size.width - 20,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                // border: Border(
                                //     bottom: BorderSide(color: Colors.black.withOpacity(1))),
                              ),
                              child: Stack(
                                children: [
                                  _controller!.value.isInitialized
                                      ? Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2,
                                          width: 400,
                                          child: VideoPlayer(_controller!))
                                      : Container(),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: FloatingActionButton(
                                      onPressed: () {
                                        setState(
                                          () {
                                            _controller!.value.isPlaying
                                                ? _controller!.pause()
                                                : _controller!.play();
                                          },
                                        );
                                      },
                                      child: Icon(
                                        _controller!.value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              );
            },
            slideTransform: const CubeTransform(),
            itemCount: widget.stories.length,
          ),
        )));
  }
}
