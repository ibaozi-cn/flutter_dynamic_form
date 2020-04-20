import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../flutter_dynamic_form.dart';
import 'card_container_vertical.dart';

// ignore: must_be_immutable
class FieldSingleChoose extends FormField<int> implements CardContainerBean {
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
  Widget labelSuffix;

  @override
  double labelWitch;

  @override
  Icon leftIcon;

  @override
  Icon rightIcon;

  @override
  bool showLine;

  @override
  bool visible;

  final FormFieldSetter<int> onSaved;

  final FormFieldValidator<int> validator;

  final int initialValue;

  final Map<String, String> chooseData;

  final ValueChanged<Map> onChanged;

  FieldSingleChoose(
      {Key key,
      this.autoValidate,
      this.content,
      this.errorText,
      this.isRequired,
      this.label,
      this.labelAlign,
      this.labelIconSize,
      this.labelStyle,
      this.labelSuffix,
      this.labelWitch,
      this.leftIcon,
      this.rightIcon,
      this.showLine,
      this.visible,
      @required this.chooseData,
      this.onSaved,
      this.validator,
      this.onChanged,
      this.initialValue = 0})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (field) {
              return (field as _FieldSingleChooseState)._build(field.context);
            });

  @override
  _FieldSingleChooseState createState() {
    return _FieldSingleChooseState();
  }
}

class _FieldSingleChooseState extends FormFieldState<int> {

  int indexSelect = 0;

  @override
  FieldSingleChoose get widget => super.widget as FieldSingleChoose;

  @override
  void initState() {
    setState(() {
      indexSelect = widget.initialValue;
    });
    super.initState();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      indexSelect = widget.initialValue;
    });
    didChange(indexSelect);
    widget?.onChanged?.call({
      widget.chooseData.keys.elementAt(indexSelect):
      widget.chooseData.values.elementAt(indexSelect)
    });
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
        padding: const EdgeInsets.only(top: 20.0),
        child: Wrap(
          spacing: 15,
          children: List.generate(
              widget.chooseData.length,
              (index) => MaterialButton(
                    elevation: 1,
                    color: indexSelect == index
                        ? Color(0xFFE3F6FE)
                        : Color(0xFFF4F6F9),
                    child: Text(
                      widget.chooseData.values.elementAt(index),
                      style: TextStyle(
                          color: indexSelect == index
                              ? Color(0xFF33A1FF)
                              : Color(0xFF77808A)),
                    ),
                    onPressed: () {
                      didChange(index);
                      setState(() {
                        indexSelect = index;
                      });
                      widget?.onChanged?.call({
                        widget.chooseData.keys.elementAt(index):
                            widget.chooseData.values.elementAt(index)
                      });
                    },
                  )),
        ),
      ),
    );
  }
}
