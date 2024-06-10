import 'package:flutter/material.dart';
import 'package:flutter_jin_player/constants/ui_constants.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:flutter_jin_player/ui/player_speed_ui.dart';
import 'package:get/get.dart';

// 顶部UI
class PlayerTopUI extends GetView<PlayerGetxController> {
  const PlayerTopUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 背景渐变效果
      decoration: BoxDecoration(gradient: UIConstants.topUILinearGradient),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 返回按钮
          /*BackButton(

          ),*/
          IconButton(
              onPressed: () {
                Navigator.maybePop(context);
                controller.uiConfigOptions.uiLocked(false);
                controller.playConfigOptions.isFullScreen(false);
              },
              icon: UIConstants.backIcon),
          // 标题
          Expanded(
              child: Text(
            controller.playConfigOptions.resourceItem.value.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: UIConstants.textColor, fontSize: UIConstants.textSize),
          )),
          // 右边控制栏
          controller.playConfigOptions.isFullScreen.value
              ? _buildHorizontalScreenTopRight()
              : _buildVerticalScreenTopRight(),
        ],
      ),
    );
  }

  // 打开设置
  void openPlayerSettingUI() {
    // 先隐藏所有的标签
    controller.uiControl
        .hideUIByKeyList(controller.uiConfigOptions.overlayUIMap.keys.toList());
    // if (controller.playerParams.isFullScreen) {
    //   horizontalScreenSetting();
    // } else {
    verticalScreenSetting();
    // }
  }

  // 垂直屏幕显示内容
  _buildVerticalScreenTopRight() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 最右边的按钮
        IconButton(
            padding: const EdgeInsets.only(left: UIConstants.padding),
            onPressed: () {
              openPlayerSettingUI();
            },
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: Colors.white,
            )),
        IconButton(
            padding: const EdgeInsets.only(left: UIConstants.padding),
            onPressed: () {
              openPlayerSettingUI();
            },
            icon: UIConstants.settingIcon),
      ],
    );
  }

  // 横屏显示内容
  _buildHorizontalScreenTopRight() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 最右边的按钮
        IconButton(
            padding: const EdgeInsets.only(left: UIConstants.padding),
            onPressed: () {
              controller.logger.d("顶部右边按钮");
              openPlayerSettingUI();
            },
            icon: UIConstants.settingIcon)
      ],
    );
  }

  // 竖屏设置
  verticalScreenSetting() {
    controller.logger.d("打开设置");
    openBottomSheet(SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [Icon(Icons.favorite_border_rounded), Text("收藏")],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [Icon(Icons.file_download_rounded), Text("缓存")],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: InkWell(
              onTap: () {
                //关闭对话框
                bool open = Get.isBottomSheetOpen ?? false;
                if (open) {
                  Get.back();
                }
                openBottomSheet(const PlayerSpeedUI());
              },
              child: const Column(
                children: [Icon(Icons.fast_forward_rounded), Text("倍数播放")],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [Icon(Icons.link_rounded), Text("复制链接")],
            ),
          ),
        ],
      ),
    ));
  }

  /// 打开底部窗口
  openBottomSheet(Widget widget) {
    Get.bottomSheet(
        Stack(children: [
          // SingleChildScrollView(child: widget,),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: widget,
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      height: 6,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    TextButton(
                        onPressed: () {
                          //关闭对话框
                          bool open = Get.isBottomSheetOpen ?? false;
                          if (open) {
                            Get.back();
                          }
                        },
                        child: const Text("取消"))
                  ],
                ),
              ))
        ]),
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(10), topEnd: Radius.circular(10))));
  }
}
