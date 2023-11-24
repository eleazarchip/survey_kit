import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/src/answer_format/multiple_choice_answer_format.dart';
import 'package:survey_kit/src/answer_format/text_choice.dart';
import 'package:survey_kit/src/result/question/multiple_choice_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/widget/selection_list_tile.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

class MultipleChoiceAnswerView extends StatefulWidget {
  final QuestionStep questionStep;
  final MultipleChoiceQuestionResult? result;

  const MultipleChoiceAnswerView({
    Key? key,
    required this.questionStep,
    required this.result,
  }) : super(key: key);

  @override
  _MultipleChoiceAnswerView createState() => _MultipleChoiceAnswerView();
}

class _MultipleChoiceAnswerView extends State<MultipleChoiceAnswerView> {
  late final DateTime _startDateTime;
  late final MultipleChoiceAnswerFormat _multipleChoiceAnswer;
  
  int numberSelected = 0;
  List<TextChoice> _selectedChoices = [];

  @override
  void initState() {
    super.initState();
    _multipleChoiceAnswer =
        widget.questionStep.answerFormat as MultipleChoiceAnswerFormat;
    _selectedChoices =
        widget.result?.result ?? _multipleChoiceAnswer.defaultSelection;
    _startDateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: widget.questionStep,
      resultFunction: () => MultipleChoiceQuestionResult(
        id: widget.questionStep.stepIdentifier,
        startDate: _startDateTime,
        endDate: DateTime.now(),
        valueIdentifier: _multipleChoiceAnswer.showNumbers ? 
          _multipleChoiceAnswer.textChoices.map((choices) => choices.text).join(',') :
          _selectedChoices.map((choices) => choices.value).join(','),
        result: _multipleChoiceAnswer.showNumbers ?
          _multipleChoiceAnswer.textChoices : 
           _selectedChoices,
      ),
      isValid: widget.questionStep.isOptional || _selectedChoices.isNotEmpty,
      title: widget.questionStep.title.isNotEmpty
          ? Text(
              widget.questionStep.title,
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            )
          : widget.questionStep.content,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          children: [
            _multipleChoiceAnswer.showNumbers ? const SizedBox.shrink() : Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Text(
                widget.questionStep.text,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              children: [
                Divider(
                  color: Colors.grey,
                ),

                if (_multipleChoiceAnswer.showNumbers) ...[
                  SizedBox(
                    height: 300,
                    child: ReorderableListView(
                      buildDefaultDragHandles: false,
                      children: <Widget>[
                        for (int index = 0; index < _multipleChoiceAnswer.textChoices.length; index++)
                          ListTile(
                            key: Key('$index'),
                            title: Text(
                              '${(index+1)}.  ${_multipleChoiceAnswer.textChoices[index].text}',
                            ),
                            trailing: ReorderableDragStartListener(
                              index: index,
                              child: const Icon(Icons.drag_handle),
                            ),
                          ),                        
                      ],
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final TextChoice item = _multipleChoiceAnswer.textChoices.removeAt(oldIndex);
                          _multipleChoiceAnswer.textChoices.insert(newIndex, item);
                        });
                      },
                    ),
                  )
                  
                ] else ...[
                  ..._multipleChoiceAnswer.textChoices
                    .map((TextChoice tc) => SelectionListTile(
                        text: tc.text,
                        onTap: () {
                          setState(
                            () {
                              if (_selectedChoices.contains(tc)) {
                                _selectedChoices.remove(tc);
                              } else {
                                if (_multipleChoiceAnswer.maxAnswers >
                                    _selectedChoices.length) {
                                  _selectedChoices = [..._selectedChoices, tc];
                                }
                              }
                            },
                          );
                        },
                        isSelected: _selectedChoices.contains(tc),
                      ),
                    )
                    .toList(),
                ],

                if (_multipleChoiceAnswer.otherField) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: ListTile(
                      title: TextField(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        onChanged: (v) {
                          int? currentIndex;
                          final otherTextChoice = _selectedChoices
                              .firstWhereIndexedOrNull((index, element) {
                            final isOtherField = element.text == 'Other';

                            if (isOtherField) {
                              currentIndex = index;
                            }

                            return isOtherField;
                          });

                          setState(() {
                            if (v.isEmpty && otherTextChoice != null) {
                              _selectedChoices.remove(otherTextChoice);
                            } else if (v.isNotEmpty) {
                              final updatedTextChoice =
                                  TextChoice(text: 'Other', value: v);
                              if (otherTextChoice == null) {
                                _selectedChoices.add(updatedTextChoice);
                              } else if (currentIndex != null) {
                                _selectedChoices[currentIndex!] =
                                    updatedTextChoice;
                              }
                            }
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Otro',
                          // labelStyle: Theme.of(context).textTheme.headlineSmall,
                          labelStyle: TextStyle(
                            color: Colors.black
                          ),
                          hintText: 'Escribe otro aquí',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
