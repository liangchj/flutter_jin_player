import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:flutter_jin_player/interface/iplayer.dart';
import 'package:flutter_jin_player/jin_player_view.dart';
import 'package:flutter_jin_player/models/config_options.dart';
import 'package:flutter_jin_player/player/flutter_video_player.dart';
import 'package:get/get.dart';

class PlayPage extends StatefulWidget {
  const PlayPage(
      {super.key,
      this.player,
      required this.createdPlayerGetxController,
      this.configOptions});
  final IPlayer? player;
  final Function(PlayerGetxController) createdPlayerGetxController;
  final ConfigOptions? configOptions;

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  late PlayerGetxController _playerGetxController;
  @override
  void initState() {
    _playerGetxController = Get.put(PlayerGetxController(
        widget.player ?? FlutterVideoPlayer(),
        configOptions: widget.configOptions));
    widget.createdPlayerGetxController.call(_playerGetxController);
    _playerGetxController.fullScreenPlayDeep(2);
    _playerGetxController.playConfigOptions.isFullScreen(true);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // 在这里执行你的构建之后的操作
    //   _playerGetxController.playConfigOptions.isFullScreen(true);
    //   AutoOrientation.landscapeAutoMode();
    //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // });

    super.initState();
  }

  @override
  void dispose() {
    AutoOrientation.portraitUpMode();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
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
    return const FullScreenPlayPage();
  }
}
