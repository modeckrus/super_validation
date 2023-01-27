import 'dart:async';

import 'super_validation_a.dart';

typedef SuperValidationEnumFunc<T> = String? Function(T? value);

class SuperValidationEnum<T> extends SuperValidationValue<T> {
  final SuperValidationEnumFunc<T>? validateFunc;
  SuperValidationEnum({
    this.validateFunc,
    super.store,
  }) {
    if (validateFunc != null) {
      _streamSubscription = streamValue.listen((event) {
        validation = validateFunc!(event);
      });
      validation = validateFunc!(value);
    }
  }
  StreamSubscription<T?>? _streamSubscription;
  @override
  Future<void> dispose() async {
    await _streamSubscription?.cancel();
    await _validationController.close();
    await _valueController.close();
    return super.dispose();
  }

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
  @override
  Stream<T?> get streamValue => _valueController.stream;

  final StreamController<T?> _valueController =
      StreamController<T?>.broadcast();

  T? _value;
  @override
  T? get value => _value;
  @override
  set value(T? value) {
    _value = value;
    _valueController.add(value);
  }
}
