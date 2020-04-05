import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_form/src/components/card_container.dart';

class FieldEditor extends FormField<String> {

  final ValueChanged<String> onChanged;
  final String label;
  final TextAlign labelAlign;
  final TextAlign contentAlign;
  final String hintText;
  final Icon icon;
  final Widget requiredIndicator;
  final bool visible;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextStyle style;
  final TextAlign textAlign;
  final bool autofocus;
  final bool readOnly;
  final int maxLines;
  final int minLines;
  final int maxLength;
  final String prefixText;
  final List<TextInputFormatter> inputFormatters;

  FieldEditor({
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
    this.prefixText,
    this.decoration,
    this.keyboardType,
    this.style,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
  }) : super(
            key: key,
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            autovalidate: false,
            builder: (field) {
              return (field as _FieldEditorState)._build(field.context);
            });

  @override
  _FieldEditorState createState() {
    return _FieldEditorState();
  }
}

class _FieldEditorState extends FormFieldState<String> {
  @override
  FieldEditor get widget => super.widget as FieldEditor;

  void _handleOnChanged(String _value) {
    if (this.value != _value) {
      didChange(_value);
      if (widget.onChanged != null) {
        widget.onChanged(_value);
      }
    }
  }

  Widget _build(BuildContext context) {
    // make local mutable copies of values and options
    return GestureDetector(
      onTap: () {

      },
      child: CardContainer(
        label: widget?.label,
        labelAlign: widget?.labelAlign ?? TextAlign.start,
        visible: widget?.visible,
        iconLeft: widget?.icon,
        requiredIndicator: widget?.requiredIndicator,
        errorText: errorText,
        content: TextField(
            onChanged: _handleOnChanged,
            decoration: widget.decoration ?? InputDecoration(
              contentPadding: EdgeInsets.all(8.0),
              border: InputBorder.none,
              errorText: errorText,
              prefixText: widget?.prefixText,
              hintText: widget?.hintText,
              isDense: true,
            ),
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            autofocus: widget.autofocus,
            style: widget.style,
            textAlign: widget?.contentAlign ?? TextAlign.start,
            keyboardType: widget.keyboardType,
            maxLength: widget.maxLength,
            inputFormatters: widget?.inputFormatters ??
                [
                  // if we don't want the counter, use this maxLength instead
                  LengthLimitingTextInputFormatter(widget?.maxLength)
                ],
        ),
//        pickerIcon: Icons.arrow_drop_down,
      ),
    );
  }
}
