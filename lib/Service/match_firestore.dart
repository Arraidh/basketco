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

  Future<void> deleteMatch(String docID) {
    return matches.doc(docID).delete();
  }
}
