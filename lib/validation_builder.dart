import 'package:flutter/material.dart';
import 'package:super_validation/super_validation.dart';

typedef SuperValidationBuilderFunc = Widget Function(
    BuildContext context, String? validation, bool isValid);

class SuperValidationBuilder extends StatelessWidget {
  final SuperValidation superValidation;
  final SuperValidationBuilderFunc builder;
  const SuperValidationBuilder(
      {super.key, required this.superValidation, required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
        stream: superValidation.streamValidation,
        builder: (context, snapshot) {
          return builder(
              context, superValidation.validation, superValidation.isValid);
        });
  }
}

typedef SuperValidationSimpleMultyBuilderFunc = Widget Function(
    BuildContext context, bool isValid);

class SuperValidationSimpleMultyBuilder extends StatelessWidget {
  final SuperValidationSimpleMultyBuilderFunc builder;
  final List<SuperValidation> superValidation;
  late final SuperValidationStream superValidationStream =
      SuperValidationStream(superValidationMap: superValidation.asMap());
  SuperValidationSimpleMultyBuilder(
      {super.key, required this.builder, required this.superValidation});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: superValidationStream.streamIsValid,
        builder: (context, snapshot) {
          final map = snapshot.data ?? false;
          return builder(context, map);
        });
  }
}

typedef SuperValidationMultyBuilderFunc<T> = Widget Function(
    BuildContext context, Map<T, String?> validation, bool isValid);

class SuperValidationMultyBuilder<T> extends StatelessWidget {
  final Map<T, SuperValidation> superValidation;
  final SuperValidationMultyBuilderFunc<T> builder;

  SuperValidationMultyBuilder(
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
