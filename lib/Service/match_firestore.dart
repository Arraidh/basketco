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

  Future<void> updateMatch(String docID, MatchData match) {
    return matches.doc(docID).update(match.toJson());
  }

  Future<void> deleteMatch(String docID) {
    return matches.doc(docID).delete();
  }
}
