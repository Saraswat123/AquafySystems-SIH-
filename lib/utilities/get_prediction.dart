import 'package:tflite_flutter/tflite_flutter.dart';

Future<List<dynamic>> getPrediction() async {
  final efficiencyInterpreter =
      await Interpreter.fromAsset("assets/ml/efficiency.tflite");
  final lifespanInterpreter =
      await Interpreter.fromAsset("assets/ml/lifespan.tflite");

  final List<dynamic> efficiencyInput = [
    3.58,
    0.00,
    5.65,
    0.00,
    138.00,
  ];

  final List<dynamic> lifespanInput = [
    3.58,
    0.00,
    5.65,
    0.00,
    138.00,
  ];

  final efficiencyOutput =
      List<List<dynamic>>.filled(1, List<dynamic>.filled(1, 0));
  final lifespanOutput =
      List<List<dynamic>>.filled(1, List<dynamic>.filled(1, 0));

  efficiencyInterpreter.run(efficiencyInput, efficiencyOutput);
  lifespanInterpreter.run(lifespanInput, lifespanOutput);

  final efficiencyResult = efficiencyOutput[0];
  final lifespanResult = lifespanOutput[0];

  return [efficiencyResult, lifespanResult];
}

Future<List<dynamic>> getEfficiencyPrediction(double tds, double turbidity, double ph, double depth, double flowDischarge) async {
  final efficiencyInterpreter =
      await Interpreter.fromAsset("assets/ml/efficiency.tflite");

  final List<dynamic> efficiencyInput = [
    tds,
    turbidity,
    ph,
    depth,
    flowDischarge,
  ];

  final efficiencyOutput =
      List<List<dynamic>>.filled(1, List<dynamic>.filled(1, 0));
  
  efficiencyInterpreter.run(efficiencyInput, efficiencyOutput);

  final efficiencyResult = efficiencyOutput[0];

  return efficiencyResult;
}

Future<List<dynamic>> getLifespanPrediction(double tds, double turbidity, double ph, double depth, double flowDischarge) async {
  final lifespanInterpreter =
      await Interpreter.fromAsset("assets/ml/lifespan.tflite");

  final List<dynamic> lifespanInput = [
    tds,
    turbidity,
    ph,
    depth,
    flowDischarge,
  ];

  final lifespanOutput =
      List<List<dynamic>>.filled(1, List<dynamic>.filled(1, 0));

  lifespanInterpreter.run(lifespanInput, lifespanOutput);

  final lifespanResult = lifespanOutput[0];

  return lifespanResult;
}
