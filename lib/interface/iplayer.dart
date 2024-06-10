import 'package:flutter/material.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:flutter_jin_player/models/resource_item.dart';

abstract class IPlayer {
  PlayerGetxController? getxController;

  /// 播放器初始化
  Future<Widget?> onInitPlayer(ResourceItem resourceItem);

  /// 销毁播放器
  Future<void> onDisposePlayer();

  /// 更新状态信息
  void updateState();
  // 初始化
  Future<void> initialize();
  // 播放
  Future<void> play();
  // 暂停
  Future<void> pause();
  // 进入全屏
  Future<void> entryFullScreen();
  // 退出全屏
  Future<void> exitFullScreen();
  // 进度跳转
  Future<void> seekTo(Duration position);
  // 设置播放速度
  Future<void> setPlaySpeed(double speed);
  // 监听状态变化
  void listenerStatus();
  // 数据源变更
  bool dataSourceChange(String path);
}
