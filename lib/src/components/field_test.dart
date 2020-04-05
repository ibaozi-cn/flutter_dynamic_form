import 'package:flutter/material.dart';

String isValidator(value) {
  if (value == null) return "is null";
  if (value.isEmpty) return "is Empty";
  if (value.length > 6) return null;
  ///返回null说明校验通过
  return "value <= 6";
}

class FieldTest extends FormField {
  final ValueChanged<String> onChanged;

  FieldTest(
      {Key key,
      String initialValue,
      FormFieldSetter<String> onSaved,
      FormFieldValidator<String> validator = isValidator,
      this.onChanged})
      : super(
            key: key,
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            builder: (state) {
              void _handleOnChanged(String _value) {
                if (state.value != _value) {
                  state.didChange(_value);
                  if (onChanged != null) {
                    onChanged(_value);
                  }
                }
              }

              return Container(
                child: Column(
                  children: <Widget>[
                    Text(initialValue??""),
                    TextField(
                      onChanged: _handleOnChanged,
                    )
                  ],
                ),
              );
            });
}
