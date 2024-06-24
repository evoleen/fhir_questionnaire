import 'package:fhir_questionnaire/fhir_questionnaire.dart';
import 'package:flutter/material.dart';

/// Created by luis901101 on 3/9/24.
class CustomQuestionnaireRadioButtonChoiceItemView
    extends QuestionnaireSingleChoiceItemView {
  CustomQuestionnaireRadioButtonChoiceItemView({
    super.key,
    super.controller,
    required super.item,
    super.isOpen,
    super.enableWhenController,
  });

  @override
  State createState() => _State();
}

class _State extends QuestionnaireSingleChoiceItemViewState<
    CustomQuestionnaireRadioButtonChoiceItemView> {
  @override
  Widget choiceView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: values
          .map(
            (answerOption) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () => onSelectedValueChanged(answerOption),
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(
                    selectedValue == answerOption ? Colors.green : Colors.black,
                  ),
                  backgroundColor: WidgetStatePropertyAll(Colors.grey.shade200),
                ),
                child: Text(valueNameResolver(answerOption)),
              ),
            ),
          )
          .toList(),
    );
  }
}
