// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:super_validation/super_validation_a.dart';

import 'super_validation.dart';

typedef SuperValidationEnumBuilderFunction<T> = Widget Function(
    BuildContext context, T? value);

class SuperValidationEnumBuilder<T> extends StatelessWidget {
  final SuperValidationValue<T> superValidation;
  final SuperValidationEnumBuilderFunction<T> builder;
  const SuperValidationEnumBuilder({
    Key? key,
    required this.superValidation,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T?>(
        stream: superValidation.streamValue,
        initialData: superValidation.value,
        builder: (context, snapshot) {
          return builder(context, superValidation.value);
        });
  }
}

typedef SuperValidationEnumBuilderWithLoadingFunction<T> = Widget Function(
    BuildContext context, T? value, bool isLoading);

class SuperValidationEnumBuilderWithLoading<T> extends StatelessWidget {
  final SuperValidationEnum<T> superValidation;
  final SuperValidationEnumBuilderWithLoadingFunction<T> builder;
  final SuperLoading loading;
  const SuperValidationEnumBuilderWithLoading(
      {Key? key,
      required this.superValidation,
      required this.builder,
      required this.loading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SuperLoadingBuilder(
        loading: loading,
        builder: (context, isLoading) {
          return StreamBuilder<T?>(
              stream: superValidation.streamValue,
              initialData: superValidation.value,
              builder: (context, snapshot) {
                return builder(context, superValidation.value, isLoading);
              });
        });
  }
}
