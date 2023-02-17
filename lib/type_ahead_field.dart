import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:super_validation/super_validation_string.dart';
import 'package:flutter_typeahead/src/material/suggestions_box/suggestions_box_decoration.dart';
import 'super_validation_num.dart';

typedef TextFieldValidationFunc = String? Function(String? value);

class TypeAheadFormFieldWithSuperValidation<T> extends StatefulWidget {
  final TextFieldValidationFunc? altValidationFunc;
  final SuperValidation superValidation;
  final String? initialValue;
  final bool getImmediateSuggestions;
  final bool autovalidate;
  final bool enabled;
  final AutovalidateMode autovalidateMode;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ErrorBuilder? errorBuilder;
  final WidgetBuilder? noItemsFoundBuilder;
  final WidgetBuilder? loadingBuilder;
  final void Function(bool)? onSuggestionsBoxToggle;
  final Duration debounceDuration;
  final SuggestionsBoxDecoration suggestionsBoxDecoration;
  final SuggestionsBoxController? suggestionsBoxController;
  final SuggestionSelectionCallback<T> onSuggestionSelected;
  final ItemBuilder<T> itemBuilder;
  final SuggestionsCallback<T> suggestionsCallback;
  final double suggestionsBoxVerticalOffset;
  final TextFieldConfiguration textFieldConfiguration;
  final AnimationTransitionBuilder? transitionBuilder;
  final Duration animationDuration;
  final double animationStart;
  final AxisDirection direction;
  final bool hideOnLoading;
  final bool hideOnEmpty;
  final bool hideOnError;
  final bool hideSuggestionsOnKeyboardHide;
  final bool keepSuggestionsOnLoading;
  final bool keepSuggestionsOnSuggestionSelected;
  final bool autoFlipDirection;
  final bool hideKeyboard;
  final int minCharsForSuggestions;
  final bool hideKeyboardOnDrag;
  const TypeAheadFormFieldWithSuperValidation(
      {super.key,
      this.altValidationFunc,
      required this.superValidation,
      this.initialValue,
      this.getImmediateSuggestions = false,
      this.autovalidate = false,
      this.enabled = true,
      this.autovalidateMode = AutovalidateMode.disabled,
      this.onSaved,
      this.validator,
      this.errorBuilder,
      this.noItemsFoundBuilder,
      this.loadingBuilder,
      this.onSuggestionsBoxToggle,
      this.debounceDuration = const Duration(milliseconds: 300),
      this.suggestionsBoxDecoration = const SuggestionsBoxDecoration(),
      this.suggestionsBoxController,
      required this.onSuggestionSelected,
      required this.itemBuilder,
      required this.suggestionsCallback,
      this.suggestionsBoxVerticalOffset = 5.0,
      this.textFieldConfiguration = const TextFieldConfiguration(),
      this.transitionBuilder,
      this.animationDuration = const Duration(milliseconds: 500),
      this.animationStart = 0.25,
      this.direction = AxisDirection.down,
      this.hideOnLoading = false,
      this.hideOnEmpty = false,
      this.hideOnError = false,
      this.hideSuggestionsOnKeyboardHide = true,
      this.keepSuggestionsOnLoading = true,
      this.keepSuggestionsOnSuggestionSelected = false,
      this.autoFlipDirection = false,
      this.hideKeyboard = false,
      this.minCharsForSuggestions = 0,
      this.hideKeyboardOnDrag = false});

  @override
  State<TypeAheadFormFieldWithSuperValidation> createState() =>
      _TypeAheadFormFieldWithSuperValidationState<T>(
        suggestionsCallback: suggestionsCallback,
        onSuggestionSelected: onSuggestionSelected,
        itemBuilder: itemBuilder,
      );
}

