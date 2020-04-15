import 'package:flutter/material.dart';

abstract class CardContainer {
  String label;
  double labelWitch;
  Widget content;
  bool visible;
  String errorText;
  Icon leftIcon;
  Icon rightIcon;
  bool isRequired;
  MainAxisAlignment labelAlign;
  TextStyle labelStyle;
  double labelIconSize;
  bool autoValidate;

  CardContainer(
      this.label,
      this.labelWitch,
      this.content,
      this.visible,
      this.errorText,
      this.leftIcon,
      this.rightIcon,
      this.isRequired,
      this.labelAlign,
      this.labelStyle,
      this.labelIconSize,
      this.autoValidate);
}

mixin MixinContainer implements CardContainer {
  buildContainer(BuildContext context, Widget child) {
    if (visible) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom:
                BorderSide(width: 1.0, color: Theme.of(context).dividerColor),
          ),
        ),
        padding: EdgeInsets.all(8.0),
        child: child,
      );
    }
    return Container();
  }
  _buildRequiredIndicator(BuildContext context) {
    if (isRequired == null || isRequired == false) return Container();
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

  _buildLabelText(BuildContext context) {
    // make long label to wrap to the second line
    return Flexible(
      child: Text(
        label,
        softWrap: true,
        style: labelStyle ??
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  _buildLeftIcon(BuildContext context) {
    TextStyle labelStyle = Theme.of(context).inputDecorationTheme.labelStyle;
    return (leftIcon == null)
        ? Container()
        : Container(
            child: Icon(
              leftIcon.icon,
              size: labelIconSize ?? 24,
              color: (labelStyle == null) ? null : labelStyle.color,
            ),
          );
  }

  _buildLabelSpacer(BuildContext context) {
    return ((labelAlign ?? TextAlign.left) == TextAlign.right)
        ? Expanded(child: Container())
        : Container();
  }

  buildLabelBlock(BuildContext context) {
    return Container(
      width: labelWitch ?? 100,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildLeftIcon(context),
          _buildLabelSpacer(context),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: labelAlign ?? MainAxisAlignment.start,
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

  buildRightDecoration() {
    return (rightIcon != null)
        ? Container(alignment: Alignment.centerRight, child: rightIcon)
        : Container();
  }

  buildDecoratedContent(BuildContext context) {
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
}
