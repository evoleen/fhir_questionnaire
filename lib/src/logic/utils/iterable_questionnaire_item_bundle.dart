import 'package:fhir_questionnaire/src/model/questionnaire_item_bundle.dart';

extension IteratableItemBundle on Iterable<QuestionnaireItemBundle> {
  /// Takes a list [QuestionnaireItemBundle] flattens it by extracting all the
  /// child items and putting them all in one list.
  ///
  /// Can be used for searching/filtering a list of [QuestionnaireItemBundle] objects
  List<QuestionnaireItemBundle> flatten() {
    return _flatten(toList());
  }

  List<QuestionnaireItemBundle> _flatten(
    List<QuestionnaireItemBundle> itemBundles,
  ) {
    final flattenedList = <QuestionnaireItemBundle>[];

    for (var itemBundle in itemBundles) {
      flattenedList.add(itemBundle);
      if (itemBundle.children?.isNotEmpty == true) {
        flattenedList.addAll(_flatten(itemBundle.children!));
      }
    }

    return flattenedList;
  }
}
