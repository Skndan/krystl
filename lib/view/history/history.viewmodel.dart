import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/base/base_model.dart';
import '../../core/network/firebase_manager.dart';
import 'expense.model.dart';

/// Created by Balaji Malathi on 6/5/2024 at 22:31.

class HistoryViewModel extends BaseModel with BaseViewModel {
  @override
  void setContext(BuildContext context) => this.context = context;

  //region Variable Initialization
  final FirestoreService _firestoreService = FirestoreService.instance;

  String? profile = "", displayName = "";
  String uid = "";

  //endregion
  @override
  void init() {
    uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  Future<List<Expense>> fetchExpenses() async {
    final querySnapshot = await _firestoreService.getExpenses(uid);
    return querySnapshot;
  }

  Map<String, List<Expense>> groupExpensesByDate(List<Expense> expenses) {
    final Map<String, List<Expense>> groupedExpenses = {};

    for (final expense in expenses) {
      final dateKey = DateFormat('yyyy-MM-dd').format(expense.createdAt);
      if (groupedExpenses.containsKey(dateKey)) {
        groupedExpenses[dateKey]!.add(expense);
      } else {
        groupedExpenses[dateKey] = [expense];
      }
    }

    return groupedExpenses;
  }
}
