import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:flutter_jin_player/jin_player_view.dart';
import 'package:flutter_jin_player/models/danmaku_item.dart';
import 'package:flutter_jin_player/models/resource_chapter_item.dart';
import 'package:flutter_jin_player/models/resource_item.dart';

class V2hPage extends StatefulWidget {
  const V2hPage({super.key});

  @override
  State<V2hPage> createState() => _V2hPageState();
}

class _V2hPageState extends State<V2hPage> {
  PlayerGetxController? playerGetxController;
  Timer? timer;
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("小屏转大屏"),
      ),
      body: Center(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9.0,
              child: Container(
                color: Colors.black,
                child: JinPlayerView(
                  createdPlayerGetxController: (c) {
                    playerGetxController = c;
                    c.playConfigOptions.resourceChapterList([
                      ResourceChapterItem(
                          resourceItem: ResourceItem(
                              id: "2",
                              name: "测试视频2",
                              path: "assets/video/2.mp4"),
                          index: 0),
                      ResourceChapterItem(
                          resourceItem: ResourceItem(
                              id: "3",
                              name: "测试视频3",
                              path: "assets/video/3.mp4"),
                          index: 1),
                    ]);
                    c.danmakuConfigOptions.visible(true);
                    c.playConfigOptions.initialized(true);
                    c.playConfigOptions.playing(true);
                    c.danmakuConfigOptions.danmakuSourceItem(
                        DanmakuSourceItem(path: "assets/danmaku/1.xml"));
                    timer = Timer.periodic(Duration(seconds: 1), (timer) {
                      c.playConfigOptions.positionDuration(Duration(
                          seconds: c.playConfigOptions.positionDuration.value
                                  .inSeconds +
                              1));
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
