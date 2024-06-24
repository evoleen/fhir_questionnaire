import 'package:example/pages/examples/questionnaire_builder_page.dart';
import 'package:example/pages/examples/questionnaire_view_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: const Text('QuestionnaireView Demo'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const QuestionnaireViewPage(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('QuestionnaireBuilder Demo'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const QuestionnaireBuilderPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
