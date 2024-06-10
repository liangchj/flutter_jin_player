import 'package:flutter/material.dart';
import 'package:flutter_jin_player/constants/ui_constants.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:flutter_jin_player/utils/format_util.dart';
import 'package:get/get.dart';

class PlayProgressUI extends GetView<PlayerGetxController> {
  const PlayProgressUI({super.key});

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        width: UIConstants.playProgressUISize.width,
        height: UIConstants.playProgressUISize.height,
        decoration: BoxDecoration(
          color: UIConstants.backgroundColor,
          //设置四周圆角 角度
          borderRadius:
              const BorderRadius.all(Radius.circular(UIConstants.borderRadius)),
        ),
        child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${durationToMinuteAndSecond(Duration(seconds: controller.playConfigOptions.draggingSecond.value > 0 ? controller.playConfigOptions.dragProgressPositionDuration.inSeconds + controller.playConfigOptions.draggingSecond.value : 0))}/${durationToMinuteAndSecond(controller.playConfigOptions.duration.value)}",
                  style: const TextStyle(color: UIConstants.textColor),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                Text(
                  "${controller.playConfigOptions.draggingSecond}秒",
                  style: const TextStyle(color: UIConstants.textColor),
                )
              ],
            )),
      ),
    );
  }
}
