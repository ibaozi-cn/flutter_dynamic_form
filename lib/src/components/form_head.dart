import 'package:flutter/material.dart';

class FormHead extends FormField {

  final TextAlign titleAlign;
  final String title;
  final TextStyle titleStyle;
  final Icon icon;
  final Color bgColor;
  final EdgeInsetsGeometry padding;

  FormHead(Key key,
      {this.titleAlign,
      this.title,
      this.titleStyle =const TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      this.icon,
      this.bgColor = Colors.blue,
      this.padding = const EdgeInsets.only(left: 8,top: 16,bottom: 16)})
      : super(
            key: key,
            builder: (state) {
              return Ink(
                color: bgColor,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: padding,
                    child: Row(
                      children: <Widget>[
                        icon ?? SizedBox(),
                        Text(
                          title,
                          textAlign: titleAlign,
                          style: titleStyle,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            initialValue: title);
}
