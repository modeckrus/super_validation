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
  set value(T? value) {
    if (store != null) {
      store!.valueStored = value;
    }
  }

  final SuperValidationStore<T>? store;
  SuperValidationValue({this.store}) {
    if (store != null) {
      value = store!.valueStored;
    }
  }
}

abstract class SuperValidationStore<T> {
  T? get valueStored;
  set valueStored(T? valueStored);
}
