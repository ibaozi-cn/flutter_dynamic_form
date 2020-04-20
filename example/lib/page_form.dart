import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form/flutter_dynamic_form.dart';

// ignore: must_be_immutable
class PageForm extends StatelessWidget {
  GlobalKey<FormState> _formKey = GlobalKey();

  var labelStyle = TextStyle(
    fontSize: 24,
    color: Color(0xFF3E4254),
  );

  var contentTextStyle = TextStyle(fontSize: 16, color: Color(0xFF3E4A59));

  String isValidator(List<String> value) {
    if (value == null) return "is null";
    if (value.isEmpty) return "is Empty";
    if (value[0].length > 6&&value[1].length > 6) return null;
    ///返回null说明校验通过
    return "value <= 6";
  }

  _labelSuffixBuilder(String content) {
    return Text(
      content,
      style: TextStyle(
        fontSize: 16,
        color: Color(0xFF999999),
      ),
    );
  }

  _onSaved(value){
    print("value${value.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        FieldEditorRange(
                          validator: isValidator,
                          label: "总价",
                          onSaved: _onSaved,
                          labelStyle: labelStyle,
                          labelSuffix: _labelSuffixBuilder('(万元)'),
                          fieldEditorRangeBean: FieldEditorRangeBean(
                              TextFieldBean(
                                  initialValue: "0",
                                  onChanged: (value) {
                                    print('value$value');
                                  },
                                  contentTextStyle: contentTextStyle),
                              TextFieldBean(
                                  initialValue: "不限",
                                  contentTextStyle: contentTextStyle)),
                        ),
                        FieldEditorRange(
                          validator: isValidator,
                          label: "单价",
                          onSaved: _onSaved,
                          labelSuffix: _labelSuffixBuilder('(元)'),
                          labelStyle: labelStyle,
                          fieldEditorRangeBean: FieldEditorRangeBean(
                              TextFieldBean(
                                  initialValue: "100",
                                  contentTextStyle: contentTextStyle),
                              TextFieldBean(
                                  initialValue: '200',
                                  contentTextStyle: contentTextStyle)),
                        ),
                        FieldEditorRange(
                          validator: isValidator,
                          label: "面积",
                          labelStyle: labelStyle,
                          labelSuffix: _labelSuffixBuilder('(㎡)'),
                          onSaved: _onSaved,
                          fieldEditorRangeBean: FieldEditorRangeBean(
                              TextFieldBean(
                                  initialValue: '100',
                                  contentTextStyle: contentTextStyle),
                              TextFieldBean(
                                  initialValue: '200',
                                  contentTextStyle: contentTextStyle)),
                        ),
                        FieldSingleChoose(
                          label: '户型',
                          labelStyle: labelStyle,
                          onSaved: _onSaved,
                          chooseData: {
                            "0":"不限",
                            "1":"一居",
                            "2":"二居",
                            "3":"三居",
                            "4":"四居",
                            "5":"五居及以上",
                          },
                        ),
                        FieldSingleChoose(
                          label: '地铁线',
                          labelStyle: labelStyle,
                          onSaved: _onSaved,
                          chooseData: {
                            "1":"一号线",
                            "2":"二号线",
                            "3":"三号线",
                            "4":"四号线",
                            "5":"五号线",
                            "6":"六号线",
                            "7":"七号线",
                            "8":"八号线",
                            "9":"九号线",
                          },
                        ),
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey[300]
                                )
                              ]
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: Colors.white,
                              child: Text('重置',style: TextStyle(
                                color: Color(0xFF999999)
                              ),),
                              onPressed: () {
                                _formKey.currentState.reset();
                              }),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: Color(0xFF33A1FF),
                              child: Text('校验',style: TextStyle(
                                  color: Colors.white
                          )),
                              onPressed: () {
                                if(_formKey.currentState.validate()){
                                  _formKey.currentState.save();
                                }
                              }),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
