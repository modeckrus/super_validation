import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_validation/super_validation.dart';

part 'test_event.dart';
part 'test_state.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc() : super(TestInitial()) {
    on<TestTextE>(_text);
    on<TestValidateE>(_validate);
    on<TestSetTextE>(_setText);
    validation.stream.listen(_listenStream);
  }
  final SuperValidation validation = SuperValidation((value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  });

  FutureOr<void> _text(TestTextE event, Emitter<TestState> emit) {
    emit(TextStringS(event.text, event.validation));
  }

  void _listenStream(String event) {
    add(TestTextE(text: event, validation: validation.validation));
  }

  FutureOr<void> _validate(TestValidateE event, Emitter<TestState> emit) {
    validation.validate(event.validation);
  }

  FutureOr<void> _setText(TestSetTextE event, Emitter<TestState> emit) {
    validation.text = event.text;
  }
}
