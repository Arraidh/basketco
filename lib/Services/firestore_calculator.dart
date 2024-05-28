import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  //get collection of notes
  final CollectionReference calculator = FirebaseFirestore.instance.collection(
      'calculator');


  //Create
  Future<void> addNote() {
    return calculator.add({
      'poin': 0,
      'kehilanganPoin': 0,
      'timestamp': Timestamp.now(),
    });
  }
}