import 'package:flutter/material.dart';
import 'package:flutter_jin_player/constants/ui_constants.dart';
import 'package:flutter_jin_player/controller/player_getx_controller.dart';
import 'package:flutter_jin_player/ui/player_ui.dart';
import 'package:get/get.dart';

class DanmakuSettingUI extends GetView<PlayerGetxController> {
  const DanmakuSettingUI({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: UIConstants.barrageUIDefaultWidth
          .clamp(screenWidth * 0.45, screenWidth * 0.8),
      color: UIConstants.backgroundColor,
      padding: const EdgeInsets.all(UIConstants.padding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // 弹幕设置
            Column(
              children: [
                _createTitle("弹幕设置"),
                Column(
                  children: [
                    // 弹幕不透明度设置
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: UIConstants.padding / 2),
                      child: _danmakuOpacitySetting(context),
                    ),
                    // 弹幕显示区域设置
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: UIConstants.padding / 2),
                      child: _danmakuDisplayAreaSetting(context),
                    ),
                    // 弹幕字号设置
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: UIConstants.padding / 2),
                      child: _danmakuFontSizeSetting(context),
                    ),
                    // 弹幕速度设置
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: UIConstants.padding / 2),
                      child: _danmakuSpeedSetting(context),
                    ),
                    // 弹幕描边设置
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: UIConstants.padding / 2),
                      child: _danmakuStyleStrokeWidthSetting(context),
                    ),
                  ],
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: UIConstants.padding / 2),
            ),
            // 屏蔽类型
            Column(
              children: [
                _createTitle("屏蔽类型"),
                FractionallySizedBox(
                  widthFactor: 1.0,
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: UIConstants.margin, // 主轴(水平)方向间距
                    runSpacing: UIConstants.margin, // 纵轴（垂直）方向间距
                    verticalDirection: VerticalDirection.down,
                    alignment: WrapAlignment.spaceBetween, //
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ...controller.danmakuConfigOptions.danmakuFilterTypeList
                          .map((filterType) => Obx(() => InkWell(
                                onTap: () =>
                                    filterType.filter(!filterType.filter.value),
                                child: Column(
                                  children: [
                                    UIConstants.lockedIcon,
                                    Text(
                                      filterType.chName,
                                      style: TextStyle(
                                          fontSize: UIConstants.textSize,
                                          color: filterType.filter.value
                                              ? UIConstants.textActivatedColor
                                              : UIConstants.textColor),
                                    )
                                  ],
                                ),
                              )))
                    ],
                  ),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: UIConstants.padding),
            ),
            // 时间调整
            Column(
              children: [
                _createTitle("时间调整（秒）"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () => controller.danmakuConfigOptions
                            .uiShowAdjustTime(controller.danmakuConfigOptions
                                    .uiShowAdjustTime.value -
                                0.5),
                        icon: const Icon(
                          Icons.remove_circle_rounded,
                          color: UIConstants.iconColor,
                        )),
                    Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(
                          horizontal: UIConstants.padding),
                      child: Center(
                          child: Obx(
                        () => Text(
                          controller.danmakuConfigOptions.uiShowAdjustTime
                              .toStringAsFixed(1),
                          style: const TextStyle(
                              fontSize: UIConstants.textSize,
                              color: UIConstants.textColor),
                        ),
                      )),
                    ),
                    IconButton(
                        onPressed: () => controller.danmakuConfigOptions
                            .uiShowAdjustTime(controller.danmakuConfigOptions
                                    .uiShowAdjustTime.value +
                                0.5),
                        icon: const Icon(Icons.add_circle_rounded,
                            color: UIConstants.iconColor)),
                  ],
                ),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.danmakuConfigOptions.adjustTime(controller
                            .danmakuConfigOptions.uiShowAdjustTime.value);
                      },
                      style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    UIConstants.danmakuBigBtnBorderRadius)),
                          ),
                          backgroundColor: WidgetStateProperty.all(
                              UIConstants.danmakuBigBtnColor)),
                      child: const Text("同步弹幕时间",
                          style: TextStyle(
                              fontSize: UIConstants.textSize,
                              color: UIConstants.textBlackColor)),
                    )),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: UIConstants.padding),
            ),

            // 弹幕屏蔽词
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _createTitle("弹幕屏蔽词"),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: UIConstants.padding),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    UIConstants.danmakuBigBtnBorderRadius)),
                          ),
                          backgroundColor: WidgetStateProperty.all(
                              UIConstants.danmakuBigBtnColor)),
                      child: const Text(
                        "弹幕屏蔽管理",
                        style: TextStyle(
                            fontSize: UIConstants.textSize,
                            color: UIConstants.textBlackColor),
                      )),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: UIConstants.padding),
            ),
            // 弹幕列表
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _createTitle("弹幕列表"),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: UIConstants.padding),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    UIConstants.danmakuBigBtnBorderRadius)),
                          ),
                          backgroundColor: WidgetStateProperty.all(
                              UIConstants.danmakuBigBtnColor)),
                      child: const Text(
                        "查看弹幕列表",
                        style: TextStyle(
                            fontSize: UIConstants.textSize,
                            color: UIConstants.textBlackColor),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 弹幕不透明度设置
  Widget _danmakuOpacitySetting(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 左边文字说明
            _leftDescText("不透明度"),

            // 中间进度指示器
            Expanded(
              child: SliderTheme(
                  data: UIConstants.danmakuSliderTheme(context),
                  child: Slider(
                    value: controller
                        .danmakuConfigOptions.danmakuAlphaRatio.value.ratio,
                    min: controller
                        .danmakuConfigOptions.danmakuAlphaRatio.value.min,
                    max: controller
                        .danmakuConfigOptions.danmakuAlphaRatio.value.max,
                    onChanged: (value) {
                      controller.danmakuConfigOptions.danmakuAlphaRatio.value
                          .ratio = value.truncateToDouble();
                      controller.danmakuConfigOptions.danmakuAlphaRatio
                          .refresh();
                    },
                  )),
            ),

            // 右边进度提示
            _rightTipText(
                "${controller.danmakuConfigOptions.danmakuAlphaRatio.value.ratio}%"),
          ],
        ));
  }

  /// 弹幕显示区域设置
  Widget _danmakuDisplayAreaSetting(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 左边文字说明
            _leftDescText("显示区域"),

            // 中间进度指示器
            Expanded(
              child: SliderTheme(
                  data: UIConstants.danmakuSliderTheme(context),
                  child: Slider(
                    value: controller
                        .danmakuConfigOptions.danmakuArea.value.areaIndex
                        .toDouble(),
                    min: 0,
                    max: controller.danmakuConfigOptions.danmakuArea.value
                            .danmakuAreaItemList.length -
                        1,
                    divisions: controller.danmakuConfigOptions.danmakuArea.value
                            .danmakuAreaItemList.length -
                        1,
                    onChanged: (value) {
                      controller.danmakuConfigOptions.danmakuArea.value
                          .areaIndex = value.toInt();
                      controller.danmakuConfigOptions.danmakuArea.refresh();
                    },
                  )),
            ),
            _rightTipText(controller
                .danmakuConfigOptions
                .danmakuArea
                .value
                .danmakuAreaItemList[
                    controller.danmakuConfigOptions.danmakuArea.value.areaIndex]
                .name)
          ],
        ));
  }

  /// 弹幕字号设置
  Widget _danmakuFontSizeSetting(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 左边文字说明
            _leftDescText("弹幕字号"),

            // 中间进度指示器
            Expanded(
              child: SliderTheme(
                  data: UIConstants.danmakuSliderTheme(context),
                  child: Slider(
                    value: controller
                        .danmakuConfigOptions.danmakuFontSize.value.ratio,
                    min: controller
                        .danmakuConfigOptions.danmakuFontSize.value.min,
                    max: controller
                        .danmakuConfigOptions.danmakuFontSize.value.max,
                    onChanged: (value) {
                      controller.danmakuConfigOptions.danmakuFontSize.value
                          .ratio = value.truncateToDouble();
                      controller.danmakuConfigOptions.danmakuFontSize.refresh();
                    },
                  )),
            ),

            // 右边进度提示
            _rightTipText(
                "${controller.danmakuConfigOptions.danmakuFontSize.value.ratio}%")
          ],
        ));
  }

  /// 弹幕速度设置
  Widget _danmakuSpeedSetting(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 左边文字说明
            _leftDescText("弹幕速度"),

            // 中间进度指示器
            Expanded(
              child: SliderTheme(
                  data: UIConstants.danmakuSliderTheme(context),
                  child: Slider(
                    value: controller
                        .danmakuConfigOptions.danmakuSpeed.value.speed,
                    min: controller.danmakuConfigOptions.danmakuSpeed.value.min,
                    max: controller.danmakuConfigOptions.danmakuSpeed.value.max,
                    onChanged: (value) {
                      controller.danmakuConfigOptions.danmakuSpeed.value.speed =
                          value.truncateToDouble();
                      controller.danmakuConfigOptions.danmakuSpeed.refresh();
                    },
                  )),
            ),

            // 右边进度提示
            _rightTipText(
                "${controller.danmakuConfigOptions.danmakuSpeed.value.speed}秒")
          ],
        ));
  }

  /// 弹幕描边设置
  Widget _danmakuStyleStrokeWidthSetting(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 左边文字说明
            _leftDescText("弹幕描边"),

            // 中间进度指示器
            Expanded(
              child: SliderTheme(
                  data: UIConstants.danmakuSliderTheme(context),
                  child: Slider(
                    value: controller.danmakuConfigOptions
                        .danmakuStyleStrokeWidth.value.strokeWidth,
                    min: controller
                        .danmakuConfigOptions.danmakuStyleStrokeWidth.value.min,
                    max: controller
                        .danmakuConfigOptions.danmakuStyleStrokeWidth.value.max,
                    onChanged: (value) {
                      controller.danmakuConfigOptions.danmakuStyleStrokeWidth
                          .value.strokeWidth = value.truncateToDouble();
                      controller.danmakuConfigOptions.danmakuStyleStrokeWidth
                          .refresh();
                    },
                  )),
            ),

            // 右边进度提示
            _rightTipText(
                "${controller.danmakuConfigOptions.danmakuStyleStrokeWidth.value.strokeWidth}")
          ],
        ));
  }

  // 左边描述文字
  Widget _leftDescText(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: UIConstants.textColor, fontSize: UIConstants.textSize),
      strutStyle: const StrutStyle(forceStrutHeight: true),
    );
  }

  // 右边提示文字
  Widget _rightTipText(String text) {
    return Stack(
      children: [
        const Text(
          "占位符",
          style: TextStyle(
              fontSize: UIConstants.textSize,
              color: Color.fromARGB(0, 0, 0, 0)),
        ),
        Text(
          text,
          style: const TextStyle(
              color: UIConstants.textColor, fontSize: UIConstants.textSize),
          strutStyle: const StrutStyle(forceStrutHeight: true),
        )
      ],
    );
  }

  Widget _createTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: BuildTextWidget(
          text: text,
          style: const TextStyle(
              color: UIConstants.textColor,
              fontSize: UIConstants.titleTextSize),
          edgeInsets: const EdgeInsets.all(0)),
    );
  }
}