class _TypeAheadFormFieldWithSuperValidationState<T>
    extends State<TypeAheadFormFieldWithSuperValidation> {
  final FutureOr<Iterable<T>> Function(String) suggestionsCallback;
  final SuggestionSelectionCallback<T> onSuggestionSelected;
  final ItemBuilder<T> itemBuilder;
  late final TextFieldConfiguration _textFieldConfiguration =
      buildTextFieldConfiguration();

  _TypeAheadFormFieldWithSuperValidationState({
    required this.suggestionsCallback,
    required this.onSuggestionSelected,
    required this.itemBuilder,
  });
  TextEditingController get controller =>
      _textFieldConfiguration.controller ?? TextEditingController();
  SuperValidation get superValidation => widget.superValidation;
  FocusNode get focusNode =>
      widget.textFieldConfiguration.focusNode ?? FocusNode();
  late StreamSubscription<String> _textSubscription;
  late StreamSubscription<String?> _validationSubscription;
  @override
  void initState() {
    super.initState();
    controller.value = formatText(superValidation.text);
    controller.addListener(_onControllerChanged);
    _validationSubscription =
        superValidation.streamValidation.listen(_listenValidation);
    _textSubscription =
        superValidation.textFieldStream.listen(_listenTextField);
    if (widget.autovalidateMode == AutovalidateMode.always) {
      //addpostframecallback
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _formKey.currentState?.validate();
      });
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    if (widget.textFieldConfiguration.controller == null) controller.dispose();
    if (widget.textFieldConfiguration.focusNode == null) focusNode.dispose();
    _validationSubscription.cancel();
    _textSubscription.cancel();
    super.dispose();
  }

  void _onControllerChanged() {
    superValidation.controllerSetText(controller.text);
  }

  void _listenValidation(String? event) {
    _formKey.currentState?.validate();
  }

  final _formKey = GlobalKey<FormState>();

  void _listenTextField(String event) {
    final hasFocus = focusNode.hasFocus;
    controller.value = formatText(event);
    if (hasFocus) {
      focusNode.requestFocus();
    }
  }

  TextEditingValue formatText(String event) {
    var value =
        widget.textFieldConfiguration.inputFormatters?.fold<TextEditingValue>(
              TextEditingValue(
                text: event,
                selection: TextSelection.collapsed(offset: event.length),
              ),
              (TextEditingValue newValue, TextInputFormatter formatter) {
                String text = controller.text;
                TextSelection selection = controller.selection;
                if (superValidation is SuperValidationNum) {
                  text = text.isEmpty ? '0.0' : text;
                  selection = selection.copyWith(
                    baseOffset: text.length,
                    extentOffset: text.length,
                  );
                }
                TextEditingValue value =
                    controller.value.copyWith(text: text, selection: selection);
                final result = formatter.formatEditUpdate(value, newValue);
                return result;
              },
            ) ??
            TextEditingValue(
              text: event,
              selection: TextSelection.collapsed(offset: event.length),
            );
    if (value.selection.start < 1) {
      value = value.copyWith(selection: TextSelection.collapsed(offset: 1));
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TypeAheadFormField<T>(
        textFieldConfiguration: _textFieldConfiguration,
        onSaved: widget.onSaved,
        validator: (txt) {
          final altValidationFunc = widget.altValidationFunc;
          if (altValidationFunc != null) {
            return altValidationFunc.call(txt);
          }
          return superValidation.validation;
        },
        errorBuilder: widget.errorBuilder,
        noItemsFoundBuilder: widget.noItemsFoundBuilder,
        loadingBuilder: widget.loadingBuilder,
        onSuggestionsBoxToggle: widget.onSuggestionsBoxToggle,
        debounceDuration: widget.debounceDuration,
        suggestionsBoxDecoration: widget.suggestionsBoxDecoration,
        suggestionsBoxController: widget.suggestionsBoxController,
        onSuggestionSelected: onSuggestionSelected,
        itemBuilder: itemBuilder,
        suggestionsCallback: suggestionsCallback,
        suggestionsBoxVerticalOffset: widget.suggestionsBoxVerticalOffset,
        transitionBuilder: widget.transitionBuilder,
        animationDuration: widget.animationDuration,
        animationStart: widget.animationStart,
        direction: widget.direction,
        hideOnLoading: widget.hideOnLoading,
        hideOnEmpty: widget.hideOnEmpty,
        hideOnError: widget.hideOnError,
        hideSuggestionsOnKeyboardHide: widget.hideSuggestionsOnKeyboardHide,
        keepSuggestionsOnLoading: widget.keepSuggestionsOnLoading,
        keepSuggestionsOnSuggestionSelected:
            widget.keepSuggestionsOnSuggestionSelected,
        autoFlipDirection: widget.autoFlipDirection,
        hideKeyboard: widget.hideKeyboard,
        minCharsForSuggestions: widget.minCharsForSuggestions,
        hideKeyboardOnDrag: widget.hideKeyboardOnDrag,
        autovalidateMode: widget.autovalidateMode,
        getImmediateSuggestions: widget.getImmediateSuggestions,
        enabled: widget.enabled,
      ),
    );
  }

  TextFieldConfiguration buildTextFieldConfiguration() {
    final controller = widget.textFieldConfiguration.controller ??
        TextEditingController(text: superValidation.text);
    final focusNode = widget.textFieldConfiguration.focusNode ?? FocusNode();
    return widget.textFieldConfiguration.copyWith(
      controller: controller,
      focusNode: focusNode,
    );
  }
}
