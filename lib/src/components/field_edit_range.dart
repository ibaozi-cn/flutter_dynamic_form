import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_form/src/components/card_container_vertical.dart';

import 'abstract_card_container.dart';

// ignore: must_be_immutable
class FieldEditorRange extends FormField<List<String>>
    implements CardContainerBean {
  @override
  bool autoValidate;

  @override
  Widget content;

  @override
  String errorText;

  @override
  bool isRequired;

  @override
  String label;

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
  bool visible;

  @override
  bool showLine;

  final FormFieldSetter<List<String>> onSaved;

  final FormFieldValidator<List<String>> validator;

  final FieldEditorRangeBean fieldEditorRangeBean;

  FieldEditorRange({Key key,
    this.onSaved,
    this.validator,
    this.autoValidate,
    this.content,
    this.errorText,
    this.isRequired,
    this.label,
    this.labelAlign,
    this.labelIconSize,
    this.labelStyle,
    this.labelWitch,
    this.leftIcon,
    this.rightIcon,
    this.visible = true,
    this.showLine = false,
    this.labelSuffix,
    this.fieldEditorRangeBean})
      : super(
      key: key,
      initialValue: [
        fieldEditorRangeBean.rangeStart.initialValue,
        fieldEditorRangeBean.rangeEnd.initialValue
      ],
      onSaved: onSaved,
      validator: validator,
      autovalidate: false,
      builder: (field) {
        return (field as _FieldEditRangeState)._build(field.context);
      });

  @override
  _FieldEditRangeState createState() {
    return _FieldEditRangeState();
  }

  @override
  Widget labelSuffix;

}

class _FieldEditRangeState extends FormFieldState<List<String>> {

  TextEditingController _controllerStart;
  TextEditingController _controllerEnd;

  TextEditingController get _effectiveControllerStart =>
      widget.fieldEditorRangeBean.rangeStart.controller ?? _controllerStart;

  TextEditingController get _effectiveControllerEnd =>
      widget.fieldEditorRangeBean.rangeEnd.controller ?? _controllerEnd;

  @override
  FieldEditorRange get widget => super.widget as FieldEditorRange;

