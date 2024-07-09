import 'dart:async';
import 'dart:ui';

import 'package:example/pages/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

StreamController<InputDecorationTheme?> inputDecorationThemeStream =
    StreamController<InputDecorationTheme>.broadcast();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InputDecorationTheme?>(
      stream: inputDecorationThemeStream.stream,
      initialData: null,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'FHIR Questionnaire Demo',
          scrollBehavior: const CustomScrollBehavior(),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
            inputDecorationTheme: snapshot.data,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  static const _webScrollPhysics =
      BouncingScrollPhysics(parent: RangeMaintainingScrollPhysics());

  const CustomScrollBehavior() : super();

  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      kIsWeb ? _webScrollPhysics : super.getScrollPhysics(context);
}
