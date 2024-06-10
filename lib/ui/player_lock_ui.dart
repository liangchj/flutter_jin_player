import 'package:flutter/material.dart';
import 'package:flutter_jin_player/constants/ui_constants.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:get/get.dart';

class PlayerLockUI extends GetView<PlayerGetxController> {
  const PlayerLockUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => IconButton(
        onPressed: () {
          controller.uiConfigOptions
              .uiLocked(!controller.uiConfigOptions.uiLocked.value);
        },
        style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all(Colors.black.withOpacity(0.1))),
        icon: controller.uiConfigOptions.uiLocked.value
            ? UIConstants.lockedIcon
            : UIConstants.unLockedIcon));
  }
}
