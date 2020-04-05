import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form/src/components/field_edit.dart';
import 'package:flutter_dynamic_form/src/components/field_picker.dart';
import 'package:flutter_dynamic_form/src/components/form_head.dart';
import 'package:flutter_dynamic_form/src/models/form_item.dart';

abstract class MapperFactory {
  Widget mapperWidget(FormItem item);
}

class DefaultMapperFactory extends MapperFactory {

  MapperFactory _mapperFactory;

  DefaultMapperFactory(this._mapperFactory);

  // ignore: missing_return
  Widget mapperWidget(FormItem item) {

    if (!item.visible) return Container();

    if (_mapperFactory != null) {
      return _mapperFactory.mapperWidget(item);
    }

    switch (item.widgetType) {
      case WIDGET_TYPE_HEAD:
        return FormHead(
          item.key,
          title: item.label,
        );
        break;
      case WIDGET_TYPE_PICKER:
        return FieldPicker(
            options: <String>['Earth', 'Unicorn', 'Pegasi', 'Alicorn'],
            values: <String>['E', 'U', 'P', 'A'],
            onSaved: (value) {
              print("picker onSaved value=$value");
              item.mapValue = value;
            });
        break;
      case WIDGET_TYPE_EDIT:
        return FieldEditor(
          key: item.key,
          label: item.label,
          initialValue: "",
          hintText: item.extra['hintText'],
          required: item.required,
          validator: (value) {
            print("required${item.required}");
            if (!item.required) return null;
            String result = item?.validators?.call(value);
            print(result);
            return result;
          },
          onChanged: (value) {
            print("edit onChanged value=$value");
            item.mapValue = value;
          },
          onSaved: (value) {
            print("edit onSaved value=$value");
            item.mapValue = value;
          },
        );
        break;
    }
  }
}
