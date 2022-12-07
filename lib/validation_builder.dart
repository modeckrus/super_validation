import 'package:flutter/material.dart';
import 'package:super_validation/super_validation.dart';

typedef SuperValidationBuilderFunc = Widget Function(
    BuildContext context, String? validation, bool isValid);

class SuperValidationBuilder extends StatelessWidget {
  final SuperValidationA superValidation;
  final SuperValidationBuilderFunc builder;
  final AutovalidateMode autovalidateMode;
  const SuperValidationBuilder(
      {super.key,
      required this.superValidation,
      required this.builder,
      this.autovalidateMode = AutovalidateMode.disabled});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
        stream: superValidation.streamValidation,
        initialData: autovalidateMode == AutovalidateMode.disabled
            ? null
            : superValidation.validation,
        builder: (context, snapshot) {
          return builder(
              context, superValidation.validation, superValidation.isValid);
        });
  }
}

typedef SuperValidationSimpleMultiBuilderFunc = Widget Function(
    BuildContext context, bool isValid);

class SuperValidationSimpleMultiBuilder extends StatelessWidget {
  final SuperValidationSimpleMultiBuilderFunc builder;
  final List<SuperValidationA> superValidation;
  late final SuperValidationStream superValidationStream =
      SuperValidationStream(superValidationMap: superValidation.asMap());
  SuperValidationSimpleMultiBuilder(
      {super.key,
      required this.builder,
      required this.superValidation,
      this.autovalidateMode = AutovalidateMode.disabled});
  final AutovalidateMode autovalidateMode;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: superValidationStream.streamIsValid,
        initialData: autovalidateMode == AutovalidateMode.disabled
            ? false
            : superValidationStream.isValid,
        builder: (context, snapshot) {
          final map = snapshot.data ?? false;
          return builder(context, map);
        });
  }
}

typedef SuperValidationMultiBuilderFunc<T> = Widget Function(
    BuildContext context, Map<T, String?> validation, bool isValid);

class SuperValidationMultiBuilder<T> extends StatelessWidget {
  final Map<T, SuperValidationA> superValidation;
  final SuperValidationMultiBuilderFunc<T> builder;

  SuperValidationMultiBuilder(
      {super.key, required this.superValidation, required this.builder});

  late final SuperValidationStream<T> superValidationStream =
      SuperValidationStream<T>(
    superValidationMap: superValidation,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<T, String?>>(
        stream: superValidationStream.streamValidation,
        initialData: superValidationStream.store,
        builder: (context, snapshot) {
          final map = snapshot.data ?? {};
          return builder(context, map, superValidationStream.isValid);
        });
  }
}
