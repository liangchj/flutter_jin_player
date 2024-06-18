import 'package:flutter/widgets.dart';
import 'package:flutter_jin_player/flutter_jin_player.dart';
import 'package:get/get.dart';

class DanmakuConfigOptions {
  IDanmaku? danmaku;
  // 弹幕源信息
  var danmakuSourceItem = DanmakuSourceItem().obs;
  final Function(String)? updateDanmakuPathFn;

  DanmakuConfigOptions({
    this.danmaku,
    bool visible = true,
    DanmakuSourceItem? danmakuSourceItem,
    this.updateDanmakuPathFn,
    DanmakuAlphaRatio? danmakuAlphaRatio,
    DanmakuArea? danmakuArea,
    DanmakuFontSize? danmakuFontSize,
    DanmakuSpeed? danmakuSpeed,
    DanmakuStyleStrokeWidth? danmakuStyleStrokeWidth,
    List<DanmakuFilterType>? danmakuFilterTypeList,
    double? adjustTime,
  }) {
    this.visible(visible);
    if (danmakuSourceItem != null) {
      this.danmakuSourceItem(danmakuSourceItem);
    }
    if (danmakuAlphaRatio != null) {
      this.danmakuAlphaRatio(danmakuAlphaRatio);
    }
    if (danmakuArea != null) {
      this.danmakuArea(danmakuArea);
    }
    if (danmakuFontSize != null) {
      this.danmakuFontSize(danmakuFontSize);
    }
    if (danmakuSpeed != null) {
      this.danmakuSpeed(danmakuSpeed);
    }
    if (danmakuStyleStrokeWidth != null) {
      this.danmakuStyleStrokeWidth(danmakuStyleStrokeWidth);
    }
    if (danmakuFilterTypeList != null) {
      this.danmakuFilterTypeList = danmakuFilterTypeList;
    }
    if (adjustTime != null) {
      this.adjustTime(adjustTime);
      uiShowAdjustTime(adjustTime);
    }
  }

  // // 弹幕列表
  var danmakuList = <DanmakuItem>[].obs;

  // 是否已经初始化
  var initialized = false.obs;
  // 显示
  var visible = true.obs;
  var danmakuView = Rx<Widget?>(null);
  // 弹幕错误信息
  var errorMsg = "".obs;

  // 设置
  // 不透明度
  var danmakuAlphaRatio = DanmakuAlphaRatio(min: 0, max: 100, ratio: 100).obs;
  // 显示区域["1/4屏", "半屏", "3/4屏", "满屏", "无限"]，选择下标，默认半屏（下标1）
  var danmakuArea = DanmakuArea(danmakuAreaItemList: [
    DanmakuAreaItem(area: 0.25, name: "1/4屏"),
    DanmakuAreaItem(area: 0.5, name: "半屏"),
    DanmakuAreaItem(area: 0.75, name: "3/4屏"),
    DanmakuAreaItem(area: 1.0, name: "满屏"),
    DanmakuAreaItem(area: 1.0, name: "无限", filter: false),
  ], areaIndex: 1)
      .obs;

  // 弹幕字体大小，显示百分比， 区间[20, 200]
  var danmakuFontSize =
      DanmakuFontSize(size: 16.0, min: 20, max: 200, ratio: 80).obs;
  // 弹幕播放速度（最终速度仍需要与视频速度计算而得）
  var danmakuSpeed = DanmakuSpeed(min: 3.0, max: 12.0, speed: 6).obs;
  // 弹幕描边
  var danmakuStyleStrokeWidth =
      DanmakuStyleStrokeWidth(min: 1.0, max: 10.0, strokeWidth: 1.0).obs;

  // 弹幕过滤类型
  var danmakuFilterTypeList = [
    DanmakuFilterType(enName: "repeat", chName: "重复", modeList: []),
    DanmakuFilterType(enName: "fixedTop", chName: "顶部", modeList: [5]),
    DanmakuFilterType(enName: "fixedBottom", chName: "底部", modeList: [4]),
    DanmakuFilterType(enName: "scroll", chName: "滚动", modeList: [1, 2, 3]),
    DanmakuFilterType(enName: "color", chName: "彩色", modeList: []),
  ];

  // 时间调整
  var adjustTime = 0.0.obs;
  // ui显示更新
  var uiShowAdjustTime = 0.0.obs;
}
