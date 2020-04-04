
import 'package:flutter/material.dart';


 class FieldResults{

  bool isPass = false;
  dynamic error;

  FieldResults({this.isPass, this.error});

}

void showErrors(BuildContext context,{String title='Form has validation errors',String content='Please fix all errors before submitting the form.'}) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}