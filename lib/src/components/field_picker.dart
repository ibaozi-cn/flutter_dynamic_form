import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form/src/components/card_container.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

class FieldPicker extends FormField<String> {

  final ValueChanged<String> onChanged;

  final String label;

  final TextAlign labelAlign;

  final TextAlign contentAlign;

  final String hintText;

  final Icon icon;

  final Widget requiredIndicator;

  final List<String> options;

  final List<String> values;

  final bool visible;

  final bool autoValidate;

  FieldPicker({
    Key key,
    String initialValue,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    this.label = 'Label',
    this.visible = true,
    this.onChanged,
    this.labelAlign,
    this.icon,
    this.contentAlign,
    this.requiredIndicator,
    this.hintText,
    this.options,
    this.values,
    this.autoValidate
  })  : assert(values == null || options.length == values.length,
            "If you provide 'values', they need the same number as 'options'"),
        super(
            key: key,
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            autovalidate: autoValidate,
            builder: (field) {
              return (field as _FieldPickerState)._build(field.context);
            });

  @override
  _FieldPickerState createState() {
    return _FieldPickerState();
  }
}

class _FieldPickerState extends FormFieldState<String> {
  @override
  FieldPicker get widget => super.widget as FieldPicker;

  List<String> values;
  List<String> options;

  void _showDialog(String label) {
    int optionIndex = values.indexOf(value);
    String option;
    if (optionIndex >= 0) {
      option = options[optionIndex];
    } else {
      optionIndex = 0; // set to first element in the list
    }
    _showMaterialScrollPicker(label, option);
  }

  void _showMaterialScrollPicker(String label, String option) {
    showMaterialScrollPicker(
      context: context,
      title: label,
      items: options,
      selectedItem: option,
      onChanged: (option) {
        if (option != null) {
          int optionIndex = options.indexOf(option);
          String value = values[optionIndex];
          didChange(value);
          if (widget.onChanged != null) widget.onChanged(value);
        }
      },
    );
  }

  Widget _build(BuildContext context) {
    // make local mutable copies of values and options
    options = widget.options;
    if (widget.values == null) {
      // if values are not provided, copy the options over and use those
      values = widget.options;
    } else {
      values = widget.values;
    }

    // get the content label from options based on value
    int optionIndex = values.indexOf(value);
    String content = widget?.hintText ?? '';
    if (optionIndex >= 0) {
      content = options[optionIndex];
    }
    return GestureDetector(
      onTap: () {
        _showDialog(widget?.label);
      },
      child: CardContainer(
        label: widget?.label,
        visible: widget?.visible,
        leftIcon: widget?.icon,
        requiredIndicator: widget?.requiredIndicator,
        errorText: errorText,
        content: Text(
          content,
          textAlign:
              widget?.contentAlign,
        ),
        rightIcon: Icon(Icons.arrow_drop_down),
      ),
    );
  }
}
