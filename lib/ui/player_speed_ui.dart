import 'package:flutter/material.dart';
import 'package:flutter_jin_player/constants/ui_constants.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:get/get.dart';

// 设置播放速度UI
class PlayerSpeedUI extends GetView<PlayerGetxController> {
  const PlayerSpeedUI({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (!controller.playConfigOptions.isFullScreen.value) {
      return SingleChildScrollView(
          child: Obx(() => Column(
                children: UIConstants.playSpeedList.map((e) {
                  Color fontColor =
                      e == controller.playConfigOptions.playSpeed.value
                          ? Colors.redAccent
                          : Colors.black;
                  return ListTile(
                      onTap: () {
                        controller.playConfigOptions.playSpeed(e);
                      },
                      textColor: fontColor,
                      title: Text("${e.toString()}x"),
                      trailing: const Icon(Icons.add));
                }).toList(),
              )));
    }

    return Container(
      width: UIConstants.speedSettingUIDefaultWidth
          .clamp(screenWidth * 0.3, screenWidth * 0.8),
      height: double.infinity,
      color: UIConstants.backgroundColor,
      padding: const EdgeInsets.all(UIConstants.padding),
      child: Center(
        child: SingleChildScrollView(
          child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: UIConstants.playSpeedList.map((e) {
                Color fontColor =
                    e == controller.playConfigOptions.playSpeed.value
                        ? UIConstants.textActivatedColor
                        : UIConstants.textColor;
                return SizedBox(
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () {
                        controller.playConfigOptions.playSpeed(e);
                      },
                      child: Text(
                        "${e.toString()}x",
                        style: TextStyle(
                            color: fontColor, fontSize: UIConstants.textSize),
                        textAlign: TextAlign.center,
                      )),
                );
              }).toList())),
        ),
      ),
    );
  }
}
