part of 'test_bloc.dart';

abstract class TestEvent extends Equatable {
  const TestEvent();

  @override
  List<Object?> get props => [];
}

class TestTextE extends TestEvent {
  final String text;
  final String? validation;

  const TestTextE({required this.text, required this.validation});

  @override
  List<Object?> get props => [text, validation];
}

class TestValidateE extends TestEvent {
  final String validation;

  const TestValidateE({required this.validation});

  @override
  List<Object?> get props => [validation];
}

class TestSetTextE extends TestEvent {
  final String text;

  const TestSetTextE({required this.text});

  @override
  List<Object?> get props => [text];
}

class TestInitializeE extends TestEvent {
  const TestInitializeE();
}
