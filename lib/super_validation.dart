// ignore_for_file: public_member_api_docs, sort_constructors_first
library super_validation;

import 'dart:async';

import 'package:equatable/equatable.dart';

export 'text_form_field.dart';
export 'validation_builder.dart';

typedef ValidationFunc = String? Function(String? value);

class SuperValidation {
  String _text = '';

  final ValidationFunc validationFunc;
  final String initalText;

  SuperValidation(this.validationFunc, {this.initalText = ''});
  bool get isValid => validation == null;

  String? validation;
  final StreamController<String> _textFieldController =
      StreamController<String>.broadcast();
  Stream<String> get textFieldStream => _textFieldController.stream;
  late final StreamController<SuperValidationHelper> _controller =
      StreamController.broadcast()
        ..add(SuperValidationHelper(
            text: initalText, validation: validationFunc(initalText)));
  Stream<String> get stream => _controller.stream.map((event) => event.text);
  Stream<String?> get streamValidation =>
      _controller.stream.distinct().map((event) => event.validation);
  Stream<bool> get streamIsValid =>
      _controller.stream.distinct().map((_) => isValid);

  Future<void> dispose() async {
    await _controller.close();
  }

  void controllerSetText(String text) {
    _text = text;
    validation = validationFunc(text);
    _controller.add(SuperValidationHelper(text: text, validation: validation));
  }

  void validate(String? value) {
    validation = value;
    _controller.add(SuperValidationHelper(text: _text, validation: value));
  }

  set text(String text) {
    _text = text;
    validation = validationFunc(text);
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
