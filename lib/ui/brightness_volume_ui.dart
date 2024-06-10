import 'package:flutter/material.dart';
import 'package:flutter_jin_player/constants/ui_constants.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:get/get.dart';

enum BrightnessVolumeType { brightness, volume, none }

class BrightnessVolumeUI extends GetView<PlayerGetxController> {
  const BrightnessVolumeUI(
      {super.key, this.brightnessVolumeType = BrightnessVolumeType.none});
  final BrightnessVolumeType brightnessVolumeType;

  @override
  Widget build(BuildContext context) {
    return brightnessVolumeType == BrightnessVolumeType.none
        ? Container()
        : Center(
            child: UnconstrainedBox(
              child: Container(
                width: UIConstants.volumeOrBrightnessUISize.width,
                height: UIConstants.volumeOrBrightnessUISize.height,
                decoration: BoxDecoration(
                  color: UIConstants.backgroundColor,
                  //设置四周圆角 角度
                  borderRadius: const BorderRadius.all(
                      Radius.circular(UIConstants.borderRadius)),
                ),
                child: Obx(() {
                  List<Widget> uiList = [];
                  if (brightnessVolumeType == BrightnessVolumeType.brightness) {
                    uiList = [
                      const Icon(
                        Icons.brightness_6_rounded,
                        color: UIConstants.iconColor,
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                      Text(
                        "${controller.playConfigOptions.brightness}%",
                        style: const TextStyle(
                            color: UIConstants.textColor,
                            fontSize: UIConstants.textSize),
                      )
                    ];
                  } else if (brightnessVolumeType ==
                      BrightnessVolumeType.volume) {
                    uiList = [
                      const Icon(
                        Icons.volume_up_rounded,
                        color: UIConstants.iconColor,
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                      Text(
                        "${controller.playConfigOptions.volume}%",
                        style: const TextStyle(
                            color: UIConstants.textColor,
                            fontSize: UIConstants.textSize),
                      )
                    ];
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: uiList.map((e) => e).toList(),
                  );
                }),
              ),
            ),
          );
  }
}
