import 'package:flutter/cupertino.dart';
import 'package:flutter_dynamic_form/src/validators/fiield_results.dart';

abstract class BaseFormValidators {
  FieldResults validatorData(dynamic data);
}

class DefaultFormValidators extends BaseFormValidators {
  @override
  FieldResults validatorData(data) {
    return FieldResults(isPass: true);
  }
}

class EmailFormValidators extends BaseFormValidators {
  @override
  FieldResults validatorData(data) {
    if (!(data is String)) {
      return FieldResults(isPass: false, error: "data is error in type, please enter string type");
    }
    if (_isEmail(data)) {
      return FieldResults(isPass: true);
    } else {
      return FieldResults(
          isPass: false,
          error: (BuildContext context) {
            showErrors(context, content: 'data is not email');
          });
    }
  }
}

class PasswordMin6CharFormValidators extends BaseFormValidators {
  @override
  FieldResults validatorData(data) {
    if (!(data is String)) {
      return FieldResults(isPass: false, error: "data is error in type, please enter string type");
    }
    if (_passwordMin6Chars(data)) {
      return FieldResults(isPass: true);
    } else {
      return FieldResults(
          isPass: false,
          error: (BuildContext context) {
            showErrors(context, content: 'Illegal password');
          });
    }
  }
}


bool _isEmail(value) {
  final emailRegExp =
      RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
  if (value == null) {
    return false;
  }

  if (value.isEmpty) {
    return false;
  }
  return emailRegExp.hasMatch(value);
}

bool _passwordMin6Chars(String value) {
  if (value == null) {
    return false;
  }
  if (value.isEmpty) {
    return false;
  }
  return value.length >= 6;
}
