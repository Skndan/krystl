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
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime startOfNextDay = startOfDay.add(Duration(days: 1));

    Timestamp startOfDayTimestamp = Timestamp.fromDate(startOfDay);
    Timestamp startOfNextDayTimestamp = Timestamp.fromDate(startOfNextDay);

    try {
      QuerySnapshot expensesSnapshot = await _db
          .collection('/${FirebaseAuth.instance.currentUser?.uid}/expense/2024')
          .where('createdAt', isGreaterThanOrEqualTo: startOfDayTimestamp)
          .where('createdAt', isLessThan: startOfNextDayTimestamp)
          .orderBy("createdAt", descending: true)
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

  Future updateBalance(String uid, Map<String, dynamic> dd) async {
//DocumentReference
    String budgetDocId = "";
    QuerySnapshot querySnapshot = await _db
        .collection('/${uid}/master/budget')
        .where("year", isEqualTo: DateTime.now().year)
        .where("month", isEqualTo: monthMapInverse[DateTime.now().month])
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      budgetDocId = querySnapshot.docs.first.id;
    } else {
      throw Exception(
          "No budget document found for the specified month and year");
    }

    final budgetRef = _db.collection('/$uid/master/budget').doc(budgetDocId);

    await _db.runTransaction((transaction) async {
      // Get the budget document
      DocumentSnapshot budgetSnapshot = await transaction.get(budgetRef);
      if (!budgetSnapshot.exists) {
        throw Exception("Budget document does not exist!");
      }

      // Calculate the new balance
      double currentBalance = budgetSnapshot['balance'].toDouble();
      double newBalance = currentBalance - double.parse(dd["expense"]);

      // Update the budget balance
      transaction.update(budgetRef, {'balance': newBalance});
    }).then((_) {
      print('Transaction successfully completed');
    }).catchError((error) {
      print('Failed to complete transaction: $error');
    });
  }

  Future<double> getBalance(String uid) async {
    QuerySnapshot querySnapshot = await _db
        .collection('/${uid}/master/budget')
        .where("year", isEqualTo: DateTime.now().year)
        .where("month", isEqualTo: monthMapInverse[DateTime.now().month])
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.get("balance");
    } else {
      throw Exception(
          "No budget document found for the specified month and year");
    }
  }
}

Map<int, String> monthMapInverse = {
  1: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'September',
  10: 'October',
  11: 'November',
  12: 'December',
};
