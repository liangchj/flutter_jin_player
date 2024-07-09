import 'package:flutter/material.dart';
import 'package:flutter_jin_player/constants/ui_constants.dart';
import 'package:flutter_jin_player/controller/getx_id.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:flutter_jin_player/utils/format_util.dart';
import 'package:flutter_jin_player/widgets/player_progress_bar.dart';
import 'package:get/get.dart';

// 播放器底部UI
class PlayerBottomUI extends GetView<PlayerGetxController> {
  const PlayerBottomUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        // 背景渐变效果
        decoration: BoxDecoration(gradient: UIConstants.bottomUILinearGradient),
        child: controller.playConfigOptions.isFullScreen.value
            ? _buildHorizontalScreenBottomUI()
            : _buildVerticalScreenBottomUI()));
  }

  /// 竖屏底部UI
  Widget _buildVerticalScreenBottomUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 播放/暂停按钮
        _buildPlayPause(),
        // 下一个视频按钮
        if (controller.playConfigOptions.resourceChapterList.isNotEmpty &&
            controller.playConfigOptions.resourceChapterList.length > 1 &&
            controller.playConfigOptions.resourceChapterList.length - 1 >
                controller.playConfigOptions.currentPlayIndex.value)
          IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              onPressed: () => controller.playNext(),
              icon: UIConstants.nextPlayIcon),

        // 播放时长
        _buildPlayPositionDuration(),
        // 进度条
        _buildProgressBar(),
        // 总时长
        _buildTotalDuration(),
        if (!(controller.fullScreenPlayDeep <= 1 &&
            controller.playConfigOptions.isFullScreen.value))
          // 全屏按钮
          IconButton(
              onPressed: () {
                controller.entryOrExitFullScreen();
              },
              icon: UIConstants.entryFullScreenIcon),
      ],
    );
  }

  /// 横屏底部UI
  Widget _buildHorizontalScreenBottomUI() {
    return _buildBottomEvent(DefaultTextStyle(
        style: const TextStyle(
            color: UIConstants.textColor, fontSize: UIConstants.textSize),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 播放时长
                _buildPlayPositionDuration(),
                // 进度条
                _buildProgressBar(),
                // 总时长
                _buildTotalDuration(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPlayPause(),
                // 下一个视频
                if (controller.playConfigOptions.resourceChapterList.isNotEmpty &&
                    controller.playConfigOptions.resourceChapterList.length >
                        1 &&
                    controller.playConfigOptions.resourceChapterList.length -
                            1 >
                        controller.playConfigOptions.currentPlayIndex.value)
                  IconButton(
                      onPressed: () => controller.playNext(),
                      icon: UIConstants.nextPlayIcon),

                // 弹幕开关
                IconButton(
                    onPressed: () => controller.danmakuControl
                        .setDanmakuVisibility(
                            !controller.danmakuConfigOptions.visible.value),
                    icon: Obx(() =>
                        controller.danmakuConfigOptions.visible.value
                            ? UIConstants.danmakuOpen
                            : UIConstants.danmakuClose)),

                // // 弹幕设置
                IconButton(
                    onPressed: () => controller.uiControl
                        .onlyShowUIByKeyList([GetxId.danmakuSettingUI]),
                    icon: UIConstants.danmakuSetting),

                Expanded(child: Container()),

                // 选集
                if (controller
                        .playConfigOptions.resourceChapterList.isNotEmpty &&
                    controller.playConfigOptions.resourceChapterList.length > 1)
                  TextButton(
                    onPressed: () => controller.uiControl
                        .onlyShowUIByKeyList([GetxId.chapterUI]),
                    child: const Text(
                      "选集",
                      style: TextStyle(color: UIConstants.textColor),
                    ),
                  ),

                // 倍数
                TextButton(
                  onPressed: () => controller.uiControl
                      .onlyShowUIByKeyList([GetxId.speedSettingUI]),
                  child: const Text(
                    "倍数",
                    style: TextStyle(color: UIConstants.textColor),
                  ),
                ),

                /// 只有全屏时没有退出全屏按钮
                if (!(controller.fullScreenPlayDeep > 1 &&
                    controller.playConfigOptions.isFullScreen.value))
                  IconButton(
                      onPressed: () {
                        controller.entryOrExitFullScreen();
                      },
                      icon: const Icon(
                        Icons.fullscreen_exit_rounded,
                        color: Colors.white,
                      )),
              ],
            )
          ],
        )));
  }

  _buildBottomEvent(Widget widget) {
    return GestureDetector(
      onTap: () {
        // controller.cancelAndRestartTimer();
      },
      child: Container(
        padding: const EdgeInsets.only(top: 6),
        decoration: BoxDecoration(
            // 渐变颜色（上下至上）
            gradient: UIConstants.bottomUILinearGradient),
        child: widget,
      ),
    );
  }

  /// 播放、暂停按钮
  Widget _buildPlayPause() {
    return IconButton(
      onPressed: () => controller.playOrPause(),
      icon: Obx(() {
        var isFinished = controller.playConfigOptions.finished.value;
        var isPlaying = controller.playConfigOptions.playing.value;
        return isFinished
            ? UIConstants.bottomReplayPlayIcon
            : (isPlaying
                ? UIConstants.bottomPauseIcon
                : UIConstants.bottomPlayIcon);
      }),
    );
  }

  /// 播放时长位置
  Widget _buildPlayPositionDuration({EdgeInsetsGeometry? padding}) {
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: UIConstants.padding),
      child: Obx(() => Text(durationToMinuteAndSecond(
          controller.playConfigOptions.positionDuration.value))),
    );
  }

  /// 总时长
  Widget _buildTotalDuration({EdgeInsetsGeometry? padding}) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() => Text(durationToMinuteAndSecond(
          controller.playConfigOptions.duration.value))),
    );
  }

  /// 进度条
  Widget _buildProgressBar() {
    return Expanded(
      child: Obx(() {
        if (!controller.uiConfigOptions.bottomUI.visible.value) {
          return Container();
        }
        controller.logger
            .d("播放进度：${controller.playConfigOptions.positionDuration}");
        return AbsorbPointer(
          absorbing: !controller.playConfigOptions.initialized.value,
          child: PlayerProgressBar(
            progress: controller.playConfigOptions.positionDuration.value,
            totalDuration: controller.playConfigOptions.duration.value,
            bufferedDurationRange:
                controller.playConfigOptions.bufferedDurationRange.value,
            barHeight: UIConstants.progressBarHeight,
            thumbShape: ProgressBarThumbShape(
                thumbColor: Colors.redAccent,
                thumbRadius: UIConstants.progressBarThumbRadius,
                thumbInnerColor: Colors.white,
                thumbInnerRadius: UIConstants.progressBarThumbInnerRadius),
            thumbOverlayColor: UIConstants.progressBarThumbOverlayColor,
            thumbOverlayShape: ProgressBarThumbOverlayShape(
                thumbOverlayColor:
                    UIConstants.progressBarThumbOverlayShapeColor,
                thumbOverlayRadius:
                    UIConstants.progressBarThumbOverlayColorShapeRadius),
            onChangeStart: (details) {
              controller.hideTimer?.cancel();
              controller.playConfigOptions.dragging(true);
            },
            onChangeEnd: (details) {
              if (controller.playConfigOptions.playing.value) {
                controller.pause();
                controller.playConfigOptions.beforeSeekIsPlaying(true);
              } else {
                controller.playConfigOptions.beforeSeekIsPlaying(false);
              }
              controller.playConfigOptions.dragging(false);
            },
            onChanged: (details) {
              controller.logger.d("进度条改变事件");
            },
            onSeek: (details) async {
              controller.playConfigOptions.seeking(true);
              await controller
                  .seekTo(details.currentDuration)
                  .then((value) async {
                if (controller.playConfigOptions.beforeSeekIsPlaying.value) {
                  await controller.play();
                  controller.playConfigOptions.seeking(false);
                }
              });
              if (controller.uiControl.haveUIShow()) {
                controller.startHideTimer();
              }
            },
          ),
        );
      }),
    );
  }
}
