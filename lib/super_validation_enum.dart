import 'dart:async';

import 'super_validation_a.dart';

class SuperValidationEnum<T> extends SuperValidationA {
  @override
  String? get validation => _validation;
  @override
  set validation(String? value) {
    _validationController.add(value);
    _validation = value;
  }

  String? _validation;

  final StreamController<String?> _validationController =
      StreamController<String?>.broadcast();
  @override
  Stream<bool> get streamIsValid =>
      _validationController.stream.map((event) => event == null);

  @override
  Stream<String?> get streamValidation => _validationController.stream;

  Stream<T?> get streamValue => _valueController.stream;

  final StreamController<T?> _valueController =
      StreamController<T?>.broadcast();

  T? _value;

  T? get value => _value;

  set value(T? value) {
    _value = value;
    _valueController.add(value);
  }
}
