import 'package:flutter/widgets.dart';
import 'package:flutter_jin_player/constants/logger_tag.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:flutter_jin_player/interface/idanmaku.dart';
import 'package:flutter_jin_player/models/danmaku_item.dart';
import 'package:get/get.dart';
import 'package:ns_danmaku/danmaku_controller.dart';
import 'package:ns_danmaku/danmaku_view.dart';
import 'package:ns_danmaku/models/danmaku_item.dart' as ns_danmaku;
import 'package:flutter_jin_player/models/danmaku_item.dart' as jin_player;
import 'package:ns_danmaku/models/danmaku_option.dart';

class MyNsDanmaku extends IDanmaku {
  DanmakuController? danmakuController;
  MyNsDanmaku(PlayerGetxController playerGetxController) {
    this.playerGetxController = playerGetxController;
  }
  // key：时间；value：弹幕列表
  Map<int, List<ns_danmaku.DanmakuItem>> _danmakuItems = {};
  // 前一秒发送弹幕时间
  int prevPlaySecond = -1;
  // 弹幕是否已经启动过
  bool started = false;

  void updateDanmakuItems(List<jin_player.DanmakuItem> danmakuList) {
    _danmakuItems.clear();
    for (jin_player.DanmakuItem danmakuItem in danmakuList) {
      int time = danmakuItem.time.floor();
      List<ns_danmaku.DanmakuItem> items = _danmakuItems[time] ?? [];
      items.add(ns_danmaku.DanmakuItem(danmakuItem.content,
          time: time,
          type: getDanmakuItemType(danmakuItem.mode),
          color: decimalToColor(danmakuItem.color)));
      _danmakuItems[time] = items;
    }
    playerGetxController.logger.d("读取并处理弹幕：${_danmakuItems.length}");
  }

  // 初始化弹幕
  @override
  Widget? initDanmaku() {
    playerGetxController.logger.d("初始化弹幕");
    updateDanmakuItems(playerGetxController.danmakuConfigOptions.danmakuList);
    ever(playerGetxController.danmakuConfigOptions.danmakuList, (list) {
      updateDanmakuItems(list);
    });
    return DanmakuView(
      createdController: (DanmakuController e) {
        danmakuController = e;
      },
      option: getDanmakuOption(),
    );
  }

  DanmakuOption getDanmakuOption() {
    // 显示区域
    int areaIndex =
        playerGetxController.danmakuConfigOptions.danmakuArea.value.areaIndex;
    List<DanmakuAreaItem> danmakuAreaItemList = playerGetxController
        .danmakuConfigOptions.danmakuArea.value.danmakuAreaItemList;
    double area =
        danmakuAreaItemList.isNotEmpty && danmakuAreaItemList.length > areaIndex
            ? danmakuAreaItemList[areaIndex].area
            : 1.0;

    // 弹幕速度
    double speed =
        playerGetxController.danmakuConfigOptions.danmakuSpeed.value.speed /
            playerGetxController.playConfigOptions.playSpeed.value;
    DanmakuOption danmakuOption = DanmakuOption(
      opacity: playerGetxController
              .danmakuConfigOptions.danmakuAlphaRatio.value.ratio /
          100.0,
      fontSize:
          playerGetxController.danmakuConfigOptions.danmakuFontSize.value.size *
              (playerGetxController
                      .danmakuConfigOptions.danmakuFontSize.value.ratio /
                  100.0),
      area: area,
      duration: speed,
      strokeWidth: playerGetxController
          .danmakuConfigOptions.danmakuStyleStrokeWidth.value.strokeWidth,
    );
    for (DanmakuFilterType filterType
        in playerGetxController.danmakuConfigOptions.danmakuFilterType) {
      switch (filterType.enName) {
        case "fixedTop":
          danmakuOption =
              danmakuOption.copyWith(hideTop: filterType.filter.value);
          break;

        case "fixedBottom":
          danmakuOption =
              danmakuOption.copyWith(hideBottom: filterType.filter.value);
          break;
        case "scroll":
          danmakuOption =
              danmakuOption.copyWith(hideScroll: filterType.filter.value);
          break;
      }
    }
    playerGetxController.logger.d(
        "配置，opacity：${danmakuOption.opacity}， fontSize：${danmakuOption.fontSize}，area：${danmakuOption.area}，duration：${danmakuOption.duration}，strokeWidth：${danmakuOption.strokeWidth}，hideTop：${danmakuOption.hideTop}，hideBottom：${danmakuOption.hideBottom}，hideScroll：${danmakuOption.hideScroll}");
    return danmakuOption;
  }

