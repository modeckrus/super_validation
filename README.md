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