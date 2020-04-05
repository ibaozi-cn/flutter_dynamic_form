import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form/flutter_dynamic_form.dart';

import 'mapper/form_mapper.dart';

typedef OnSubmit(bool isValidator, List<FormItem> itemList);

class FormBuilderWidget extends StatefulWidget {
  final bool showSubmitButton;
  final List<FormItem> itemList;
  final MapperFactory mapperFactory;
  final FormBuilderController formBuilderController;
  final OnSubmit onSubmit;

  FormBuilderWidget(
      {Key key,
      this.showSubmitButton = false,
      this.itemList = const [],
      this.onSubmit,
      @required this.mapperFactory,
      this.formBuilderController})
      : super(key: key);

  @override
  _FormBuilderWidgetState createState() => _FormBuilderWidgetState();
}

class _FormBuilderWidgetState extends State<FormBuilderWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.formBuilderController != null) {
      widget.formBuilderController.validate = validate;
      widget.formBuilderController.reset = reset;
      widget.formBuilderController.save = save;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.itemList.length,
                    itemBuilder: (BuildContext context, int index) {
                      FormItem item = widget.itemList[index];
                      return widget.mapperFactory.mapperWidget(item);
                    }),
              ),
              widget.showSubmitButton
                  ? Container(
                      width: 200,
                      child: RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text('提交'),
                        onPressed: () async {
                          await onPressSubmitButton(context);
                        },
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  onPressSubmitButton(BuildContext context) async {
    if (validate()) {
      save();
      // hide keyboard
      FocusScope.of(context).requestFocus(FocusNode());
      // call on submit function
      if (widget.onSubmit != null) {
        widget.onSubmit(true, widget.itemList);
      }
    } else {
      await widget.onSubmit(false, null);
    }
  }

  // clear the content
  reset() {
    _formKey.currentState.reset();
  }

  save() {
    _formKey.currentState.save();
  }

  bool validate() {
    return _formKey.currentState.validate();
  }
}

typedef void Reset();
typedef void Save();
typedef bool Validate();

class FormBuilderController {
  Reset reset;
  Save save;
  Validate validate;
}
