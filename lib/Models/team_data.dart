import 'package:cloud_firestore/cloud_firestore.dart';

class TeamData {
  final String? id;
  final String? namaTeam;
  final String? pemain;
  final String? jersey;
  final String? asalTeam;
  final String? waktu;

  TeamData({
    this.id,
    this.namaTeam,
    this.pemain,
    this.jersey,
    this.asalTeam,
    this.waktu,
  });

  factory TeamData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    return TeamData(
      id: doc.id,
      namaTeam: json['nama_team'],
      pemain: json['pemain'],
      jersey: json['jersey'],
      asalTeam: json['asal_team'],
      waktu: json['waktu'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_team': namaTeam,
      'pemain': pemain,
      'jersey': jersey,
      'asal_team': asalTeam,
      'waktu': waktu,
      'timestamp': Timestamp.now(),
    };
  }
}

// class Player {
//   final String? namaPemain;
//   final String? nomorJersey;
//   final String? asalPemain;
//
//   Player({
//     this.namaPemain,
//     this.nomorJersey,
//     this.asalPemain,
//   });
//
//   factory Player.fromJson(Map<String, dynamic> json) {
//     return Player(
//       namaPemain: json['nama_pemain'],
//       nomorJersey: json['nomor_jersey'],
//       asalPemain: json['asal_pemain'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'nama_pemain': namaPemain,
//       'nomor_jersey': nomorJersey,
//       'asal_pemain': asalPemain,
//     };
//   }
// }
