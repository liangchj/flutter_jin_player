import 'package:flutter/material.dart';
import 'package:flutter_jin_player/constants/ui_constants.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:flutter_jin_player/models/resource_chapter_item.dart';
import 'package:get/get.dart';

enum ResourceFromApiLayout { scroll, select }

class ChapterListUI extends GetView<PlayerGetxController> {
  const ChapterListUI(
      {super.key, this.resourceFromApiLayout = ResourceFromApiLayout.scroll});
  final ResourceFromApiLayout resourceFromApiLayout;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    controller.logger.d(
        "宽度：${UIConstants.chapterUIDefaultWidth.clamp(screenWidth * 0.45, screenWidth * 0.8)}");
    return Container(
      width: UIConstants.chapterUIDefaultWidth
          .clamp(screenWidth * 0.45, screenWidth * 0.8),
      color: UIConstants.backgroundColor,
      padding: const EdgeInsets.all(UIConstants.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 来源API
          _createFromApiLayout(),
          // 来源线路
          _createRouteLayout(),
          // 创建具体章节
          Expanded(child: _createChapterListLayout()),
        ],
      ),
    );
  }

  // 来源API
  _createFromApiLayout() {
    return Obx(() {
      if (controller.playConfigOptions.resourceApiList.isEmpty) {
        return Container();
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: UIConstants.padding / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "资源（${controller.playConfigOptions.resourceApiList.length}）",
              style: const TextStyle(
                  color: UIConstants.textColor,
                  fontSize: UIConstants.titleTextSize),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: UIConstants.padding / 2),
            ),
            Stack(
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: UIConstants.textSize * 3,
                ),
                Positioned.fill(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          controller.playConfigOptions.resourceApiList.length,
                      itemExtent: UIConstants.textSize * 10,
                      itemBuilder: (context, index) {
                        ResourceApiItem fromApi =
                            controller.playConfigOptions.resourceApiList[index];
                        return Container(
                            margin: const EdgeInsets.only(
                                right: UIConstants.margin),
                            child: MaterialButton(
                              //边框样式
                              shape: RoundedRectangleBorder(
                                  //边框颜色
                                  side: BorderSide(
                                    color: fromApi.activated
                                        ? UIConstants.iconActivatedColor
                                        : UIConstants.iconColor,
                                    width: UIConstants.borderWidth,
                                  ),
                                  //边框圆角
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(UIConstants.borderRadius),
                                  )),
                              onPressed: () {
                                if (!fromApi.activated) {
                                  for (var element in controller
                                      .playConfigOptions.resourceApiList) {
                                    element.activated = false;
                                  }
                                  fromApi.activated = true;
                                  controller.playConfigOptions
                                      .resourceRouteList(
                                          fromApi.resourceRouteList);
                                  controller.playConfigOptions.resourceApiList
                                      .refresh();
                                }
                              },
                              child: Text(
                                fromApi.apiName,
                                style: TextStyle(
                                    fontSize: UIConstants.textSize,
                                    color: fromApi.activated
                                        ? UIConstants.textActivatedColor
                                        : UIConstants.textColor),
                              ),
                            ));
                      }),
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  // 创建资源线路
  _createRouteLayout() {
    return Obx(() {
      if (controller.playConfigOptions.resourceRouteList.isEmpty) {
        return Container();
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: UIConstants.padding / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "线路（${controller.playConfigOptions.resourceRouteList.length}）",
              style: const TextStyle(
                  color: UIConstants.textColor,
                  fontSize: UIConstants.titleTextSize),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: UIConstants.padding / 2),
            ),
            Stack(
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: UIConstants.textSize * 3,
                ),
                Positioned.fill(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          controller.playConfigOptions.resourceRouteList.length,
                      itemExtent: UIConstants.textSize * 10,
                      itemBuilder: (context, index) {
                        ResourceRouteItem routeItem = controller
                            .playConfigOptions.resourceRouteList[index];
                        return Container(
                            margin: const EdgeInsets.only(
                                right: UIConstants.margin),
                            child: MaterialButton(
                              //边框样式
                              shape: RoundedRectangleBorder(
                                  //边框颜色
                                  side: BorderSide(
                                    color: routeItem.activated
                                        ? UIConstants.iconActivatedColor
                                        : UIConstants.iconColor,
                                    width: UIConstants.borderWidth,
                                  ),
                                  //边框圆角
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(UIConstants.borderRadius),
                                  )),
                              onPressed: () {
                                if (!routeItem.activated) {
                                  for (var element in controller
                                      .playConfigOptions.resourceRouteList) {
                                    element.activated = false;
                                  }
                                  routeItem.activated = true;
                                  /*controller.playerParams.resourceChapterList(
                                      routeModel.resourceChapterModelList);*/
                                  controller.playConfigOptions.resourceRouteList
                                      .refresh();
                                }
                              },
                              child: Text(
                                routeItem.routeName,
                                style: TextStyle(
                                    fontSize: UIConstants.textSize,
                                    color: routeItem.activated
                                        ? UIConstants.textActivatedColor
                                        : UIConstants.textColor),
                              ),
                            ));
                      }),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  //创建具体章节
  _createChapterListLayout() {
    return Obx(() {
      if (controller.playConfigOptions.resourceChapterList.isNotEmpty) {
        return Padding(
            padding: const EdgeInsets.only(bottom: UIConstants.padding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "选集（${controller.playConfigOptions.resourceChapterList.length}）",
                        style: const TextStyle(
                            color: UIConstants.textColor,
                            fontSize: UIConstants.titleTextSize)),
                    // TextButton.icon(
                    //     onPressed: () {
                    //       controller.playerParams.chapterAsc(
                    //           !controller.playerParams.chapterAsc.value);
                    //       List<ResourceChapterModel> list = [];
                    //       list.addAll(controller
                    //           .playerParams.resourceChapterList.reversed);
                    //       controller.playerParams.resourceChapterList(list);
                    //     },
                    //     icon: Icon(
                    //       controller.playerParams.chapterAsc.value
                    //           ? Icons.upgrade_rounded
                    //           : Icons.download_rounded,
                    //       color: Colors.white,
                    //     ),
                    //     label: Row(
                    //       children: [
                    //         Text(
                    //           controller.playerParams.chapterAsc.value
                    //               ? '升序'
                    //               : '降序',
                    //           style: const TextStyle(color: Colors.white),
                    //         ),
                    //       ],
                    //     )),
                  ],
                ),
                // const Padding(
                //   padding: EdgeInsets.only(bottom: UIConstants.padding),
                // ),
                Expanded(child: _buildChapterNormalLayout()),
              ],
            ));
      } else {
        return Container();
      }
    });
  }

  /// 普通列表排版
  _buildChapterNormalLayout() {
    return Obx(() {
      if (controller.playConfigOptions.resourceChapterList.isEmpty) {
        return const Text(
          "无数据",
          style: TextStyle(
              color: UIConstants.textColor, fontSize: UIConstants.textSize),
          textAlign: TextAlign.center,
        );
      }
      return ListView.builder(
          itemCount: controller.playConfigOptions.resourceChapterList.length,
          itemBuilder: (context, index) {
            var resourceChapter =
                controller.playConfigOptions.resourceChapterList[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 1.0),
              child: MaterialButton(
                //边框样式
                shape: RoundedRectangleBorder(
                    //边框颜色
                    side: BorderSide(
                      color: resourceChapter.activated
                          ? UIConstants.iconActivatedColor
                          : UIConstants.iconColor.withOpacity(0.6),
                      width: 1.0,
                    ),
                    //边框圆角
                    borderRadius: const BorderRadius.all(
                      Radius.circular(6.0),
                    )),
                onPressed: () {
                  if (!resourceChapter.activated) {
                    controller.playConfigOptions.currentPlayIndex(index);
                    // for (var element
                    // in controller.playerParams.resourceChapterList) {
                    //   element.activated = false;
                    // }
                    // resourceChapter.activated = true;
                    // controller.playerParams.resourceChapterList.refresh();
                    // 更改播放
                    /*controller.playerParams.resourceModel(
                        ResourceModel(id: resourceChapter.resourceModel.id, name: resourceChapter.resourceModel.name, path: resourceChapter.resourceModel.path, coverUrl: resourceChapter.resourceModel.coverUrl)
                    );*/
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: UIConstants.textSize / 1.5),
                  child: Row(
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        size: UIConstants.iconSize,
                        color: Colors.redAccent
                            .withOpacity(resourceChapter.activated ? 1 : 0),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Text(
                            resourceChapter.resourceItem.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: UIConstants.textSize,
                                color: resourceChapter.activated
                                    ? UIConstants.textActivatedColor
                                    : UIConstants.textColor,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    });
  }

  // 创建网格排版
  _buildChapterGridLayout() {
    return Obx(() {
      if (controller.playConfigOptions.resourceChapterList.isEmpty) {
        return const Text(
          "无数据",
          style: TextStyle(
              color: UIConstants.textColor, fontSize: UIConstants.textSize),
          textAlign: TextAlign.center,
        );
      }
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth;
        // 最多可以显示3位（多算以为是要包括边框）
        double cardWidth =
            UIConstants.textSize * 4 + UIConstants.gridMainAxisSpacing;
        // 显示数量
        int showNum = (maxWidth / cardWidth).floor();
        // 剩余的宽度分配给各个间距
        double gridSpace = UIConstants.gridMainAxisSpacing +
            (maxWidth - cardWidth * showNum) / showNum;

        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: showNum, //每行四列
                childAspectRatio: 1.0, //显示区域宽高相等
                mainAxisSpacing: gridSpace,
                crossAxisSpacing: UIConstants.gridCrossAxisSpacing),
            itemCount: controller.playConfigOptions.resourceChapterList.length,
            itemBuilder: (context, index) {
              var resourceChapter =
                  controller.playConfigOptions.resourceChapterList[index];
              return MaterialButton(
                //边框样式
                shape: RoundedRectangleBorder(
                    //边框颜色
                    side: BorderSide(
                      color: resourceChapter.activated
                          ? UIConstants.iconActivatedColor
                          : UIConstants.iconColor.withOpacity(0.6),
                      width: UIConstants.borderWidth,
                    ),
                    //边框圆角
                    borderRadius: const BorderRadius.all(
                      Radius.circular(6.0),
                    )),
                onPressed: () {
                  if (!resourceChapter.activated) {
                    controller.playConfigOptions.currentPlayIndex(index);
                    // for (var element
                    //     in controller.playerParams.resourceChapterList) {
                    //   element.activated = false;
                    // }
                    // resourceChapter.activated = true;
                    // controller.playerParams.resourceChapterList.refresh();
                    // 更改播放
                    /*controller.playerParams.resourceModel(
                            ResourceModel(id: resourceChapter.resourceModel.id, name: resourceChapter.resourceModel.name, path: resourceChapter.resourceModel.path,
                                coverUrl: resourceChapter.resourceModel.coverUrl
                            ));*/
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: UIConstants.textSize / 1.5),
                  child: Text(
                    resourceChapter.resourceItem.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: UIConstants.textSize,
                        color: resourceChapter.activated
                            ? UIConstants.textActivatedColor
                            : UIConstants.textColor,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              );
            });
      });
    });
  }
}
