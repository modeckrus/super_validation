import 'dart:async';

import 'package:flutter/material.dart';
import 'package:super_validation/super_validation_a.dart';

class DropDownEnumField<T> extends StatefulWidget {
  final SuperValidationValue<T> superValidation;
  final Map<T, String> items;
  final DropdownButtonBuilder? selectedItemBuilder;
  final T? value;
  final Widget? hint;
  final Widget? disabledHint;
  final VoidCallback? onTap;
  final int elevation;
  final TextStyle? style;
  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  final double iconSize;
  final bool isDense;
  final bool isExpanded;
  final double? itemHeight;
  final Color? focusColor;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? dropdownColor;
  final InputDecoration? decoration;
  final AutovalidateMode? autovalidateMode;
  final double? menuMaxHeight;
  final bool? enableFeedback;
  final AlignmentGeometry alignment;
  final BorderRadius? borderRadius;
  const DropDownEnumField(
      {super.key,
      required this.items,
      required this.superValidation,
      this.value,
      this.hint,
      this.disabledHint,
      this.onTap,
      this.elevation = 8,
      this.style,
      this.icon,
      this.iconDisabledColor,
      this.iconEnabledColor,
      this.iconSize = 24.0,
      this.isDense = true,
      this.isExpanded = false,
      this.itemHeight,
      this.focusColor,
      this.focusNode,
      this.autofocus = false,
      this.dropdownColor,
      this.decoration,
      this.autovalidateMode,
      this.menuMaxHeight,
      this.enableFeedback,
      this.alignment = AlignmentDirectional.centerStart,
      this.borderRadius,
      this.selectedItemBuilder});

  @override
  State<DropDownEnumField<T>> createState() => _DropDownEnumFieldState<T>();
}

class _DropDownEnumFieldState<T> extends State<DropDownEnumField<T>> {
  SuperValidationValue<T> get superValidation => widget.superValidation;
  late StreamSubscription<String?> _validationSubscription;
  @override
  void initState() {
    super.initState();
    _validationSubscription =
        superValidation.streamValidation.listen(_listenValidation);
    if (superValidation.validation != null) {
      _listenValidation(superValidation.validation);
    }
  }

  @override
  void dispose() {
    _validationSubscription.cancel();
    super.dispose();
  }

  void _listenValidation(String? event) {
    _formKey.currentState?.validate();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T?>(
        stream: widget.superValidation.streamValue,
        builder: (context, snapshot) {
          return DropdownButtonFormField<T>(
            key: _formKey,
            value: widget.superValidation.value,
            onTap: () => FocusScope.of(context).unfocus(),
            items: widget.items.entries.map(
              (MapEntry<T, String> e) {
                return DropdownMenuItem<T>(
                  value: e.key,
                  child: Text(e.value),
                );
              },
            ).toList(),
            onChanged: (T? value) => widget.superValidation.value = value,
            selectedItemBuilder: widget.selectedItemBuilder,
            hint: widget.hint,
            disabledHint: widget.disabledHint,
            elevation: widget.elevation,
            style: widget.style,
            icon: widget.icon,
            iconDisabledColor: widget.iconDisabledColor,
            iconEnabledColor: widget.iconEnabledColor,
            iconSize: widget.iconSize,
            isDense: widget.isDense,
            isExpanded: widget.isExpanded,
            itemHeight: widget.itemHeight,
            focusColor: widget.focusColor,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            dropdownColor: widget.dropdownColor,
            decoration: widget.decoration,
            autovalidateMode: widget.autovalidateMode,
            menuMaxHeight: widget.menuMaxHeight,
            validator: (value) => widget.superValidation.validation,
          );
        });
  }
}
