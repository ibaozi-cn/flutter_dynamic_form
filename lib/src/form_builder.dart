import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form/flutter_dynamic_form.dart';

typedef Future OnSubmit(List<FormItem> itemList);

class FormBuilderWidget extends StatefulWidget {
  final bool showSubmitButton;
  final List<FormItem> itemList;
  final Map<String, dynamic> values;
  final OnSubmit onSubmit;

  const FormBuilderWidget({Key key,
    this.showSubmitButton,
    this.itemList,
    this.values,
    this.onSubmit})
      : super(key: key);

  @override
  _FormBuilderWidgetState createState() => _FormBuilderWidgetState();
}

class _FormBuilderWidgetState extends State<FormBuilderWidget> {

  final _formKey = GlobalKey<FormState>();

  List<FormItem> itemList = [];

  @override
  void initState() {
    super.initState();
  }

  Widget _buildBody(FormItem item) {
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
          label: "Editor",
          initialValue: item.label,
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
              Expanded(
                child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      FormItem item = itemList[index];
                      return _buildBody(item);
                    }),
              ),
              widget.showSubmitButton ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: 300,
                      height: 40,
                      child: RaisedButton(
                        color: Theme.of(context).buttonColor,
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .title
                                  .color),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            new BorderRadius.circular(30.0)),
                        onPressed: () async {
                          await onPressSubmitButton(context);
                        },
                      ),
                    ),
                  ),
                ],
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
        await widget.onSubmit(itemList);
      }
      // clear the content
      _formKey.currentState.reset();
    } else {
      print("Form is not vaild");
    }
  }

}
