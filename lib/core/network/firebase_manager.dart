import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Created by Balaji Malathi on 5/25/2024 at 18:24.

class FirestoreService {
  FirestoreService._privateConstructor();

  static final FirestoreService instance =
      FirestoreService._privateConstructor();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> insert(String collectionPath, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionPath).add(data);
    } catch (e) {
      print("Error inserting document: $e");
    }
  }

  Future<void> update(String collectionPath, String documentId,
      Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionPath).doc(documentId).update(data);
    } catch (e) {
      print("Error updating document: $e");
    }
  }

  Future<DocumentSnapshot> fetch(
      String collectionPath, String documentId) async {
    try {
      DocumentSnapshot doc =
          await _db.collection(collectionPath).doc(documentId).get();
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

  Future<void> insertOrUpdate(String collectionPath, String documentId,
      Map<String, dynamic> data) async {
    try {
      DocumentSnapshot doc =
          await _db.collection(collectionPath).doc(documentId).get();
      if (doc.exists) {
        await _db.collection(collectionPath).doc(documentId).update(data);
      } else {
        await _db.collection(collectionPath).doc(documentId).set(data);
      }
    } catch (e) {
      print("Error inserting or updating document: $e");
    }
  }

  Future<List<QueryDocumentSnapshot>> fetchCollection(
      String collectionPath) async {
    try {
      QuerySnapshot querySnapshot = await _db.collection(collectionPath).get();
      return querySnapshot.docs;
    } catch (e) {
      print("Error fetching collection: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchExpensesWithCategory() async {
    try {
      QuerySnapshot expensesSnapshot = await _db
          .collection('/${FirebaseAuth.instance.currentUser?.uid}/expense/2024')
          .get();
      List<Map<String, dynamic>> expenses = [];

      for (var expenseDoc in expensesSnapshot.docs) {
        var expenseData = expenseDoc.data() as Map<String, dynamic>;
        String categoryId = expenseData['category'];
        DocumentSnapshot categoryDoc = await _db
            .collection(
                '/${FirebaseAuth.instance.currentUser?.uid}/master/category')
            .doc(categoryId)
            .get();
        var categoryData = categoryDoc.data() as Map<String, dynamic>;

        expenses.add({
          'expense': expenseData['expense'],
          'date': expenseData['createdAt'],
          'category': {
            'name': categoryData['name'],
            'icon': categoryData['icon'],
            'color': categoryData['color']
          },
        });
      }

      return expenses;
    } catch (e) {
      print("Error fetching expenses with category: $e");
      rethrow;
    }
  }

  Stream<DocumentSnapshot> listenToDocument(
      String collectionPath, String documentId) {
    return _db.collection(collectionPath).doc(documentId).snapshots();
  }

  Stream<QuerySnapshot> listenToCollection(String collectionPath) {
    return _db.collection(collectionPath).snapshots();
  }
}
