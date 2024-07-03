// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';

import 'package:super_validation/super_validation.dart';

class SuperLoading extends SuperValidationA {
  final String? validationText;
  SuperLoading({
    this.validationText,
  });
  @override
  String? get validation => _validation;
  @override
  set validation(String? value) {
    if (_validation == value) return;
    _validationController.add(value);
    _validation = value;
  }

  Future<void> dispose() async {
    await _validationController.close();
    await _valueController.close();
  }

  String? _validation;

  final StreamController<String?> _validationController =
      StreamController<String?>.broadcast();
  @override
  Stream<bool> get streamIsValid =>
      _validationController.stream.map((event) => event == null);

  @override
  Stream<String?> get streamValidation => _validationController.stream;

  Stream<bool> get streamValue => _valueController.stream;

  final StreamController<bool> _valueController =
      StreamController<bool>.broadcast();

  bool _value = true;

  bool get value => _value;

  set value(bool value) {
    if (_value == value) return;
    _value = value;
    _valueController.add(value);
  }

  void loading() {
    value = true;
  }

  void loaded() {
    value = false;
  }
}
