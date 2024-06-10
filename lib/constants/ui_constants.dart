import 'package:flutter/material.dart';
import 'package:flutter_jin_player/widgets/my_slider_thumb_shape.dart';
import 'package:flutter_jin_player/widgets/my_slider_track_shape.dart';

abstract class UIConstants {
  // ui显示时长
  static Duration uiShowDuration = const Duration(seconds: 5);
  // ui动画时长
  static Duration uiAnimationDuration = const Duration(milliseconds: 300);
  // 图标切换动画时长
  static Duration iconChangeDuration = const Duration(milliseconds: 75);
  // 音量和亮度ui显示时长
  static const Duration volumeOrBrightnessUIShowDuration =
      Duration(milliseconds: 1000);
  // 音量和亮度UI大小
  static const Size volumeOrBrightnessUISize = Size(80, 70);
  static const Size playProgressUISize = Size(100, 70);
  // 渐变色
  static List<Color> gradientBackground = [
    Colors.black54,
    Colors.black45,
    Colors.black38,
    Colors.black26,
    Colors.black12,
    Colors.transparent
  ];
  // 顶部UI渐变色
  static final LinearGradient topUILinearGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: gradientBackground);

  // 顶部UI渐变色
  static final LinearGradient bottomUILinearGradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: gradientBackground);

  // ui背景色
  static Color backgroundColor = Colors.black.withOpacity(0.8);

  // 文本文字
  // 文本文字颜色
  static const Color textColor = Colors.white;
  static const Color textBlackColor = Colors.black;
  // 文本文字选中颜色
  static const Color textActivatedColor = Colors.redAccent;
  // 文本文字大小
  static const double textSize = 12.0;
  // 标题类字体大小
  static const double titleTextSize = 16.0;

  // 默认的图标颜色
  static const Color iconColor = Colors.white;
  // 图标选中颜色
  static const Color iconActivatedColor = Colors.redAccent;
  // 图标大小
  static const double iconSize = 26.0;

  // 默认的按钮颜色
  static const Color buttonColor = Colors.white;
  // 按钮选中颜色
  static const Color buttonActivatedColor = Colors.redAccent;

  // padding
  static const double padding = 12.0;
  // margin
  static const double margin = 12.0;
  // 边框宽度
  static const double borderWidth = 1.0;
  // 边框圆角
  static const double borderRadius = 6.0;

  // 弹幕大按钮边框圆角
  static const double danmakuBigBtnBorderRadius = 20.0;
  // 弹幕大按钮背景色
  static Color danmakuBigBtnColor = Colors.white.withOpacity(0.8);

  // 中间的播放图标
  static const ImageIcon centerPlayIcon = ImageIcon(
    AssetImage("assets/icons/center_play.png", package: "flutter_jin_player"),
    size: iconSize,
    color: iconColor,
  );
  // 中间的暂停图标
  static const ImageIcon centerPauseIcon = ImageIcon(
    AssetImage("assets/icons/center_pause.png", package: "flutter_jin_player"),
    size: iconSize,
    color: iconColor,
  );
  // 中间的重新播放图标
  static const Icon centerReplayPlayIcon = Icon(
    Icons.replay_rounded,
    size: iconSize,
    color: Colors.white,
  );

  // 底部播放图标
  static const ImageIcon bottomPlayIcon = ImageIcon(
    AssetImage("assets/icons/bottom_play.png", package: "flutter_jin_player"),
    size: iconSize,
    color: iconColor,
  );
  // 底部暂停图标
  static const ImageIcon bottomPauseIcon = ImageIcon(
    AssetImage("assets/icons/bottom_pause.png", package: "flutter_jin_player"),
    size: iconSize,
    color: iconColor,
  );
  // 底部重新播放图标
  static const ImageIcon bottomReplayPlayIcon = ImageIcon(
    AssetImage("assets/icons/bottom_replay.png", package: "flutter_jin_player"),
    size: iconSize,
    color: iconColor,
  );

  // 下一个视频图标
  static const ImageIcon nextPlayIcon = ImageIcon(
    AssetImage("assets/icons/bottom_next_play.png",
        package: "flutter_jin_player"),
    size: iconSize,
    color: iconColor,
  );

  // 进入全屏图标
  static const Icon entryFullScreenIcon = Icon(
    Icons.fullscreen_rounded,
    size: iconSize,
    color: Colors.white,
  );
  // 退出全屏图标
  static const Icon exitFullScreenIcon = Icon(
    Icons.fullscreen_exit_rounded,
    size: iconSize,
    color: Colors.white,
  );

  static const ImageIcon backIcon = ImageIcon(
    AssetImage("assets/icons/back.png", package: "flutter_jin_player"),
    size: iconSize,
    color: iconColor,
  );
  // static const ImageIcon settingIcon = ImageIcon(AssetImage("assets/icons/more_h.png", package: "flutter_jin_player"), size: iconSize, color: iconColor,);
  static const Icon settingIcon = Icon(
    Icons.more_vert_rounded,
    size: iconSize,
    color: Colors.white,
  );

  // 锁
  static const ImageIcon lockedIcon = ImageIcon(
    AssetImage("assets/icons/locked.png", package: "flutter_jin_player"),
    size: 40,
    color: iconColor,
  );
  static const ImageIcon unLockedIcon = ImageIcon(
    AssetImage("assets/icons/unlocked.png", package: "flutter_jin_player"),
    size: 40,
    color: iconColor,
  );
  // 截图
  static const ImageIcon screenshotIcon = ImageIcon(
    AssetImage("assets/icons/screenshot.png", package: "flutter_jin_player"),
    size: 40,
    color: iconColor,
  );

  // 弹幕开
  static const ImageIcon danmakuOpen = ImageIcon(
    AssetImage("assets/icons/danmaku_open.png", package: "flutter_jin_player"),
    size: iconSize,
    color: iconActivatedColor,
  );
  // 弹幕关
  static const ImageIcon danmakuClose = ImageIcon(
    AssetImage("assets/icons/danmaku_close.png", package: "flutter_jin_player"),
    size: iconSize,
    color: iconColor,
  );
  // 弹幕设置
  static const ImageIcon barrageSetting = ImageIcon(
    AssetImage("assets/icons/danmaku_setting.png",
        package: "flutter_jin_player"),
    size: iconSize,
    color: iconColor,
  );

  // 进度条
  // 高度
  static const double progressBarHeight = 4.0;
  // 滑块圆角
  static const double progressBarThumbRadius = 8.0;
  // 滑块内部圆角
  static const double progressBarThumbInnerRadius = 3.0;
  // 滑块外部颜色
  static Color progressBarThumbOverlayColor =
      Colors.redAccent.withOpacity(0.24);
  static Color progressBarThumbOverlayShapeColor =
      Colors.redAccent.withOpacity(0.5);
  // 滑块滑动或选中时显示外围的圆角
  static const double progressBarThumbOverlayColorShapeRadius = 16.0;

  // 网格间距
  static const double gridMainAxisSpacing = 10.0;
  static const double gridCrossAxisSpacing = 10.0;

  static const List<double> playSpeedList = [
    0.25,
    0.5,
    0.75,
    1.0,
    1.25,
    1.5,
    1.75,
    2.0
  ];

  // 播放速度默认宽度
  static const double speedSettingUIDefaultWidth = 150.0;

  static const double chapterUIDefaultWidth = 300.0;
  static const double barrageUIDefaultWidth = 300.0;

  // 弹幕设置
  // slider
  static const Color activeTrackColor = Colors.redAccent;
  static const Color inactiveTrackColor = Colors.white60;
  static const Color inactiveTickMarkColor = Colors.white;
  static const double trackHeight = 2.0;
  static const double thumbInnerRadius = 1.8;
  static const Color thumbInnerColor = Colors.redAccent;
  static const double thumbRadius = 4;
  static const Color thumbColor = Colors.white;
  static const RoundSliderOverlayShape overlayShape =
      RoundSliderOverlayShape(overlayRadius: 8);
  static Color overlayColor = Colors.white.withOpacity(0.2);

  static SliderThemeData danmakuSliderTheme(BuildContext context) {
    return SliderTheme.of(context).copyWith(
        trackHeight: UIConstants.trackHeight,
        trackShape: const MySliderTrackShape(),
        activeTrackColor: UIConstants.activeTrackColor,
        inactiveTrackColor: UIConstants.inactiveTrackColor,
        inactiveTickMarkColor: UIConstants.inactiveTickMarkColor,
        tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2.5),
        thumbShape: const MySliderThumbShape(
            thumbInnerRadius: UIConstants.thumbInnerRadius,
            thumbInnerColor: UIConstants.thumbInnerColor,
            thumbRadius: UIConstants.thumbRadius,
            thumbColor: UIConstants.thumbColor),
        overlayColor: UIConstants.overlayColor,
        overlayShape: UIConstants.overlayShape);
  }
}
