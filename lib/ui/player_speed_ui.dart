import 'package:flutter/material.dart';
import 'package:flutter_jin_player/constants/ui_constants.dart';
import 'package:flutter_jin_player/controller/getx_id.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:get/get.dart';

// 设置播放速度UI
// class PlayerSpeedUI extends GetView<PlayerGetxController> {
// const PlayerSpeedUI({super.key});
class PlayerSpeedUI extends StatefulWidget {
  const PlayerSpeedUI({super.key});

  @override
  State<PlayerSpeedUI> createState() => _PlayerSpeedUIState();
}

class _PlayerSpeedUIState extends State<PlayerSpeedUI> {
  late PlayerGetxController controller;

  final ScrollController _scrollController = ScrollController();
  late GlobalKey _listKey;
  late GlobalKey _lastItemKey;

  @override
  void initState() {
    controller = Get.find<PlayerGetxController>();
    _listKey = GlobalKey(
        debugLabel:
            "${GetxId.speedSettingUI}_ListGlobalKey_${controller.playConfigOptions.isFullScreen.value}");
    _lastItemKey = GlobalKey(
        debugLabel:
            "${GetxId.speedSettingUI}_LastItemGlobalKey_${controller.playConfigOptions.isFullScreen.value}");
    // 渲染完成后滚动到指定项（居中）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double listHeight = _listKey.currentContext?.size?.height ?? 0;
      double itemHeight = _lastItemKey.currentContext?.size?.height ?? 0;
      if (listHeight > 0 && itemHeight > 0) {
        int index = UIConstants.playSpeedList
            .indexOf(controller.playConfigOptions.playSpeed.value);
        double curIndexOffsetY = index <= 0 ? 0 : index * itemHeight;
        _scrollController.animateTo(curIndexOffsetY - listHeight / 2.0,
            duration: const Duration(microseconds: 1), curve: Curves.linear);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (!controller.playConfigOptions.isFullScreen.value) {
      return Container(
        key: _listKey,
        child: SingleChildScrollView(
            controller: _scrollController,
            child: Obx(() => Column(
                  children: UIConstants.playSpeedList.map((e) {
                    return _buildDialogSpeedButton(e);
                  }).toList(),
                ))),
      );
    }
    return Container(
      width: UIConstants.speedSettingUIDefaultWidth
          .clamp(screenWidth * 0.3, screenWidth * 0.8),
      height: double.infinity,
      color: UIConstants.backgroundColor,
      padding: const EdgeInsets.all(UIConstants.padding),
      child: Center(
        key: _listKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: UIConstants.playSpeedList.map((e) {
                return _buildFullScreenSpeedButton(e);
              }).toList())),
        ),
      ),
    );
  }

  Widget _buildDialogSpeedButton(double e) {
    Color fontColor = e == controller.playConfigOptions.playSpeed.value
        ? Colors.redAccent
        : Colors.black;
    return ListTile(
        key: UIConstants.playSpeedList.indexOf(e) ==
                UIConstants.playSpeedList.length - 1
            ? _lastItemKey
            : null,
        onTap: () {
          controller.playConfigOptions.playSpeed(e);
        },
        textColor: fontColor,
        title: Text("${e.toString()}x"),
        trailing: const Icon(Icons.add));
  }

  Widget _buildFullScreenSpeedButton(double e) {
    Color fontColor = e == controller.playConfigOptions.playSpeed.value
        ? UIConstants.textActivatedColor
        : UIConstants.textColor;
    return SizedBox(
      key: UIConstants.playSpeedList.indexOf(e) ==
              UIConstants.playSpeedList.length - 1
          ? _lastItemKey
          : null,
      width: double.infinity,
      child: TextButton(
          onPressed: () {
            controller.playConfigOptions.playSpeed(e);
          },
          child: Text(
            "${e.toString()}x",
            style: TextStyle(color: fontColor, fontSize: UIConstants.textSize),
            textAlign: TextAlign.center,
          )),
    );
  }
}
