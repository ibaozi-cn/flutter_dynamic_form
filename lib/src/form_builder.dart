import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form/flutter_dynamic_form.dart';

typedef Future OnSubmit(List<FormItem> itemList);

class FormBuilderWidget extends StatefulWidget {
  final bool showSubmitButton;
  final List<FormItem> itemList;

  final OnSubmit onSubmit;

  const FormBuilderWidget(
      {Key key,
      this.showSubmitButton = false,
      this.itemList = const [],
      this.onSubmit})
      : super(key: key);

  @override
  _FormBuilderWidgetState createState() => _FormBuilderWidgetState();
}

class _FormBuilderWidgetState extends State<FormBuilderWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  // ignore: missing_return
  Widget _buildBody(FormItem item) {
    if (!item.visible) return Container();
    switch (item.widgetType) {
      case WidgetType.title:
        return FieldTitleText(
          item.key,
          label: item.label,
        );
        break;
      case WidgetType.picker:
        return FieldPicker(
            options: <String>['Earth', 'Unicorn', 'Pegasi', 'Alicorn'],
            values: <String>['E', 'U', 'P', 'A'],
            onSaved: (value) {
              print("picker onSaved value=$value");
              item.mapValue = value;
            });
        break;
      case WidgetType.edit:
        return FieldEditor(
          key: item.key,
          label: item.label,
          initialValue: item.label,
          hintText: item.extra['hintText'],
          validator: (value) {
            String result = item.validators.call(value);
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
      case WidgetType.custom:
        return Container(
          height: 50,
          color: Colors.amber,
        );
        break;
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
                      return _buildBody(item);
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
