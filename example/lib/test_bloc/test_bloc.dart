import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_validation/super_validation.dart';

part 'test_event.dart';
part 'test_state.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc() : super(TestLoading()) {
    on<TestTextE>(_text);
    on<TestValidateE>(_validate);
    on<TestSetTextE>(_setText);
    on<TestInitializeE>(_initialize);
    numberStream.listen(_listenNumber);
    stringValidation.stream.listen(_listenStream);
  }
  final SuperValidation numberValidation = SuperValidation((value) {
    final number = int.tryParse(value ?? '') ?? 0;
    if (number == 0) {
      return 'Enter number';
    }
    return null;
  });

  Stream<int> get numberStream => numberValidation.stream.map((event) {
        //Remove all non digits
        final String digits = event.replaceAll(RegExp(r'\D'), '');
        if (digits.isEmpty) {
          return 0;
        }
        return int.tryParse(digits) ?? 0;
      });

  final SuperValidation stringValidation = SuperValidation((value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  });

  FutureOr<void> _text(TestTextE event, Emitter<TestState> emit) {
    emit(TextStringS(event.text, event.validation));
  }

  String currentText = '';

  void _listenStream(String event) {
    currentText = event;
    add(TestTextE(text: event, validation: numberValidation.validation));
  }

  FutureOr<void> _validate(TestValidateE event, Emitter<TestState> emit) {
    stringValidation.validate(event.validation);
  }

  FutureOr<void> _setText(TestSetTextE event, Emitter<TestState> emit) {
    stringValidation.text = event.text;
  }

  FutureOr<void> _initialize(TestInitializeE event, Emitter<TestState> emit) {
    stringValidation.text = 'Initial text';
    emit(TextStringS(numberValidation.text, numberValidation.validation));
  }

  int number = 0;
  void _listenNumber(int event) {
    number = event;
  }
}
