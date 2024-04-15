import 'package:flutter/material.dart';
import 'package:survey_kit/src/answer_format/scale_answer_format.dart';
import 'package:survey_kit/src/result/question/scale_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

class ScaleAnswerView extends StatefulWidget {
  final QuestionStep questionStep;
  final ScaleQuestionResult? result;

  const ScaleAnswerView({
    Key? key,
    required this.questionStep,
    required this.result,
  }) : super(key: key);

  @override
  _ScaleAnswerViewState createState() => _ScaleAnswerViewState();
}

class _ScaleAnswerViewState extends State<ScaleAnswerView> {
  late final DateTime _startDate;
  late final ScaleAnswerFormat _scaleAnswerFormat;
  late double _sliderValue;
  List<double> _slidersList = [];
  int _indexToSliders = 0;
  bool yaSeContesto = false;
  List sliderOpciones = [];

  @override
  void initState() {
    super.initState();
    _scaleAnswerFormat = widget.questionStep.answerFormat as ScaleAnswerFormat;
    // print(_scaleAnswerFormat.opciones.length);
    // print('--------------------------------');
    // print(widget.result?.result);
    // print('--------------------------------');
    _sliderValue = widget.result?.result ?? _scaleAnswerFormat.defaultValue;
    _startDate = DateTime.now();
    if ( _scaleAnswerFormat.opciones.length > 0) {
      _scaleAnswerFormat.opciones.forEach((e) {
        _slidersList.add(0.toDouble());
      });
    } else {
      _slidersList.add(0.toDouble());
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_scaleAnswerFormat.opciones.length > 0) {
      sliderOpciones = _scaleAnswerFormat.opciones.map((opcion) {
        int idx = _scaleAnswerFormat.opciones.indexOf(opcion);
        // print('Index: $idx');
        return Padding(
          padding: EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  'Valor seleccionado: ${_slidersList[idx].toInt().toString()}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          opcion.titulo.toString(),
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          opcion.titulo2.toString(),
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Slider.adaptive(
                    value: _slidersList[idx],
                    onChanged: (double value) {
                      setState(() {
                        _slidersList[idx] = value;
                        opcion.valor = value.toString();
                        yaSeContesto = true;
                      });
                    },
                    min: _scaleAnswerFormat.minimumValue,
                    max: _scaleAnswerFormat.maximumValue,
                    activeColor: Theme.of(context).primaryColor,
                    divisions: ((_scaleAnswerFormat.maximumValue -
                                _scaleAnswerFormat.minimumValue) ~/
                            _scaleAnswerFormat.step)
                        .abs(),
                    // divisions: 1,
                    label: _slidersList[idx].toString(),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList();
    } else {
      sliderOpciones = [
        Padding(
          padding: EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  'Valor seleccionado: ${_sliderValue.toInt().toString()}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _scaleAnswerFormat.minimumValueDescription,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          _scaleAnswerFormat.maximumValueDescription,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Slider.adaptive(
                    value: _sliderValue,
                    onChanged: (double value) {
                      setState(() {
                        _sliderValue = value;
                        yaSeContesto = true;
                      });
                    },
                    min: _scaleAnswerFormat.minimumValue,
                    max: _scaleAnswerFormat.maximumValue,
                    activeColor: Theme.of(context).primaryColor,
                    divisions: ((_scaleAnswerFormat.maximumValue -
                                _scaleAnswerFormat.minimumValue) ~/
                            _scaleAnswerFormat.step)
                        .abs(),
                    // divisions: 1,
                    label: _sliderValue.toString(),
                  ),
                ],
              ),
            ],
          ),
        )
      ];
    }
    

    return StepView(
      step: widget.questionStep,
      resultFunction: () => ScaleQuestionResult(
        id: widget.questionStep.stepIdentifier,
        startDate: _startDate,
        endDate: DateTime.now(),
        valueIdentifier: _scaleAnswerFormat.opciones.length > 0 ? _slidersList.join(',') : _sliderValue.toString(),
        // result: _sliderValue,
        result: _scaleAnswerFormat.opciones.length > 0? _slidersList[0].toDouble() : _sliderValue.toDouble(),
      ),
      title: widget.questionStep.title.isNotEmpty
        ? Text(
            widget.questionStep.title,
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          )
        : widget.questionStep.content,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0, left: 14.0, right: 14.0),
            child: Text(
              widget.questionStep.text,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          ...sliderOpciones
        ],
      ),
    );
  }
}
