import 'package:cloud_firestore/cloud_firestore.dart';

class Calculator {
  final String quarter;
  final int time;
  final String tim;
  final String nomorPunggung;
  final CalculatorAction action;

  Calculator({
    required this.quarter,
    required this.time,
    required this.tim,
    required this.nomorPunggung,
    required this.action,
  });

  // factory Calculator.fromJson(Map<String, dynamic> json) {
  //   return Calculator(
  //     quarter: json['quarter'],
  //     time: json['time'] as int, // Cast to double if needed
  //     tim: json['tim'],
  //     nomorPunggung:  json['nomor_punggung'],
  //     action: CalculatorAction.fromJson(json['action']),
  //   );
  // }

  factory Calculator.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    return Calculator(
      quarter: json['quarter'],
      time: json['time'] as int,
      tim: json['tim'],
      nomorPunggung: json['nomor_punggung'],
      action: CalculatorAction.fromJson(json['action']),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'quarter': quarter,
      'time': time,
      'tim': tim,
      'nomor_punggung': nomorPunggung,
      'action': action.toJson(),
    };
  }
}

class CalculatorAction {
  final String nama;
  final int value;

  CalculatorAction({
    required this.nama,
    required this.value,
  });

  CalculatorAction.empty() : nama = '', value = 0;

  factory CalculatorAction.fromJson(Map<String, dynamic> json) {
    return CalculatorAction(
      nama: json['nama'],
      value: json['value'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'value': value,
    };
  }
}