  // 发送弹幕
  @override
  void sendDanmaku(jin_player.DanmakuItem danmakuItem) {
    danmakuController?.addItems([
      ns_danmaku.DanmakuItem(danmakuItem.content,
          time: danmakuItem.time.floor(),
          type: getDanmakuItemType(danmakuItem.mode),
          color: decimalToColor(danmakuItem.color))
    ]);
  }

  // 发送弹幕列表
  @override
  void sendDanmakuList(List<jin_player.DanmakuItem> danmakuItemList) {
    List<ns_danmaku.DanmakuItem> items = [];
    for (jin_player.DanmakuItem danmakuItem in danmakuItemList) {
      items.add(ns_danmaku.DanmakuItem(danmakuItem.content,
          time: danmakuItem.time.floor(),
          type: getDanmakuItemType(danmakuItem.mode),
          color: decimalToColor(danmakuItem.color)));
    }
    danmakuController?.addItems(items);
  }

  // 启动弹幕
  @override
  Future<bool?> startDanmaku({double? startTime}) {
    playerGetxController.logger.d("进入启动弹幕方法");
    if (!playerGetxController.danmakuConfigOptions.initialized.value ||
        playerGetxController.danmakuConfigOptions.danmakuView.value == null) {
      playerGetxController.danmakuControl.initDanmaku();
    }
    if (started) {
      playerGetxController.logger
          .d("${LoggerTag.danmakuLog}startDanmaku，启动弹幕：弹幕已经启动过，无需再次启动！");
      return Future.value(true);
    }
    try {
      playerGetxController.logger.d("启动弹幕");
      listenerPlayDuration(second: startTime == null ? 0 : startTime.floor());
      // 监听播放进度改变时同步读取对应时间的弹幕
      ever(playerGetxController.playConfigOptions.positionDuration, (duration) {
        if (playerGetxController.playConfigOptions.playing.value &&
            duration.inSeconds != prevPlaySecond) {
          listenerPlayDuration(second: duration.inSeconds);
        }
      });
      started = true;
    } catch (e) {
      playerGetxController.danmakuConfigOptions.errorMsg("启动弹幕失败：$e");
      playerGetxController.logger
          .d("${LoggerTag.danmakuLog}startDanmaku，启动弹幕失败：$e");
      return Future.value(false);
    }
    return Future.value(true);
  }

  // 暂停弹幕
  @override
  Future<bool?> pauseDanmaku() {
    if (danmakuController != null && !danmakuController!.running) {
      return Future.value(true);
    }
    try {
      danmakuController?.pause();
    } catch (e) {
      playerGetxController.danmakuConfigOptions.errorMsg("暂停弹幕失败：$e");
      playerGetxController.logger
          .d("${LoggerTag.danmakuLog}pauseDanmaku，暂停弹幕失败：$e");
      return Future.value(false);
    }
    return Future.value(true);
  }

  // 继续弹幕
  @override
  Future<bool?> resumeDanmaku() {
    if (danmakuController != null && danmakuController!.running) {
      return Future.value(true);
    }
    try {
      if (started) {
        danmakuController?.resume();
      } else {
        startDanmaku();
      }
    } catch (e) {
      playerGetxController.danmakuConfigOptions.errorMsg("继续弹幕失败：$e");
      playerGetxController.logger
          .d("${LoggerTag.danmakuLog}resumeDanmaku，继续弹幕失败：$e");
      return Future.value(false);
    }
    return Future.value(true);
  }

