import 'package:async/async.dart';
import 'package:super_validation/super_validation_a.dart';

class SuperValidationStream<T> {
  final Map<T, SuperValidationA> superValidationMap;
  SuperValidationStream({
    required this.superValidationMap,
  }) {
    superValidationMap.forEach((key, value) {
      if (value.validation != null) {
        if (value.validation?.isNotEmpty ?? false) {
          store[key] = value.validation;
        }
      }
    });
  }
  bool get isValid {
    if (superValidationMap.isEmpty) return true;
    return superValidationMap.values.every((e) => e.isValid);
  }

  Stream<bool> get streamIsValid {
    if (superValidationMap.isEmpty) return Stream.value(true);
    return streamValidation.map((event) {
      bool isValid = true;
      event.forEach((key, value) {
        if (value != null) {
          isValid = false;
        }
      });
      return isValid;
    });
  }

  Map<T, String?> store = {};
  Stream<Map<T, String?>> get streamValidation async* {
    if (superValidationMap.isEmpty) yield {};
    var result = List<Stream<Map<T, String?>>>.empty(growable: true);
    superValidationMap.forEach((key, value) {
      result.add(value.streamValidation.map((e) => {key: e}));
    });
    await for (var state in StreamGroup.merge<Map<T, String?>>(result)) {
      state.forEach((key, value) {
        if (value == null) {
          if (store.containsKey(key)) {
            store.remove(key);
          }
        } else {
          store[key] = value;
        }
      });
      yield store;
    }
  }
}
