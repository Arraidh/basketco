import 'package:basketco/Models/calculator.dart';
import 'package:basketco/Models/team_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference teams =
    FirebaseFirestore.instance.collection('basketcoteams');

  Future<void> addTeam(TeamData team) {
    return teams.add(team.toJson());
  }

  Stream<List<TeamData>> getTeamStream() {
    return teams
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TeamData.fromFirestore(doc);
      }).toList();
    });
  }

  Future<TeamData?> getTeam(String teamId) async {
    try {
      DocumentSnapshot doc = await teams.doc(teamId).get();
      if (doc.exists) {
        return TeamData.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching team data: $e');
      return null;
    }
  }

  Future<void> updateTeam(String docID, TeamData team) {
    return teams.doc(docID).update(team.toJson());
  }

  Future<void> updateCalculatorTeam(String? docID, Calculator calculator) {
    return teams.doc(docID).update({"calculator": FieldValue.arrayUnion([calculator.toJson()])});
  }

  Future<void> deleteTeam(String docID) {
    return teams.doc(docID).delete();
  }
}
