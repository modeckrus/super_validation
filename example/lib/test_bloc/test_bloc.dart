// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:super_validation/super_validation.dart';

part 'test_event.dart';
part 'test_state.dart';

class FileManaged extends Equatable {
  final String id;
  final String path;
  const FileManaged({
    required this.id,
    required this.path,
  });

  @override
  List<Object?> get props => [id, path];
}

enum TestEnum {
  one,
  two,
  three,
}

extension TestEnumM on TestEnum {
  static Map<String, TestEnum> get map => {
        'one': TestEnum.one,
        'two': TestEnum.two,
        'three': TestEnum.three,
      };

  String get name => map.entries.firstWhere((e) => e.value == this).key;
  static Map<TestEnum, String> get mapName =>
      map.map((key, value) => MapEntry(value, key));
}

class SuperValidationFile extends SuperValidationA {
  SuperValidationFile() {
    validate();
  }
  void validate() {
    if (files.length != 2) {
      validation = 'You need to add 2 files';
    } else {
      validation = null;
    }
  }

  final StreamController<String?> _streamController =
      StreamController.broadcast();
  @override
  Stream<bool> get streamIsValid =>
      _streamController.stream.map((event) => event == null);

  @override
  Stream<String?> get streamValidation => _streamController.stream;
  String? _validation;
  @override
  String? get validation => _validation;
  @override
  set validation(String? value) {
    _validation = value;
    _streamController.add(value);
  }

  final List<FileManaged> _files = [];
  List<FileManaged> get files => [..._files];
  void addFile(FileManaged file) {
    _files.add(file);
    validate();
  }

  void removeFile(FileManaged file) {
    _files.remove(file);
    validate();
  }
}

class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc() : super(TestLoading()) {
    on<TestTextE>(_text);
    on<TestValidateE>(_validate);
    on<TestSetTextE>(_setText);
    on<TestInitializeE>(_initialize);
    stringValidation.stream.listen(_listenStream);
  }
  final SuperValidationNum numberValidation = SuperValidationNum.minMax(
    min: 0,
    max: 10,
    minMessage: 'Min 0',
    maxMessage: 'Max 10',
  )..text = '1';

  final SuperValidation stringValidation =
      SuperValidation(validationFunc: (value) {
    if (value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  });

  final SuperValidation errorValidation =
      SuperValidation(validationFunc: (value) {
    if (value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  });

  final SuperValidationFile fileValidation = SuperValidationFile();
  final SuperValidationEnum<String> stringEnumValidation =
      SuperValidationEnum<String>(
          validateFunc: (String? val) =>
              val == null ? 'Выберите значение' : null);

  late final SuperValidationStream superValidationStream =
      SuperValidationStream(
    superValidationMap: {
      'string': stringValidation,
      'number': numberValidation,
      'file': fileValidation,
    },
  );
  final SuperValidationEnum<TestEnum> enumValidation =
      SuperValidationEnum(validateFunc: (value) {
    if (value == null) {
      return 'Выберите один из пунктов';
    }
    return null;
  });

  FutureOr<void> _text(TestTextE event, Emitter<TestState> emit) {
    emit(TextStringS(event.text, event.validation));
  }

  String currentText = '';

  void _listenStream(String event) {
    add(TestTextE(text: event, validation: numberValidation.validation));
  }

  FutureOr<void> _validate(TestValidateE event, Emitter<TestState> emit) {
    stringValidation.validation = (event.validation);
  }

  FutureOr<void> _setText(TestSetTextE event, Emitter<TestState> emit) {
    stringValidation.text = event.text;
  }

  FutureOr<void> _initialize(TestInitializeE event, Emitter<TestState> emit) {
    stringValidation.text = 'Initial text';
    emit(TextStringS(numberValidation.text, numberValidation.validation));
  }
}
