import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:super_validation/super_validation.dart';


typedef TextFieldValidationFunc = String? Function(String? value);
typedef ErrorValidationBuilder = Widget Function(
    BuildContext context, String? error, Widget errorIcon, Widget errorSuffix);

typedef CounterWidgetBuilder = Widget Function(
    BuildContext context, int currentLength, int maxLength);

class TextFieldSuperValidationWithIcon extends StatefulWidget {
  final SuperValidation superValidation;
  final Widget errorIcon;
  final Widget errorSuffix;
  final SuperValidationA? altValidation;
  final AutovalidateMode? autovalidateMode;
  final Alignment? alignment;
  final EdgeInsets? padding;
  final BoxDecoration? containerDecoration;
  final EdgeInsetsGeometry? margin;
  final bool onlyValidationOnTextChange;
  final ErrorValidationBuilder? errorValidationBuilder;
  final CounterWidgetBuilder? counterBuilder;
  const TextFieldSuperValidationWithIcon(
      {this.onlyValidationOnTextChange = false,
      this.counterBuilder,
      this.margin,
      this.alignment,
      this.padding,
      this.containerDecoration,
      this.autovalidateMode = AutovalidateMode.disabled,
      this.altValidation,
      this.contextMenuBuilder,
      this.onFieldSubmitted,
      required this.superValidation,
      this.errorIcon = const Icon(Icons.error, color: Colors.red, size: 20),
      this.errorSuffix = const SizedBox(),
      super.key,
      this.controller,
      this.focusNode,
      this.decoration = const InputDecoration(),
      TextInputType? keyboardType,
      this.textInputAction,
      this.textCapitalization = TextCapitalization.none,
      this.style,
      this.strutStyle,
      this.textAlign = TextAlign.start,
      this.textAlignVertical,
      this.textDirection,
      this.readOnly = false,
      ToolbarOptions? toolbarOptions,
      this.showCursor,
      this.autofocus = false,
      this.obscuringCharacter = '•',
      this.obscureText = false,
      this.autocorrect = true,
      SmartDashesType? smartDashesType,
      SmartQuotesType? smartQuotesType,
      this.enableSuggestions = true,
      this.maxLines = 1,
      this.minLines,
      this.expands = false,
      this.maxLength,
      this.maxLengthEnforcement,
      this.onChanged,
      this.onEditingComplete,
      this.onSubmitted,
      this.onAppPrivateCommand,
      this.inputFormatters,
      this.enabled,
      this.cursorWidth = 2.0,
      this.cursorHeight,
      this.cursorRadius,
      this.cursorColor,
      this.selectionHeightStyle = ui.BoxHeightStyle.tight,
      this.selectionWidthStyle = ui.BoxWidthStyle.tight,
      this.keyboardAppearance,
      this.scrollPadding = const EdgeInsets.all(20.0),
      this.dragStartBehavior = DragStartBehavior.start,
      bool? enableInteractiveSelection,
      this.selectionControls,
      this.onTap,
      this.mouseCursor,
      this.buildCounter,
      this.scrollController,
      this.scrollPhysics,
      this.autofillHints = const <String>[],
      this.clipBehavior = Clip.hardEdge,
      this.restorationId,
      this.scribbleEnabled = true,
      this.enableIMEPersonalizedLearning = true,
      this.onWillPop,
      this.errorValidationBuilder})
      : smartDashesType = smartDashesType ??
            (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
        smartQuotesType = smartQuotesType ??
            (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
        keyboardType = keyboardType ??
            (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
        enableInteractiveSelection =
            enableInteractiveSelection ?? (!readOnly || !obscureText),
        toolbarOptions = toolbarOptions ??
            (obscureText
                ? (readOnly
                    // No point in even offering "Select All" in a read-only obscured
                    // field.
                    ? const ToolbarOptions()
                    // Writable, but obscured.
                    : const ToolbarOptions(
                        selectAll: true,
                        paste: true,
                      ))
                : (readOnly
                    // Read-only, not obscured.
                    ? const ToolbarOptions(
                        selectAll: true,
                        copy: true,
                      )
                    // Writable, not obscured.
                    : const ToolbarOptions(
                        copy: true,
                        cut: true,
                        selectAll: true,
                        paste: true,
                      )));

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// Defines the keyboard focus for this widget.
  ///
  /// The [focusNode] is a long-lived object that's typically managed by a
  /// [StatefulWidget] parent. See [FocusNode] for more information.
  ///
  /// To give the keyboard focus to this widget, provide a [focusNode] and then
  /// use the current [FocusScope] to request the focus:
  ///
  /// ```dart
  /// FocusScope.of(context).requestFocus(myFocusNode);
  /// ```
  ///
  /// This happens automatically when the widget is tapped.
  ///
  /// To be notified when the widget gains or loses the focus, add a listener
  /// to the [focusNode]:
  ///
  /// ```dart
  /// focusNode.addListener(() { print(myFocusNode.hasFocus); });
  /// ```
  ///
  /// If null, this widget will create its own [FocusNode].
  ///
  /// ## Keyboard
  ///
  /// Requesting the focus will typically cause the keyboard to be shown
  /// if it's not showing already.
  ///
  /// On Android, the user can hide the keyboard - without changing the focus -
  /// with the system back button. They can restore the keyboard's visibility
  /// by tapping on a text field.  The user might hide the keyboard and
  /// switch to a physical keyboard, or they might just need to get it
  /// out of the way for a moment, to expose something it's
  /// obscuring. In this case requesting the focus again will not
  /// cause the focus to change, and will not make the keyboard visible.
  ///
  /// This widget builds an [EditableText] and will ensure that the keyboard is
  /// showing when it is tapped by calling [EditableTextState.requestKeyboard()].
  final FocusNode? focusNode;

  /// The decoration to show around the text field.
  ///
  /// By default, draws a horizontal line under the text field but can be
  /// configured to show an icon, label, hint text, and error text.
  ///
  /// Specify null to remove the decoration entirely (including the
  /// extra padding introduced by the decoration to save space for the labels).
  final InputDecoration? decoration;

  /// {@macro flutter.widgets.editableText.keyboardType}
  final TextInputType keyboardType;

  /// The type of action button to use for the keyboard.
  ///
  /// Defaults to [TextInputAction.newline] if [keyboardType] is
  /// [TextInputType.multiline] and [TextInputAction.done] otherwise.
  final TextInputAction? textInputAction;

  /// {@macro flutter.widgets.editableText.textCapitalization}
  final TextCapitalization textCapitalization;

  /// The style to use for the text being edited.
  ///
  /// This text style is also used as the base style for the [decoration].
  ///
  /// If null, defaults to the `subtitle1` text style from the current [Theme].
  final TextStyle? style;

  /// {@macro flutter.widgets.editableText.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.widgets.editableText.textAlign}
  final TextAlign textAlign;

  /// {@macro flutter.material.InputDecorator.textAlignVertical}
  final TextAlignVertical? textAlignVertical;

  /// {@macro flutter.widgets.editableText.textDirection}
  final TextDirection? textDirection;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.editableText.obscuringCharacter}
  final String obscuringCharacter;

  /// {@macro flutter.widgets.editableText.obscureText}
  final bool obscureText;

  /// {@macro flutter.widgets.editableText.autocorrect}
  final bool autocorrect;

  /// {@macro flutter.services.TextInputConfiguration.smartDashesType}
  final SmartDashesType smartDashesType;

  /// {@macro flutter.services.TextInputConfiguration.smartQuotesType}
  final SmartQuotesType smartQuotesType;

  /// {@macro flutter.services.TextInputConfiguration.enableSuggestions}
  final bool enableSuggestions;

  /// {@macro flutter.widgets.editableText.maxLines}
  ///  * [expands], which determines whether the field should fill the height of
  ///    its parent.
  final int? maxLines;

  /// {@macro flutter.widgets.editableText.minLines}
  ///  * [expands], which determines whether the field should fill the height of
  ///    its parent.
  final int? minLines;

  /// {@macro flutter.widgets.editableText.expands}
  final bool expands;

  /// {@macro flutter.widgets.editableText.readOnly}
  final bool readOnly;

  /// Configuration of toolbar options.
  ///
  /// If not set, select all and paste will default to be enabled. Copy and cut
  /// will be disabled if [obscureText] is true. If [readOnly] is true,
  /// paste and cut will be disabled regardless.
  final ToolbarOptions toolbarOptions;

  /// {@macro flutter.widgets.editableText.showCursor}
  final bool? showCursor;

  /// If [maxLength] is set to this value, only the "current input length"
  /// part of the character counter is shown.
  static const int noMaxLength = -1;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  ///
  /// If set, a character counter will be displayed below the
  /// field showing how many characters have been entered. If set to a number
  /// greater than 0, it will also display the maximum number allowed. If set
  /// to [TextField.noMaxLength] then only the current character count is displayed.
  ///
  /// After [maxLength] characters have been input, additional input
  /// is ignored, unless [maxLengthEnforcement] is set to
  /// [MaxLengthEnforcement.none].
  ///
  /// The text field enforces the length with a [LengthLimitingTextInputFormatter],
  /// which is evaluated after the supplied [inputFormatters], if any.
  ///
  /// This value must be either null, [TextField.noMaxLength], or greater than 0.
  /// If null (the default) then there is no limit to the number of characters
  /// that can be entered. If set to [TextField.noMaxLength], then no limit will
  /// be enforced, but the number of characters entered will still be displayed.
  ///
  /// Whitespace characters (e.g. newline, space, tab) are included in the
  /// character count.
  ///
  /// If [maxLengthEnforcement] is [MaxLengthEnforcement.none], then more than
  /// [maxLength] characters may be entered, but the error counter and divider
  /// will switch to the [decoration]'s [InputDecoration.errorStyle] when the
  /// limit is exceeded.
  ///
  /// {@macro flutter.services.lengthLimitingTextInputFormatter.maxLength}
  final int? maxLength;

  /// Determines how the [maxLength] limit should be enforced.
  ///
  /// {@macro flutter.services.textFormatter.effectiveMaxLengthEnforcement}
  ///
  /// {@macro flutter.services.textFormatter.maxLengthEnforcement}
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// {@macro flutter.widgets.editableText.onChanged}
  ///
  /// See also:
  ///
  ///  * [inputFormatters], which are called before [onChanged]
  ///    runs and can validate and change ("format") the input value.
  ///  * [onEditingComplete], [onSubmitted]:
  ///    which are more specialized input change notifications.
  final ValueChanged<String>? onChanged;

  /// {@macro flutter.widgets.editableText.onEditingComplete}
  final VoidCallback? onEditingComplete;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  ///
  /// See also:
  ///
  ///  * [TextInputAction.next] and [TextInputAction.previous], which
  ///    automatically shift the focus to the next/previous focusable item when
  ///    the user is done editing.
  final ValueChanged<String>? onSubmitted;

  /// {@macro flutter.widgets.editableText.onAppPrivateCommand}
  final AppPrivateCommandCallback? onAppPrivateCommand;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  /// If false the text field is "disabled": it ignores taps and its
  /// [decoration] is rendered in grey.
  ///
  /// If non-null this property overrides the [decoration]'s
  /// [InputDecoration.enabled] property.
  final bool? enabled;

  /// {@macro flutter.widgets.editableText.cursorWidth}
  final double cursorWidth;

  /// {@macro flutter.widgets.editableText.cursorHeight}
  final double? cursorHeight;

  /// {@macro flutter.widgets.editableText.cursorRadius}
  final Radius? cursorRadius;

  /// The color of the cursor.
  ///
  /// The cursor indicates the current location of text insertion point in
  /// the field.
  ///
  /// If this is null it will default to the ambient
  /// [DefaultSelectionStyle.cursorColor]. If that is null, and the
  /// [ThemeData.platform] is [TargetPlatform.iOS] or [TargetPlatform.macOS]
  /// it will use [CupertinoThemeData.primaryColor]. Otherwise it will use
  /// the value of [ColorScheme.primary] of [ThemeData.colorScheme].
  final Color? cursorColor;

  /// Controls how tall the selection highlight boxes are computed to be.
  ///
  /// See [ui.BoxHeightStyle] for details on available styles.
  final ui.BoxHeightStyle selectionHeightStyle;

  /// Controls how wide the selection highlight boxes are computed to be.
  ///
  /// See [ui.BoxWidthStyle] for details on available styles.
  final ui.BoxWidthStyle selectionWidthStyle;

  /// The appearance of the keyboard.
  ///
  /// This setting is only honored on iOS devices.
  ///
  /// If unset, defaults to [ThemeData.brightness].
  final Brightness? keyboardAppearance;

  /// {@macro flutter.widgets.editableText.scrollPadding}
  final EdgeInsets scrollPadding;

  /// {@macro flutter.widgets.editableText.enableInteractiveSelection}
  final bool enableInteractiveSelection;

  /// {@macro flutter.widgets.editableText.selectionControls}
  final TextSelectionControls? selectionControls;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@template flutter.material.textfield.onTap}
  /// Called for each distinct tap except for every second tap of a double tap.
  ///
  /// The text field builds a [GestureDetector] to handle input events like tap,
  /// to trigger focus requests, to move the caret, adjust the selection, etc.
  /// Handling some of those events by wrapping the text field with a competing
  /// GestureDetector is problematic.
  ///
  /// To unconditionally handle taps, without interfering with the text field's
  /// internal gesture detector, provide this callback.
  ///
  /// If the text field is created with [enabled] false, taps will not be
  /// recognized.
  ///
  /// To be notified when the text field gains or loses the focus, provide a
  /// [focusNode] and add a listener to that.
  ///
  /// To listen to arbitrary pointer events without competing with the
  /// text field's internal gesture detector, use a [Listener].
  /// {@endtemplate}
  final GestureTapCallback? onTap;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  ///
  /// If [mouseCursor] is a [MaterialStateProperty<MouseCursor>],
  /// [WidgetStateProperty.resolve] is used for the following [WidgetState]s:
  ///
  ///  * [WidgetState.error].
  ///  * [WidgetState.hovered].
  ///  * [WidgetState.focused].
  ///  * [WidgetState.disabled].
  ///
  /// If this property is null, [WidgetStateMouseCursor.textable] will be used.
  ///
  /// The [mouseCursor] is the only property of [TextField] that controls the
  /// appearance of the mouse pointer. All other properties related to "cursor"
  /// stand for the text cursor, which is usually a blinking vertical line at
  /// the editing position.
  final MouseCursor? mouseCursor;

  /// Callback that generates a custom [InputDecoration.counter] widget.
  ///
  /// See [InputCounterWidgetBuilder] for an explanation of the passed in
  /// arguments.  The returned widget will be placed below the line in place of
  /// the default widget built when [InputDecoration.counterText] is specified.
  ///
  /// The returned widget will be wrapped in a [Semantics] widget for
  /// accessibility, but it also needs to be accessible itself. For example,
  /// if returning a Text widget, set the [Text.semanticsLabel] property.
  ///
  /// {@tool snippet}
  /// ```dart
  /// Widget counter(
  ///   BuildContext context,
  ///   {
  ///     required int currentLength,
  ///     required int? maxLength,
  ///     required bool isFocused,
  ///   }
  /// ) {
  ///   return Text(
  ///     '$currentLength of $maxLength characters',
  ///     semanticsLabel: 'character count',
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  ///
  /// If buildCounter returns null, then no counter and no Semantics widget will
  /// be created at all.
  final InputCounterWidgetBuilder? buildCounter;

  /// {@macro flutter.widgets.editableText.scrollPhysics}
  final ScrollPhysics? scrollPhysics;

  /// {@macro flutter.widgets.editableText.scrollController}
  final ScrollController? scrollController;

  /// {@macro flutter.widgets.editableText.autofillHints}
  /// {@macro flutter.services.AutofillConfiguration.autofillHints}
  final Iterable<String>? autofillHints;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// {@template flutter.material.textfield.restorationId}
  /// Restoration ID to save and restore the state of the text field.
  ///
  /// If non-null, the text field will persist and restore its current scroll
  /// offset and - if no [controller] has been provided - the content of the
  /// text field. If a [controller] has been provided, it is the responsibility
  /// of the owner of that controller to persist and restore it, e.g. by using
  /// a [RestorableTextEditingController].
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in
  ///    Flutter.
  /// {@endtemplate}
  final String? restorationId;

  /// {@macro flutter.widgets.editableText.scribbleEnabled}
  final bool scribbleEnabled;

  /// {@macro flutter.services.TextInputConfiguration.enableIMEPersonalizedLearning}
  final bool enableIMEPersonalizedLearning;

  /// Enables the form to veto attempts by the user to dismiss the [ModalRoute]
  /// that contains the form.
  ///
  /// If the callback returns a Future that resolves to false, the form's route
  /// will not be popped.
  ///
  /// See also:
  ///
  ///  * [WillPopScope], another widget that provides a way to intercept the
  ///    back button.
  final WillPopCallback? onWillPop;

  final Widget Function(BuildContext, EditableTextState)? contextMenuBuilder;

  final Function(String)? onFieldSubmitted;

  @override
  State<TextFieldSuperValidationWithIcon> createState() =>
      _TextFieldSuperValidationWithIconState();
}

class _TextFieldSuperValidationWithIconState
    extends State<TextFieldSuperValidationWithIcon> {
  /// {@macro flutter.widgets.editableText.selectionEnabled}
  bool get selectionEnabled => widget.enableInteractiveSelection;
  TextEditingController get controller =>
      widget.controller ?? _buildController();
  TextEditingController? _controller;
  TextEditingController _buildController() {
    _controller ??= TextEditingController();

    return _controller!;
  }

  SuperValidation get superValidation => widget.superValidation;
  late FocusNode focusNode = widget.focusNode ?? FocusNode();
  late StreamSubscription<String> _textSubscription;
  late StreamSubscription<String?> _validationSubscription;
  Stream<String?> get validationStream {
    final altValidation = widget.altValidation;
    if (altValidation != null) {
      return altValidation.streamValidation;
    }
    return superValidation.streamValidation;
  }

  String? get validationText {
    final altValidation = widget.altValidation;
    if (altValidation != null) {
      return altValidation.validation;
    }
    return superValidation.validation;
  }

  @override
  void initState() {
    super.initState();
    controller.value = formatText(superValidation.value);
    controller.addListener(_onControllerChanged);
    _validationSubscription = validationStream.listen(_listenValidation);
    _textSubscription =
        superValidation.textFieldStream.listen(_listenTextField);
    if (validationText != null &&
        widget.autovalidateMode == AutovalidateMode.always) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _formKey.currentState?.validate();
      });
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    if (widget.controller == null) controller.dispose();
    if (widget.focusNode == null) focusNode.dispose();
    _validationSubscription.cancel();
    _textSubscription.cancel();
    super.dispose();
  }

  void _onControllerChanged() {
    if (widget.onlyValidationOnTextChange) {
      if (controller.text == superValidation.value) {
        return;
      }
    }
    superValidation.controllerSetText(controller.text);
  }

  void _listenValidation(String? event) {
    _formKey.currentState?.validate();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var decoration = widget.decoration ??
        const InputDecoration()
            .applyDefaults(Theme.of(context).inputDecorationTheme);
    InputDecoration newDecoration;
    if (widget.counterBuilder != null) {
      newDecoration = decoration.copyWith(
          errorStyle: decoration.errorStyle?.copyWith(height: 0, fontSize: 0) ??
              const TextStyle(height: 0, fontSize: 0),
          counter: const SizedBox.shrink());
    } else {
      newDecoration = decoration.copyWith(
        errorStyle: decoration.errorStyle?.copyWith(height: 0, fontSize: 0) ??
            const TextStyle(height: 0, fontSize: 0),
      );
    }
    return Form(
      key: _formKey,
      onWillPop: widget.onWillPop,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            key: widget.key,
            validator: (txt) {
              return validationText;
            },
            autovalidateMode: widget.autovalidateMode,
            obscuringCharacter: widget.obscuringCharacter,
            obscureText: widget.obscureText,
            autocorrect: widget.autocorrect,
            smartDashesType: widget.smartDashesType,
            smartQuotesType: widget.smartQuotesType,
            enableSuggestions: widget.enableSuggestions,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            expands: widget.expands,
            maxLengthEnforcement: widget.maxLengthEnforcement,
            maxLength: widget.maxLength,
            onChanged: widget.onChanged,
            onEditingComplete: widget.onEditingComplete,
            onFieldSubmitted: widget.onFieldSubmitted,
            controller: controller,
            focusNode: focusNode,
            decoration: newDecoration,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            textCapitalization: widget.textCapitalization,
            style: widget.style,
            strutStyle: widget.strutStyle,
            textAlign: widget.textAlign,
            textAlignVertical: widget.textAlignVertical,
            textDirection: widget.textDirection,
            autofocus: widget.autofocus,
            toolbarOptions: widget.toolbarOptions,
            readOnly: widget.readOnly,
            showCursor: widget.showCursor,
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled,
            cursorWidth: widget.cursorWidth,
            cursorHeight: widget.cursorHeight,
            cursorRadius: widget.cursorRadius,
            cursorColor: widget.cursorColor,
            keyboardAppearance: widget.keyboardAppearance,
            scrollPadding: widget.scrollPadding,
            enableInteractiveSelection: widget.enableInteractiveSelection,
            selectionControls: widget.selectionControls,
            onTap: widget.onTap,
            mouseCursor: widget.mouseCursor,
            buildCounter: widget.buildCounter,
            scrollPhysics: widget.scrollPhysics,
            scrollController: widget.scrollController,
            autofillHints: widget.autofillHints,
            restorationId: widget.restorationId,
            enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
          ),
          needWithCounter ? validationWithCounter() : validationWithoutCounter()
        ],
      ),
    );
  }

  bool get needWithCounter {
    return widget.counterBuilder != null && widget.maxLength != null;
  }

  Widget validationWithCounter() {
    return SuperValidationEnumBuilder<String?>(
        superValidation: superValidation,
        builder: (context, text) {
          text ??= '';
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: validationWithoutCounter()),
              counterWidget(text.length, widget.maxLength ?? 0)
            ],
          );
        });
  }

  Widget validationWithoutCounter() {
    return SuperValidationBuilder(
        superValidation: widget.altValidation ?? superValidation,
        builder: (context, validation, isValid) {
          if (!isValid) {
            return errorValidationBuilder(
                context, validation, widget.errorIcon, widget.errorSuffix);
          }
          return const SizedBox();
        });
  }

  Widget counterWidget(int current, int max) {
    return widget.counterBuilder?.call(context, current, max) ??
        const SizedBox.shrink();
  }

  ErrorValidationBuilder get errorValidationBuilder =>
      widget.errorValidationBuilder ?? _defaultErrorValidationBuilder;
  Widget _defaultErrorValidationBuilder(BuildContext context,
      String? validation, Widget errorPrefix, Widget errorSuffix) {
    return Container(
        alignment: widget.alignment,
        padding: widget.padding,
        margin: widget.margin,
        decoration: widget.containerDecoration,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            errorPrefix,
            Expanded(
              child: Text(
                validation ?? '',
                style: widget.decoration?.errorStyle ??
                    TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
            errorSuffix,
          ],
        ));
  }

  void _listenTextField(String event) {
    final hasFocus = focusNode.hasFocus;
    controller.value = formatText(event);
    if (hasFocus) {
      focusNode.requestFocus();
    }
  }

  TextEditingValue formatText(String? event) {
    var value = widget.inputFormatters?.fold<TextEditingValue>(
          TextEditingValue(
            text: event ?? '',
            selection: TextSelection.collapsed(offset: event?.length ?? 0),
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
          text: event ?? '',
          selection: TextSelection.collapsed(offset: event?.length ?? 0),
        );
    if (value.selection.start < 1) {
      if (value.text.isEmpty) {
        value =
            value.copyWith(selection: const TextSelection.collapsed(offset: 0));
      } else {
        value =
            value.copyWith(selection: const TextSelection.collapsed(offset: 1));
      }
    }
    return value;
  }
}
