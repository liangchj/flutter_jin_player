import 'package:flutter/material.dart';
import 'package:flutter_jin_player/constants/logger_tag.dart';
import 'package:flutter_jin_player/flutter_jin_player.dart';
import 'package:render_object_danmaku/render_object_danmaku.dart'
    as danmaku_package;

class MyDanmakuView extends IDanmaku {
  danmaku_package.DanmakuController? danmakuController;

  MyDanmakuView({playerGetxController});

  bool _loadedByPath = false;

  // 初始化弹幕
  @override
  Widget? initDanmaku({bool start = false}) {
    playerGetxController!.logger.d("初始化弹幕");

    return danmaku_package.DanmakuView(
      createdController: (danmaku_package.DanmakuController e) {
        danmakuController = e;
        if (start) {
          if (playerGetxController!
                      .danmakuConfigOptions.danmakuSourceItem.value.path ==
                  null ||
              playerGetxController!
                  .danmakuConfigOptions.danmakuSourceItem.value.path!.isEmpty) {
            danmakuController?.start(
                ms: playerGetxController!
                    .playConfigOptions.positionDuration.value.inMilliseconds);
          } else {
            loadDanmakuByPath(
                playerGetxController!
                    .danmakuConfigOptions.danmakuSourceItem.value.path!,
                fromAssets: playerGetxController!.danmakuConfigOptions
                        .danmakuSourceItem.value.pathFromAssets ??
                    false,
                start: start,
                startMs: playerGetxController!
                    .playConfigOptions.positionDuration.value.inMilliseconds);
          }
        }
      },
      option: getDanmakuOption(),
    );
  }

  // 获取弹幕配置
  danmaku_package.DanmakuOption getDanmakuOption() {
    // 显示区域
    int areaIndex =
        playerGetxController!.danmakuConfigOptions.danmakuArea.value.areaIndex;
    List<DanmakuAreaItem> danmakuAreaItemList = playerGetxController!
        .danmakuConfigOptions.danmakuArea.value.danmakuAreaItemList;
    double area =
        danmakuAreaItemList.isNotEmpty && danmakuAreaItemList.length > areaIndex
            ? danmakuAreaItemList[areaIndex].area
            : 1.0;

    // 弹幕速度
    double speed =
        playerGetxController!.danmakuConfigOptions.danmakuSpeed.value.speed /
            (playerGetxController!.playConfigOptions.playSpeed.value * 1.0);
    danmaku_package.DanmakuOption danmakuOption = danmaku_package.DanmakuOption(
      opacity: playerGetxController!
              .danmakuConfigOptions.danmakuAlphaRatio.value.ratio /
          100.0,
      fontSize: playerGetxController!
              .danmakuConfigOptions.danmakuFontSize.value.size *
          (playerGetxController!
                  .danmakuConfigOptions.danmakuFontSize.value.ratio /
              100.0),
      area: area,
      duration: (speed * 1000).floor(),
      strokeWidth: playerGetxController!
          .danmakuConfigOptions.danmakuStyleStrokeWidth.value.strokeWidth,
    );
    for (DanmakuFilterType filterType
        in playerGetxController!.danmakuConfigOptions.danmakuFilterTypeList) {
      switch (filterType.enName) {
        case "fixedTop":
          danmakuOption =
              danmakuOption.copyWith(filterTop: filterType.filter.value);
          break;

        case "fixedBottom":
          danmakuOption =
              danmakuOption.copyWith(filterBottom: filterType.filter.value);
          break;
        case "scroll":
          danmakuOption =
              danmakuOption.copyWith(filterScroll: filterType.filter.value);
          break;
        case "color":
          danmakuOption =
              danmakuOption.copyWith(filterColour: filterType.filter.value);
          break;
        case "repeat":
          danmakuOption =
              danmakuOption.copyWith(filterRepeat: filterType.filter.value);
          break;
      }
    }
    playerGetxController!.logger.d(
        "配置，opacity：${danmakuOption.opacity}， fontSize：${danmakuOption.fontSize}，area：${danmakuOption.area}，duration：${danmakuOption.duration}，showStroke：${danmakuOption.strokeWidth}，hideTop：${danmakuOption.filterTop}，hideBottom：${danmakuOption.filterBottom}，hideScroll：${danmakuOption.filterScroll}");
    return danmakuOption;
  }

