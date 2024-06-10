import 'package:flutter/material.dart';
import 'package:flutter_jin_player/constants/ui_constants.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:get/get.dart';

class PlayerScreenshotUI extends GetView<PlayerGetxController> {
  const PlayerScreenshotUI({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {},
        style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all(Colors.white.withOpacity(0.1))),
        icon: UIConstants.screenshotIcon);
  }
}
