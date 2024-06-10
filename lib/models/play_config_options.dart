import 'package:flutter/widgets.dart';
import 'package:flutter_jin_player/models/resource_chapter_item.dart';
import 'package:flutter_jin_player/models/resource_item.dart';
import 'package:flutter_jin_player/widgets/player_progress_bar.dart';
import 'package:get/get.dart';

class PlayConfigOptions {
  // // 播放比例
  // final double playerAspectRatio;
  // // 播放速度
  // final double playSpeed;

  PlayConfigOptions({double? aspectRatio, double? playSpeed}) {
    this.aspectRatio(aspectRatio ?? 16 / 9.0);
    this.playSpeed(playSpeed ?? 1.0);
  }

  // 播放器
  var playerView = Rx<Widget?>(Container());

  // 视频信息
  // var hasError = false.obs; // 有错误信息

  // 错误信息
  var errorMsg = "".obs;

  // 视频播放比例
  var aspectRatio = (16 / 9.0).obs;

  // 视频本身的比例
  var videoAspectRatio = 1.0.obs;

  // 全屏播放（全屏/非全屏转换状态）
  var isFullScreen = false.obs;

  // 播放速度： ['0.25x', '0.5x', '0.75x', '1.0x', '1.25x', '1.5x', '1.75x', '2.0x']
  var playSpeed = 1.0.obs;

  // 是否自动播放
  bool autoPlay = false;
  // 视频已初始化
  var initialized = false.obs;
  // 视频播放中
  var playing = false.obs;
  // 拖动进度时播放状态
  var beforeSeekIsPlaying = false.obs;
  // 缓冲中
  var buffering = false.obs;
  // 进度跳转中
  var seeking = false.obs;
  // 拖动中
  var dragging = false.obs;
  // 播放结束
  var finished = false.obs;

  // 总时长
  var duration = Duration.zero.obs;
  // 当前播放时长
  var positionDuration = Duration.zero.obs;
  // 缓冲区间列表
  var bufferedDurationRange = Rx<List<BufferedDurationRange>>([]);

  // 拖动进度时的播放位置
  Duration dragProgressPositionDuration = Duration.zero;
  // 播放进度拖动秒数
  var draggingSecond = 0.obs;
  // 前一次拖动剩余值（每次更新只获取整数部分更新，剩下的留给后面更新）
  double draggingSurplusSecond = 0.0;

  // 当前音量值（使用百分比）
  var volume = 0.obs;
  // 当前音量值（使用百分比）
  var brightness = 0.obs;
  // 纵向滑动剩余值（每次更新只获取整数部分更新，剩下的留给后面更新）
  double verticalDragSurplus = 0.0;
  var volumeDragging = false.obs; // 音量拖动中
  var brightnessDragging = false.obs; // 亮度拖动中

  // 资源来源信息列表
  var resourceApiList = <ResourceApiItem>[].obs;
  var resourceRouteList = <ResourceRouteItem>[].obs;
  var resourceChapterList = <ResourceChapterItem>[].obs;
  var resourceItem = ResourceItem(id: "", name: "", path: "").obs;

  // 当前播放视频下标
  // var currentPlayIndex = 0.obs;
  var currentPlayIndex = RxInt(-1);

  // 章节升序
  var chapterAsc = true.obs;

  resetOptions() {
    initialized(false);
    playing(false);
    beforeSeekIsPlaying(false);
    buffering(false);
    seeking(false);
    finished(false);
    // hasError(false);
    errorMsg("");
    duration(Duration.zero);
    positionDuration(Duration.zero);
    bufferedDurationRange([]);
  }

  updateOptions({
    bool? initialized,
    bool? playing,
    bool? beforeSeekIsPlaying,
    bool? buffering,
    bool? seeking,
    bool? finished,
    bool? hasError,
    Duration? duration,
    Duration? positionDuration,
    List<BufferedDurationRange>? bufferedDurationRange,
  }) {
    if (initialized != null) {
      this.initialized(initialized);
    }

    if (beforeSeekIsPlaying != null) {
      this.beforeSeekIsPlaying(beforeSeekIsPlaying);
    }
    if (buffering != null) {
      this.buffering(buffering);
    }
    if (seeking != null) {
      this.seeking(seeking);
    }

    // if (hasError != null) {
    //   this.hasError(hasError);
    // }

    if (duration != null) {
      this.duration(duration);
    }
    if (positionDuration != null) {
      this.positionDuration(positionDuration);
    }
    if (bufferedDurationRange != null) {
      this.bufferedDurationRange(bufferedDurationRange);
    }

    if (finished != null) {
      this.finished(finished);
      if (finished) {
        this.playing(false);
      }
    }

    if (playing != null) {
      this.playing(playing);
    }
  }
}

/// 缓冲区间
// class BufferedDurationRange {
//   BufferedDurationRange({required this.start, required this.end});

//   /// 开始时间
//   final Duration start;

//   /// 结束时间
//   final Duration end;

//   static const List<BufferedDurationRange> empty = <BufferedDurationRange>[];
// }
