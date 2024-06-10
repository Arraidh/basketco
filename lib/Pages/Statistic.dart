import 'package:basketco/Models/calculator.dart';
import 'package:basketco/Models/match_data.dart';
import 'package:basketco/Service/match_firestore.dart';
import 'package:basketco/Utils/Colors.dart';
import 'package:flutter/material.dart';

class StatisticPage extends StatefulWidget {
  final MatchData matchData;

  StatisticPage({required this.matchData});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  FirestoreService firestoreService = FirestoreService();

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
      body: StreamBuilder<List<Calculator>>(
        stream: firestoreService.getCalculatorStreamFromMatch(widget.matchData.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildLoadingIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            final calculatorData = snapshot.data!;
            final actionTypes = calculatorData.map((calc) => calc.action?.nama ?? '').toSet().toList();

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: getColumns(actionTypes),
                rows: getRows(calculatorData, actionTypes),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  List<DataColumn> getColumns(List<String> actionTypes) {
    List<DataColumn> columns = [
      const DataColumn(
        label: Text(
          'Nomor Punggung',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      const DataColumn(
        label: Text(
          'PTS',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      const DataColumn(
        label: Text(
          'FGM',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      const DataColumn(
        label: Text(
          'FGA',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      const DataColumn(
        label: Text(
          'FG%',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      const DataColumn(
        label: Text(
          'FTM',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      const DataColumn(
        label: Text(
          'FTA',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      const DataColumn(
        label: Text(
          'FT%',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ];

    for (String actionType in actionTypes) {
      if (actionType != 'Made' && actionType != 'Missed') {
        columns.add(
          DataColumn(
            label: Text(
              actionType,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    }

    return columns;
  }

  List<DataRow> getRows(List<Calculator> calculatorData, List<String> actionTypes) {
    List<DataRow> rows = [];

    for (String nomorPunggung in calculatorData.map((calc) => calc.nomorPunggung).toSet()) {
      // Initialize statistics values
      int pts = 0;
      int fgm = 0;
      int fga = 0;
      int ftm = 0;
      int fta = 0;

      // Iterate over calculatorData to calculate statistics for each player
      for (Calculator calc in calculatorData) {
        if (calc.nomorPunggung == nomorPunggung) {
          if (calc.action?.nama == 'Made') {
            if (calc.action?.value == 1) {
              ftm++;
            } else if (calc.action?.value == 2 || calc.action?.value == 3) {
              fgm++;
            }
          } else if (calc.action?.nama == 'Missed') {
            if (calc.action?.value == 1) {
              fta++;
            } else if (calc.action?.value == 2 || calc.action?.value == 3) {
              fga++;
            }
          }
        }
      }

      pts = (fgm * 2) + (ftm * 1); // Points calculation

      double fgPercentage = fga != 0 ? (fgm / fga) * 100 : 0;
      double ftPercentage = fta != 0 ? (ftm / fta) * 100 : 0;

      List<DataCell> cells = [
        DataCell(
          Text(
            nomorPunggung,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        DataCell(
          Text(
            pts.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        DataCell(
          Text(
            fgm.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        DataCell(
          Text(
            fga.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        DataCell(
          Text(
            fgPercentage.toStringAsFixed(2) + '%',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        DataCell(
          Text(
            ftm.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        DataCell(
          Text(
            fta.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        DataCell(
          Text(
            ftPercentage.toStringAsFixed(2) + '%',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ];

      // Add action values for each player
      for (String actionType in actionTypes) {
        if (actionType != 'Made' && actionType != 'Missed') {
          int actionValue = calculatorData
              .where((calc) => calc.nomorPunggung == nomorPunggung && calc.action?.nama == actionType)
              .map((calc) => calc.action?.value == 0 ? 1 : calc.action?.value ?? 0)
              .fold(0, (previousValue, element) => previousValue + element);

          cells.add(
            DataCell(
              Text(
                actionValue.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        } else {
          cells.add(DataCell(Text('')));
        }
      }

      rows.add(DataRow(cells: cells));
    }

    return rows;
  }

}
