import 'package:flutter_jin_player/models/danmaku_config_options.dart';
import 'package:flutter_jin_player/models/play_config_options.dart';
import 'package:flutter_jin_player/models/ui_config_options.dart';

class ConfigOptions {
  // 播放器部分
  PlayConfigOptions? playConfigOption;

  // ui 部分
  UIConfigOptions? uiConfigOptions;

  // 弹幕部分
  DanmakuConfigOptions? danmakuConfigOptions;

  ConfigOptions({
    this.playConfigOption,
    this.uiConfigOptions,
    this.danmakuConfigOptions,
  });
}

// class DanmakuConfigOption {
//   // 字体大小
//   final double fontSize;
//   // 显示区域，0.1-1.0
//   final double area;

//   /// 不透明度，0.1-1.0
//   final double opacity;
//   // 速度
//   final double speed;
//   // 隐藏顶部
//   final bool hideTop;

//   // 隐藏底部
//   final bool hideBottom;
//   // 隐藏滚动
//   final bool hideScroll;
//   // 隐藏彩色
//   final bool hideColorful;

//   const DanmakuConfigOption({
//     this.fontSize = 16.0,
//     this.area = 1.0,
//     this.opacity = 1.0,
//     this.speed = 1.0,
//     this.hideTop = false,
//     this.hideBottom = false,
//     this.hideScroll = false,
//     this.hideColorful = false,
//   });

//   DanmakuConfigOption copyWidth({
//     double? fontSize,
//     double? area,
//     double? opacity,
//     double? speed,
//     bool? hideTop,
//     bool? hideBottom,
//     bool? hideScroll,
//     bool? hideColorful,
//   }) {
//     return DanmakuConfigOption(
//       fontSize: fontSize ?? this.fontSize,
//       area: area ?? this.area,
//       opacity: opacity ?? this.opacity,
//       speed: speed ?? this.speed,
//       hideTop: hideTop ?? this.hideTop,
//       hideBottom: hideBottom ?? this.hideBottom,
//       hideScroll: hideScroll ?? this.hideScroll,
//       hideColorful: hideColorful ?? this.hideColorful,
//     );
//   }
// }
