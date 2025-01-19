import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../view/history/expense.model.dart';

/// Created by Balaji Malathi on 5/25/2024 at 18:24.

class FirestoreService {
  FirestoreService._privateConstructor();

  static final FirestoreService instance =
      FirestoreService._privateConstructor();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  int _getYear() {
    return DateTime.now().year;
  }

  Future<void> insert(String collectionPath, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionPath).add(data);
    } catch (e) {
      debugPrint("Error inserting document: $e");
    }
  }

  Future<void> update(String collectionPath, String documentId,
      Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionPath).doc(documentId).update(data);
    } catch (e) {
      debugPrint("Error updating document: $e");
    }
  }

  Future<DocumentSnapshot> fetch(
      String collectionPath, String documentId) async {
    try {
      DocumentSnapshot doc =
          await _db.collection(collectionPath).doc(documentId).get();
      return doc;
    } catch (e) {
      debugPrint("Error fetching document: $e");
      rethrow;
    }
  }

  Future<void> delete(String collectionPath, String documentId) async {
    try {
      await _db.collection(collectionPath).doc(documentId).delete();
    } catch (e) {
      debugPrint("Error deleting document: $e");
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
      debugPrint("Error inserting or updating document: $e");
    }
  }

  Future<List<QueryDocumentSnapshot>> fetchCollection(
      String collectionPath) async {
    try {
      QuerySnapshot querySnapshot = await _db.collection(collectionPath).get();
      return querySnapshot.docs;
    } catch (e) {
      debugPrint("Error fetching collection: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchExpensesWithCategory() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime startOfNextDay = startOfDay.add(const Duration(days: 1));
    int year = now.year;
    Timestamp startOfDayTimestamp = Timestamp.fromDate(startOfDay);
    Timestamp startOfNextDayTimestamp = Timestamp.fromDate(startOfNextDay);

    try {
      QuerySnapshot expensesSnapshot = await _db
          .collection('/${FirebaseAuth.instance.currentUser?.uid}/expense/$year')
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
      debugPrint("Error fetching expenses with category: $e");
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
        .collection('/$uid/budget/${_getYear()}')
        .where("year", isEqualTo: DateTime.now().year)
        .where("month", isEqualTo: monthMapInverse[DateTime.now().month])
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      budgetDocId = querySnapshot.docs.first.id;
    } else {
      throw Exception(
          "No budget document found for the specified month and year");
    }

    final budgetRef = _db.collection('/$uid/budget/${_getYear()}').doc(budgetDocId);

    await _db.runTransaction((transaction) async {
      // Get the budget document
      DocumentSnapshot budgetSnapshot = await transaction.get(budgetRef);
      if (!budgetSnapshot.exists) {
        throw Exception("Budget document does not exist!");
      }

      // Calculate the new balance
      double currentBalance = budgetSnapshot['balance'].toDouble();
      double newBalance = currentBalance - double.parse(dd["expense"].toString());

      // Update the budget balance
      transaction.update(budgetRef, {'balance': newBalance});
    }).then((_) {
      debugPrint('Transaction successfully completed');
    }).catchError((error) {
      debugPrint('Failed to complete transaction: $error');
    });
  }

  Future<double> getBalance(String uid) async {
    QuerySnapshot querySnapshot = await _db
        .collection('/$uid/budget/${_getYear()}')
        .where("year", isEqualTo: DateTime.now().year)
        .where("month", isEqualTo: monthMapInverse[DateTime.now().month])
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return double.parse(querySnapshot.docs.first.get("balance").toString());
    } else {
      throw Exception(
          "No budget document found for the specified month and year");
    }
  }

  Future<List<Expense>> getExpenses(String uid) async {

    QuerySnapshot expensesSnapshot = await _db
        .collection(
            '/${FirebaseAuth.instance.currentUser?.uid}/expense/${DateTime.now().year}')
        .orderBy("createdAt", descending: true)
        .get();

    List<Expense> expenses = [];

    for (var expenseDoc in expensesSnapshot.docs) {
      var expenseData = expenseDoc.data() as Map<String, dynamic>;
      String categoryId = expenseData['category'];
      DocumentSnapshot categoryDoc = await _db
          .collection(
              '/${FirebaseAuth.instance.currentUser?.uid}/master/category')
          .doc(categoryId)
          .get();
      var categoryData = categoryDoc.data() as Map<String, dynamic>;

      expenses.add(Expense(
          expense: double.parse(expenseData['expense'].toString()),
          category: Category(
              name: categoryData['name'],
              icon: categoryData['icon'],
              color: categoryData['color']),
          createdAt: (expenseData['createdAt'] as Timestamp).toDate()));
    }

    return expenses;
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
