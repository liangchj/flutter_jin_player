import 'package:flutter/material.dart';
import 'package:flutter_jin_player/interface/iplayer.dart';
import 'package:flutter_jin_player/models/resource_item.dart';
import 'package:flutter_jin_player/widgets/player_progress_bar.dart';
import 'package:video_player/video_player.dart';

class FlutterVideoPlayer extends IPlayer {
  VideoPlayerController? _videoPlayerController;

  @override
  Future<Widget?> onInitPlayer(ResourceItem resourceItem) async {
    Widget? playerView;
    try {
      //初始化播放器设置
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(resourceItem.path));
      playerView = VideoPlayer(
        _videoPlayerController!,
        key: Key(resourceItem.path),
      );
    } catch (e) {
      playerView = null;
    }
    return Future(() => playerView);
  }

  @override
  Future<void> onDisposePlayer() async {
    _videoPlayerController?.removeListener(updateState);
    return _videoPlayerController?.dispose();
  }

  @override
  Future<void> initialize() async {
    if (_videoPlayerController != null &&
        !_videoPlayerController!.value.isInitialized) {
      // return _videoPlayerController?.initialize();
      await _videoPlayerController?.initialize();
    }
  }

  @override
  void listenerStatus() {
    _videoPlayerController?.addListener(updateState);
  }

  @override
  void updateState() {
    var value = _videoPlayerController?.value;
    // getxController?.playConfigOptions.hasError(false);
    getxController?.playConfigOptions.errorMsg("");
    if (value == null) {
      // 错误显示
      getxController?.playConfigOptions.errorMsg("播放器获取信息失败");
      // getxController?.playConfigOptions.hasError(true);
      return;
    }
    // 视频是否加载错误
    if (value.hasError) {
      var errorDescription = value.errorDescription;
      getxController?.playConfigOptions.errorMsg(errorDescription);
      // 标记错误
      // getxController?.playConfigOptions.hasError(true);
    } else {
      var buffered = value.buffered; // 缓冲信息
      List<BufferedDurationRange> bufferedDurationRange = [];
      if (buffered.isNotEmpty) {
        for (var element in buffered) {
          bufferedDurationRange.add(
              BufferedDurationRange(start: element.start, end: element.end));
        }
      }
      bool isFinished = value.isCompleted;
      // 插件读取可能会有毫秒级差
      if (!isFinished &&
          value.duration.inMilliseconds - value.position.inMilliseconds < 500) {
        isFinished = true;
      }

      getxController?.playConfigOptions.updateOptions(
          initialized: value.isInitialized,
          playing: value.isPlaying,
          duration: value.duration,
          positionDuration: value.position,
          bufferedDurationRange: bufferedDurationRange,
          finished: isFinished);
    }
    if (_videoPlayerController != null &&
        _videoPlayerController!.value.isInitialized) {
      getxController?.playConfigOptions
          .videoAspectRatio(_videoPlayerController!.value.aspectRatio);
    }
  }

  @override
  Future<void> play() async {
    if (_videoPlayerController != null &&
        !_videoPlayerController!.value.isInitialized) {
      return _videoPlayerController!
          .initialize()
          .then((_) => _videoPlayerController!.play());
    } else {
      return _videoPlayerController?.play();
    }
  }

  @override
  Future<void> pause() async {
    return _videoPlayerController?.pause();
  }

  @override
  Future<void> entryFullScreen() async {
    return pause();
  }

  @override
  Future<void> exitFullScreen() async {
    pause();
  }

  @override
  Future<void> seekTo(Duration position) async {
    getxController!.logger.d("进度跳转：$position");
    return _videoPlayerController?.seekTo(position);
  }

  @override
  Future<void> setPlaySpeed(double speed) async {
    return _videoPlayerController?.setPlaybackSpeed(speed);
  }

  @override
  bool dataSourceChange(String path) {
    return _videoPlayerController?.dataSource != path;
  }
}
