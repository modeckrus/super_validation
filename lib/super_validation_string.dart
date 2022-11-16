import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'super_validation_a.dart';

typedef ValidationFunc = String? Function(String value);

class SuperValidation extends SuperValidationA {
  @protected
  String internalText = '';

  ValidationFunc? validationFunc;
  final String initalText;

  SuperValidation({this.validationFunc, this.initalText = ''}) {
    if (validationFunc == null) {
      return;
    }
    validation = validationFunc?.call(initalText);
  }

  @override
  String? get validation => internalValidation;
  @protected
  String? internalValidation;
  @override
  set validation(String? value) {
    internalValidation = value;
    internalController
        .add(SuperValidationHelper(text: internalText, validation: validation));
  }

  @protected
  final StreamController<String> internalTextFieldController =
      StreamController<String>.broadcast();
  Stream<String> get textFieldStream => internalTextFieldController.stream;
  @protected
  late final StreamController<SuperValidationHelper> internalController =
      StreamController.broadcast()
        ..add(SuperValidationHelper(
            text: initalText, validation: validationFunc?.call(initalText)));
  Stream<String> get stream =>
      internalController.stream.map((event) => event.text);
  @override
  Stream<String?> get streamValidation =>
      internalController.stream.distinct().map((event) => event.validation);
  @override
  Stream<bool> get streamIsValid => internalController.stream
      .distinct()
      .map((event) => event.validation == null);

  Future<void> dispose() async {
    await internalController.close();
  }

  @protected
  void controllerSetText(String text) {
    internalText = text;
    internalValidation = validationFunc?.call(text);
    internalController
        .add(SuperValidationHelper(text: text, validation: validation));
  }

  set text(String text) {
    internalText = text;
    internalValidation = validationFunc?.call(text);
    internalTextFieldController.add(text);
  }

  String get text => internalText;
}

class SuperValidationHelper extends Equatable {
  final String text;
  final String? validation;
  const SuperValidationHelper({
    required this.text,
    this.validation,
  });

  @override
  List<Object?> get props => [text, validation];
}
