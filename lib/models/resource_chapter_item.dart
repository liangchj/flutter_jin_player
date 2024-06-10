import 'dart:convert';

import 'package:flutter_jin_player/models/resource_item.dart';

List<ResourceChapterItem> resourceChapterItemListFromJsonStr(String str) =>
    List<ResourceChapterItem>.from(
        json.decode(str).map((x) => ResourceChapterItem.fromJson(x)));

List<ResourceChapterItem> resourceChapterItemListFromJson(List<dynamic> json) =>
    List<ResourceChapterItem>.from(
        json.map((x) => ResourceChapterItem.fromJson(x)));

String resourceChapterItemListToJson(List<ResourceChapterItem> data) =>
    json.encode(List<dynamic>.from(data.map((e) => e.toJson())));

/// 视频资源章节信息
class ResourceChapterItem {
  final ResourceItem resourceItem;

  /// 是否选中
  bool activated;

  /// 是否播放中
  bool playing;

  /// 下标，用于升序和降序
  int index;

  ResourceChapterItem(
      {required this.resourceItem,
      this.activated = false,
      this.playing = false,
      required this.index});

  factory ResourceChapterItem.fromJson(Map<String, dynamic> json) {
    return ResourceChapterItem(
        resourceItem: ResourceItem.fromJson(json["resourceItem"]),
        activated: json["activated"] ?? false,
        playing: json["playing"] ?? false,
        index: json["index"] ?? 0);
  }
  Map<String, dynamic> toJson() => {
        "id": resourceItem.toString(),
        "activated": activated,
        "playing": playing,
        "index": index
      };
}

List<ResourceRouteItem> resourceRouteItemListFromJson(List<dynamic> listJson) =>
    List<ResourceRouteItem>.from(
        listJson.map((x) => ResourceRouteItem.fromJson(x)));

List<ResourceRouteItem> resourceRouteItemListFromJsonStr(String str) =>
    List<ResourceRouteItem>.from(
        json.decode(str).map((x) => ResourceRouteItem.fromJson(x)));

String resourceRouteItemListToJson(List<ResourceRouteItem> data) =>
    json.encode(List<dynamic>.from(data.map((e) => e.toJson())));

/// 资源线路
class ResourceRouteItem {
  /// 当前播放线路
  final String routeEnName;
  final String routeName;
  List<ResourceChapterItem>? resourceChapterItemList;
  bool activated;
  int maxVideoNameLen;

  ResourceRouteItem(
      {required this.routeEnName,
      required this.routeName,
      this.resourceChapterItemList,
      this.activated = false,
      required this.maxVideoNameLen});

  factory ResourceRouteItem.fromJson(Map<String, dynamic> json) {
    List<ResourceChapterItem>? resourceChapterItemList;
    var resourceChapterItemJsonList = json["resourceChapterItemList"];
    if (resourceChapterItemJsonList != null) {
      try {
        resourceChapterItemList =
            resourceChapterItemListFromJsonStr(resourceChapterItemJsonList);
      } catch (e) {}
    }
    int maxVideoNameLen = -1;
    try {
      maxVideoNameLen = json["maxVideoNameLen"];
    } catch (e) {
      if (resourceChapterItemList != null &&
          resourceChapterItemList.isNotEmpty) {
        for (ResourceChapterItem e in resourceChapterItemList) {
          if (e.resourceItem.name.length > maxVideoNameLen) {
            maxVideoNameLen = e.resourceItem.name.length;
          }
        }
      }
    }
    return ResourceRouteItem(
        routeEnName: json["routeEnName"],
        routeName: json["routeName"],
        resourceChapterItemList: resourceChapterItemList,
        activated: json["activated"] ?? false,
        maxVideoNameLen: maxVideoNameLen);
  }

  Map<String, dynamic> toJson() => {
        "routeEnName": routeEnName,
        "routeName": routeName,
        "resourceChapterItemList": resourceChapterItemList == null
            ? null
            : resourceChapterItemListToJson(resourceChapterItemList!),
        "activated": activated
      };
}

/// 资源来源api
class ResourceApiItem {
  final String apiKey;
  final String apiEnName;
  final String apiName;
  bool activated;
  final List<ResourceRouteItem> resourceRouteList;

  ResourceApiItem(
      {required this.apiKey,
      required this.apiEnName,
      required this.apiName,
      required this.activated,
      required this.resourceRouteList});

  factory ResourceApiItem.fromJson(Map<String, dynamic> json) {
    var routeListJson = json["resourceRouteList"];
    List<ResourceRouteItem> fromList = routeListJson != null
        ? resourceRouteItemListFromJson(routeListJson)
        : [];
    return ResourceApiItem(
        apiKey: json["apiKey"] ?? "",
        apiEnName: json["apiEnName"] ?? "",
        apiName: json["apiName"] ?? "",
        activated: json["activated"] ?? false,
        resourceRouteList: fromList);
  }
}
