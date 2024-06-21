import 'package:fhir_questionnaire/src/model/questionnaire_item_bundle.dart';
import 'package:fhir_questionnaire/src/presentation/widgets/questionnaire_builder/questionnaire_controller.dart';
import 'package:flutter/material.dart';

class QuestionnaireBuilder extends StatefulWidget {
  final Widget? child;

  final QuestionnaireController controller;

  final Widget Function({
    required BuildContext context,
    List<QuestionnaireItemBundle> itemBundles,
  }) builder;

  const QuestionnaireBuilder({
    super.key,
    required this.controller,
    required this.builder,
    this.child,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<QuestionnaireBuilder> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, questionnaireControllerData, child) {
        return widget.builder(
          context: context,
          itemBundles: questionnaireControllerData.itemBundles,
        );
      },
      child: widget.child,
    );
  }
}
