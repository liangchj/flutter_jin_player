import 'package:flutter/material.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:flutter_jin_player/models/ui_config_options.dart';
import 'package:get/get.dart';

import 'background_event_ui.dart';

class PlayerUI extends StatefulWidget {
  const PlayerUI({super.key});

  @override
  State<PlayerUI> createState() => _PlayerUIState();
}

class _PlayerUIState extends State<PlayerUI> with TickerProviderStateMixin {
  PlayerGetxController controller = Get.find<PlayerGetxController>();
  @override
  void initState() {
    controller.uiControl.updateAnimateController(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在这里执行你的构建之后的操作
      controller.cancelAndRestartTimer();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.logger.d(
        "playerUI创建，isFullScreen：${controller.playConfigOptions.isFullScreen.value}");
    try {
      return ClipRect(
        // 使用ClipRect来裁剪Stack的溢出内容
        child: Stack(
          children: [
            // 事件层
            const Positioned.fill(child: BackgroundEventUI()),
            // 顶部UI（资源信息）
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Obx(() =>
                  _createSlideTransitionUI(controller.uiConfigOptions.topUI)),
            ),

            // 底部UI（进度和控制信息）
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Obx(() => _createSlideTransitionUI(
                  controller.uiConfigOptions.bottomUI)),
            ),

            // 居中暂停或播放按钮
            Center(
              child: Obx(() =>
                  controller.uiConfigOptions.centerPlayPauseUI.ui.value ??
                  Container()),
            ),

            // 居中加载
            Center(
              child: Obx(() =>
                  controller.uiConfigOptions.centerLoadingUI.ui.value ??
                  Container()),
            ),

            // 居中进度
            Center(
              child: Obx(() =>
                  controller.uiConfigOptions.centerProgressUI.ui.value ??
                  Container()),
            ),

            // 左边UI （锁按钮）
            Align(
              alignment: Alignment.centerLeft,
              child: Obx(() => _createSlideTransitionUI(
                  controller.uiConfigOptions.lockCtrUI)),
            ),
            // 右边UI（截屏按钮）
            Align(
              alignment: Alignment.centerRight,
              child: Obx(() => _createSlideTransitionUI(
                  controller.uiConfigOptions.screenshotCtrUI)),
            ),

            // 右边播放速度设置（全屏情况显示）
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: Obx(() => controller.playConfigOptions.isFullScreen.value
                  ? _createSlideTransitionUI(
                      controller.uiConfigOptions.speedSettingUI)
                  : Container()),
            ),

            // 右边章节选择（全屏情况显示）
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: Obx(() => controller.playConfigOptions.isFullScreen.value
                  ? _createSlideTransitionUI(
                      controller.uiConfigOptions.chapterUI)
                  : Container()),
            ),

            // 右边设置（全屏情况显示）
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: Obx(() => controller.playConfigOptions.isFullScreen.value
                  ? _createSlideTransitionUI(
                      controller.uiConfigOptions.settingUI)
                  : Container()),
            ),

            // 右边弹幕源设置（全屏情况显示）
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: Obx(() => controller.playConfigOptions.isFullScreen.value
                  ? _createSlideTransitionUI(
                      controller.uiConfigOptions.danmakuSourceSettingUI)
                  : Container()),
            ),

            // 右边弹幕设置（全屏情况显示）
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: Obx(() => controller.playConfigOptions.isFullScreen.value
                  ? _createSlideTransitionUI(
                      controller.uiConfigOptions.danmakuSettingUI)
                  : Container()),
            ),

            // 居中错误信息
            Center(
              child: Obx(() => controller.playConfigOptions.errorMsg.isNotEmpty
                  ? Center(
                      child: Text(controller.playConfigOptions.errorMsg.value),
                    )
                  : Container()),
            ),

            // 居中亮度和音量（最高层）
            Center(
              child: Obx(() =>
                  controller
                      .uiConfigOptions.centerVolumeAndBrightnessUI.ui.value ??
                  Container()),
            ),
          ],
        ),
      );
    } catch (e) {
      return Container();
    }
  }

  Widget _createSlideTransitionUI(RxPlayerOverlayUI overlayUI) {
    Widget? ui = overlayUI.ui.value;
    if (ui == null) {
      return Container();
    }
    if (overlayUI.useAnimationController && overlayUI.animation != null) {
      ui = SlideTransition(
        position: overlayUI.animation!,
        child: ui,
      );
    }
    return ui;
  }
}

/// 文本框Widget
class BuildTextWidget extends StatelessWidget {
  const BuildTextWidget(
      {super.key, required this.text, this.style, this.edgeInsets});
  final String text;
  final TextStyle? style;
  final EdgeInsets? edgeInsets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: edgeInsets ?? const EdgeInsets.only(left: 5, right: 5),
      child: Text(text, style: style ?? const TextStyle(color: Colors.white)),
    );
  }
}
