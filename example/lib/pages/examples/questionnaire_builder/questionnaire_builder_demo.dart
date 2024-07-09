import 'package:collection/collection.dart';
import 'package:example/pages/examples/questionnaire_builder/custom_radio_button_questionnaire_item_view.dart';
import 'package:example/questionnaire_samples.dart';
import 'package:fhir/r4.dart';
import 'package:fhir_questionnaire/fhir_questionnaire.dart';
import 'package:flutter/material.dart';

class QuestionnaireBuilderDemo extends StatefulWidget {
  const QuestionnaireBuilderDemo({super.key});

  @override
  State<QuestionnaireBuilderDemo> createState() =>
      _QuestionnaireBuilderDemoState();
}

class _QuestionnaireBuilderDemoState extends State<QuestionnaireBuilderDemo> {
  late QuestionnaireController _questionnaireController;

  @override
  void initState() {
    super.initState();
    _questionnaireController = QuestionnaireController(
      questionnaire:
          Questionnaire.fromJsonString(QuestionnaireSamples.sampleWithGroups),
      overrideQuestionnaireItemMapper: (
        item,
        onAttachmentLoaded,
        enableWhenController,
      ) {
        print('custom map function called');
        print('item type: ${item.type.value}');
        if (item.type.value == 'choice') {
          return CustomQuestionnaireRadioButtonChoiceItemView(
            item: item,
            enableWhenController: enableWhenController,
          );
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: QuestionnaireBuilder(
        controller: _questionnaireController,
        builder: (context, items) {
          for (final item in items) {
            print('groupId: ${item.groupId} - id: ${item.item.linkId}');
          }

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
