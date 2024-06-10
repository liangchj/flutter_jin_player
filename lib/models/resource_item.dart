// 资源信息
import 'package:flutter_jin_player/models/danmaku_item.dart';

class ResourceItem {
  final String id;
  final String name;
  final String path;
  final String? coverUrl;

  DanmakuSourceItem? danmakuSourceItem;

  ResourceItem({
    required this.id,
    required this.name,
    required this.path,
    this.coverUrl,
    this.danmakuSourceItem,
  });

  factory ResourceItem.fromJson(Map<String, dynamic> json) => ResourceItem(
      id: json["id"],
      name: json["name"],
      path: json["path"],
      coverUrl: json["coverUrl"],
      danmakuSourceItem: json["danmakuSourceItem"] == null ||
              json["danmakuSourceItem"] is! Map<String, dynamic>
          ? null
          : DanmakuSourceItem.fromJson(json["danmakuSourceItem"]));

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "path": path, "coverUrl": coverUrl};
}
