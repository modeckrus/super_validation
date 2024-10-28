import 'dart:async';

import 'package:meta/meta.dart';

abstract class SuperValidationA {
  Stream<String?> get streamValidation;
  Stream<bool> get streamIsValid;
  String? get validation;
  set validation(String? validation);
  bool get isValid => validation == null;
}

typedef SuperValidationValueFunc<T> = String? Function(T? value);

class SuperValidationValue<T> extends SuperValidationA {
  SuperValidationValueFunc<T>? validateFunc;
  final SuperValidationStore<T>? store;
  SuperValidationValue({
    this.validateFunc,
    this.store,
  }) {
    if (store != null) {
      _streamSubscription = streamValue.listen((value) async {
        await store?.setValueStored(value);
      });
    }
  }

  Future<void> _initStored() async {
    final stored = await store?.getValueStored();
    if (stored != null) {
      value = stored;
    }
  }

  StreamSubscription<T?>? _streamSubscription;

  @mustCallSuper
  Future<void> dispose() async {
    await _streamSubscription?.cancel();
    await validationController.close();
    await valueController.close();
  }

  @override
  String? get validation => internalValidation;
  @override
  set validation(String? value) {
    if (internalValidation == value) {
      return;
    }
    validationController.add(value);
    internalValidation = value;
  }

  @protected
  String? internalValidation;
  @protected
  final StreamController<String?> validationController =
      StreamController<String?>.broadcast();
  @override
  Stream<bool> get streamIsValid =>
      validationController.stream.map((event) => event == null);

  @override
  Stream<String?> get streamValidation => validationController.stream;

  Stream<T?> get streamValue => valueController.stream;
  @protected
  final StreamController<T?> valueController = StreamController<T?>.broadcast();
  @protected
  T? internalValue;

  T? get value => internalValue;

  set value(T? value) {
    if (internalValue == value) {
      return;
    }
    internalValue = value;
    valueController.add(value);
    validation = validateFunc?.call(value);
  }
}

abstract class SuperValidationStore<T> {
  FutureOr<T?> getValueStored();
  FutureOr<void> setValueStored(T? valueStored);
}
