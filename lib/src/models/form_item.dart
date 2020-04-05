import 'package:flutter/material.dart';

import '../../flutter_dynamic_form.dart';

class FormItem {
  final Key key;
  String label;
  final WidgetType widgetType;
  final bool required;
  bool visible;
  final String mapKey;
  dynamic mapValue;
  final Map<String, dynamic> extra;
  final FieldValidator validators;

  FormItem(this.key,
      {this.label,
      this.widgetType,
      this.required = false,
      this.mapKey,
      this.extra,
      this.validators,
      this.visible  = true,
      this.mapValue});

  @override
  String toString() {
    return 'FormItem{key: $key, label: $label, widgetType: $widgetType, required: $required, visible: $visible, mapKey: $mapKey, mapValue: $mapValue, extra: $extra, validators: $validators}';
  }


}

enum WidgetType { title, picker, edit, custom }
