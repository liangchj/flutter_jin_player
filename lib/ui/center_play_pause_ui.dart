import 'package:flutter/material.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:get/get.dart';

// 居中播放和暂停按钮
class CenterPlayPauseUI extends GetView<PlayerGetxController> {
  const CenterPlayPauseUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow_rounded)),
    );
  }
}
