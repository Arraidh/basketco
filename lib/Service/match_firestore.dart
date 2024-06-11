import 'package:basketco/Models/calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:basketco/Models/match_data.dart'; // Import MatchData

class FirestoreService {
  final CollectionReference matches =
      FirebaseFirestore.instance.collection('basketcomatch');

  Future<void> addMatch(MatchData match) {
    return matches.add(match.toJson());
  }

  Stream<List<MatchData>> getMatchStream() {
    return matches
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MatchData.fromFirestore(doc);
      }).toList();
    });
  }

  Future<MatchData?> getMatchPlayer(String matchId) async {
    try {
      DocumentSnapshot doc = await matches.doc(matchId).get();
      if (doc.exists) {
        return MatchData.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching match data: $e');
      return null;
    }
  }

  Future<void> updateMatch(String docID, MatchData match) {
    return matches.doc(docID).update(match.toJson());
  }

  Future<void> updateCalculatorMatch(String? docID, Calculator calculator) {
    return matches.doc(docID).update({"calculator": FieldValue.arrayUnion([calculator.toJson()])});
  }

  List<Map<String, dynamic>> calculatorsToJson(List<Calculator> events) {
    return events.map((event) => event.toJson()).toList();
  }

  Future<void> rewriteCalculatorMatch(String? docID, List<Calculator> calculator) {
    return matches.doc(docID).update({"calculator": calculatorsToJson(calculator)});
  }

  Future<List<Calculator>> getCalculatorsFromMatch(String matchId) async {
    try {
      DocumentSnapshot doc = await matches.doc(matchId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final calculatorList = data['calculator'] as List<dynamic>? ?? [];

        return calculatorList.map((calculatorData) {
          final actionData = calculatorData['action'] as Map<String, dynamic>?;
          final action = actionData != null
              ? CalculatorAction.fromJson(actionData)
              : CalculatorAction.empty();

          return Calculator(
            action: action,
            nomorPunggung: calculatorData['nomor_punggung'] as String? ?? '',
            quarter: calculatorData['quarter'] as String? ?? '',
            tim: calculatorData['tim'] as String? ?? '',
            time: calculatorData['time'] as int? ?? 0,
          );
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching calculator data: $e');
      return [];
    }
  }

  Stream<List<Calculator>> getCalculatorStreamFromMatch(String matchId) {
    return matches
        .doc(matchId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data == null) return [];

      if (data is Map<String, dynamic> && data.containsKey('calculator')) {
        final calculatorList =
        (data['calculator'] as List<dynamic>).cast<Map<String, dynamic>>();

        return calculatorList.map((calculatorData) {
          final actionData = calculatorData['action'] as Map<String, dynamic>?;
          final action = actionData != null
              ? CalculatorAction.fromJson(actionData)
              : CalculatorAction.empty();

          return Calculator(
            action: action,
            nomorPunggung: calculatorData['nomor_punggung'] as String? ?? '',
            quarter: calculatorData['quarter'] as String? ?? '',
            tim: calculatorData['tim'] as String? ?? '',
            time: calculatorData['time'] as int? ?? 0,
          );
        }).toList();
      } else {
        return [];
      }
    });
  }

  Future<void> deleteMatch(String docID) {
    return matches.doc(docID).delete();
  }

  Future<MatchData?> getMatchData(String matchId) async {
    try {
      DocumentSnapshot doc = await matches.doc(matchId).get();
      if (doc.exists) {
        return MatchData.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching match data: $e');
      return null;
    }
  }

  Future<void> deleteStatistics(String matchId) async {
    try {
      var matchDoc = matches.doc(matchId);
      await matchDoc.update({
        'calculator': FieldValue.delete(),  // Menghapus objek 'calculator' dari dokumen
      });
    } catch (e) {
      print('Failed to delete statistics: $e');
      rethrow;
    }
  }
}
