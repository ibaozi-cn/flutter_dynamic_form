import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form/src/validators/field_validators.dart';

class FormItem {
  final Key key;
  String label;
  final WidgetType widgetType;
  final bool required;
  bool visible;
  final String mapKey;
  dynamic mapValue;
  final Map<String, dynamic> extra;
  final BaseFormValidators validators;

  FormItem(this.key,
      {this.label,
      this.widgetType,
      this.required = false,
      this.mapKey,
      this.extra,
      this.validators,
      this.visible,
      this.mapValue});
}

enum WidgetType { title, picker, edit, custom }
