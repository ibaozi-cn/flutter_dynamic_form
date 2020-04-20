import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form/src/components/abstract_card_container.dart';

// ignore: must_be_immutable
class CardContainerVertical extends StatelessWidget with MixinContainer {

  CardContainerVertical({
    Key key,
    this.label,
    this.labelAlign,
    this.labelStyle,
    this.labelIconSize,
    this.labelWitch,
    this.content,
    this.rightIcon,
    this.errorText,
    this.visible,
    this.leftIcon,
    this.isRequired = false,
    this.autoValidate = false,
    this.showLine = false,
    this.labelSuffix
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildContainer(context);
  }

  Widget _buildContainer(BuildContext context) {
    return buildContainer(
        context,
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: buildLabelBlock(context),
                ),
                buildRightDecoration()
              ],
            ),
            buildDecoratedContent(context)
          ],
        ));
  }

  @override
  bool autoValidate;

  @override
  Widget content;

  @override
  String errorText;

  @override
  bool isRequired;

  @override
  String label;

  @override
  MainAxisAlignment labelAlign;

  @override
  double labelIconSize;

  @override
  TextStyle labelStyle;

  @override
  Icon leftIcon;

  @override
  Icon rightIcon;

  @override
  bool visible;

  @override
  double labelWitch;

  @override
  bool showLine;

  @override
  Widget labelSuffix;
}
