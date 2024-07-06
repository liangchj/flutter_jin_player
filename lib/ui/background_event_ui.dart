import 'package:flutter/material.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:get/get.dart';

// 背景事件层
class BackgroundEventUI extends GetView<PlayerGetxController> {
  const BackgroundEventUI({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: controller.uiControl.toggleBackground,
      onHorizontalDragStart: (DragStartDetails details) {
        if (!controller.uiConfigOptions.uiLocked.value) {
          controller.logger.d(
              "滑动屏幕 开始拖动 横向: $details, ${details.globalPosition}, ${details.localPosition}, ${context.size}");
          controller.playProgressOnHorizontalDragStart();
        }
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!controller.uiConfigOptions.uiLocked.value) {
          controller.logger.d(
              "滑动屏幕 拖动中 横向: $details, ${details.globalPosition}, ${details.localPosition}, ${details.delta}");
          controller.playProgressOnHorizontalDragUpdate(context, details.delta);
        }
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (!controller.uiConfigOptions.uiLocked.value) {
          controller.logger.d("滑动屏幕 拖动结束 横向: $details");
          controller.playProgressOnHorizontalDragEnd();
        }
      },
      onVerticalDragStart: (DragStartDetails details) {
        if (!controller.uiConfigOptions.uiLocked.value) {
          controller.logger.d(
              "滑动屏幕 开始拖动 纵向: $details, ${details.globalPosition}, ${details.localPosition}");
          controller.volumeOrBrightnessOnVerticalDragStart(details);
        }
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        if (!controller.uiConfigOptions.uiLocked.value) {
          controller.logger.d(
              "滑动屏幕 拖动中 纵向: $details, ${details.globalPosition}, ${details.localPosition}, ${details.delta}");
          controller.volumeOrBrightnessOnVerticalDragUpdate(context, details);
        }
      },
      onVerticalDragEnd: (DragEndDetails details) {
        if (!controller.uiConfigOptions.uiLocked.value) {
          controller.logger.d("滑动屏幕 拖动结束 纵向: $details");
          controller.volumeOrBrightnessOnVerticalDragEnd();
        }
      },
      child: Container(
        color: Colors.redAccent.withOpacity(0),
      ),
    );
  }
}
