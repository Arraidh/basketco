import 'package:cloud_firestore/cloud_firestore.dart';

class MatchData {
  final String? id;
  final String? waktu;
  final String? venue;
  final String? terang;
  final String? gelap;
  final String? KU;
  final String? pool;
  final String? terangPemain;
  final String? gelapPemain;
  final String? terangId;
  final String? gelapId;
  final String? tanggalPlain;
  final String? tanggal;
  final String? jam;

  MatchData({
    this.id,
    this.waktu,
    this.venue,
    this.terang,
    this.gelap,
    this.KU,
    this.pool,
    this.terangPemain,
    this.gelapPemain,
    this.terangId,
    this.gelapId,
    this.tanggalPlain,
    this.tanggal,
    this.jam,
  });

  factory MatchData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    return MatchData(
      id: doc.id,
      waktu: json['waktu'],
      venue: json['venue'],
      terang: json['terang'],
      gelap: json['gelap'],
      KU: json['KU'],
      pool: json['pool'],
      terangPemain: json['terang_pemain'],
      gelapPemain: json['gelap_pemain'],
      terangId: json['terang_id'],
      gelapId: json['gelap_id'],
      tanggalPlain: json['tanggal_plain'],
      tanggal: json['tanggal'],
      jam: json['jam'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'waktu': waktu,
      'venue': venue,
      'terang': terang,
      'gelap': gelap,
      'KU': KU,
      'pool': pool,
      'terang_pemain': terangPemain,
      'gelap_pemain': gelapPemain,
      'terang_id': terangId,
      'gelap_id': gelapId,
      'tanggal_plain': tanggalPlain,
      'tanggal': tanggal,
      'jam': jam,
      'timestamp': Timestamp.now(),
    };
  }
}
