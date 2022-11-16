import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'super_validation_a.dart';

typedef ValidationFunc = String? Function(String value);

class SuperValidation extends SuperValidationA {
  String _text = '';

  ValidationFunc? validationFunc;
  final String initalText;

  SuperValidation({this.validationFunc, this.initalText = ''}) {
    if (validationFunc == null) {
      return;
    }
    validation = validationFunc?.call(initalText);
  }

  @override
  String? get validation => _validation;
  String? _validation;
  @override
  set validation(String? value) {
    _validation = value;
    _controller.add(SuperValidationHelper(text: _text, validation: validation));
  }

  final StreamController<String> _textFieldController =
      StreamController<String>.broadcast();
  Stream<String> get textFieldStream => _textFieldController.stream;
  late final StreamController<SuperValidationHelper> _controller =
      StreamController.broadcast()
        ..add(SuperValidationHelper(
            text: initalText, validation: validationFunc?.call(initalText)));
  Stream<String> get stream => _controller.stream.map((event) => event.text);
  @override
  Stream<String?> get streamValidation =>
      _controller.stream.distinct().map((event) => event.validation);
  @override
  Stream<bool> get streamIsValid =>
      _controller.stream.distinct().map((event) => event.validation == null);

  Future<void> dispose() async {
    await _controller.close();
  }

  @internal
  void controllerSetText(String text) {
    _text = text;
    _validation = validationFunc?.call(text);
    _controller.add(SuperValidationHelper(text: text, validation: validation));
  }

  set text(String text) {
    _text = text;
    _validation = validationFunc?.call(text);
    _textFieldController.add(text);
  }

  String get text => _text;
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
