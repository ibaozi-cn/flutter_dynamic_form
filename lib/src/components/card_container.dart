import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {

  final String label;
  final String unitLabel;
  final Widget content;
  final IconData pickerIcon;
  final double labelWidth;
  final String errorText;
  final bool visible;
  final TextAlign labelAlign;
  final Icon iconLeft;
  final Widget requiredIndicator;

  const CardContainer(
      {Key key,
      this.label,
      this.unitLabel,
      this.content,
      this.pickerIcon,
      this.labelWidth,
      this.errorText,
      this.visible,
      this.labelAlign,
      this.iconLeft,
      this.requiredIndicator})
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildLabelBlock(context),
                Expanded(
                  child: content,
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

  Widget _buildRightDecoration() {
    return (pickerIcon != null || unitLabel != null)
        ? Container(
      alignment: Alignment.centerRight,
      child: (pickerIcon != null)
          ? Icon(pickerIcon)
          : Text(
        unitLabel,
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
    )
        : Container();
  }

  _buildLabelBlock(BuildContext context) {
    return Container(
      width: labelWidth ?? 100.0,
//      color: Colors.cyan,
      child: Row(
        children: <Widget>[
          _buildLeftIcon(context),
          _buildLabelSpacer(context),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _buildLabelText(context),
                _buildRequiredIndicator(context),
              ],
            ),
          ),
          _buildLabelSuffix(context),
        ],
      ),
    );
  }

  Widget _buildLabelSuffix(BuildContext context) {
    return Text(
      unitLabel ?? "",
      style: _buildLabelStyle(context),
    );
  }

  Widget _buildRequiredIndicator(BuildContext context) {
    if (requiredIndicator == null) return Container();
    if (requiredIndicator is Text) {
      var indicatorStyle = (requiredIndicator as Text).style;
      var style = _buildLabelStyle(context).merge(indicatorStyle);

      return Text(
        (requiredIndicator as Text).data,
        style: style,
      );
    }
    return requiredIndicator;
  }

  Widget _buildLabelText(BuildContext context) {
    // make long label to wrap to the second line
    return Flexible(
      child: Text(
        label,
        softWrap: true,
        style: _buildLabelStyle(context),
      ),
    );
  }

  TextStyle _buildLabelStyle(BuildContext context) {
    TextStyle labelStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14.0,
    );

    return labelStyle.merge(Theme.of(context).inputDecorationTheme.labelStyle);
  }

  Widget _buildLeftIcon(BuildContext context) {
    TextStyle labelStyle = Theme.of(context).inputDecorationTheme.labelStyle;
    return (iconLeft == null)
        ? Container()
        : Container(
            margin: EdgeInsets.all(0.0),
            padding: EdgeInsets.only(right: 4.0),
            child: Icon(
              iconLeft.icon,
              color: (labelStyle == null) ? null : labelStyle.color,
            ),
          );
  }

  Widget _buildLabelSpacer(BuildContext context) {
    return ((labelAlign ?? TextAlign.left) == TextAlign.right)
        ? Expanded(child: Container())
        : Container();
  }
}