  // 弹幕跳转
  @override
  Future<bool?> danmakuSeekTo(double time) {
    if (!playerGetxController.playConfigOptions.initialized.value ||
        playerGetxController.playConfigOptions.finished.value) {
      return Future.value(true);
    }
    try {
      danmakuController?.clear();
      // 添加指定时间的弹幕
      listenerPlayDuration(second: (time).floor());
    } catch (e) {
      playerGetxController.danmakuConfigOptions.errorMsg("弹幕跳转失败：$e");
      playerGetxController.logger
          .d("${LoggerTag.danmakuLog}danmakuSeekTo，弹幕跳转失败：$e");
      return Future.value(false);
    }
    return Future.value(true);
  }

  // 显示/隐藏弹幕
  @override
  Future<bool?> setDanmakuVisibility(bool visible) {
    if (!playerGetxController.playConfigOptions.initialized.value ||
        playerGetxController.playConfigOptions.finished.value) {
      return Future.value(true);
    }
    try {
      playerGetxController.danmakuConfigOptions.visible(visible);
      // 如果设置显示弹幕，且视频已经初始化未播放结束，弹幕插件未初始化
      if (visible &&
          playerGetxController.playConfigOptions.initialized.value &&
          !playerGetxController.playConfigOptions.finished.value &&
          (!playerGetxController.danmakuConfigOptions.initialized.value ||
              playerGetxController.danmakuConfigOptions.danmakuView.value ==
                  null)) {
        playerGetxController.danmakuControl.initDanmaku();
        // 视频正在播放，就需要播放弹幕
        if (playerGetxController.playConfigOptions.playing.value) {
          playerGetxController.danmakuControl.resumeDanmaku();
        }
      }
    } catch (e) {
      playerGetxController.danmakuConfigOptions.errorMsg("显示/隐藏弹幕失败：$e");
      playerGetxController.logger
          .d("${LoggerTag.danmakuLog}setDanmakuVisibility，显示/隐藏弹幕失败：$e");
      return Future.value(false);
    }
    if (playerGetxController.danmakuConfigOptions.visible.value != visible) {
      playerGetxController.danmakuConfigOptions.visible(visible);
    }
    return Future.value(true);
  }

  // 设置弹幕透明的（百分比）
  @override
  Future<bool?> setDanmakuAlphaRatio(double danmakuAlphaRatio) {
    try {
      danmakuController?.onUpdateOption(
          (danmakuController?.option ?? getDanmakuOption())
              .copyWith(opacity: danmakuAlphaRatio / 100.0));
    } catch (e) {
      playerGetxController.danmakuConfigOptions.errorMsg("设置弹幕透明度失败：$e");
      playerGetxController.logger
          .d("${LoggerTag.danmakuLog}setDanmakuAlphaRatio，设置弹幕透明度失败：$e");
      return Future.value(false);
    }
    if (playerGetxController
            .danmakuConfigOptions.danmakuAlphaRatio.value.ratio !=
        danmakuAlphaRatio) {
      playerGetxController.danmakuConfigOptions.danmakuAlphaRatio.value.ratio =
          danmakuAlphaRatio;
    }
    return Future.value(true);
  }

  // 设置弹幕显示区域
  @override
  Future<bool?> setDanmakuArea(double area, bool filter) {
    try {
      danmakuController?.onUpdateOption(
          (danmakuController?.option ?? getDanmakuOption())
              .copyWith(area: area));
    } catch (e) {
      playerGetxController.danmakuConfigOptions.errorMsg("设置弹幕显示区域失败：$e");
      playerGetxController.logger
          .d("${LoggerTag.danmakuLog}setDanmakuArea，设置弹幕显示区域失败：$e");
      return Future.value(false);
    }
    int areaIndex =
        playerGetxController.danmakuConfigOptions.danmakuArea.value.areaIndex;
    List<DanmakuAreaItem> danmakuAreaItemList = playerGetxController
        .danmakuConfigOptions.danmakuArea.value.danmakuAreaItemList;
    DanmakuAreaItem configItem = danmakuAreaItemList[areaIndex];

    if (configItem.area != area || configItem.filter != filter) {
      playerGetxController.danmakuConfigOptions.danmakuArea.value.areaIndex =
          areaIndex;
    }
    return Future.value(true);
  }

