import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:flutter_jin_player/interface/iplayer.dart';
import 'package:flutter_jin_player/models/config_options.dart';
import 'package:flutter_jin_player/player/flutter_video_player.dart';
import 'package:get/get.dart';

class JinPlayerView extends StatefulWidget {
  const JinPlayerView({
    super.key,
    this.player,
    required this.createdPlayerGetxController,
    this.configOptions,
  });
  final IPlayer? player;
  final Function(PlayerGetxController) createdPlayerGetxController;
  final ConfigOptions? configOptions;

  @override
  State<JinPlayerView> createState() => _JinPlayerViewState();
}

class _JinPlayerViewState extends State<JinPlayerView> {
  late PlayerGetxController _playerGetxController;
  late IPlayer _player;
  @override
  void initState() {
    _player = widget.player ?? FlutterVideoPlayer();
    _playerGetxController = Get.put(
        PlayerGetxController(_player, configOptions: widget.configOptions));
    widget.createdPlayerGetxController.call(_playerGetxController);
    super.initState();
  }

  @override
  void dispose() {
    _playerGetxController.hideTimer?.cancel();
    try {
      _playerGetxController.player.onDisposePlayer();
      _playerGetxController.dispose();
    } catch (e) {
      rethrow;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => _playerGetxController.fullScreenPlayDeep.value > 1
        ? Container()
        : _playerGetxController.jinPlayerView);
  }
}

class FullScreenPlayPage extends StatefulWidget {
  const FullScreenPlayPage({super.key});

  @override
  State<FullScreenPlayPage> createState() => _FullScreenPlayPageState();
}

class _FullScreenPlayPageState extends State<FullScreenPlayPage> {
  PlayerGetxController controller = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在这里执行你的构建之后的操作
      // Navigator.push(context, MaterialPageRoute(builder: (context) =>   _FullScreenPlayerView()));
      controller.playConfigOptions.isFullScreen(true);
      // controller.cancelAndRestartTimer();
      AutoOrientation.landscapeAutoMode();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    });

    super.initState();
  }

  @override
  void dispose() {
    AutoOrientation.portraitUpMode();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => PopScope(
          canPop: controller.uiConfigOptions.interceptRoute.value,
          onPopInvoked: (bool didPop) async {
            if (!didPop) {
              controller.uiControl.hideUIByKeyList(
                  controller.uiConfigOptions.interceptRouteUIKeyList);
            } else {
              controller.fullScreenPlayDeep(1);
              controller.playConfigOptions.isFullScreen(false);
            }
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: controller.jinPlayerView,
            ),
          ),
        ));
  }
}
