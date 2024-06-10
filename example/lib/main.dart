import 'package:example/v2h_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jin_player/danmaku/parse/parse_bilibili_danmaku.dart';
import 'package:flutter_jin_player/flutter_jin_player.dart';
import 'package:flutter_jin_player/models/danmaku_item.dart';
import 'package:flutter_jin_player/models/resource_chapter_item.dart';
import 'package:flutter_jin_player/models/resource_item.dart';
import 'package:get/get.dart';

void main() {
  runApp(const GetMaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton(
                onPressed: () {
                  Get.to(PlayPage(createdPlayerGetxController: (c) {
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
                    // c.playConfigOptions.resourceItem(ResourceItem(
                    //     id: "ceshi", name: "测试视频", path: "assets/video/2.mp4"));
                  }));
                },
                child: const Text("直接进入大屏")),
            TextButton(
                onPressed: () {
                  Get.to(V2hPage());
                },
                child: const Text("小屏转大屏")),
            TextButton(
                onPressed: () {
                  ParseBilibiliDanmaku()
                      .pasrseBilibiliDanmakuByXml("assets/danmaku/1.xml",
                          fromAssets: true)
                      .then((List<DanmakuItem> list) {
                    print("读取的弹幕结果：${list.length}");
                  });
                },
                child: const Text("读取弹幕")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
