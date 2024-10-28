import 'dart:async';

import 'super_validation_a.dart';

class SuperValidation extends SuperValidationValue<String> {
  SuperValidation({super.validateFunc, super.store});

  String get text => internalValue ?? '';
  @override
  set value(String? value) {
    if (internalValue == value) {
      return;
    }
    internalValue = value;
    valueController.add(value);
    _textFieldController.add(text);
    validation = validateFunc?.call(text);
  }

  set text(String t) {
    if (t.isEmpty) {
      value = null;
    } else {
      value = t;
    }
  }

  @override
  Future<void> dispose() {
    final list = [
      _textFieldController.close(),
      super.dispose(),
    ];
    return Future.wait(list);
  }

  final StreamController<String> _textFieldController =
      StreamController.broadcast();

  Stream<String> get textFieldStream => _textFieldController.stream;

  Stream<String> get stream => valueController.stream.map((e) => e ?? '');

  void controllerSetText(String controllerText) {
    if (internalValue == controllerText) {
      return;
    }
    if (controllerText.isEmpty) {
      final i = internalValue;
      if (i == null || i.isEmpty) {
        return;
      }
      internalValue = null;
      valueController.add(null);
      validation = validateFunc?.call(controllerText);
      return;
    }

    internalValue = controllerText;
    valueController.add(controllerText);
    validation = validateFunc?.call(controllerText);
  }
}
