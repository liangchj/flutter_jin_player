import 'package:flutter/material.dart';
import 'package:flutter_jin_player/controller/getx_id.dart';
import 'package:flutter_jin_player/ui/chapter_list_ui.dart';
import 'package:flutter_jin_player/ui/danmaku_setting_ui.dart';
import 'package:flutter_jin_player/ui/play_progress_ui.dart';
import 'package:flutter_jin_player/ui/player_bottom_ui.dart';
import 'package:flutter_jin_player/ui/player_lock_ui.dart';
import 'package:flutter_jin_player/ui/player_screenshot_ui.dart';
import 'package:flutter_jin_player/ui/player_speed_ui.dart';
import 'package:flutter_jin_player/ui/player_top_ui.dart';
import 'package:get/get.dart';

class UIConfigOptions {
  dynamic playerUIState;
  // 锁住ui
  var uiLocked = false.obs;

  var topUI = RxPlayerOverlayUI(
      key: GetxId.topUI,
      sourceUI: const PlayerTopUI(),
      useAnimationController: true,
      beginOffset: const Offset(0.0, -0.5));
  var bottomUI = RxPlayerOverlayUI(
      key: GetxId.bottomUI,
      sourceUI: const PlayerBottomUI(),
      useAnimationController: true,
      beginOffset: const Offset(0.0, 1));
  var lockCtrUI = RxPlayerOverlayUI(
      key: GetxId.lockCtrUI,
      sourceUI: const PlayerLockUI(),
      useAnimationController: true,
      beginOffset: const Offset(-1.0, 0.0));
  var screenshotCtrUI = RxPlayerOverlayUI(
      key: GetxId.screenshotCtrUI,
      sourceUI: const PlayerScreenshotUI(),
      useAnimationController: true,
      beginOffset: const Offset(1.0, 0.0));
  var settingUI = RxPlayerOverlayUI(
      key: GetxId.settingUI,
      useAnimationController: true,
      beginOffset: const Offset(1.0, 0.0));
  var speedSettingUI = RxPlayerOverlayUI(
      key: GetxId.speedSettingUI,
      sourceUI: const PlayerSpeedUI(),
      useAnimationController: true,
      beginOffset: const Offset(1.0, 0.0));
  var chapterUI = RxPlayerOverlayUI(
      key: GetxId.chapterUI,
      sourceUI: const ChapterListUI(),
      useAnimationController: true,
      beginOffset: const Offset(1.0, 0.0));
  var danmakuSourceSettingUI = RxPlayerOverlayUI(
      key: GetxId.danmakuSourceSettingUI,
      useAnimationController: true,
      beginOffset: const Offset(1.0, 0.0));
  var danmakuSettingUI = RxPlayerOverlayUI(
      key: GetxId.danmakuSettingUI,
      sourceUI: const DanmakuSettingUI(),
      useAnimationController: true,
      beginOffset: const Offset(1.0, 0.0));

  var centerPlayPauseUI = RxPlayerOverlayUI(key: GetxId.centerPlayPauseUI);
  var centerLoadingUI = RxPlayerOverlayUI(
      key: GetxId.centerLoadingUI, sourceUI: const PlayProgressUI());
  var centerProgressUI = RxPlayerOverlayUI(key: GetxId.centerProgressUI);
  var centerVolumeAndBrightnessUI =
      RxPlayerOverlayUI(key: GetxId.centerVolumeAndBrightnessUI);

  Map<String, RxPlayerOverlayUI> overlayUIMap = {};

  UIConfigOptions() {
    overlayUIMap.addAll({
      GetxId.topUI: topUI,
      GetxId.bottomUI: bottomUI,
      GetxId.lockCtrUI: lockCtrUI,
      GetxId.screenshotCtrUI: screenshotCtrUI,
      GetxId.settingUI: settingUI,
      GetxId.speedSettingUI: speedSettingUI,
      GetxId.chapterUI: chapterUI,
      GetxId.danmakuSourceSettingUI: danmakuSourceSettingUI,
      GetxId.danmakuSettingUI: danmakuSettingUI,
      GetxId.centerPlayPauseUI: centerPlayPauseUI,
      GetxId.centerLoadingUI: centerLoadingUI,
      GetxId.centerProgressUI: centerProgressUI,
      GetxId.centerVolumeAndBrightnessUI: centerVolumeAndBrightnessUI,
    });
  }

  // 点击背景时可以显示的所有UI列表
  List<String> touchBackgroundShowUIAllKeyList = [
    GetxId.topUI,
    GetxId.lockCtrUI,
    GetxId.screenshotCtrUI,
    GetxId.bottomUI
  ];
  // 有错误时只能显示顶部
  List<String> touchBackgroundErrorShowUIKeyList = [GetxId.topUI];
  // 锁时只能显示锁键
  List<String> touchBackgroundLockedShowUIKeyList = [GetxId.lockCtrUI];
  // 点击背景时需要显示的UI列表（一般是顶部、底部、左边锁键和右边截图按钮，在报错情况下只显示顶部）
  List<String> touchBackgroundShowUIKeyList = [
    GetxId.topUI,
    GetxId.lockCtrUI,
    GetxId.screenshotCtrUI,
    GetxId.bottomUI
  ];

  // 拦截路由
  var interceptRoute = false.obs;
  // 拦截路由UI列表
  var interceptRouteUIKeyList = [
    GetxId.settingUI,
    GetxId.speedSettingUI,
    GetxId.chapterUI,
    GetxId.danmakuSourceSettingUI,
    GetxId.danmakuSettingUI
  ];
}

class RxPlayerOverlayUI {
  final String key;
  var ui = Rx<Widget?>(null);
  Widget? sourceUI;
  var visible = false.obs;
  bool useAnimationController;
  AnimationController? animateController;
  Animation<Offset>? animation;
  Offset beginOffset;
  Offset endOffset;

  RxPlayerOverlayUI({
    required this.key,
    this.sourceUI,
    this.useAnimationController = false,
    this.animateController,
    this.animation,
    this.beginOffset = const Offset(0.0, 0.0),
    this.endOffset = const Offset(0.0, 0.0),
  });
}
