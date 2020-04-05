import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CardContainer extends StatelessWidget {

  final Icon leftIcon;
  final String label;
  final double labelWidth;
  final Widget content;
  final Icon rightIcon;
  final String errorText;
  final bool visible;
  final Widget requiredIndicator;
  final bool required;

  MainAxisAlignment labelAlign = MainAxisAlignment.start;
  TextStyle labelStyle =
  TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  double labelIconSize = 24;

  bool autoValidate = false;

   CardContainer(
      {Key key,
      this.label,
      this.content,
      this.rightIcon,
      this.labelWidth,
      this.errorText,
      this.visible,
      this.leftIcon,
      this.requiredIndicator,
      this.required = false,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (visible) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom:
                BorderSide(width: 1.0, color: Theme.of(context).dividerColor),
          ),
        ),
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildLabelBlock(context),
                Expanded(
                  child: _buildDecoratedContent(context),
                ),
                _buildRightDecoration()
              ],
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildDecoratedContent(BuildContext context) {
    var decoratedContent = content;
    if (content is TextField || content is TextFormField) {
      // do nothing, these already have built in InputDecorations
    } else {
      // wrap in a decorator to show validation errors
      final InputDecoration decoration = const InputDecoration()
          .applyDefaults(Theme.of(context).inputDecorationTheme)
          .copyWith(
              errorText: errorText,
              contentPadding: EdgeInsets.all(0.0),
              isDense: true,
              border: InputBorder.none);

      decoratedContent = InputDecorator(decoration: decoration, child: content);
    }

    return decoratedContent;
  }

  Widget _buildRightDecoration() {
    return (rightIcon != null)
        ? Container(alignment: Alignment.centerRight, child: rightIcon)
        : Container();
  }

  _buildLabelBlock(BuildContext context) {
    return Container(
      width: labelWidth ?? 100.0,
      height: 40,
      child: Row(
        children: <Widget>[
          _buildLeftIcon(context),
          _buildLabelSpacer(context),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: labelAlign,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _buildLabelText(context),
                  _buildRequiredIndicator(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelText(BuildContext context) {
    // make long label to wrap to the second line
    return Flexible(
      child: Text(
        label,
        softWrap: true,
        style: labelStyle,
      ),
    );
  }

  Widget _buildLeftIcon(BuildContext context) {
    TextStyle labelStyle = Theme.of(context).inputDecorationTheme.labelStyle;
    return (leftIcon == null)
        ? Container()
        : Container(
            child: Icon(
              leftIcon.icon,
              size: labelIconSize,
              color: (labelStyle == null) ? null : labelStyle.color,
            ),
          );
  }

  Widget _buildLabelSpacer(BuildContext context) {
    return ((labelAlign ?? TextAlign.left) == TextAlign.right)
        ? Expanded(child: Container())
        : Container();
  }

  _buildRequiredIndicator(BuildContext context) {
    if (required == null || !required) return Container();
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "*",
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
