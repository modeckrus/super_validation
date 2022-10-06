Package to controll TextFormField from bloc

## Usage
In test_bloc.dart
```dart
final SuperValidation validation = SuperValidation((value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
});
```
In test_page.dart
```dart
TextFieldSuperValidation(
    superValidation: context.read<TestBloc>().validation,
    autovalidateMode: AutovalidateMode.onUserInteraction,
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