// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:super_validation/super_validation.dart';

class CheckWidget extends StatelessWidget {
  final SuperValidationEnum<String> superValidation;
  final List<String> values;
  const CheckWidget({
    Key? key,
    required this.superValidation,
    required this.values,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SuperValidationEnumBuilder<String>(
        superValidation: superValidation,
        builder: (context, value) {
          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: values
                .map((e) => CheckboxListTile(
                      title: Text(e),
                      value: value == e,
                      onChanged: (value) {
                        if (value == true) {
                          superValidation.value = e;
                        }
                      },
                    ))
                .toList(),
          );
        });
  }
}
