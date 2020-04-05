# flutter_dynamic_form

A new Flutter package project.

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

# 架构图
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
# 实现一个FormField子类
创建一个FieldTest类
```
import 'package:flutter/material.dart';

class FieldTest extends FormField{

}
```
没有任何提示，也不用实现什么，那怎么办？这个时候就需要点进去看下FormField源码，通过对源码的分析，我们有一个清晰的认识
```
import 'framework.dart';
import 'navigator.dart';
import 'will_pop_scope.dart';

class Form extends StatefulWidget 

class FormState extends State<Form> 

class _FormScope extends InheritedWidget 

typedef FormFieldValidator<T> = String Function(T value);

typedef FormFieldSetter<T> = void Function(T newValue);

typedef FormFieldBuilder<T> = Widget Function(FormFieldState<T> field);

class FormField<T> extends StatefulWidget 

class FormFieldState<T> extends State<FormField<T>> 

```
一共涉及到五个类，三个函数，Form 其实这个类你可以理解为一个ListView的角色，它对FormField负责，管理等。_FormScope是InheritedWidget的子类，用来做数据共享的，从上往下的共享数据，Form的child最终被包装到了_FormScope中。三个函数分别实现了数据校验FormFieldValidator，数据更新FormFieldSetter，构建child widget的FormFieldBuilder，我们拓展的构建的child就是通过FormFieldBuilder函数。我们再仔细看下FormField类，源码如下
```
class FormField<T> extends StatefulWidget {

  /// [builder] 不能为空.
  const FormField({
    Key key,
    @required this.builder,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.autovalidate = false,
    this.enabled = true,
  }) : assert(builder != null),
       super(key: key);

  /// 可选函数，数据保存时回调
  /// [FormState.save].
  final FormFieldSetter<T> onSaved;

  /// 可选函数，用于数据的校验
  final FormFieldValidator<T> validator;

  /// 构建子widget
  final FormFieldBuilder<T> builder;

  /// 可选参数，默认值
  final T initialValue;

  ///是否自动触发校验
  final bool autovalidate;

  /// 控制是否能输入，默认true
  final bool enabled;

  @override
  FormFieldState<T> createState() => FormFieldState<T>();
}

///[FormField]的当前状态。传递给[FormFieldBuilder]方法，用于构造表单字段的小部件。
class FormFieldState<T> extends State<FormField<T>> {
  ///表单数据T
  T _value;
 /// 要显示的错误信息
  String _errorText;

  /// 当前表单的值
  T get value => _value;

  /// 获取当前错误信息
  String get errorText => _errorText;

  /// 判断是否有错误
  bool get hasError => _errorText != null;

  /// 验证数据是否有效
  bool get isValid => widget.validator?.call(_value) == null;

  /// 保存数据，回调onSaved函数，并把数据传递给你
  void save() {
    if (widget.onSaved != null)
      widget.onSaved(value);
  }

  /// 重置数据
  void reset() {
    setState(() {
      _value = widget.initialValue;
      _errorText = null;
    });
  }

  /// 校验数据，主动验证，并刷新UI
  bool validate() {
    setState(() {
      _validate();
    });
    return !hasError;
  }
  /// 刷新错误信息
  void _validate() {
    if (widget.validator != null)
      _errorText = widget.validator(_value);
  }

  /// 更新当前页面数据
  void didChange(T value) {
    setState(() {
      _value = value;
    });
    ///当窗体字段更改时调用。通知所有表单字段要重新生成，如果有连动的效果，就显现出来了。
    Form.of(context)?._fieldDidChange();
  }

  /// 此方法只能由需要更新的子类调用，说了很长意思是，不然你通过它更新数据，应该调用didChange来设置数据。
  @protected
  void setValue(T value) {
    _value = value;
  }

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  void deactivate() {
    /// 这里发现了当前Form注销掉了当前state的
    Form.of(context)?._unregister(this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    // Only autovalidate if the widget is also enabled
    if (widget.autovalidate && widget.enabled)
      _validate();
    /// 注册引用
    Form.of(context)?._register(this);
    return widget.builder(this);
  }
}
```
请先看注释，通过FormField构造，我们了解到，它最主要就是抽象了对数据T的初始化，校验，通知其他人我更新了，重置，保存等一系列的操作，我们应该关心的就是，如何validate，如何didChange，然后如何save数据对吧，这样我们就可以自己实现了，那么我们接下来就要开始实现了
```
class FieldTest extends FormField {
  FieldTest(
      {Key key,
      String initialValue,
      FormFieldSetter<String> onSaved,
      FormFieldValidator<String> validator,})
      : super(
            key: key,
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            builder: (state) {
              return Container(
                child: Text(initialValue),
              );
            });
}
```
一个没什么交互的简版实现了，没有交互那岂不是扯的吗，表单输入怎么也得有个输入框吧，哈哈，好我们接着实现。
```
class FieldTest extends FormField {
  final ValueChanged<String> onChanged;
  FieldTest(
      {Key key,
      String initialValue,
      FormFieldSetter<String> onSaved,
      FormFieldValidator<String> validator,
      this.onChanged})
      : super(
            key: key,
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            builder: (state) {
              return Container(
                child: Column(
                  children: <Widget>[
                    Text(initialValue),
                    TextField(
                      onChanged: onChanged,
                    )
                  ],
                ),
              );
            });
}
```
这次加了一个onChanged，用来监听输入框的更新，然后给父类的value赋值，然后触发相应的操作，比如校验什么的。
```
 builder: (state) {

              void _handleOnChanged(String _value) {
                if (state.value != _value) {
                  state.didChange(_value);
                  if (onChanged != null) {
                    onChanged(_value);
                  }
                }
              }
              
              return Container(
                child: Column(
                  children: <Widget>[
                    Text(initialValue),
                    TextField(
                      onChanged: _handleOnChanged,
                    )
                  ],
                ),
              );
            }
```
在builder 函数中添加一个_handleOnChanged函数，用来接管输入框的值，并更新到value上。这里解释下为什么，看FormFieldState源码应该知道，所有校验，重置，保存的操作都是T _value;这个变量，所以在输入框的实现中，我们肯定是对输入的内容做校验或者其他操作，所以这里要去更加输入的内容来更新_value的值，而更新的办法就是通过state.didChange函数。
下面来实现一个校验规则
```
String isValidator(value) {
  if (value == null) return "is null";
  if (value.isEmpty) return "is Empty";
  if (value.length > 6) return null;
  ///返回null说明校验通过
  return "value <= 6";
}
```
然后传递给它
```
FieldTest(
      {Key key,
      String initialValue,
      FormFieldSetter<String> onSaved,
      FormFieldValidator<String> validator = isValidator, /// 这里
      this.onChanged})
```
这样我们的校验规则有了，我们可以试下ok不，把组件加载到Page内
```
 Form(
                key: _formKey,
                child: FieldTest(
                  onChanged: (value) {
                    print("FieldTest onChanged value$value");
                  },
                ),
              ),
              RaisedButton(
                onPressed: (){
                  if(_formKey.currentState.validate()){
                    print("FieldTest验证通过");
                  }else{
                    print("FieldTest验证失败");
                  }
                },
                child: Text("校验FieldTest"),
              ),
```
嵌套在Form内，然后通过_formKey可以做管理，如validate()校验数据
![](https://upload-images.jianshu.io/upload_images/2413316-7375c68580685525.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
输入23
![](https://upload-images.jianshu.io/upload_images/2413316-327c0705cc85309e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
控制台对应输出，校验一下，点击按钮打印
![](https://upload-images.jianshu.io/upload_images/2413316-3ac1f10a29744e76.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![](https://upload-images.jianshu.io/upload_images/2413316-f62fdbe4ae4a7872.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
当我们再次输入超过校验规则的数据时，验证通过，其实就是这么的简单就实现了。在理解的基础上可以拓展更多的操作，比如显示错误信息，数据格式化，数据自动映射等等操作。接下来我们要做的就是对整个框架的拓展，拓展更多的FormField。
# 总结
动态表单在实际的业务开发中，有相当多的业务场景，特别是针对ToB的业务，表单的提交，校验就更别说了，太多，太复杂了，但如果说能有一个合适框架来完成那些本来就很简单但充斥着大量重复的操作，能有效的解决问题，何乐而不为呢。
项目源码：[https://github.com/ibaozi-cn/flutter_dynamic_form](https://github.com/ibaozi-cn/flutter_dynamic_form)
# 感谢大佬们的项目和文章
[sirily11](https://github.com/sirily11)/**[json-textfrom](https://github.com/sirily11/json-textfrom)**
 [codegrue](https://github.com/codegrue)/**[card_settings](https://github.com/codegrue/card_settings)**
[https://medium.com/flutter-community/flutter-how-to-validate-fields-dynamically-created-40cafca5c3cb](https://medium.com/flutter-community/flutter-how-to-validate-fields-dynamically-created-40cafca5c3cb)
[https://stackoverflow.com/questions/55463981/whats-the-best-way-to-dynamically-load-form-fields-in-flutter](https://stackoverflow.com/questions/55463981/whats-the-best-way-to-dynamically-load-form-fields-in-flutter)
[https://book.flutterchina.club/chapter7/inherited_widget.html](https://book.flutterchina.club/chapter7/inherited_widget.html)




