import 'package:flutter/widgets.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:flutter_jin_player/models/danmaku_item.dart';

abstract class IDanmaku {
  PlayerGetxController? playerGetxController;

  // 初始化弹幕
  Widget? initDanmaku({bool start = false});

  // 根据文件路径加载弹幕
  void loadDanmakuByPath(String path,
      {bool fromAssets = false, bool start = false, int? startMs});

  // 发送弹幕
  void sendDanmaku(DanmakuItem danmakuItem);
  // 发送弹幕列表
  void sendDanmakuList(List<DanmakuItem> danmakuItemList);
  // 启动弹幕（毫秒）
  Future<bool?> startDanmaku({int? startTime});
  // 暂停弹幕
  Future<bool?> pauseDanmaku();
  // 继续弹幕
  Future<bool?> resumeDanmaku();
  // 弹幕跳转（毫秒）
  Future<bool?> danmakuSeekTo(int time);
  // 显示/隐藏弹幕
  Future<bool?> setDanmakuVisibility(bool visible);
  // 设置弹幕透明的（百分比）
  Future<bool?> setDanmakuAlphaRatio(double danmakuAlphaRatio);
  // 设置弹幕显示区域
  // filter表示弹幕过多是否过滤
  Future<bool?> setDanmakuArea(double area, bool filter);
  // 设置字体大小（百分比）
  Future<bool?> setDanmakuFontSize(double fontSizeRatio);
  // 设置描边
  Future<bool?> setDanmakuStyleStrokeWidth(double strokeWidth);
  // 设置滚动速度
  Future<bool?> setDanmakuSpeed(int durationMs, double playSpeed);
  // 设置是否启用合并重复弹幕
  Future<bool?> setDuplicateMergingEnabled(bool flag);
  // 设置是否显示顶部固定弹幕
  Future<bool?> setFixedTopDanmakuVisibility(bool visible);
  // 设置是否显示滚动弹幕
  Future<bool?> setRollDanmakuVisibility(bool visible);
  // 设置是否显示底部固定弹幕
  Future<bool?> setFixedBottomDanmakuVisibility(bool visible);
  // 设置是否显示特殊弹幕
  Future<bool?> setSpecialDanmakuVisibility(bool visible);
  // 是否显示彩色弹幕
  Future<bool?> setColorsDanmakuVisibility(bool visible);
  // 清空弹幕
  void clearDanmaku();
  // 根据类型过滤弹幕
  void filterDanmakuType(DanmakuFilterType filterType);

  // 调整弹幕时间
  void danmakuAdjustTime(int adjustTime);

  void dispose();

  Color decimalToColor(int decimalColor) {
    final red = (decimalColor & 0xFF0000) >> 16;
    final green = (decimalColor & 0x00FF00) >> 8;
    final blue = decimalColor & 0x0000FF;
    return Color.fromARGB(255, red, green, blue);
  }

  bool isColorFulByInt(int color) {
    int red = (color >> 16) & 0xFF;
    int green = (color >> 8) & 0xFF;
    int blue = color & 0xFF;
    if (red == 0 && green == 0 && blue == 0) {
      return false;
    }
    if (red == 255 && green == 255 && blue == 255) {
      return false;
    }
    return red != green && green != blue && blue != red;
  }

  bool isColorFulByColor(Color color) {
    if (color.red == 0 && color.green == 0 && color.blue == 0) {
      return false;
    }
    if (color.red == 255 && color.green == 255 && color.blue == 255) {
      return false;
    }
    return color.red != color.green &&
        color.green != color.blue &&
        color.blue != color.red;
  }
}
