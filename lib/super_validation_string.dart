import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'super_validation_a.dart';

typedef ValidationFunc = String? Function(String value);

class SuperValidation extends SuperValidationValue<String> {
  ValidationFunc? validationFunc;

  SuperValidation({
    this.validationFunc,
  });
  @override
  String? get validation => _validation;
  @override
  set validation(String? value) {
    if (_validation == value) {
      return;
    }
    _validation = value;
    _validationController.add(value);
  }

  String? _validation;

  @override
  String? get value => _value;
  String get text => _value ?? '';
  @override
  set value(String? value) {
    if (_value == value) {
      return;
    }
    _value = value;
    _valueController.add(value);
    _textFieldController.add(text);
    validation = validationFunc?.call(text);
  }

  set text(String t) {
    if (t.isEmpty) {
      value = null;
    } else {
      value = t;
    }
  }

  String? _value;

  final StreamController<String?> _validationController =
      StreamController.broadcast();

  final StreamController<String?> _valueController =
      StreamController.broadcast();
  final StreamController<String> _textFieldController =
      StreamController.broadcast();

  @override
  Future<void> dispose() {
    final list = [
      _validationController.close(),
      _valueController.close(),
      _textFieldController.close(),
      super.dispose(),
    ];
    return Future.wait(list);
  }

  @override
  Stream<bool> get streamIsValid =>
      _validationController.stream.map((e) => e == null);

  @override
  Stream<String?> get streamValidation => _validationController.stream;

  @override
  Stream<String?> get streamValue => _valueController.stream;

  Stream<String> get textFieldStream => _textFieldController.stream;

  Stream<String> get stream => _validationController.stream.map((e) => e ?? '');

  void controllerSetText(String controllerText) {
    if (controllerText.isEmpty) {
      if (_value == null) {
        return;
      }
      _value = null;
      _valueController.add(null);
      return;
    }
    if (_value == controllerText) {
      return;
    }
    _value = controllerText;
    _valueController.add(controllerText);
    validation = validationFunc?.call(controllerText);
  }
}
