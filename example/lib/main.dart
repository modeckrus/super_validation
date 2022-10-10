import 'package:example/utils/percent_input_formatter.dart';
import 'package:example/utils/zero_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_validation/super_validation.dart';

import 'test_bloc/test_bloc.dart';

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

class TestContent extends StatelessWidget {
  const TestContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.error),
            onPressed: () {
              context.read<TestBloc>().add(const TestValidateE(
                    validation: 'test',
                  ));
            },
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            child: const Icon(Icons.edit),
            onPressed: () {
              context.read<TestBloc>().add(const TestSetTextE(
                    text: 'text',
                  ));
            },
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            child: const Icon(Icons.run_circle),
            onPressed: () {
              context.read<TestBloc>().add(const TestInitializeE());
            },
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            child: const Icon(Icons.file_copy),
            onPressed: () {
              context
                  .read<TestBloc>()
                  .fileValidation
                  .addFile(const FileManaged(id: 'id', path: 'path'));
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
              SuperValidationMultyBuilder(
                  superValidation: {
                    'string': context.read<TestBloc>().stringValidation,
                    'number': context.read<TestBloc>().numberValidation,
                    'file': context.read<TestBloc>().fileValidation,
                    'enum': context.read<TestBloc>().enumValidation,
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
              TextFieldSuperValidation(
                superValidation: context.read<TestBloc>().numberValidation,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  PercentInputFormatter(defaultValue: 0, mantissaLength: 1),
                  ZeroPercentFormatter()
                ],
                decoration: InputDecoration(
                  labelText: 'Number',
                  suffix: IconButton(
                      onPressed: () {
                        context.read<TestBloc>().numberValidation.text = '0';
                      },
                      icon: const Icon(Icons.clear)),
                ),
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
              SuperValidationSimpleMultyBuilder(
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
