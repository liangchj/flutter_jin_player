import 'package:flutter/material.dart';
import 'package:flutter_jin_player/constants/ui_constants.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:flutter_jin_player/models/ui_config_options.dart';

class UIControl {
  UIControl(this.getxController);
  final PlayerGetxController getxController;

  // 更新动画控制
  void updateAnimateController(playerUIState) {
    getxController.uiConfigOptions.playerUIState = playerUIState;
    // 遍历需要显示的UI并生成对应的动画控制
    getxController.uiConfigOptions.overlayUIMap.forEach((key, uiOverlay) {
      // 当前UI是否需要动画控制器（有效ui直接使用属性动画）
      if (uiOverlay.useAnimationController) {
        uiOverlay.animateController = AnimationController(
          duration: UIConstants.uiAnimationDuration,
          vsync: getxController.uiConfigOptions.playerUIState,
        );

        uiOverlay.animation = Tween<Offset>(
          begin: uiOverlay.beginOffset,
          end: uiOverlay.endOffset,
        ).animate(uiOverlay.animateController!);

        uiOverlay.animation?.addStatusListener((status) {
          if (status == AnimationStatus.dismissed) {
            // 改成null不会触发，因此用Container()来代替
            uiOverlay.ui(Container());
            uiOverlay.ui.refresh();
          }
        });
      }
    });
  }

  // 新增显示的UI
  void addUI(String key, RxPlayerOverlayUI rxOverlayUI) {
    if (getxController.uiConfigOptions.playerUIState == null) {
      getxController.logger.e("还未初始化，无法添加");
      return;
    }
    // 当前UI是否需要动画控制器（有效ui直接使用属性动画）
    if (rxOverlayUI.useAnimationController) {
      rxOverlayUI.animateController = AnimationController(
        duration: UIConstants.uiAnimationDuration,
        vsync: getxController.uiConfigOptions.playerUIState,
      );

      rxOverlayUI.animation = Tween<Offset>(
        begin: rxOverlayUI.beginOffset,
        end: rxOverlayUI.endOffset,
      ).animate(rxOverlayUI.animateController!);

      rxOverlayUI.animation?.addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          // 改成null不会触发，因此用Container()来代替
          rxOverlayUI.ui(Container());
          rxOverlayUI.ui.refresh();
        }
      });
    }
    getxController.uiConfigOptions.overlayUIMap.addAll({key: rxOverlayUI});
  }

  /// 是否有UI显示（除了特殊的UI）
  bool haveUIShow() {
    bool flag = false;
    for (var element in getxController.uiConfigOptions.overlayUIMap.values) {
      if (element.visible.value) {
        flag = true;
        break;
      }
    }
    return flag;
  }

  // 根据Key值隐藏ui
  void hideUIByKeyList(List<String> keyList) {
    if (keyList.isEmpty) {
      return;
    }
    for (MapEntry<String, RxPlayerOverlayUI> entry
        in getxController.uiConfigOptions.overlayUIMap.entries) {
      if (!keyList.contains(entry.key)) {
        continue;
      }
      RxPlayerOverlayUI element = entry.value;
      element.visible(false);
      if (element.ui.value == null) {
        continue;
      }
      if (element.useAnimationController) {
        element.animateController?.reverse();
      } else {
        element.ui(Container());
        element.ui.refresh();
      }
    }
  }

  // 只显示指定key值显示UI
  void onlyShowUIByKeyList(List<String> keyList) {
    List<String> hideList = [];
    for (MapEntry<String, RxPlayerOverlayUI> entry
        in getxController.uiConfigOptions.overlayUIMap.entries) {
      if (!keyList.contains(entry.key)) {
        hideList.add(entry.key);
        continue;
      }
      RxPlayerOverlayUI element = entry.value;
      element.visible(true);
      element.ui(element.sourceUI);
      if (element.useAnimationController) {
        element.animateController?.forward();
      }
      element.ui.refresh();
    }
    if (hideList.isNotEmpty) {
      hideUIByKeyList(hideList);
    }
  }

  // 根据key值显示UI
  void showUIByKeyList(List<String> keyList) {
    for (String key in keyList) {
      RxPlayerOverlayUI? element =
          getxController.uiConfigOptions.overlayUIMap[key];
      if (element == null) {
        continue;
      }
      element.visible(true);
      element.ui(element.sourceUI);
      if (element.useAnimationController) {
        element.animateController?.forward();
      }
      element.ui.refresh();
    }
  }

  /// 点击背景
  void toggleBackground() {
    getxController.logger.d("点击背景");
    if (haveUIShow()) {
      getxController.logger.d("有显示");
      hideUIByKeyList(
          getxController.uiConfigOptions.overlayUIMap.keys.toList());
    } else {
      // onlyShowUIByKeyList(getxController.uiParams.touchBackgroundShowUIKeyList);
      getxController.cancelAndRestartTimer();
    }
  }
}