  // 根据文件路径加载弹幕
  @override
  void loadDanmakuByPath(String path,
      {bool fromAssets = false, bool start = false, int? startMs}) {
    try {
      debugPrint("读取弹幕path：$path,fromAssets：$fromAssets");
      _loadedByPath = false;
      danmakuController?.onDanmakuFileParse(
          path: path,
          fromAssets: fromAssets,
          danmakuParser: danmaku_package.BiliDanmakuParser(),
          loaded: (flag) {
            _loadedByPath = flag;
            if (_loadedByPath) {
              if (start) {
                startDanmaku(startTime: startMs);
              }
            }
          });
    } catch (e) {
      playerGetxController!.danmakuConfigOptions.errorMsg("根据文件路径加载弹幕失败：$e");
      playerGetxController!.logger
          .d("${LoggerTag.danmakuLog}loadDanmakuByPath，根据文件路径加载弹幕失败：$e");
    }
  }

  // 发送弹幕
  @override
  void sendDanmaku(DanmakuItem danmakuItem) {
    danmakuController?.addDanmaku(danmaku_package.DanmakuItem(
      danmakuId: danmakuItem.danmakuId,
      content: danmakuItem.content,
      time: (danmakuItem.time * 1000).floor(),
      mode: danmakuItem.mode,
      fontSize: danmakuItem.fontSize,
      color: danmakuItem.color,
      createTime: danmakuItem.createTime == null
          ? null
          : Duration(seconds: danmakuItem.createTime!),
      backgroundColor: Colors.black.withOpacity(0.5).value,
      boldColor: Colors.greenAccent.value,
    ));
  }

  // 发送弹幕列表
  @override
  void sendDanmakuList(List<DanmakuItem> danmakuItemList) {
    for (DanmakuItem danmakuItem in danmakuItemList) {
      sendDanmaku(danmakuItem);
    }
  }

  // 启动弹幕
  @override
  Future<bool?> startDanmaku({int? startTime}) {
    playerGetxController!.logger.d("进入启动弹幕方法");
    // if (!playerGetxController!.danmakuConfigOptions.initialized.value ||
    //     playerGetxController!.danmakuConfigOptions.danmakuView.value == null) {
    //   playerGetxController!.danmakuControl.initDanmaku();
    // }

    if (playerGetxController!
                .danmakuConfigOptions.danmakuSourceItem.value.path !=
            null &&
        playerGetxController!
            .danmakuConfigOptions.danmakuSourceItem.value.path!.isNotEmpty &&
        !_loadedByPath) {
      loadDanmakuByPath(
          playerGetxController!
              .danmakuConfigOptions.danmakuSourceItem.value.path!,
          start: true,
          startMs: playerGetxController!
              .playConfigOptions.positionDuration.value.inMilliseconds);
      return Future.value(true);
    }

    if (danmakuController != null && danmakuController!.running) {
      playerGetxController!.logger
          .d("${LoggerTag.danmakuLog}startDanmaku，启动弹幕：弹幕已经启动过，无需再次启动！");
      return Future.value(true);
    }
    try {
      playerGetxController!.logger.d("启动弹幕");
      danmakuController?.start(ms: startTime);
    } catch (e) {
      playerGetxController!.danmakuConfigOptions.errorMsg("启动弹幕失败：$e");
      playerGetxController!.logger
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
      playerGetxController!.danmakuConfigOptions.errorMsg("暂停弹幕失败：$e");
      playerGetxController!.logger
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
      if (danmakuController!.running) {
        danmakuController?.resume();
      } else {
        startDanmaku(
            startTime: playerGetxController!
                .playConfigOptions.positionDuration.value.inMilliseconds);
      }
    } catch (e) {
      playerGetxController!.danmakuConfigOptions.errorMsg("继续弹幕失败：$e");
      playerGetxController!.logger
          .d("${LoggerTag.danmakuLog}resumeDanmaku，继续弹幕失败：$e");
      return Future.value(false);
    }
    return Future.value(true);
  }

  // 弹幕跳转
  @override
  Future<bool?> danmakuSeekTo(int time) {
    if (!playerGetxController!.playConfigOptions.initialized.value ||
        playerGetxController!.playConfigOptions.finished.value) {
      return Future.value(true);
    }
    try {
      danmakuController?.clear();
      danmakuController?.pause();
      startDanmaku(startTime: time);
    } catch (e) {
      playerGetxController!.danmakuConfigOptions.errorMsg("弹幕跳转失败：$e");
      playerGetxController!.logger
          .d("${LoggerTag.danmakuLog}danmakuSeekTo，弹幕跳转失败：$e");
      return Future.value(false);
    }
    return Future.value(true);
  }

