# flutter_dynamic_form
⚡️动态表单在实际的业务开发中，有相当多的业务场景，特别是针对ToB的业务，表单的提交，校验就更别说了，越来越多，越来越复杂，如果说能有一个合适框架来减少那些本来就很简单但充斥着大量重复的操作，同样也可以解决那些复杂的操作，何乐而不为呢。

# Architecture
![image](https://github.com/ibaozi-cn/flutter_dynamic_form/raw/master/img/arc.webp)
用了几年前设计的Table架构图，是kotlin版本的动态表单框架，也同样适用于现在的设计，这次从设计到实现，其实经历了很多，前期看官方文档FormField的用法，还有一些现有的动态表单框架，一开始选择用一般的StatefulWidget实现，但做了几个发现一个问题，各个Widget的状态管理，数据的变化，或者说统一的验证提交等操作，需要太多的实现，未来简化实现，最终还是选择用FormField，拓展它的子类来更好的管理表单。请仔细看图，我来解释下。
整个架构图分两个部分
- 第一部分展示的是这次框架的主角FormBuilder在Page页面中的位置，以及基本的属性定义

  **formController** 是对表单统一管理的抽象，可以对表单做验证validator，重置所有表单状态reset，保存save等，未来根据需求再拓展

  **showSubmitButton** 显示提交按钮，有自己的提交按钮可以设置false隐藏

  **onSubmit** 数据校验后的callBack回调，返回数据验证结果

  **mapperFactory** 这个是FormField动态扩展的关键，通过它就是让其他人动态实现一个自己的FormField，用来满足特殊的业务需求。

  **itemList** 这个是mapperFactory将业务数据集合FormItem转换成对应的Widget集合，最终显示的当前页面。

- 第二部分展示了一个动态表单的业务流程，从服务器下发数据，到映射成对应的FormItemList，再由MapperFactory转换成对应的Widget，最终交给FormBuilder，再由FormBuilder生成一个Form，通过一个ListView动态的展示所有的FormField，并通过FieldValidator的抽象实现来做最终的数据校验，这是大致的流程。
希望两种表达，能让你对整个框架有一个清晰的认识，接下来我们就聊一下，如何拓展一个FormField，这样你就能从源头了解到该框架。
## Getting Started
Step 1
```
///prepare data
List<FormItem> buildFormItemList() {
  List<FormItem> item = [];
  item.add(FormItem(
    GlobalKey<FormState>(),
    widgetType: WIDGET_TYPE_HEAD,
    label: "登录",
  ));
  item.add(FormItem(GlobalKey<FormState>(),
      widgetType: WIDGET_TYPE_EDIT,
      label: "用户名",
      required: false,
      validators: EmailValidator(errorText: "请输入正确的邮箱"),
      mapKey: "userName",
      extra: {'hintText': '请输入用户名'}));

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: '密码不能为空'),
    MinLengthValidator(8, errorText: '密码必须大于8位'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: '密码必须至少有一个特殊字符')
  ]);

  item.add(FormItem(GlobalKey<FormState>(),
      widgetType: WIDGET_TYPE_EDIT,
      label: "密码",
      required: true,
      validators: passwordValidator,
      mapKey: "password",
      extra: {'hintText': '请输入密码'}));
  return item;
}

```
Step 2
```
  /// new FormBuilderController
  FormBuilderController _builderController = FormBuilderController();
  /// get data
  List<FormItem> _formList = buildFormItemList();

  /// in your page add this widget
            FormBuilderWidget(
                showSubmitButton: true,
                itemList: _formList,
                formBuilderController: _builderController,
                onSubmit: (bool, data) async {
                  if (bool) print(data.toString());
                },
                mapperFactory: DefaultMapperFactory(null),
              )
```
## Ui and validator result

![image](https://github.com/ibaozi-cn/flutter_dynamic_form/raw/master/img/login.jpg)

![image](https://github.com/ibaozi-cn/flutter_dynamic_form/raw/master/img/validator_empty.jpg)

![image](https://github.com/ibaozi-cn/flutter_dynamic_form/raw/master/img/validator_min.jpg)

## Blog 

https://www.jianshu.com/p/42759cd7eba5

## Thanks
[sirily11](https://github.com/sirily11)/**[json-textfrom](https://github.com/sirily11/json-textfrom)**

[codegrue](https://github.com/codegrue)/**[card_settings](https://github.com/codegrue/card_settings)**

[https://medium.com/flutter-community/flutter-how-to-validate-fields-dynamically-created-40cafca5c3cb](https://medium.com/flutter-community/flutter-how-to-validate-fields-dynamically-created-40cafca5c3cb)

[https://stackoverflow.com/questions/55463981/whats-the-best-way-to-dynamically-load-form-fields-in-flutter](https://stackoverflow.com/questions/55463981/whats-the-best-way-to-dynamically-load-form-fields-in-flutter)

[https://book.flutterchina.club/chapter7/inherited_widget.html](https://book.flutterchina.club/chapter7/inherited_widget.html)




