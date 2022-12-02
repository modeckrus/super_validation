import 'package:flutter/material.dart';

import 'super_validation.dart';

typedef SuperValidationBuilderFuncWithLoading = Widget Function(
    BuildContext context, String? validation, bool isValid, bool isLoading);

class SuperValidationBuilderWithLoading extends StatelessWidget {
  final SuperValidationA superValidation;
  final SuperLoading loading;
  final SuperValidationBuilderFuncWithLoading builder;
  const SuperValidationBuilderWithLoading(
      {super.key,
      required this.superValidation,
      required this.loading,
      required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: loading.streamValue,
      initialData: loading.value,
      builder: (context, state) {
        return StreamBuilder<String?>(
            stream: superValidation.streamValidation,
            builder: (context, snapshot) {
              return builder(context, superValidation.validation,
                  superValidation.isValid, loading.value);
            });
      },
    );
  }
}

typedef SuperValidationSimpleMultiBuilderFuncWithLoading = Widget Function(
    BuildContext context, bool isValid, bool isLoading);

class SuperValidationSimpleMultiBuilderWithLoading extends StatelessWidget {
  final SuperValidationSimpleMultiBuilderFuncWithLoading builder;
  final List<SuperValidationA> superValidation;
  final SuperLoading loading;
  late final SuperValidationStream superValidationStream =
      SuperValidationStream(superValidationMap: superValidation.asMap());
  SuperValidationSimpleMultiBuilderWithLoading(
      {super.key,
      required this.builder,
      required this.superValidation,
      required this.loading});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: loading.streamValue,
        builder: (context, _) => StreamBuilder<bool>(
            stream: superValidationStream.streamIsValid,
            builder: (context, snapshot) {
              final map = snapshot.data ?? false;
              return builder(context, map, loading.value);
            }));
  }
}

typedef SuperValidationMultiBuilderFuncWithLoading<T> = Widget Function(
    BuildContext context,
    Map<T, String?> validation,
    bool isValid,
    bool isLoading);

class SuperValidationMultiBuilderWithLoading<T> extends StatelessWidget {
  final Map<T, SuperValidationA> superValidation;
  final SuperLoading loading;
  final SuperValidationMultiBuilderFuncWithLoading<T> builder;

  SuperValidationMultiBuilderWithLoading(
      {super.key,
      required this.superValidation,
      required this.builder,
      required this.loading});

  late final SuperValidationStream<T> superValidationStream =
      SuperValidationStream<T>(
    superValidationMap: superValidation,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: loading.streamValue,
      builder: (context, state) {
        return StreamBuilder<Map<T, String?>>(
            stream: superValidationStream.streamValidation,
            initialData: superValidationStream.store,
            builder: (context, snapshot) {
              final map = snapshot.data ?? {};
              return builder(
                  context, map, superValidationStream.isValid, loading.value);
            });
      },
    );
  }
}

typedef SuperLoadingBuilderFunc = Widget Function(
    BuildContext context, bool isLoading);

class SuperLoadingBuilder extends StatelessWidget {
  final SuperLoading loading;
  final SuperLoadingBuilderFunc builder;
  const SuperLoadingBuilder(
      {super.key, required this.loading, required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: loading.streamValue,
        builder: (context, state) {
          return builder(context, loading.value);
        });
  }
}
