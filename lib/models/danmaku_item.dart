import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 哔哩哔哩的xml弹幕
// <d p="490.19100,1,25,16777215,1584268892,0,a16fe0dd,29950852386521095">从结尾回来看这里，更感动了！</d>
// 0 视频内弹幕出现时间	float	秒

// 1 弹幕类型	int32	1 2 3：普通弹幕
//                  4：底部弹幕
//                  5：顶部弹幕
//                  6：逆向弹幕
//                  7：高级弹幕
//                  8：代码弹幕
//                  9：BAS弹幕（pool必须为2）

//2	弹幕字号	int32	18：小
//                  25：标准
//                  36：大

// 3	弹幕颜色	int32	十进制RGB888值

// 4	弹幕发送时间	int32	时间戳

// 5	弹幕池类型	int32	0：普通池
//                      1：字幕池
//                      2：特殊池（代码/BAS弹幕）

// 6	发送者mid的HASH	string	用于屏蔽用户和查看用户发送的所有弹幕 也可反查用户id
// 7	弹幕dmid	int64	唯一 可用于操作参数
// 8	弹幕的屏蔽等级	int32	0-10，低于用户设定等级的弹幕将被屏蔽 （新增，下方样例未包含）

String danmakuItemListToJson(List<DanmakuItem> data) =>
    json.encode(List<dynamic>.from(data.map((e) => e.toJson())));

List<DanmakuItem> danmakuItemlListFromJson(String str) =>
    List<DanmakuItem>.from(
        json.decode(str).map((x) => DanmakuItem.fromJson(x)));

class DanmakuItem {
  // 	视频内弹幕出现时间	float	秒
  final double time;
  // 	弹幕类型
  final int mode;
  // 弹幕字号
  final double fontSize;
  // 弹幕颜色（十进制RGB888值）
  final int color;
  // 弹幕发送时间	时间戳
  final int? createTime;
  // 弹幕池类型
  final String? poolType;
  // 发送者mid的HASH	string	用于屏蔽用户和查看用户发送的所有弹幕 也可反查用户id
  final String? sendUserId;
  // 弹幕dmid	int64	唯一 可用于操作参数
  final String danmakuId;
  // 弹幕的屏蔽等级
  final int level;

  // 弹幕内容
  final String content;

  DanmakuItem({
    required this.time,
    required this.mode,
    required this.fontSize,
    required this.color,
    this.createTime,
    this.poolType,
    this.sendUserId,
    required this.danmakuId,
    required this.level,
    required this.content,
  });

  factory DanmakuItem.fromJson(Map<String, dynamic> json) => DanmakuItem(
        time: json["time"],
        mode: json["mode"],
        fontSize: json["fontSize"],
        color: json["color"],
        createTime: json["createTime"],
        poolType: json["poolType"],
        sendUserId: json["sendUserId"],
        danmakuId: json["danmakuId"],
        level: json["level"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "mode": mode,
        "fontSize": fontSize,
        "color": color,
        "createTime": createTime,
        "poolType": poolType,
        "sendUserId": sendUserId,
        "danmakuId": danmakuId,
        "level": level,
        "content": content,
      };
}

// 弹幕源文件
class DanmakuSourceItem {
  String? path;
  bool? pathFromAssets;
  List<DanmakuItem>? addDanmakuList;
  final bool clearOldDanmaku;
  bool read;

  DanmakuSourceItem(
      {this.path,
      this.pathFromAssets = false,
      this.addDanmakuList,
      this.clearOldDanmaku = false,
      this.read = false});

  factory DanmakuSourceItem.fromJson(Map<String, dynamic> json) =>
      DanmakuSourceItem(
          path: json["path"],
          pathFromAssets: json["pathFromAssets"],
          addDanmakuList: json["addDanmakuList"] == null ||
                  json["addDanmakuList"]! is Map<String, dynamic>
              ? null
              : danmakuItemlListFromJson(json["addDanmakuList"]),
          clearOldDanmaku: json["clearOldDanmaku"],
          read: json["read"]);

  Map<String, dynamic> toJson() => {
        "path": path,
        "pathFromAssets": pathFromAssets,
        "addDanmakuList": addDanmakuList != null
            ? danmakuItemListToJson(addDanmakuList!)
            : addDanmakuList,
        "clearOldDanmaku": clearOldDanmaku,
        "read": read
      };
}

// 弹幕显示区域
class DanmakuAreaItem {
  final double area;
  final String name;
  // 弹幕过多是否限制显示（自动过滤）
  bool filter;

  DanmakuAreaItem({required this.area, required this.name, this.filter = true});
}

class DanmakuArea {
  final List<DanmakuAreaItem> danmakuAreaItemList;
  int _areaIndex = 0;
  int get areaIndex => _areaIndex;
  String name = "";

  DanmakuArea({required this.danmakuAreaItemList, required int areaIndex}) {
    _areaIndex = areaIndex;
    name = danmakuAreaItemList.length > _areaIndex
        ? danmakuAreaItemList[_areaIndex].name
        : "";
  }

  set areaIndex(int i) {
    _areaIndex = i;
    name = danmakuAreaItemList.length > _areaIndex
        ? danmakuAreaItemList[_areaIndex].name
        : "";
  }
}

// 弹幕文字大小
class DanmakuFontSize {
  // 基础字体大小
  final double size;
  final double min;
  final double max;
  double? _ratio;
  double get ratio => _ratio ?? min;

  DanmakuFontSize(
      {this.size = 16.0,
      required this.min,
      required this.max,
      required double ratio}) {
    _ratio = ratio.round().toDouble();
  }
  set ratio(double d) {
    _ratio = d.round().toDouble();
  }
}

// 弹幕速度
class DanmakuSpeed {
  final double min;
  final double max;
  double? _speed;
  double get speed => _speed ?? min;

  DanmakuSpeed({required this.min, required this.max, required double speed}) {
    _speed = speed.round().toDouble();
  }

  set speed(double s) {
    _speed = s.round().toDouble();
  }
}

// 弹幕透明的
class DanmakuAlphaRatio {
  final double min;
  final double max;
  double? _ratio;
  double get ratio => _ratio ?? min;

  DanmakuAlphaRatio(
      {required this.min, required this.max, required double ratio}) {
    _ratio = ratio.round().toDouble();
  }

  set ratio(double d) {
    _ratio = d.round().toDouble();
  }
}

// 弹幕描边
class DanmakuStyleStrokeWidth {
  final double min;
  final double max;
  double? _strokeWidth;
  double get strokeWidth => _strokeWidth ?? min;

  DanmakuStyleStrokeWidth(
      {required this.min, required this.max, required double strokeWidth}) {
    _strokeWidth = strokeWidth.round().toDouble();
  }
  set strokeWidth(double d) {
    _strokeWidth = d.round().toDouble();
  }
}

// 弹幕过滤类型
class DanmakuFilterType {
  final String enName;
  final String chName;
  final List<int> modeList;
  final ImageIcon openImageIcon;
  final ImageIcon closeImageIcon;
  var filter = false.obs;

  DanmakuFilterType({
    required this.enName,
    required this.chName,
    required this.modeList,
    required this.openImageIcon,
    required this.closeImageIcon,
  });
}
