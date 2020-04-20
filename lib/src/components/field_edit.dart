import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_form/src/components/card_container_horizontal.dart';
import 'package:flutter_dynamic_form/src/components/card_container_vertical.dart';

import 'abstract_card_container.dart';

// ignore: must_be_immutable
class FieldEditor extends FormField<String>
    implements CardContainerBean, TextFieldBean {
  FieldEditor(
      {Key key,
      this.onSaved,
      this.validator,
      this.initialValue,
      this.label = 'Label',
      this.visible = true,
      this.onChanged,
      this.leftIcon,
      this.hintText,
      this.prefixText,
      this.decoration,
      this.keyboardType,
      this.autoFocus = false,
      this.readOnly = false,
      this.maxLines = 1,
      this.minLines,
      this.maxLength,
      this.inputFormatterList,
      this.isRequired,
      this.contentTextAlign = TextAlign.start,
      this.contentTextStyle =
          const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      this.controller,
        this.labelSuffix,
      this.showLine})
      : super(
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

  @override
  bool autoValidate;

  @override
  Widget content;

  @override
  String errorText;

  @override
  bool isRequired;

  @override
  MainAxisAlignment labelAlign;

  @override
  double labelIconSize;

  @override
  TextStyle labelStyle;

  @override
  double labelWitch;

  @override
  Icon leftIcon;

  @override
  Icon rightIcon;

  @override
  String label;

  @override
  bool visible;

  @override
  bool autoFocus;

  @override
  TextAlign contentTextAlign;

  @override
  TextStyle contentTextStyle;

  @override
  TextEditingController controller;

  @override
  InputDecoration decoration;

  @override
  String hintText;

  @override
  List<TextInputFormatter> inputFormatterList;

  @override
  TextInputType keyboardType;

  @override
  int maxLength;

  @override
  int maxLines;

  @override
  int minLines;

  @override
  var onChanged;

  @override
  String prefixText;

  @override
  bool readOnly;

  @override
  String initialValue;

  @override
  FormFieldSetter<String> onSaved;

  @override
  FormFieldValidator<String> validator;

  @override
  bool showLine;

  @override
  Widget labelSuffix;
}

class _FieldEditorState extends FormFieldState<String> {
  TextEditingController _controller;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  @override
  FieldEditor get widget => super.widget as FieldEditor;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController.text = widget.initialValue;
    });
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(FieldEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller.value);
      if (widget.controller != null) {
        setValue(widget.controller.text);
        if (oldWidget.controller == null) _controller = null;
      }
    }
  }

  void _handleControllerChanged() {
    if (_effectiveController.text != value) {
      didChange(_effectiveController.text);
    }
  }

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
    return CardContainerHorizontal(
      label: widget?.label,
      visible: widget?.visible,
      leftIcon: widget?.leftIcon,
      errorText: errorText,
      isRequired: widget?.isRequired,
      content: TextField(
        controller: _effectiveController,
        onChanged: _handleOnChanged,
        decoration: widget.decoration ??
            InputDecoration(
              border: InputBorder.none,
              errorText: errorText,
              prefixText: widget?.prefixText,
              hintText: widget?.hintText,
              isDense: true,
            ),
        readOnly: widget.readOnly,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        autofocus: widget.autoFocus,
        style: widget.contentTextStyle,
        textAlign: widget.contentTextAlign ?? TextAlign.start,
        keyboardType: widget.keyboardType,
        maxLength: widget.maxLength,
        inputFormatters: widget?.inputFormatterList ??
            [
              // if we don't want the counter, use this maxLength instead
              LengthLimitingTextInputFormatter(widget?.maxLength)
            ],
      ),
//        pickerIcon: Icons.arrow_drop_down,
    );
  }
}
