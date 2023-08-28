import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'colors.dart' as color;
import 'dart:developer' as developer;

class VideoInfo extends StatefulWidget {
  const VideoInfo({super.key});

  @override
  State<VideoInfo> createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {
  List videoInfo = [];
  bool _playArea = false;
  bool _isPlaying = false;
  bool _disposed = false;
  int _isPlayingIndex = -1;
  VideoPlayerController? _controller;

  _initData() async {
    await DefaultAssetBundle.of(context).loadString("json/videoinfo.json").then((value) => {
          setState(() {
            videoInfo = json.decode(value);
          })
        });
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _disposed = true;
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: _playArea == false
          ? BoxDecoration(
              gradient: LinearGradient(
                  colors: [color.AppColor.gradientFirst.withOpacity(0.9), color.AppColor.gradientSecond],
                  begin: const FractionalOffset(0.0, 0.4),
                  end: Alignment.topRight))
          : BoxDecoration(
              color: color.AppColor.gradientSecond,
            ),
      child: Column(
        children: [
          _playArea == false
              ? Container(
                  padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(Icons.arrow_back_ios, size: 20, color: color.AppColor.secondPageIconColor)),
                          Expanded(child: Container()),
                          Icon(Icons.info_outline, size: 20, color: color.AppColor.secondPageIconColor)
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Legs Toning",
                        style: TextStyle(fontSize: 25, color: color.AppColor.secondPageTitleColor),
                      ),
                      Text(
                        "and Glutes Workout",
                        style: TextStyle(fontSize: 25, color: color.AppColor.secondPageTitleColor),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(children: [
                        Container(
                          width: 100,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  color.AppColor.secondPageContainerGradient1stColor,
                                  color.AppColor.secondPageContainerGradient2ndColor,
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              )),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.timer_outlined, size: 20, color: color.AppColor.secondPageIconColor),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("68 mins", style: TextStyle(fontSize: 16, color: color.AppColor.secondPageIconColor))
                          ]),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          width: 240,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  color.AppColor.secondPageContainerGradient1stColor,
                                  color.AppColor.secondPageContainerGradient2ndColor,
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              )),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.handyman_outlined, size: 20, color: color.AppColor.secondPageIconColor),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("Resistent band, kettebell",
                                style: TextStyle(fontSize: 16, color: color.AppColor.secondPageIconColor))
                          ]),
                        ),
                      ])
                    ],
                  ),
                )
              : Column(
              children: [
                Container(
                    height: 100,
                    padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(Icons.arrow_back_ios, size: 20, color: color.AppColor.secondPageTopIconColor),
                        ),
                        Expanded(child: Container()),
                        Icon(Icons.info_outline, size: 20, color: color.AppColor.secondPageTopIconColor),
                      ],
                    )),
                _playView(context),
                _controlView(context),
              ],
                ),
          Expanded(
              child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(70),
                )),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const SizedBox(
                      height: 30,
                      width: 30,
                    ),
                    Text("Circuit 1: Legs Toning",
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color.AppColor.circuitsColor)),
                    Expanded(child: Container()),
                    Row(
                      children: [
                        Icon(Icons.loop, size: 30, color: color.AppColor.loopColor),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("3 sets",
                            style: TextStyle(
                              fontSize: 15,
                              color: color.AppColor.setsColor,
                            ))
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(child: _listView())
              ],
            ),
          ))
        ],
      ),
    ));
  }

  String convertTwo(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  Widget _controlView(BuildContext context) {
    final noMute = (_controller?.value.volume ?? 0) > 0;
    final duration = _duration?.inSeconds ?? 0;
    final head = _position?.inSeconds ?? 0;
    final remained = max(0, duration - head);
    final mins = convertTwo(remained ~/ 60.0);
    final secs = convertTwo(remained % 60);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.red[700],
            inactiveTrackColor: Colors.red[100],
            trackShape: const RoundedRectSliderTrackShape(),
            trackHeight: 2.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
            thumbColor: Colors.redAccent,
            overlayColor: Colors.red.withAlpha(32),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
            tickMarkShape: const RoundSliderTickMarkShape(),
            activeTickMarkColor: Colors.red[700],
            inactiveTickMarkColor: Colors.red[100],
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: Colors.redAccent,
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.white,
            )
        ), child: Slider(
          value: max(0, min(_progress * 100, 100)),
          min: 0,
          max: 100,
          divisions: 100,
          label: _position?.toString().split(".")[0],
          onChanged: (value) {
            setState(() {
              _progress = value * 0.01;
            });
          },
          onChangeStart: (value) {
            _controller?.pause();
          },
          onChangeEnd: (value) {
            final duration = _controller?.value.duration;
            if (duration != null) {
              var newValue = max(0, min(value, 99)) * 0.01;
              var millis = (duration.inMilliseconds * newValue).toInt();
              _controller?.seekTo(Duration(microseconds: millis));
              _controller?.play();
            }
          },
        )),
        Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                      BoxShadow(offset: Offset(0.0, 0.0), blurRadius: 4.0, color: Color.fromARGB(50, 0, 0, 0))
                    ]),
                    child: Icon(
                      noMute ? Icons.volume_up : Icons.volume_off,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {
                  if (noMute) {
                    _controller?.setVolume(0);
                  } else {
                    _controller?.setVolume(1.0);
                  }
                  setState(() {

                  });
                },
              ),
              TextButton(
                onPressed: () async {
                  final index = _isPlayingIndex - 1;
                  if (index >= 0 && videoInfo.isNotEmpty) {
                    _initializeVideo(index);
                  } else {
                    Get.snackbar("Video List", "",
                        snackPosition: SnackPosition.BOTTOM,
                        icon: const Icon(
                          Icons.face,
                          size: 30,
                          color: Colors.white,
                        ),
                        backgroundColor: color.AppColor.gradientSecond,
                        colorText: Colors.white,
                        messageText: const Text("No videos ahead!", style: TextStyle(fontSize: 20, color: Colors.white)));
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero
                ),
                child: const Icon(Icons.fast_rewind, size: 36, color: Colors.white),
              ),
              TextButton(
                onPressed: () async {
                  if (_isPlaying) {
                    setState(() {
                      _isPlaying = false;
                    });
                    _controller?.pause();
                  } else {
                    setState(() {
                      _isPlaying = true;
                    });
                    _controller?.play();
                  }
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero
                ),
                child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 36, color: Colors.white),
              ),
              TextButton(
                onPressed: () async {
                  final index = _isPlayingIndex + 1;
                  if (index <= videoInfo.length - 1) {
                    _initializeVideo(index);
                  } else {
                    Get.snackbar("Video List", "",
                        snackPosition: SnackPosition.BOTTOM,
                        icon: const Icon(
                          Icons.face,
                          size: 30,
                          color: Colors.white,
                        ),
                        backgroundColor: color.AppColor.gradientSecond,
                        colorText: Colors.white,
                        messageText: const Text("You have finished watching all the videos.",
                            style: TextStyle(fontSize: 20, color: Colors.white)));
                  }
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero
                ),
                child: const Icon(Icons.fast_forward, size: 36, color: Colors.white),
              ),
              Text(
                "$mins:$secs",
                style: const TextStyle(
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, 1.0),
                      blurRadius: 4.0,
                      color: Color.fromARGB(150, 0, 0, 0),
                    )
                  ]
                )
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _playView(BuildContext context) {
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: VideoPlayer(controller),
      );
    } else {
      return const AspectRatio(
          aspectRatio: 16 / 9,
          child: Center(
              child: Text(
            "Preparing...",
            style: TextStyle(fontSize: 20, color: Colors.white60),
          )));
    }
  }

  var _onUpdateControllerTime = 0;
  Duration? _duration;
  Duration? _position;
  var _progress = 0.0;
  void _onControllerUpdate() async {
    if (_disposed) {
      return;
    }

    //_onUpdateControllerTime = 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_onUpdateControllerTime > now) {
      return;
    }

    _onUpdateControllerTime = now + 500;
    final controller = _controller;
    if (controller == null) {
      debugPrint("controller can not be null");
      return;
    }
    if (!controller.value.isInitialized) {
      debugPrint("controller can not be initialized");
      return;
    }

    _duration = _controller?.value.duration;
    var duration = _duration;
    if (duration == null) return;

    var position = await controller.position;
    _position = position;

    final playing = controller.value.isPlaying;
    if (playing) {
      //handle progress indicator
      if (_disposed) return;
      setState(() {
        // range: (0, 1), Ex: 45 / 60 = 0.75
        _progress = position!.inMilliseconds.ceilToDouble() / duration.inMilliseconds.ceilToDouble();
      });
    }
    _isPlaying = playing;
  }

  _initializeVideo(int index) {
    if (_controller != null) {
      _controller?.removeListener(_onControllerUpdate);
      _controller?.pause();
      _controller?.dispose();
    }
    _controller = VideoPlayerController.networkUrl(Uri.parse(videoInfo[index]["videoUrl"]))
      ..addListener(_onControllerUpdate)
      ..initialize().then((_) {
        _isPlayingIndex = index;
        setState(() {});
        _controller?.play();
      });
  }

  _listView() {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        itemCount: videoInfo.length,
        itemBuilder: (_, int index) {
          return GestureDetector(
            onTap: () {
              _initializeVideo(index);
              debugPrint(index.toString());
              setState(() {
                if (_playArea == false) {
                  _playArea = true;
                }
              });
            },
            child: _buildCard(index),
          );
        });
  }

  _buildCard(int index) {
    return SizedBox(
      height: 135,
      width: 200,
      child: Column(
        children: [
          Row(children: [
            Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(image: AssetImage(videoInfo[index]["thumbnail"]), fit: BoxFit.cover))),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  videoInfo[index]["title"],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(videoInfo[index]["time"], style: TextStyle(color: Colors.grey[500])),
                ),
              ],
            )
          ]),
          const SizedBox(
            height: 18,
          ),
          Row(
            children: [
              Container(
                width: 80,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xffeaeefc),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text("15s rest", style: TextStyle(color: Color(0xff839fed))),
                ),
              ),
              Row(
                children: [
                  for (int i = 0; i < 70; i++)
                    i.isEven
                        ? Container(
                            width: 3,
                            height: 1,
                            decoration:
                                BoxDecoration(color: const Color(0xff839fed), borderRadius: BorderRadius.circular(2)),
                          )
                        : Container(width: 3, height: 1, color: Colors.white)
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
