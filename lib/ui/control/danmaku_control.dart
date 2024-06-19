import 'package:flutter/widgets.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:flutter_jin_player/danmaku/my_ns_danmaku.dart';
import 'package:flutter_jin_player/danmaku/parse/parse_bilibili_danmaku.dart';
import 'package:flutter_jin_player/interface/idanmaku.dart';
import 'package:flutter_jin_player/models/danmaku_item.dart';

class DanmakuControl {
  PlayerGetxController controller;
  IDanmaku? danmaku;
  DanmakuControl(this.controller, {IDanmaku? danmaku}) {
    this.danmaku = danmaku ?? MyNsDanmaku();
    if (!this.danmaku!.initPlayerGetxController) {
      try {
        this.danmaku!.playerGetxController = controller;
      } catch (e) {
        debugPrint(
            "设置playerGetxController时报错：$e, danmaku: ${this.danmaku == null}, dnamaku.playerGetxController: ${this.danmaku?.playerGetxController}");
      }
    }
  }

  // 读取弹幕文件
  void readDanmakuListByFilePath() {
    controller.logger.d("进入读取弹幕文件内容");
    if (controller.danmakuConfigOptions.danmakuSourceItem.value.path != null &&
        controller
            .danmakuConfigOptions.danmakuSourceItem.value.path!.isNotEmpty &&
        !controller.danmakuConfigOptions.danmakuSourceItem.value.read) {
      controller.danmakuConfigOptions.danmakuSourceItem.value.read = true;
      try {
        ParseBilibiliDanmaku()
            .pasrseBilibiliDanmakuByXml(
                controller.danmakuConfigOptions.danmakuSourceItem.value.path!,
                fromAssets: controller.danmakuConfigOptions.danmakuSourceItem
                    .value.pathFromAssets!)
            .then((List<DanmakuItem> list) {
          if (list.isNotEmpty) {
            controller.danmakuConfigOptions.danmakuList.addAll(list);
          }

          controller.logger.d(
              "读取弹幕文件内容：${controller.danmakuConfigOptions.danmakuList.length}");
        });
      } catch (e) {
        controller.danmakuConfigOptions.errorMsg("读取弹幕文件出错：$e");
      }
    }
  }

  // 弹幕可用
  bool danmakuViewAvailable() {
    return controller.danmakuConfigOptions.initialized.value &&
        controller.danmakuConfigOptions.danmakuView.value != null;
  }

  // 初始化弹幕
  void initDanmaku() {
    controller.danmakuConfigOptions.initialized(false);
    controller.danmakuConfigOptions.danmakuView(null);
    controller.danmakuConfigOptions.danmakuView.refresh();
    try {
      Widget? view = danmaku?.initDanmaku();
      if (view != null) {
        controller.danmakuConfigOptions.initialized(true);
        controller.danmakuConfigOptions.errorMsg("初始化弹幕view");

        controller.danmakuConfigOptions.danmakuView(Container(
          key: GlobalKey(
              debugLabel:
                  "danmakuGlobalKey_${controller.playConfigOptions.resourceItem.value.path}_${controller.danmakuConfigOptions.danmakuSourceItem.value.path ?? DateTime.now().millisecondsSinceEpoch}"),
          child: view,
        ));
      } else {
        controller.danmakuConfigOptions.errorMsg("初始化弹幕出错");
      }
    } catch (e) {
      controller.danmakuConfigOptions.errorMsg("初始化弹幕出错：$e");
    }
  }

  // 开始弹幕
  void startDanmaku() {
    // 只有视频播放时才需要启动弹幕
    if (!controller.playConfigOptions.playing.value) {
      return;
    }
    if (!danmakuViewAvailable()) {
      // 初始化弹幕库
      initDanmaku();
    }
    controller.danmakuConfigOptions.initialized(true);
    controller.danmakuConfigOptions.visible(true);
    danmaku?.setDanmakuVisibility(true);
    danmaku?.startDanmaku(
        startTime: controller.playConfigOptions.positionDuration.value.inSeconds
            .toDouble());
  }

  // 继续播放弹幕
  void resumeDanmaku() {
    // 只有弹幕显示时才需要
    if (controller.playConfigOptions.playing.value &&
        controller.danmakuConfigOptions.visible.value) {
      if (!controller.danmakuConfigOptions.initialized.value ||
          controller.danmakuConfigOptions.danmakuView.value == null) {
        startDanmaku();
      } else {
        danmaku?.resumeDanmaku();
      }
    }
  }

  // 暂停弹幕
  void pauseDanmaku() {
    if (danmakuViewAvailable()) {
      danmaku?.pauseDanmaku();
    }
  }

  // 显示或隐藏弹幕
  void setDanmakuVisibility(bool visible) {
    if (visible) {
      if (!danmakuViewAvailable()) {
        // 初始化弹幕库
        initDanmaku();
      }
    }
    controller.danmakuConfigOptions.visible(visible);
    danmaku?.setDanmakuVisibility(visible);
  }

  // 弹幕调整
  void danmakuSeekTo(double second) {
    danmaku?.danmakuSeekTo(second);
  }

  // 设置弹幕透明的（百分比）
  void setDanmakuAlphaRatio({double? ratio}) {
    ratio =
        ratio ?? controller.danmakuConfigOptions.danmakuAlphaRatio.value.ratio;
    danmaku?.setDanmakuAlphaRatio(ratio);
  }

  // 设置弹幕显示区域
  void setDanmakuArea({int? index}) {
    index =
        index ?? controller.danmakuConfigOptions.danmakuArea.value.areaIndex;
    List<DanmakuAreaItem> danmakuAreaItemList =
        controller.danmakuConfigOptions.danmakuArea.value.danmakuAreaItemList;
    if (danmakuAreaItemList.length < index) {
      index = danmakuAreaItemList.length - 1;
    }
    DanmakuAreaItem item = danmakuAreaItemList[index];
    controller.logger.d("设置显示显示下标2：$index");
    danmaku?.setDanmakuArea(item.area, item.filter);
  }

  // 设置字体大小（百分比）
  void setDanmakuFontSize({double? ratio}) {
    ratio =
        ratio ?? controller.danmakuConfigOptions.danmakuAlphaRatio.value.ratio;
    danmaku?.setDanmakuFontSize(ratio);
  }

  // 设置描边
  void setDanmakuStyleStrokeWidth({double? strokeWidth}) {
    strokeWidth = strokeWidth ??
        controller
            .danmakuConfigOptions.danmakuStyleStrokeWidth.value.strokeWidth;
    danmaku?.setDanmakuStyleStrokeWidth(strokeWidth);
  }

  // 设置滚动速度
  void setDanmakuSpeed({double? second}) {
    second = second ?? controller.danmakuConfigOptions.danmakuSpeed.value.speed;
    danmaku?.setDanmakuSpeed(
        second, controller.playConfigOptions.playSpeed.value);
  }

  // 清空弹幕
  void clearDanmaku() {
    danmaku?.clearDanmaku();
  }

  // 根据类型过滤弹幕
  void filterDanmakuType(DanmakuFilterType filterType) {}
}
