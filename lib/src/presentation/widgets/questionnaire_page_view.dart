import 'package:fhir/r4.dart';
import 'package:fhir_questionnaire/fhir_questionnaire.dart';
import 'package:flutter/material.dart';

///
class QuestionnairePageView extends StatefulWidget {
  /// The Questionnaire definition.
  final Questionnaire questionnaire;

  /// Get the QuestionnaireResponse once the user taps on Submit button.
  final ValueChanged<QuestionnaireResponse> onSubmit;

  /// Necessary callback when Questionnaire has items of type = `attachment`
  /// so the logic of loading an Attachment is handled outside of the logic
  /// of QuestionnaireView
  final Future<Attachment?> Function()? onAttachmentLoaded;

  /// To indicate there is an ongoing loading process
  final bool isLoading;

  /// Indicates what should be the fallback localization if locale is not
  /// supported.
  /// Defaults to English
  final QuestionnaireBaseLocalization? defaultLocalization;

  /// Indicates the definition of extra supported localizations.
  /// By default Spanish and English are supported, but you can set
  /// other localizations on this List to be considered.
  final List<QuestionnaireBaseLocalization>? localizations;

  /// The expected locale to show, by default Platform locale is used.
  final String? locale;
  const QuestionnairePageView({
    super.key,
    required this.questionnaire,
    required this.onSubmit,
    this.onAttachmentLoaded,
    this.isLoading = false,
    this.defaultLocalization,
    this.localizations,
    this.locale,
  });

  @override
  State createState() => QuestionnairePageViewState();
}

class QuestionnairePageViewState extends State<QuestionnairePageView>
    with WidgetsBindingObserver {
  static const fabSize = kFloatingActionButtonMargin + 56;
  double questionnaireTitleHeight = 0;
  bool isKeyboardVisible = false;
  bool scrollReachedBottom = false;
  final showFAB = ValueNotifier<bool>(false);
  Questionnaire get questionnaire => widget.questionnaire;
  List<QuestionnaireItem> get questionnaireItems => questionnaire.item ?? [];

  late final double bottomPadding;
  List<QuestionnaireItemBundle> itemBundles = [];

  bool _isLoading = true;

  void loading(bool value) {
    if (_isLoading != value) setState(() => _isLoading = value);
  }

  bool get isLoading => widget.isLoading || _isLoading;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(onCreated);
    bottomPadding = FlutterViewUtils.get().padding.bottom;
    if (!widget.isLoading) {
      String? locale;
      try {
        locale = widget.locale ??
            FlutterViewUtils.get().platformDispatcher.locale.languageCode;
      } catch (_) {}
      QuestionnaireLocalization.instance.init(
        defaultLocalization: widget.defaultLocalization,
        localizations: widget.localizations,
        locale: locale,
      );
      buildQuestionnaireItems();
    }
  }

  void onCreated(_) {
    if (!widget.isLoading) {
      calculateQuestionnaireTitleHeight();
    }
  }

  void calculateQuestionnaireTitleHeight() {
    try {
      questionnaireTitleHeight = ViewUtils.getTextHeightAfterRender(
        context: context,
        text: questionnaire.title!,
        padding:
            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 24.0),
        textStyle: Theme.of(context).textTheme.titleLarge,
      );
    } catch (_) {}
  }

  Future<void> buildQuestionnaireItems() async {
    itemBundles = await QuestionnaireController.buildQuestionnaireItems(
      questionnaire.item,
      onAttachmentLoaded: widget.onAttachmentLoaded,
    );
    loading(false);
  }

  int get listViewCount =>
      itemBundles.length + (questionnaire.title.isNotEmpty ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: showFAB,
        builder: (context, value, child) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: !showFAB.value ? const SizedBox() : child,
          );
        },
        child: FractionallySizedBox(
          key: ValueKey('showFAB: ${showFAB.value}'),
          widthFactor: 0.8,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding > 0 ? 0 : 16),
            child: FloatingActionButton.extended(
              shape: const StadiumBorder(),
              onPressed: isLoading ? null : onSubmit,
              label: Text(
                  QuestionnaireLocalization.instance.localization.btnSubmit),
            ),
          ),
        ),
      ),
      body: UnfocusView(
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: QuestionnaireLoadingView(),
              )
            : Scrollbar(
                child: ListView.builder(
                    primary: true,
                    addAutomaticKeepAlives: true,
                    padding: const EdgeInsets.only(
                        top: 16, left: 16, right: 16, bottom: fabSize + 64),
                    shrinkWrap: true,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemBuilder: (context, index) {
                      if (index == 0 && questionnaire.title.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 24.0,
                          ),
                          child: Text(
                            questionnaire.title!,
                            style: theme.textTheme.titleLarge
                                ?.copyWith(color: theme.colorScheme.primary),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return itemBundles[
                              index - (questionnaire.title.isNotEmpty ? 1 : 0)]
                          .view;
                    },
                    // separatorBuilder: (context, index) =>
                    //     const SizedBox(height: 24.0),
                    itemCount: listViewCount),
              ),
      ),
    );
  }

  bool validate() {
    setState(() {});
    bool isValid = true;
    FieldController? controller;
    double tempOffset = questionnaireTitleHeight;
    double indexOffset = 0;
    for (int i = 0; i < itemBundles.length; ++i) {
      final item = itemBundles[i];
      if (!item.controller.validate() && isValid) {
        isValid = false;
        indexOffset = tempOffset;
        controller = item.controller;
      }
      tempOffset += item.controller.size.height;
    }
    // TODOO: validation should happen and should navigate to invalid page or WHAT :shrug
    // scrollToField(controller: controller, indexOffset: indexOffset);
    return isValid;
  }

  void onSubmit() {
    if (validate()) {
      final questionnaireResponse = QuestionnaireController.generateResponse(
          questionnaire: questionnaire, itemBundles: itemBundles);
      // if (kDebugMode) {
      //   var prettyString = const JsonEncoder.withIndent('  ')
      //       .convert(questionnaireResponse.toJson());
      //   print('''
      //   ========================================================================
      //   $prettyString
      //   ========================================================================
      //   ''');
      //   return;
      // }
      widget.onSubmit(questionnaireResponse);
    }
  }

  @override
  void dispose() {
    showFAB.dispose();
    WidgetsBinding.instance.removeObserver(this);
    for (final item in itemBundles) {
      item.controller.focusNode?.dispose();
    }
    super.dispose();
  }
}
