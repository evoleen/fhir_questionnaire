import 'package:collection/collection.dart';
import 'package:fhir/r4.dart';
import 'package:fhir_questionnaire/fhir_questionnaire.dart';
import 'package:fhir_questionnaire/src/model/questionnaire_item_bundle.dart';
import 'package:flutter/widgets.dart';

class QuestionnaireController
    extends ValueNotifier<QuestionnaireControllerData> {
  QuestionnaireController({
    required this.questionnaire,
    this.onAttachmentLoaded,
  }) : super(
          QuestionnaireControllerData(
            itemBundles: [],
          ),
        );

  final Questionnaire questionnaire;

  /// Necessary callback when Questionnaire has items of type = `attachment`
  /// so the logic of loading an Attachment is handled outside of the logic
  /// of QuestionnaireView
  final Future<Attachment?> Function()? onAttachmentLoaded;

  Future<void> buildQuestionnaireItems() async {
    final items = QuestionnaireLogic.buildQuestionnaireItems(
      questionnaire.item,
      onAttachmentLoaded: onAttachmentLoaded,
    );

    value = value.copyWith(itemBundles: items);
  }
}

class QuestionnaireControllerData {
  QuestionnaireControllerData({
    required this.itemBundles,
  });

  final List<QuestionnaireItemBundle> itemBundles;

  QuestionnaireControllerData copyWith({
    List<QuestionnaireItemBundle>? itemBundles,
  }) =>
      QuestionnaireControllerData(
        itemBundles: itemBundles ?? this.itemBundles,
      );

  @override
  bool operator ==(Object other) =>
      other is QuestionnaireControllerData &&
      itemBundles.equals(other.itemBundles);

  @override
  int get hashCode => Object.hash(itemBundles, 10);
}
