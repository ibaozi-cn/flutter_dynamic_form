import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form/flutter_dynamic_form.dart';

import 'mapper/form_mapper.dart';

typedef Future OnSubmit(List<FormItem> itemList);

class FormBuilderWidget extends StatefulWidget {
  final bool showSubmitButton;
  final List<FormItem> itemList;
  final OnSubmit onSubmit;
  final MapperFactory mapperFactory;

  FormBuilderWidget({
    Key key,
    this.showSubmitButton = false,
    this.itemList = const [],
    this.onSubmit,
    @required this.mapperFactory,
  }) : super(key: key);

  @override
  _FormBuilderWidgetState createState() => _FormBuilderWidgetState();
}

class _FormBuilderWidgetState extends State<FormBuilderWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // hide keyboard
      FocusScope.of(context).requestFocus(FocusNode());
      // call on submit function
      if (widget.onSubmit != null) {
        await widget.onSubmit(widget.itemList);
      }
      // clear the content
      _formKey.currentState.reset();
    } else {
      print("Form is not vaild");
    }
  }
}
