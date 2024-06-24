import 'package:collection/collection.dart';
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

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
            children: [
              ...items.map((e) {
                return [
                  if (e.item.type.value == 'choice')
                    const Text(
                      'type of this item is choice',
                      style: TextStyle(color: Colors.red),
                    ),
                  Container(
                    color: e.item.type.value == 'choice'
                        ? Colors.red.shade200
                        : null,
                    child: e.view,
                  ),
                ];
              }).flattened,
              ElevatedButton(
                onPressed: () {
                  final submitResult = _questionnaireController.submit();
                  if (submitResult.hasInvalidItems) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'there are ${submitResult.invalidItems.length} invalid answers. index of invalid answered items are ${submitResult.invalidItems.keys}',
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Success: QuestionnaireResponse created !!'),
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          );
        },
      ),
    );
  }
}