  // 设置字体大小（百分比）
  @override
  Future<bool?> setDanmakuFontSize(double fontSizeRatio) {
    try {
      danmakuController?.onUpdateOption(
          (danmakuController?.option ?? getDanmakuOption()).copyWith(
              fontSize: playerGetxController
                      .danmakuConfigOptions.danmakuFontSize.value.size *
                  (fontSizeRatio / 100)));
    } catch (e) {
      playerGetxController.danmakuConfigOptions.errorMsg("设置字体大小失败：$e");
      playerGetxController.logger
          .d("${LoggerTag.danmakuLog}setDanmakuFontSize，设置字体大小失败：$e");
      return Future.value(false);
    }
    if (playerGetxController.danmakuConfigOptions.danmakuFontSize.value.ratio !=
        fontSizeRatio) {
      playerGetxController.danmakuConfigOptions.danmakuFontSize.value.ratio =
          fontSizeRatio;
    }
    return Future.value(true);
  }

  // 设置描边
  @override
  Future<bool?> setDanmakuStyleStrokeWidth(double strokeWidth) {
    try {
      danmakuController?.onUpdateOption(
          (danmakuController?.option ?? getDanmakuOption())
              .copyWith(strokeWidth: strokeWidth));
    } catch (e) {
      playerGetxController.danmakuConfigOptions.errorMsg("设置描边失败：$e");
      playerGetxController.logger
          .d("${LoggerTag.danmakuLog}setDanmakuStyleStrokeWidth，设置描边失败：$e");
      return Future.value(false);
    }
    if (playerGetxController
            .danmakuConfigOptions.danmakuStyleStrokeWidth.value.strokeWidth !=
        strokeWidth) {
      playerGetxController.danmakuConfigOptions.danmakuStyleStrokeWidth.value
          .strokeWidth = strokeWidth;
    }
    return Future.value(true);
  }

  // 设置滚动速度
  @override
  Future<bool?> setDanmakuSpeed(double speed, double playSpeed) {
    try {
      danmakuController?.onUpdateOption(
          (danmakuController?.option ?? getDanmakuOption())
              .copyWith(duration: speed / playSpeed));
    } catch (e) {
      playerGetxController.danmakuConfigOptions.errorMsg("设置滚动速度失败：$e");
      playerGetxController.logger
          .d("${LoggerTag.danmakuLog}setDanmakuSpeed，设置滚动速度失败：$e");
      return Future.value(false);
    }
    if (playerGetxController.danmakuConfigOptions.danmakuSpeed.value.speed !=
        speed) {
      playerGetxController.danmakuConfigOptions.danmakuSpeed.value.speed =
          speed;
    }
    return Future.value(true);
  }

  // 设置是否启用合并重复弹幕
  @override
  Future<bool?> setDuplicateMergingEnabled(bool flag) {
    return Future.value(true);
  }

  // 设置是否显示顶部固定弹幕
  @override
  Future<bool?> setFixedTopDanmakuVisibility(bool visible) {
    try {
      danmakuController?.onUpdateOption(
          (danmakuController?.option ?? getDanmakuOption())
              .copyWith(hideTop: visible));
    } catch (e) {
      playerGetxController.danmakuConfigOptions.errorMsg("设置是否显示顶部固定弹幕失败：$e");
      playerGetxController.logger.d(
          "${LoggerTag.danmakuLog}setFixedTopDanmakuVisibility，设置是否显示顶部固定弹幕失败：$e");
      return Future.value(false);
    }
    return Future.value(true);
  }

