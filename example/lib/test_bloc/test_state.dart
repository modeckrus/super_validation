part of 'test_bloc.dart';

abstract class TestState extends Equatable {
  const TestState();

  @override
  List<Object?> get props => [];
}

class TestLoading extends TestState {}

class TextStringS extends TestState {
  final String text;
  final String? validation;
  const TextStringS(this.text, this.validation);

  @override
  List<Object?> get props => [text, validation];
}