  // 显示/隐藏弹幕
  @override
  Future<bool?> setDanmakuVisibility(bool visible) {
    if (!playerGetxController!.playConfigOptions.initialized.value ||
        playerGetxController!.playConfigOptions.finished.value) {
      return Future.value(true);
    }
    try {
      playerGetxController!.danmakuConfigOptions.visible(visible);
      // 如果设置显示弹幕，且视频已经初始化未播放结束，弹幕插件未初始化
      if (visible &&
          playerGetxController!.playConfigOptions.initialized.value &&
          !playerGetxController!.playConfigOptions.finished.value &&
          (!playerGetxController!.danmakuConfigOptions.initialized.value ||
              playerGetxController!.danmakuConfigOptions.danmakuView.value ==
                  null)) {
        // playerGetxController!.danmakuControl.initDanmaku();
        // 视频正在播放，就需要播放弹幕
        if (playerGetxController!.playConfigOptions.playing.value) {
          playerGetxController!.danmakuControl.resumeDanmaku();
        }
      }
    } catch (e) {
      playerGetxController!.danmakuConfigOptions.errorMsg("显示/隐藏弹幕失败：$e");
      playerGetxController!.logger
          .d("${LoggerTag.danmakuLog}setDanmakuVisibility，显示/隐藏弹幕失败：$e");
      return Future.value(false);
    }
    if (playerGetxController!.danmakuConfigOptions.visible.value != visible) {
      playerGetxController!.danmakuConfigOptions.visible(visible);
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
      playerGetxController!.danmakuConfigOptions.errorMsg("设置弹幕透明度失败：$e");
      playerGetxController!.logger
          .d("${LoggerTag.danmakuLog}setDanmakuAlphaRatio，设置弹幕透明度失败：$e");
      return Future.value(false);
    }
    if (playerGetxController!
            .danmakuConfigOptions.danmakuAlphaRatio.value.ratio !=
        danmakuAlphaRatio) {
      playerGetxController!.danmakuConfigOptions.danmakuAlphaRatio.value.ratio =
          danmakuAlphaRatio;
    }
    return Future.value(true);
  }

