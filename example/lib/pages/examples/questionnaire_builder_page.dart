import 'package:example/questionnaire_samples.dart';
import 'package:fhir/r4.dart';
import 'package:fhir_questionnaire/fhir_questionnaire.dart';
import 'package:flutter/material.dart';

class QuestionnaireBuilderPage extends StatefulWidget {
  const QuestionnaireBuilderPage({super.key});

  @override
  State<QuestionnaireBuilderPage> createState() =>
      _QuestionnaireBuilderPageState();
}

class _QuestionnaireBuilderPageState extends State<QuestionnaireBuilderPage> {
  late QuestionnaireController _questionnaireController;

  @override
  void initState() {
    super.initState();
    _questionnaireController = QuestionnaireController(
      questionnaire:
          Questionnaire.fromJsonString(QuestionnaireSamples.sampleWithGroups),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: QuestionnaireBuilder(
        controller: _questionnaireController,
        builder: (context, items) {
          print('build method is called');
          print('items ${items.length}');
          return Column(
            children: items.map((e) => e.view).toList(),
          );
        },
      ),
    );
  }
}
