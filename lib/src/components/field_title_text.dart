import 'package:flutter/material.dart';

class FieldTitleText extends FormField {

  final double width;
  final TextAlign labelAlign;
  final String label;
  final double labelSize;
  final Icon icon;
  final Color bgColor;
  final Color labelColor;
  final EdgeInsetsGeometry padding;

  FieldTitleText(
      Key key,
      {this.width = double.infinity,
      this.labelAlign,
      this.label,
      this.labelSize = 18,
      this.icon,
      this.bgColor = Colors.blue,
      this.labelColor = Colors.white,
      this.padding = const EdgeInsets.all(16)})
      : super(
            key:key,
            builder: (state) {
              return Ink(
                color: bgColor,
                width: width,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: padding,
                    child: Row(
                      children: <Widget>[
                        icon ?? SizedBox(),
                        Text(
                          label,
                          textAlign: labelAlign,
                          style:
                              TextStyle(fontSize: labelSize, color: labelColor),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            initialValue: label);
}
