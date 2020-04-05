import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form/flutter_dynamic_form.dart';

List<FormItem> buildFormItemList() {
  List<FormItem> item = [];
  item.add(FormItem(
    GlobalKey<FormState>(),
    widgetType: WidgetType.title,
    label: "登录",
  ));
  item.add(FormItem(GlobalKey<FormState>(),
      widgetType: WidgetType.edit,
      label: "用户名",
      required: true,
      validators: EmailValidator(errorText: "请输入正确的邮箱"),
      mapKey: "userName",
      extra: {'hintText': '请输入用户名'}));

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: '密码不能为空'),
    MinLengthValidator(8, errorText: '密码必须大于8位'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: '密码必须至少有一个特殊字符')
  ]);

  item.add(FormItem(GlobalKey<FormState>(),
      widgetType: WidgetType.edit,
      label: "密码",
      required: true,
      validators: passwordValidator,
      mapKey: "password",
      extra: {'hintText': '请输入密码'}));
  return item;
}