  // 设置弹幕显示区域
  @override
  Future<bool?> setDanmakuArea(double area, bool filter) {
    playerGetxController!.logger.d("设置显示区域，area：$area，filter：$filter");
    try {
      danmakuController?.onUpdateOption(
          (danmakuController?.option ?? getDanmakuOption())
              .copyWith(area: area));
    } catch (e) {
      playerGetxController!.danmakuConfigOptions.errorMsg("设置弹幕显示区域失败：$e");
      playerGetxController!.logger
          .d("${LoggerTag.danmakuLog}setDanmakuArea，设置弹幕显示区域失败：$e");
      return Future.value(false);
    }
    int areaIndex =
        playerGetxController!.danmakuConfigOptions.danmakuArea.value.areaIndex;
    List<DanmakuAreaItem> danmakuAreaItemList = playerGetxController!
        .danmakuConfigOptions.danmakuArea.value.danmakuAreaItemList;
    DanmakuAreaItem configItem = danmakuAreaItemList[areaIndex];

    if (configItem.area != area || configItem.filter != filter) {
      playerGetxController!.logger.d("设置显示区域，不是通过监听变量");
      playerGetxController!.danmakuConfigOptions.danmakuArea.value.areaIndex =
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
              fontSize: playerGetxController!
                      .danmakuConfigOptions.danmakuFontSize.value.size *
                  (fontSizeRatio / 100)));
    } catch (e) {
      playerGetxController!.danmakuConfigOptions.errorMsg("设置字体大小失败：$e");
      playerGetxController!.logger
          .d("${LoggerTag.danmakuLog}setDanmakuFontSize，设置字体大小失败：$e");
      return Future.value(false);
    }
    if (playerGetxController!
            .danmakuConfigOptions.danmakuFontSize.value.ratio !=
        fontSizeRatio) {
      playerGetxController!.danmakuConfigOptions.danmakuFontSize.value.ratio =
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
      playerGetxController!.danmakuConfigOptions.errorMsg("设置描边失败：$e");
      playerGetxController!.logger
          .d("${LoggerTag.danmakuLog}setDanmakuStyleStrokeWidth，设置描边失败：$e");
      return Future.value(false);
    }
    if (playerGetxController!
            .danmakuConfigOptions.danmakuStyleStrokeWidth.value.strokeWidth !=
        strokeWidth) {
      playerGetxController!.danmakuConfigOptions.danmakuStyleStrokeWidth.value
          .strokeWidth = strokeWidth;
    }
    return Future.value(true);
  }

  // 设置滚动速度
  @override
  Future<bool?> setDanmakuSpeed(int durationMs, double playSpeed) {
    try {
      danmakuController?.onUpdateOption(
          (danmakuController?.option ?? getDanmakuOption())
              .copyWith(duration: (durationMs / playSpeed).toInt()));
    } catch (e) {
      playerGetxController!.danmakuConfigOptions.errorMsg("设置滚动速度失败：$e");
      playerGetxController!.logger
          .d("${LoggerTag.danmakuLog}setDanmakuSpeed，设置滚动速度失败：$e");
      return Future.value(false);
    }
    Duration duration = Duration(milliseconds: durationMs);
    if (playerGetxController!.danmakuConfigOptions.danmakuSpeed.value.speed !=
        duration.inSeconds) {
      playerGetxController!.danmakuConfigOptions.danmakuSpeed.value.speed =
          duration.inSeconds +
              (duration.inMilliseconds - duration.inSeconds) / 1000.0;
    }
    return Future.value(true);
  }

  // 设置是否启用合并重复弹幕
  @override
  Future<bool?> setDuplicateMergingEnabled(bool flag) {
    try {
      danmakuController?.onUpdateOption(
          (danmakuController?.option ?? getDanmakuOption())
              .copyWith(filterRepeat: flag));
    } catch (e) {
      playerGetxController!.danmakuConfigOptions.errorMsg("设置是否启用合并重复弹幕失败：$e");
      playerGetxController!.logger.d(
          "${LoggerTag.danmakuLog}setDuplicateMergingEnabled，设置是否启用合并重复弹幕失败：$e");
      return Future.value(false);
    }
    return Future.value(true);
  }

  // 设置是否显示顶部固定弹幕
  @override
  Future<bool?> setFixedTopDanmakuVisibility(bool visible) {
    try {
      danmakuController?.onUpdateOption(
          (danmakuController?.option ?? getDanmakuOption())
              .copyWith(filterTop: visible));
    } catch (e) {
      playerGetxController!.danmakuConfigOptions.errorMsg("设置是否显示顶部固定弹幕失败：$e");
      playerGetxController!.logger.d(
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
              .copyWith(filterScroll: visible));
    } catch (e) {
      playerGetxController!.danmakuConfigOptions.errorMsg("设置是否显示滚动弹幕失败：$e");
      playerGetxController!.logger
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
              .copyWith(filterBottom: visible));
    } catch (e) {
      playerGetxController!.danmakuConfigOptions.errorMsg("设置是否显示底部固定弹幕失败：$e");
      playerGetxController!.logger.d(
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
    try {
      danmakuController?.onUpdateOption(
          (danmakuController?.option ?? getDanmakuOption())
              .copyWith(filterColour: visible));
    } catch (e) {
      playerGetxController!.danmakuConfigOptions.errorMsg("设置是否显示彩色弹幕失败：$e");
      playerGetxController!.logger.d(
          "${LoggerTag.danmakuLog}setColorsDanmakuVisibility，设置是否显示彩色弹幕失败：$e");
      return Future.value(false);
    }
    return Future.value(true);
  }

  // 清空弹幕
  @override
  void clearDanmaku() {
    try {
      danmakuController?.clear();
    } catch (e) {
      playerGetxController!.danmakuConfigOptions.errorMsg("清空弹幕失败：$e");
      playerGetxController!.logger
          .d("${LoggerTag.danmakuLog}clearDanmaku，清空弹幕失败：$e");
    }
  }

  // 根据类型过滤弹幕
  @override
  void filterDanmakuType(DanmakuFilterType filterType) {
    switch (filterType.enName) {
      case "fixedTop":
        setFixedTopDanmakuVisibility(filterType.filter.value);
        break;

      case "fixedBottom":
        setFixedBottomDanmakuVisibility(filterType.filter.value);
        break;
      case "scroll":
        setRollDanmakuVisibility(filterType.filter.value);
        break;
      case "color":
        setColorsDanmakuVisibility(filterType.filter.value);
        break;
      case "repeat":
        setDuplicateMergingEnabled(filterType.filter.value);
        break;
    }
  }

  // 调整弹幕时间
  @override
  void danmakuAdjustTime(int adjustTime) {
    try {
      danmakuController?.onUpdateOption(
          (danmakuController?.option ?? getDanmakuOption())
              .copyWith(adjustTimeMs: adjustTime));
    } catch (e) {
      playerGetxController!.danmakuConfigOptions.errorMsg("调整弹幕时间失败：$e");
      playerGetxController!.logger
          .d("${LoggerTag.danmakuLog}danmakuAdjustTime，调整弹幕时间失败：$e");
    }
  }

  @override
  void dispose() {}
}
