Package to controll TextFormField from bloc

## Usage
In test_bloc.dart
```dart
final SuperValidation validation = SuperValidation(validationFunc: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
});
```
for int or num
```dart
final SuperValidationInt intValidation = SuperValidationInt.minMax(
  min: 0,
  max: 10,
  minMessage: 'Min 0',
  maxMessage: 'Max 10',
);
final SuperValidationNum numValidation = SuperValidationNum.minMax(
  min: 0,
  max: 10,
  minMessage: 'Min 0',
  maxMessage: 'Max 10',
);
```

for enum
```dart
enum TestEnum { one, two, three }
final SuperValidationEnum<TestEnum> enumValidation = SuperValidationEnum()
    ..validation = 'Выберите один из пунктов';

//in test_page.dart
DropDownEnumField<TestEnum>(
  superValidation: context.read<TestBloc>().enumValidation,
  items: TestEnumM.mapName,
  autovalidateMode: AutovalidateMode.always,
),
```

In test_page.dart
```dart
TextFieldSuperValidation(
    superValidation: context.read<TestBloc>().validation,
    autovalidateMode: AutovalidateMode.onUserInteraction,
);
```
If u want set custom icon or suffix to error decoration
```dart
TextFieldSuperValidationWithIcon(
      superValidation: superValidation,
      errorIcon: Icon(Icons.error, color: Colors.red, size: 20),
      errorSuffix: Icon(Icons.error, color: Colors.red, size: 20),
    );
```
Also u can enforse set Validation text with

```dart
validation.validate('Validation Text');
```

And set text of textField
    
```dart
validation.text = event.text;
```

And builder for buttons
    
```dart
SuperValidationBuilder(
  superValidation: context.read<TestBloc>().validation,
  builder: (context, validation, isValid) {
    return TextButton(
        onPressed: isValid
            ? () {
                print('Test');
                }
              null,
        child: Text('Test'));
});
```

Also u can use SuperValidationSimpleMultyBuilder for multy validation button

```dart
SuperValidationSimpleMultyBuilder(
  builder: (context, isValid) {
      return ElevatedButton(
          onPressed: isValid
              ? () {
                  print('onPressed');
              }
              : null,
                  child: Text('Validate'),
              );
      },
  superValidation: [
      context.read<TestBloc>().numberValidation,
      context.read<TestBloc>().stringValidation,
  ],
)
```

And SuperValidationMultyBuilder for multy validation button with custom validation text

```dart
SuperValidationMultyBuilder(
  builder: (context, validation, isValid) {
      return Text(
                    validation.isEmpty ? 'Valid' : validation.toString(),
                    style: TextStyle(
                      color: isValid ? Colors.green : Colors.red,
                    ),
                  );
      },
  superValidation: {
      'string': context.read<TestBloc>().stringValidation,
      'number': context.read<TestBloc>().numberValidation,
  },
)
```

If u need Custom logic for example in bloc use SuperValidationStream<T>
```dart
final SuperValidationStream<String> superValidationStream =
    SuperValidationStream<String>(
  superValidationMap: {
      'string': context.read<TestBloc>().stringValidation,
      'number': context.read<TestBloc>().numberValidation,
  },
);
superValidationStream.streamValidation.listen((event) {
    print('Validations: $event');
});
```

Custom Validation Example
```dart
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
  set validation(String? value) {
    _validation = value;
    _streamController.add(value);
  }

  List<FileManaged> _files = [];
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
```