  @override
  void initState() {
    super.initState();
    if (widget.fieldEditorRangeBean.rangeStart.controller == null) {
      _controllerStart = TextEditingController(
          text: widget.fieldEditorRangeBean.rangeStart.initialValue);
    } else {
      widget.fieldEditorRangeBean.rangeStart.controller
          .addListener(_handleControllerChangedStart);
    }
    if (widget.fieldEditorRangeBean.rangeEnd.controller == null) {
      _controllerEnd = TextEditingController(
          text: widget.fieldEditorRangeBean.rangeEnd.initialValue);
    } else {
      widget.fieldEditorRangeBean.rangeEnd.controller
          .addListener(_handleControllerChangedEnd);
    }
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveControllerStart.text =
          widget.fieldEditorRangeBean.rangeStart.initialValue;
      _effectiveControllerEnd.text =
          widget.fieldEditorRangeBean.rangeEnd.initialValue;
    });
  }

  @override
  void dispose() {
    widget.fieldEditorRangeBean.rangeStart.controller
        ?.removeListener(_handleControllerChangedStart);
    widget.fieldEditorRangeBean.rangeEnd.controller
        ?.removeListener(_handleControllerChangedEnd);
    super.dispose();
  }

  _build(BuildContext context) {
    return CardContainerVertical(
      label: widget?.label,
      labelWitch: widget?.labelWitch,
      labelAlign: widget?.labelAlign,
      labelIconSize: widget?.labelIconSize,
      labelStyle: widget?.labelStyle,
      leftIcon: widget?.leftIcon,
      autoValidate: widget?.autoValidate,
      visible: widget?.visible ?? true,
      rightIcon: widget?.rightIcon,
      labelSuffix: widget?.labelSuffix,
      content: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildTextField(widget.fieldEditorRangeBean.rangeStart,
                _effectiveControllerStart, _handleOnChangedStart),
            SizedBox(width: 20,),
            Flexible(
              flex: 1,
              child: Container(
                height: 0.5,
                color: Colors.grey,
              ),
            ),
            SizedBox(width: 20,),
            _buildTextField(widget.fieldEditorRangeBean.rangeEnd,
                _effectiveControllerEnd, _handleOnChangedEnd),
          ],
        ),
      ),
    );
  }

  _buildTextField(TextFieldBean textFieldBean,
      TextEditingController textEditingController, Function onChanged) {
    return Flexible(
      flex: 3,
      child: TextField(
        controller: textEditingController,
        onChanged: onChanged,
        decoration: textFieldBean.decoration ??
            InputDecoration(
              border: OutlineInputBorder(),
              errorText: errorText,
              prefixText: textFieldBean.prefixText,
              hintText: textFieldBean.hintText,
              isDense: true,
            ),
        readOnly: textFieldBean.readOnly,
        maxLines: textFieldBean.maxLines,
        minLines: textFieldBean.minLines,
        autofocus: textFieldBean.autoFocus,
        style: textFieldBean.contentTextStyle,
        textAlign: textFieldBean.contentTextAlign ?? TextAlign.start,
        keyboardType: textFieldBean.keyboardType,
        maxLength: textFieldBean.maxLength,
        inputFormatters: textFieldBean?.inputFormatterList ??
            [
              // if we don't want the counter, use this maxLength instead
              LengthLimitingTextInputFormatter(textFieldBean?.maxLength)
            ],
      ),
    );
  }

  @override
  void didUpdateWidget(FieldEditorRange oldWidget) {
    super.didUpdateWidget(oldWidget);
    _didUpdateWidgetStart(oldWidget);
    _didUpdateWidgetEnd(oldWidget);
  }

  _didUpdateWidgetStart(FieldEditorRange oldWidget) {
    if (widget.fieldEditorRangeBean.rangeStart.controller !=
        oldWidget.fieldEditorRangeBean.rangeStart.controller) {
      oldWidget.fieldEditorRangeBean.rangeStart.controller
          ?.removeListener(_handleControllerChangedStart);
      widget.fieldEditorRangeBean.rangeStart.controller
          ?.addListener(_handleControllerChangedStart);

      if (oldWidget.fieldEditorRangeBean.rangeStart.controller != null &&
          widget.fieldEditorRangeBean.rangeStart.controller == null)
        _controllerStart = TextEditingController.fromValue(
            oldWidget.fieldEditorRangeBean.rangeStart.controller.value);
      if (widget.fieldEditorRangeBean.rangeStart.controller != null) {
        value[0] = widget.fieldEditorRangeBean.rangeStart.controller.text;
        setValue(value);
        if (oldWidget.fieldEditorRangeBean.rangeStart.controller == null)
          _controllerStart = null;
      }
    }
  }

  _didUpdateWidgetEnd(FieldEditorRange oldWidget) {
    if (widget.fieldEditorRangeBean.rangeEnd.controller !=
        oldWidget.fieldEditorRangeBean.rangeEnd.controller) {
      oldWidget.fieldEditorRangeBean.rangeEnd.controller
          ?.removeListener(_handleControllerChangedStart);
      widget.fieldEditorRangeBean.rangeEnd.controller
          ?.addListener(_handleControllerChangedStart);
      if (oldWidget.fieldEditorRangeBean.rangeEnd.controller != null &&
          widget.fieldEditorRangeBean.rangeEnd.controller == null)
        _controllerStart = TextEditingController.fromValue(
            oldWidget.fieldEditorRangeBean.rangeEnd.controller.value);
      if (widget.fieldEditorRangeBean.rangeEnd.controller != null) {
        value[0] = widget.fieldEditorRangeBean.rangeEnd.controller.text;
        setValue(value);
        if (oldWidget.fieldEditorRangeBean.rangeEnd.controller == null)
          _controllerStart = null;
      }
    }
  }

  void _handleOnChangedStart(String _value) {
    print("_value$_value");
    if (this.value[0] != _value) {
      this.value[0] = _value;
      print("value${value.toString()}");
      didChange(value);
      if (widget.fieldEditorRangeBean.rangeStart.onChanged != null) {
        widget.fieldEditorRangeBean.rangeStart.onChanged(_value);
      }
    }
  }

  void _handleOnChangedEnd(String _value) {
    if (this.value[1] != _value) {
      this.value[1] = _value;
      didChange(value);
      if (widget.fieldEditorRangeBean.rangeEnd.onChanged != null) {
        widget.fieldEditorRangeBean.rangeEnd.onChanged(_value);
      }
    }
  }

  _handleControllerChangedStart() {
    if (_effectiveControllerStart.text != value[0]) {
      value[0] = _effectiveControllerStart.text;
      didChange(value);
    }
  }

  _handleControllerChangedEnd() {
    if (_effectiveControllerEnd.text != value[1]) {
      value[1] = _effectiveControllerEnd.text;
      didChange(value);
    }
  }
}

class FieldEditorRangeBean {

  TextFieldBean rangeStart;
  TextFieldBean rangeEnd;

  FieldEditorRangeBean(this.rangeStart, this.rangeEnd);

}
