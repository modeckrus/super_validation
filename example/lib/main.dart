import 'package:example/custom_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:super_validation/super_validation.dart';

import 'test_bloc/test_bloc.dart';
import 'widgets/check_widget.dart';
import 'widgets/percent_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: const TestProvider());
  }
}

class TestProvider extends StatelessWidget {
  const TestProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TestBloc(),
      child: const TestContent(),
    );
  }
}

class TestCounterStyle extends StatefulWidget {
  const TestCounterStyle({super.key});

  @override
  State<TestCounterStyle> createState() => _TestCounterStyleState();
}

class _TestCounterStyleState extends State<TestCounterStyle> {
  final SuperValidation superValidation = SuperValidation()
    ..validation = 'test' * 8;

  @override
  void dispose() {
    superValidation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFieldSuperValidationWithIcon(
            superValidation: superValidation,
            maxLength: 200,
            counterBuilder: (context, currentLength, maxLength) => Text(
              '$currentLength/$maxLength',
            ),
          )
        ],
      ),
    );
  }
}

class TestContent extends StatefulWidget {
  const TestContent({super.key});

  @override
  State<TestContent> createState() => _TestContentState();
}

class _TestContentState extends State<TestContent> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton.icon(
            label: const Text('error'),
            icon: const Icon(Icons.error),
            onPressed: () {
              context.read<TestBloc>().add(const TestValidateE(
                    validation: 'test',
                  ));
            },
          ),
          const SizedBox(
            width: 10,
          ),
          TextButton.icon(
            label: const Text('edit'),
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.read<TestBloc>().add(const TestSetTextE(
                    text: 'text',
                  ));
            },
          ),
          const SizedBox(
            width: 10,
          ),
          TextButton.icon(
            label: const Text('run'),
            icon: const Icon(Icons.run_circle),
            onPressed: () {
              context.read<TestBloc>().add(const TestInitializeE());
            },
          ),
          const SizedBox(
            width: 10,
          ),
          TextButton.icon(
            label: const Text('file'),
            icon: const Icon(Icons.file_copy),
            onPressed: () {
              context
                  .read<TestBloc>()
                  .fileValidation
                  .addFile(const FileManaged(id: 'id', path: 'path'));
            },
          ),
          const SizedBox(
            width: 10,
          ),
          TextButton.icon(
            label: const Text('stringEnum null'),
            icon: const Icon(Icons.eco_rounded),
            onPressed: () {
              context.read<TestBloc>().stringEnumValidation.value = null;
            },
          ),
        ],
      ),
      body: BlocBuilder<TestBloc, TestState>(
        buildWhen: (previous, current) =>
            previous.runtimeType != current.runtimeType,
        builder: (context, state) {
          if (state is TestLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: [
              SuperValidationMultiBuilder(
                  superValidation: {
                    'string': context.read<TestBloc>().stringValidation,
                    'number': context.read<TestBloc>().numberValidation,
                    'file': context.read<TestBloc>().fileValidation,
                    'enum': context.read<TestBloc>().enumValidation,
                    'address': context.read<TestBloc>().addressValidation,
                  },
                  builder: (context, validation, isValid) {
                    return Text(
                      validation.isEmpty ? 'Valid' : validation.toString(),
                      style: TextStyle(
                        color: isValid ? Colors.green : Colors.red,
                      ),
                    );
                  }),
              BlocBuilder<TestBloc, TestState>(
                builder: (context, state) {
                  if (state is TextStringS) {
                    return Column(
                      children: [
                        Text('Text: ${state.text}'),
                        Text('Validation: ${state.validation}'),
                      ],
                    );
                  }
                  return const Text('No text');
                },
              ),
              PercentFormNum(
                superValidation: context.read<TestBloc>().numberValidation,
                labelText: 'Percent',
              ),
              // TextFieldSuperValidation(
              //   superValidation: context.read<TestBloc>().stringValidation,
              // ),
              const SizedBox(
                height: 10,
              ),
              DropDownEnumField<TestEnum>(
                superValidation: context.read<TestBloc>().enumValidation,
                items: TestEnumM.mapName,
                autovalidateMode: AutovalidateMode.always,
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    final superValidation =
                        context.read<TestBloc>().stringEnumValidation;
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => Scaffold(
                              appBar: AppBar(),
                              body: CheckWidget(
                                superValidation: superValidation,
                                values: const ['Привет', 'Пока'],
                              ),
                            ));
                  },
                  child: const Text('Навигация')),

              SuperValidationEnumBuilder<String>(
                  superValidation:
                      context.read<TestBloc>().stringEnumValidation,
                  builder: (context, value) {
                    return SuperValidationTextFieldListener<String>(
                        transformer: (val) => val ?? '',
                        controller: _controller,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: value == null ? 'Выбранное значение' : null,
                        ),
                        superValidation:
                            context.read<TestBloc>().stringEnumValidation);
                  }),

              TextFieldSuperValidation(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                  ],
                  altValidation: context.read<TestBloc>().stringEnumValidation,
                  superValidation: context.read<TestBloc>().stringValidation),
              TextFieldSuperValidationWithIcon(
                decoration: const InputDecoration(errorMaxLines: 8),
                superValidation: SuperValidation()
                  ..validation = "Очень длинное сообщение об ошибке" * 8,
              ),
              AddressField(
                addressValidation: context.read<TestBloc>().addressValidation,
              ),
              SuperValidationSimpleMultiBuilder(
                  builder: (context, isValid) {
                    return ElevatedButton(
                      onPressed: isValid
                          ? () {
                              print('onPressed');
                            }
                          : null,
                      child: const Text('Validate'),
                    );
                  },
                  superValidation: [
                    context.read<TestBloc>().numberValidation,
                    context.read<TestBloc>().stringValidation,
                    context.read<TestBloc>().fileValidation,
                    context.read<TestBloc>().enumValidation,
                  ])
            ],
          );
        },
      ),
    );
  }
}

class AddressField extends StatefulWidget {
  final SuperValidationAddress addressValidation;
  const AddressField({
    super.key,
    required this.addressValidation,
  });

  @override
  State<AddressField> createState() => _AddressFieldState();
}

class _AddressFieldState extends State<AddressField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      widget.addressValidation.address(_controller.text, false);
    });
    widget.addressValidation.textFieldStream.listen((val) {
      _controller.text = val;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      textFieldConfiguration: TextFieldConfiguration(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Address',
          )),
      onSuggestionSelected: (suggestion) => {
        context.read<TestBloc>().addressValidation.address(suggestion, true)
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      suggestionsCallback: (pattern) => widget.addressValidation.suggestion,
    );
  }
}
