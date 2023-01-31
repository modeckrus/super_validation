import 'dart:async';

import 'package:meta/meta.dart';

abstract class SuperValidationA {
  Stream<String?> get streamValidation;
  Stream<bool> get streamIsValid;
  String? get validation;
  set validation(String? validation);
  bool get isValid => validation == null;
}

abstract class SuperValidationValue<T> extends SuperValidationA {
  Stream<T?> get streamValue;
  T? get value;
  set value(T? value);

  final SuperValidationStore<T>? store;
  SuperValidationValue({this.store}) {
    if (store != null) {
      value = store!.valueStored;
    }
    _streamSubscription = streamValue.listen((T? value) {
      if (store != null) {
        store!.valueStored = value;
      }
    });
  }
  StreamSubscription<T?>? _streamSubscription;

  @mustCallSuper
  Future<void> dispose() async {
    await _streamSubscription?.cancel();
  }

  void save() {
    if (store != null) {
      store!.valueStored = value;
    }
  }
}

abstract class SuperValidationStore<T> {
  T? get valueStored;
  set valueStored(T? valueStored);
}
