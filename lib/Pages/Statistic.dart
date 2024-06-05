import 'package:basketco/Models/calculator.dart';
import 'package:basketco/Models/match_data.dart';
import 'package:basketco/Service/match_firestore.dart';
import 'package:basketco/Utils/Colors.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class StatisticPage extends StatefulWidget {

  final MatchData matchData;

  StatisticPage({required this.matchData});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  FirestoreService firestoreService = FirestoreService();
  List<Calculator> calculatorData = [];
  List<String> actionTypes = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final calculators = await firestoreService.getCalculatorsFromMatch(widget.matchData.id!);
      setState(() {
        calculatorData = calculators;
        actionTypes = calculatorData.map((calc) => calc.action?.nama ?? '').toSet().toList();
      });
    } catch (error) {
      print("Failed to fetch calculators: $error");
    }
  }

  List<DataColumn> getColumns() {
    List<DataColumn> columns = [
      const DataColumn(
        label: Text(
          'Nomor Punggung',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ];

    for (String actionType in actionTypes) {
      columns.add(
        DataColumn(
          label: Text(
            actionType,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return columns;
  }

  List<DataRow> getRows() {
    List<DataRow> rows = [];

    for (String nomorPunggung in calculatorData.map((calc) => calc.nomorPunggung).toSet()) {
      List<DataCell> cells = [
        DataCell(
          Text(
            nomorPunggung,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ];

      for (String actionType in actionTypes) {
        int value = calculatorData
            .where((calc) => calc.nomorPunggung == nomorPunggung && calc.action?.nama == actionType)
            .map((calc) => calc.action?.value ?? 0)
            .sum;
        cells.add(
          DataCell(
            Text(
              value.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }

      rows.add(DataRow(cells: cells));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BasketcoColors.darkBackground,
      appBar: AppBar(
        backgroundColor: BasketcoColors.midBackground,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: calculatorData.isEmpty
          ? buildLoadingIndicator()
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: getColumns(),
          rows: getRows(),
        ),
      ),
    );
  }

  Widget buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}