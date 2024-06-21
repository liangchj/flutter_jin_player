import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_jin_player/danmaku/my_canvas_danmaku.dart';
import 'package:flutter_jin_player/flutter_jin_player.dart';

class DanmakuCanvasTest extends StatefulWidget {
  const DanmakuCanvasTest({super.key});

  @override
  State<DanmakuCanvasTest> createState() => _DanmakuCanvasTestState();
}

class _DanmakuCanvasTestState extends State<DanmakuCanvasTest> {
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
        title: const Text("canvas_danmaku测试"),
      ),
      body: Center(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9.0,
              child: Container(
                color: Colors.black,
                child: JinPlayerView(
                  configOptions: ConfigOptions(
                      danmakuConfigOptions: DanmakuConfigOptions(
                    danmaku: MyCanvasDanmaku(),
                  )),
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
                    c.danmakuConfigOptions.danmakuSourceItem(DanmakuSourceItem(
                        path: "assets/danmaku/3.xml", pathFromAssets: true));

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
