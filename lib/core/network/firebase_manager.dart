import 'package:cloud_firestore/cloud_firestore.dart';

/// Created by Balaji Malathi on 5/25/2024 at 18:24.

class FirestoreService {
  FirestoreService._privateConstructor();
  static final FirestoreService instance = FirestoreService._privateConstructor();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> insert(String collectionPath, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionPath).add(data);
    } catch (e) {
      print("Error inserting document: $e");
    }
  }

  Future<void> update(String collectionPath, String documentId, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionPath).doc(documentId).update(data);
    } catch (e) {
      print("Error updating document: $e");
    }
  }

  Future<DocumentSnapshot> fetch(String collectionPath, String documentId) async {
    try {
      DocumentSnapshot doc = await _db.collection(collectionPath).doc(documentId).get();
      return doc;
    } catch (e) {
      print("Error fetching document: $e");
      rethrow;
    }
  }

  Future<void> delete(String collectionPath, String documentId) async {
    try {
      await _db.collection(collectionPath).doc(documentId).delete();
    } catch (e) {
      print("Error deleting document: $e");
    }
  }

  Future<void> insertOrUpdate(String collectionPath, String documentId, Map<String, dynamic> data) async {
    try {
      DocumentSnapshot doc = await _db.collection(collectionPath).doc(documentId).get();
      if (doc.exists) {
        await _db.collection(collectionPath).doc(documentId).update(data);
      } else {
        await _db.collection(collectionPath).doc(documentId).set(data);
      }
    } catch (e) {
      print("Error inserting or updating document: $e");
    }
  }

  Stream<DocumentSnapshot> listenToDocument(String collectionPath, String documentId) {
    return _db.collection(collectionPath).doc(documentId).snapshots();
  }

  Stream<QuerySnapshot> listenToCollection(String collectionPath) {
    return _db.collection(collectionPath).snapshots();
  }
}
