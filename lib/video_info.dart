import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'colors.dart' as color;

class VideoInfo extends StatefulWidget {
  const VideoInfo({super.key});

  @override
  State<VideoInfo> createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {
  List videoInfo = [];

  _initData() async{
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
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [color.AppColor.gradientFirst.withOpacity(0.9), color.AppColor.gradientSecond],
                  begin: const FractionalOffset(0.0, 0.4),
                  end: Alignment.topRight)),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
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
                                TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color.AppColor
                                    .circuitsColor)),
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
                        const SizedBox(height: 20,),
                        Expanded(
                            child: _listView())
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }

  _listView() {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        itemCount: videoInfo.length,
        itemBuilder: (_, int index) {
          return GestureDetector(
            onTap: () {
              debugPrint(index.toString());
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
                    image: DecorationImage(image: AssetImage(videoInfo[index]["thumbnail"]),
                        fit: BoxFit.cover))),
            const SizedBox(width: 10,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  videoInfo[index]["title"],
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(padding: const EdgeInsets.only(top: 3),
                  child: Text(
                      videoInfo[index]["time"],
                      style: TextStyle(
                          color: Colors.grey[500]
                      )
                  ),
                ),
              ],
            )
          ]),
          const SizedBox(height: 18,),
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
                  child: Text(
                      "15s rest", style: TextStyle(
                      color: Color(0xff839fed)
                  )
                  ),
                ),
              ),
              Row(
                children: [
                  for(int i = 0; i < 70; i++)
                    i.isEven ? Container(
                      width: 3,
                      height: 1,
                      decoration: BoxDecoration(
                          color: Color(0xff839fed),
                          borderRadius: BorderRadius.circular(2)
                      ),
                    ) : Container(width: 3, height: 1, color: Colors.white)
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
