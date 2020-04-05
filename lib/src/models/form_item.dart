import 'package:flutter/material.dart';

import '../../flutter_dynamic_form.dart';

class FormItem {

  Key key;
  String label;
  String widgetType;
  bool required;
  bool visible;
  String mapKey;
  dynamic mapValue;
  Map<String, dynamic> extra;
  FieldValidator validators;

  FormItem(this.key,
      {this.label,
      this.widgetType,
      this.required = false,
      this.mapKey,
      this.extra,
      this.validators,
      this.visible = true,
      this.mapValue,});

  @override
  String toString() {
    return 'FormItem{key: $key, label: $label, widgetType: $widgetType, required: $required, visible: $visible, mapKey: $mapKey, mapValue: $mapValue, extra: $extra, validators: $validators}';
  }
}

const WIDGET_TYPE_HEAD = "widget_type_head_form";
const WIDGET_TYPE_PICKER = "widget_type_picker_form";
const WIDGET_TYPE_EDIT = "widget_type_edit_from";

