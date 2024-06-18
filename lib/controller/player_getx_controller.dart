import 'dart:async';
import 'dart:ui';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jin_player/constants/ui_constants.dart';
import 'package:flutter_jin_player/controller/getx_id.dart';
import 'package:flutter_jin_player/interface/iplayer.dart';
import 'package:flutter_jin_player/jin_player_view.dart';
import 'package:flutter_jin_player/models/config_options.dart';
import 'package:flutter_jin_player/models/danmaku_config_options.dart';
import 'package:flutter_jin_player/models/danmaku_item.dart';
import 'package:flutter_jin_player/models/play_config_options.dart';
import 'package:flutter_jin_player/models/resource_chapter_item.dart';
import 'package:flutter_jin_player/models/ui_config_options.dart';
import 'package:flutter_jin_player/ui/brightness_volume_ui.dart';
import 'package:flutter_jin_player/ui/control/danmaku_control.dart';
import 'package:flutter_jin_player/ui/control/ui_control.dart';
import 'package:flutter_jin_player/ui/player_ui.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class PlayerGetxController extends GetxController {
  final ConfigOptions? configOptions;

  PlayerGetxController(this.player, {this.configOptions});

  Timer? hideTimer;
  Logger logger = Logger();

  late PlayConfigOptions playConfigOptions;
  late UIConfigOptions uiConfigOptions;
  late UIControl uiControl;
  final IPlayer player;

  late DanmakuConfigOptions danmakuConfigOptions;
  late DanmakuControl danmakuControl;

  Widget jinPlayerView = Container();
  var overlayUI = Rx<Widget>(Container());

  // 全屏播放页面深度
  var fullScreenPlayDeep = 1.obs;

  bool isWeb = kIsWeb;

  bool _beforeHideAppPlaying = false;

  @override
  void onInit() {
    playConfigOptions = configOptions?.playConfigOption ?? PlayConfigOptions();
    uiConfigOptions = configOptions?.uiConfigOptions ?? UIConfigOptions();
    logger.d(
        "初始化，获取弹幕配置前，configOptions?.danmakuConfigOptions：${configOptions?.danmakuConfigOptions}");
    danmakuConfigOptions =
        configOptions?.danmakuConfigOptions ?? DanmakuConfigOptions();
    logger.d("初始化，获取弹幕配置后，danmakuConfigOptions：$danmakuConfigOptions");

    uiControl = UIControl(this);
    danmakuControl = DanmakuControl(this);

    // 初始化监听
    initEver();
    overlayUI(const Positioned.fill(child: PlayerUI()));

    createOverlayUI();
    super.onInit();
  }

  // 初始化监听
  void initEver() {
    // 监听资源来源线路
    ever(playConfigOptions.resourceRouteList, (list) {
      if (list.isNotEmpty) {
        bool haveActivated = false;
        for (ResourceRouteItem routeItem in list) {
          if (routeItem.activated) {
            playConfigOptions
                .resourceChapterList(routeItem.resourceChapterItemList ?? []);
            haveActivated = true;
            break;
          }
        }
        // 如果当前资源下的所有线路均没有选中，那么默认选中第一项
        if (!haveActivated) {
          list[0].activated = true;
          playConfigOptions.currentPlayIndex(0);
          playConfigOptions.currentPlayIndex.refresh();
          playConfigOptions.resourceRouteList.refresh();
          // playerParams.resourceChapterList(
          //     list[0].resourceChapterModelList ?? []);
        }
      }
    });

    // 监听播放列表发生变化
    ever(playConfigOptions.resourceChapterList, (list) {
      if (list.isNotEmpty) {
        bool haveActivated = false;

        for (int i = 0; i < list.length; i++) {
          ResourceChapterItem chapterItem = list[i];
          if (chapterItem.activated) {
            playConfigOptions.currentPlayIndex(i);
            haveActivated = true;
            break;
          }
        }
        // 如果当前线路下的章节均没有选中，那么默认选中第一项
        if (!haveActivated) {
          list[0].activated = true;
          playConfigOptions.resourceChapterList.refresh();
        }
      }
    });

    // 监听当前播放下标
    ever(playConfigOptions.currentPlayIndex, (index) {
      for (int i = 0; i < playConfigOptions.resourceChapterList.length; i++) {
        ResourceChapterItem chapterItem =
            playConfigOptions.resourceChapterList[i];
        if (i == index) {
          chapterItem.activated = true;
          chapterItem.playing = true;
          playConfigOptions.resourceItem(chapterItem.resourceItem);
        } else {
          chapterItem.activated = false;
          chapterItem.playing = false;
        }
      }
      playConfigOptions.resourceChapterList.refresh();
    });
    // 视频资源发生变化
    ever(playConfigOptions.resourceItem, (resourceItem) {
      changeVideoUrl();
      danmakuControl.clearDanmaku();
      danmakuConfigOptions.danmakuList.clear();
      danmakuConfigOptions.danmakuList.refresh();
      danmakuConfigOptions.danmakuSourceItem(DanmakuSourceItem());
      danmakuConfigOptions.danmakuSourceItem.value.addDanmakuList?.clear();
      danmakuConfigOptions.danmakuSourceItem.value.read = false;
      danmakuConfigOptions.danmakuSourceItem.refresh();
      // danmakuControl.initDanmaku();
      // danmakuControl.readDanmakuListByFilePath();
      logger.d("当前视频资源变化：弹幕：${resourceItem.danmakuSourceItem?.path}");
      if (resourceItem.danmakuSourceItem != null) {
        logger.d("当前视频资源变化，且有弹幕信息");
        danmakuConfigOptions.danmakuSourceItem(resourceItem.danmakuSourceItem!);
      }
    });

    // 监听错误信息
    ever(playConfigOptions.errorMsg, (errorMsg) {
      uiConfigOptions.touchBackgroundShowUIKeyList.clear();
      if (errorMsg.isNotEmpty) {
        // 有错误只能显示顶部（即使锁住了也显示顶部）
        uiConfigOptions.touchBackgroundShowUIKeyList
            .addAll(uiConfigOptions.touchBackgroundErrorShowUIKeyList);
        if (uiConfigOptions.topUI.visible.value) {
          uiControl.onlyShowUIByKeyList([GetxId.topUI]);
        }
        danmakuControl.pauseDanmaku();
      } else {
        if (uiConfigOptions.uiLocked.value) {
          // 锁住了只能显示锁键
          uiConfigOptions.touchBackgroundShowUIKeyList
              .addAll(uiConfigOptions.touchBackgroundLockedShowUIKeyList);
        } else {
          // 可以显示所有
          uiConfigOptions.touchBackgroundShowUIKeyList
              .addAll(uiConfigOptions.touchBackgroundShowUIAllKeyList);
        }
      }
    });

    // 监听视频本身的比例
    ever(playConfigOptions.videoAspectRatio,
        (radio) => playConfigOptions.aspectRatio(radio));

    // 监听播放状态改变
    ever(playConfigOptions.playing, (flag) {
      logger.d("视频播放状态变化：$flag");
      if (flag) {
        // 播放时保持屏幕唤醒
        WakelockPlus.enable();
        // 继续播放弹幕
        logger.d("触发弹幕继续播放");
        // 这里监听会有延迟
        danmakuControl.resumeDanmaku();
      } else {
        // 暂停时关闭保持屏幕唤醒
        WakelockPlus.disable();

        // 避免停止播放时因毫秒原因未标记结束，但实际上已经结束了，此操作为了将弹幕滚动完
        if (!playConfigOptions.finished.value &&
            !(playConfigOptions.positionDuration.value.inSeconds ==
                playConfigOptions.duration.value.inSeconds)) {
          danmakuControl.pauseDanmaku();
        }
      }
    });

    // 监听播放完成事件
    ever(playConfigOptions.finished, (flag) {
      if (flag) {
        // 播放结束时关闭保持屏幕唤醒
        WakelockPlus.disable();
        cancelAndRestartTimer();
      }
    });

    // 监听播放速度变化
    ever(playConfigOptions.playSpeed, (speed) {
      player.setPlaySpeed(speed);
      danmakuControl.setDanmakuSpeed();
    });
    // 监听视频进度跳转中
    ever(playConfigOptions.seeking, (flag) {
      if (flag) {
        danmakuControl.clearDanmaku();
      }
    });

    // 监听锁键
    ever(uiConfigOptions.uiLocked, (flag) {
      uiConfigOptions.touchBackgroundShowUIKeyList.clear();
      if (playConfigOptions.errorMsg.isNotEmpty) {
        // 有错误只能显示顶部（即使锁住了也显示顶部）
        uiConfigOptions.touchBackgroundShowUIKeyList
            .addAll(uiConfigOptions.touchBackgroundErrorShowUIKeyList);
      } else {
        if (flag) {
          uiConfigOptions.touchBackgroundShowUIKeyList
              .addAll(uiConfigOptions.touchBackgroundLockedShowUIKeyList);
        } else {
          // 可以显示所有
          uiConfigOptions.touchBackgroundShowUIKeyList
              .addAll(uiConfigOptions.touchBackgroundShowUIAllKeyList);
        }
        uiControl
            .onlyShowUIByKeyList(uiConfigOptions.touchBackgroundShowUIKeyList);
      }
    });

    // 一些ui显示会拦截路由的监听
    for (String key in uiConfigOptions.interceptRouteUIKeyList) {
      RxPlayerOverlayUI? rxPlayerOverlayUI = uiConfigOptions.overlayUIMap[key];
      if (rxPlayerOverlayUI == null) {
        continue;
      }
      ever(rxPlayerOverlayUI.visible, (visible) {
        bool intercept = !visible;
        if (!visible) {
          for (var k in uiConfigOptions.interceptRouteUIKeyList) {
            if (uiConfigOptions.overlayUIMap[k] != null &&
                uiConfigOptions.overlayUIMap[k]!.visible.value) {
              intercept = true;
            }
          }
        }
        uiConfigOptions.interceptRoute(intercept);
      });
    }

    // 弹幕文件路径变化
    ever(danmakuConfigOptions.danmakuSourceItem, (item) {
      logger.d("弹幕源变化，路径：${item.path}，读取：${item.read}");
      danmakuControl.clearDanmaku();
      danmakuConfigOptions.danmakuList.clear();
      danmakuConfigOptions.danmakuList.refresh();
      if (danmakuConfigOptions.danmakuSourceItem.value.clearOldDanmaku) {
        danmakuConfigOptions.danmakuList.clear();
      }
      if (item.path != null && item.path!.isNotEmpty && !item.read) {
        logger.d("弹幕源变化，路径不为空：${item.path}");
        danmakuControl.readDanmakuListByFilePath();
      }
      if (danmakuConfigOptions.danmakuSourceItem.value.addDanmakuList != null &&
          danmakuConfigOptions
              .danmakuSourceItem.value.addDanmakuList!.isNotEmpty) {
        danmakuConfigOptions.danmakuList.addAll(
            danmakuConfigOptions.danmakuSourceItem.value.addDanmakuList!);
      }
    });

    // 设置弹幕透明的（百分比）
    ever(danmakuConfigOptions.danmakuAlphaRatio,
        (ratio) => danmakuControl.setDanmakuAlphaRatio(ratio: ratio.ratio));

    // 设置弹幕显示区域
    ever(danmakuConfigOptions.danmakuArea,
        (areaItem) => danmakuControl.setDanmakuArea(index: areaItem.areaIndex));

    // 设置弹幕字体大小（百分比）
    ever(
        danmakuConfigOptions.danmakuFontSize,
        (fontSizeItem) =>
            danmakuControl.setDanmakuFontSize(ratio: fontSizeItem.ratio));
    // 设置弹幕滚动速度
    ever(danmakuConfigOptions.danmakuSpeed,
        (speedItem) => danmakuControl.setDanmakuSpeed(second: speedItem.speed));
    // 设置弹幕描边
    ever(
        danmakuConfigOptions.danmakuStyleStrokeWidth,
        (strokeWidthItem) => danmakuControl.setDanmakuStyleStrokeWidth(
            strokeWidth: strokeWidthItem.strokeWidth));

    // 遍历监听弹幕过滤类型变化
    for (var filterType in danmakuConfigOptions.danmakuFilterTypeList) {
      ever(filterType.filter, (flag) {
        danmakuControl.filterDanmakuType(filterType);
      });
    }
    // 弹幕时间调整
    ever(danmakuConfigOptions.adjustTime, (time) {
      danmakuConfigOptions.uiShowAdjustTime(time);
      // 在读取发送弹幕时已经自动将调整时间算上，因此跳转只需要跳转至当前播放时间即可
      danmakuControl.danmakuSeekTo(
          playConfigOptions.positionDuration.value.inSeconds.toDouble());
    });

    ever(danmakuConfigOptions.visible, (visible) {
      if (visible) {
        if (!danmakuControl.danmakuViewAvailable()) {
          danmakuControl.initDanmaku();
        }
        danmakuControl.setDanmakuVisibility(true);
        if (playConfigOptions.initialized.value &&
            playConfigOptions.playing.value &&
            !playConfigOptions.finished.value) {
          // 继续播放弹幕
          logger.d("触发弹幕继续播放");
          danmakuControl.resumeDanmaku();
        }
      } else {
        danmakuControl.pauseDanmaku();
        danmakuControl.setDanmakuVisibility(false);
      }
    });
  }

  void createOverlayUI() {
    jinPlayerView = Stack(
      key: UniqueKey(),
      children: [
        // 播放器
        Center(
          child: Obx(() => AspectRatio(
                aspectRatio: playConfigOptions.aspectRatio.value,
                child: playConfigOptions.playerView.value ?? Container(),
              )),
        ),
        Positioned.fill(child: Obx(() {
          if (!danmakuConfigOptions.initialized.value ||
              !danmakuConfigOptions.visible.value) {
            return Container();
          }
          return danmakuConfigOptions.danmakuView.value ?? Container();
        })),
        // ui
        Obx(() => overlayUI.value)
      ],
    );
  }

  // 修改资源
  Future<void> changeVideoUrl() async {
    if (player.dataSourceChange(playConfigOptions.resourceItem.value.path)) {
      // 先暂停
      if (playConfigOptions.playing.value) {
        pause();
      }
      // 重置状态
      playConfigOptions.resetOptions();
      playConfigOptions.playerView(Container());
      playConfigOptions.playerView.refresh();
      // 销毁旧的播放器
      await player.onDisposePlayer();
      // 创建并初始化新的播放器
      initPlayer(autoPlay: playConfigOptions.autoPlay);
    }
  }

  // 播放器初始化
  void initPlayer({bool autoPlay = false}) {
    PlayerGetxController getxController = this;
    player.onInitPlayer(playConfigOptions.resourceItem.value).then((view) {
      if (view != null) {
        if (autoPlay || playConfigOptions.autoPlay) {
          play();
        }
        playConfigOptions.errorMsg("");
        player.getxController = getxController;
        player.listenerStatus();
      } else {
        playConfigOptions.errorMsg("");
      }
      playConfigOptions.playerView(view);
    });
  }

  // 销毁播放器
  Future<void> disposePlayer() async {
    playConfigOptions.playerView(Container());
    playConfigOptions.playerView.refresh();
    await player.onDisposePlayer();
  }

  // 视频初始化
  Future<void> initialize() async {
    player.initialize().then((value) {
      playConfigOptions.initialized(true);
    });
  }

  // 视频播放
  Future<void> play() {
    return player.play();
  }

  // 视频暂停
  Future<void> pause() {
    return player.pause();
  }

  // 暂停或播放
  Future<void> playOrPause() async {
    if (playConfigOptions.finished.value) {
      await seekTo(Duration.zero);
    }
    if (playConfigOptions.playing.value) {
      return pause();
    } else {
      return play();
    }
  }

  // 播放下一个
  void playNext() {
    if (playConfigOptions.resourceChapterList.length - 1 <
        playConfigOptions.currentPlayIndex.value + 1) {
      return;
    }
    playConfigOptions
        .currentPlayIndex(playConfigOptions.currentPlayIndex.value + 1);
  }

  // 视频跳转
  Future<void> seekTo(Duration position) async {
    return player.seekTo(position);
  }

  // 进入/退出全屏
  Future<void> entryOrExitFullScreen() async {
    logger.d("屏幕状态：${playConfigOptions.isFullScreen.value}");
    cancelHideTimer();
    if (playConfigOptions.isFullScreen.value) {
      playConfigOptions.isFullScreen(false);
      await AutoOrientation.portraitUpMode();
      fullScreenPlayDeep(1);
      Future.delayed(const Duration(milliseconds: 100)).then((_) => Get.back());
    } else {
      playConfigOptions.isFullScreen(true);
      fullScreenPlayDeep(2);
      // Get.to(PlayPage(jinPlayerView: jinPlayerView));
      Get.to(const FullScreenPlayPage(), popGesture: true);
    }
    uiConfigOptions.uiLocked(false);
    cancelAndRestartTimer();
  }

  // 清除定时器
  void cancelHideTimer() {
    hideTimer?.cancel();
  }

  // 开始计时UI显示时间
  void startHideTimer() {
    uiControl.onlyShowUIByKeyList(uiConfigOptions.touchBackgroundShowUIKeyList);
    hideTimer = Timer(UIConstants.uiShowDuration, () {
      uiControl.hideUIByKeyList(uiConfigOptions.touchBackgroundShowUIKeyList);
    });
  }

  // 重新计算显示/隐藏UI计时器
  void cancelAndRestartTimer() {
    cancelHideTimer();
    startHideTimer();
  }

  // 开始拖动播放进度条
  void playProgressOnHorizontalDragStart() {
    if (!playConfigOptions.initialized.value ||
        playConfigOptions.errorMsg.isNotEmpty ||
        playConfigOptions.finished.value) {
      return;
    }
    // 标记拖动状态
    playConfigOptions.dragging(true);
    // 初始化拖动值
    playConfigOptions.draggingSecond(0);
    // 清除前一次拖动剩余
    playConfigOptions.draggingSurplusSecond = 0.0;
    // 记录开始拖动时的时间
    playConfigOptions.dragProgressPositionDuration =
        playConfigOptions.positionDuration.value;
    //显示拖动进度UI
    uiControl.showUIByKeyList([GetxId.centerLoadingUI]);
  }

  // 拖动播放进度条中
  void playProgressOnHorizontalDragUpdate(BuildContext context, Offset delta) {
    if (!playConfigOptions.initialized.value ||
        playConfigOptions.errorMsg.isNotEmpty ||
        playConfigOptions.finished.value) {
      uiControl.hideUIByKeyList([GetxId.centerLoadingUI]);
      return;
    }
    double width = Get.size.width;
    // 获取拖动了多少秒
    double dragSecond =
        (delta.dx / width) * 100 + playConfigOptions.draggingSurplusSecond;
    // 拖动秒数向下取整
    int dragValue = dragSecond.floor();
    // 记录本次拖动取整后剩余
    playConfigOptions.draggingSurplusSecond = dragSecond - dragValue;
    // 更新拖动值
    playConfigOptions
        .draggingSecond(playConfigOptions.draggingSecond.value + dragValue);
  }

  // 拖动播放进度结束
  void playProgressOnHorizontalDragEnd() {
    if (!playConfigOptions.initialized.value ||
        playConfigOptions.errorMsg.isNotEmpty ||
        playConfigOptions.finished.value) {
      uiControl.hideUIByKeyList([GetxId.centerLoadingUI]);
      return;
    }
    // 清除拖动标记
    playConfigOptions.dragging(false);
    // 清除前一次拖动剩余值
    playConfigOptions.draggingSurplusSecond = 0.0;
    // 更新本次拖动值
    var second = playConfigOptions.dragProgressPositionDuration.inSeconds +
        playConfigOptions.draggingSecond.value;
    seekTo(Duration(seconds: second > 0 ? second : 0));
    // 定时隐藏拖动进度ui
    Future.delayed(UIConstants.volumeOrBrightnessUIShowDuration).then((value) {
      uiControl.hideUIByKeyList([GetxId.centerLoadingUI]);
    });
  }

  // 垂直滑动开始
  void volumeOrBrightnessOnVerticalDragStart(DragStartDetails details) {
    if (isWeb) {
      return;
    }
    playConfigOptions.brightnessDragging(false);
    playConfigOptions.volumeDragging(false);
    double width = Get.size.width;
    if (details.globalPosition.dx > (width / 2)) {
      FlutterVolumeController.updateShowSystemUI(false);
      FlutterVolumeController.getVolume().then(
          (value) => playConfigOptions.volume(((value ?? 0) * 100).floor()));

      uiConfigOptions.centerVolumeAndBrightnessUI.sourceUI =
          const BrightnessVolumeUI(
        brightnessVolumeType: BrightnessVolumeType.volume,
      );
      playConfigOptions.volumeDragging(true);
    } else {
      // 获取当前亮度
      ScreenBrightness()
          .current
          .then((value) => playConfigOptions.brightness((value * 100).floor()));

      uiConfigOptions.centerVolumeAndBrightnessUI.sourceUI =
          const BrightnessVolumeUI(
        brightnessVolumeType: BrightnessVolumeType.brightness,
      );
      playConfigOptions.brightnessDragging(true);
    }
    playConfigOptions.verticalDragSurplus = 0.0;
    uiConfigOptions.centerVolumeAndBrightnessUI.visible(true);
    uiControl.showUIByKeyList([GetxId.centerVolumeAndBrightnessUI]);
  }

  // 垂直滑动中
  void volumeOrBrightnessOnVerticalDragUpdate(
      BuildContext context, DragUpdateDetails details) {
    if (isWeb) {
      return;
    }
    double height = Get.size.height;
    // 使用百分率
    // 当前拖动值
    double currentDragVal = (details.delta.dy / height) * 100;
    double totalDragValue =
        currentDragVal + playConfigOptions.verticalDragSurplus;
    int dragValue = totalDragValue.floor();
    playConfigOptions.verticalDragSurplus = totalDragValue - dragValue;
    if (playConfigOptions.volumeDragging.value) {
      // 设置音量
      playConfigOptions
          .volume((playConfigOptions.volume.value - dragValue).clamp(0, 100));
      FlutterVolumeController.updateShowSystemUI(false);
      FlutterVolumeController.setVolume(playConfigOptions.volume / 100.0);
    } else if (playConfigOptions.brightnessDragging.value) {
      // 设置亮度
      playConfigOptions.brightness(
          (playConfigOptions.brightness.value - dragValue).clamp(0, 100));
      ScreenBrightness()
          .setScreenBrightness(playConfigOptions.brightness / 100.0);
    }
    uiControl.showUIByKeyList([GetxId.centerVolumeAndBrightnessUI]);
  }

  // 垂直滑动结束
  void volumeOrBrightnessOnVerticalDragEnd() {
    if (isWeb) {
      return;
    }
    playConfigOptions.brightnessDragging(false);
    playConfigOptions.volumeDragging(false);
    playConfigOptions.verticalDragSurplus = 0.0;
    Future.delayed(UIConstants.volumeOrBrightnessUIShowDuration).then((value) {
      uiControl.hideUIByKeyList([GetxId.centerVolumeAndBrightnessUI]);
    });
  }

  // =============================== 根据App状态的产生的各种回调 ===============================

  AppLifecycleListener getAppLifecycleListener() {
    return AppLifecycleListener(
      onStateChange: onStateChange,
      onResume: onResume,
      onInactive: onInactive,
      onHide: onHide,
      onShow: onShow,
      onPause: onPause,
      onRestart: onRestart,
      onDetach: onDetach,
      onExitRequested: onExitRequested,
    );
  }

  /// 监听状态
  onStateChange(AppLifecycleState state) {
    debugPrint('app_state：$state');
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        _beforeHideAppPlaying = playConfigOptions.playing.value;
        if (_beforeHideAppPlaying) {
          pause();
          danmakuControl.resumeDanmaku();
        }
        break;

      case AppLifecycleState.resumed:
        if (_beforeHideAppPlaying) {
          play();
        }
        break;
    }
  }

  /// 在退出程序时，发出询问的回调（IOS、Android 都不支持）
  /// 响应 [AppExitResponse.exit] 将继续终止，响应 [AppExitResponse.cancel] 将取消终止。
  Future<AppExitResponse> onExitRequested() async {
    debugPrint('---onExitRequested');
    return AppExitResponse.exit;
  }

  /// 可见，并且可以响应用户操作时的回调
  /// 比如应用从后台调度到前台时，在 onShow() 后面 执行
  /// 注意：这个回调，初始化时 不执行
  onResume() {
    debugPrint('---onResume');
  }

  /// 可见，但无法响应用户操作时的回调
  onInactive() {
    debugPrint('---onInactive');
  }

  /// 隐藏时的回调
  onHide() {
    debugPrint('---onHide');
  }

  /// 显示时的回调，应用从后台调度到前台时
  onShow() {
    debugPrint('---onShow');
  }

  /// 暂停时的回调
  onPause() {
    debugPrint('---onPause');
  }

  /// 暂停后恢复时的回调
  onRestart() {
    debugPrint('---onRestart');
  }

  /// 这两个回调，不是所有平台都支持，

  /// 当退出 并将所有视图与引擎分离时的回调（IOS 支持，Android 不支持）
  onDetach() {
    debugPrint('---onDetach');
  }
}