  // 设置是否显示滚动弹幕
  @override
  Future<bool?> setRollDanmakuVisibility(bool visible) {
    try {
      danmakuController?.onUpdateOption(
          (danmakuController?.option ?? getDanmakuOption())
              .copyWith(hideScroll: visible));
    } catch (e) {
      playerGetxController.danmakuConfigOptions.errorMsg("设置是否显示滚动弹幕失败：$e");
      playerGetxController.logger
          .d("${LoggerTag.danmakuLog}setRollDanmakuVisibility，设置是否显示滚动弹幕失败：$e");
      return Future.value(false);
    }
    return Future.value(true);
  }

  // 设置是否显示底部固定弹幕
  @override
  Future<bool?> setFixedBottomDanmakuVisibility(bool visible) {
    try {
      danmakuController?.onUpdateOption(
          (danmakuController?.option ?? getDanmakuOption())
              .copyWith(hideBottom: visible));
    } catch (e) {
      playerGetxController.danmakuConfigOptions.errorMsg("设置是否显示底部固定弹幕失败：$e");
      playerGetxController.logger.d(
          "${LoggerTag.danmakuLog}setFixedBottomDanmakuVisibility，设置是否显示底部固定弹幕失败：$e");
      return Future.value(false);
    }
    return Future.value(true);
  }

  // 设置是否显示特殊弹幕
  @override
  Future<bool?> setSpecialDanmakuVisibility(bool visible) {
    return Future.value(true);
  }

  // 是否显示彩色弹幕
  @override
  Future<bool?> setColorsDanmakuVisibility(bool visible) {
    return Future.value(true);
  }

  // 清空弹幕
  @override
  void clearDanmaku() {
    danmakuController?.clear();
  }

  // 根据类型过滤弹幕
  @override
  void filterDanmakuType(DanmakuFilterType filterType) {}

  // 调整弹幕时间
  @override
  void danmakuAdjustTime(double adjustTime) {}

  ns_danmaku.DanmakuItemType getDanmakuItemType(int mode) {
    ns_danmaku.DanmakuItemType type = ns_danmaku.DanmakuItemType.scroll;
    if (mode == 5) {
      type = ns_danmaku.DanmakuItemType.top;
    } else if (mode == 4) {
      type = ns_danmaku.DanmakuItemType.bottom;
    }
    return type;
  }

  // 跟着视频发送弹幕
  listenerPlayDuration({required int second, double? adjustTime}) {
    playerGetxController.logger.d(
        "触发添加弹幕：${playerGetxController.danmakuConfigOptions.initialized.value}, ${playerGetxController.danmakuConfigOptions.visible.value}, ${playerGetxController.danmakuConfigOptions.danmakuView.value}");
    int addTime = second +
        (adjustTime ??
                playerGetxController.danmakuConfigOptions.adjustTime.value)
            .floor();
    List<ns_danmaku.DanmakuItem>? danmuItems = _danmakuItems[addTime];
    if (danmuItems != null && danmuItems.isNotEmpty) {
      // 0秒时就需要清除弹幕，避免视频播放结束后重新播放导致起始部分还在播放结束的弹幕
      if (addTime == 0) {
        danmakuController?.clear();
      }
      // List<DanmakuItem> items = [];
      // if (filterDanmakuItemTypeList.isNotEmpty) {
      //   items = danmuItems
      //       .where((test) =>
      //           // 滚动、顶部、底部
      //           !filterDanmakuItemTypeList.contains(test.type)
      //           // 彩色
      //           &&
      //           ((filterColor && !isColorFulByColor(test.color)) ||
      //               !filterColor)
      //           // 重复
      //           &&
      //           ((filterRepeat &&
      //                   repeatMinTimeMap.containsKey(test.text) &&
      //                   repeatMinTimeMap[test.text]!.floor() == test.time) ||
      //               !filterRepeat))
      //       .toList();
      // } else {
      //   items.addAll(danmuItems);
      // }
      danmakuController?.addItems(danmuItems);
    }
    prevPlaySecond = addTime;
  }
}
