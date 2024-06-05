import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/base/base_model.dart';
import '../../core/enums/app_theme.dart';
import '../../core/enums/pref.dart';
import '../../core/network/firebase_manager.dart';
import '../../core/notifier/theme_notifier.dart';
import '../../product/analytics/firebase.dart';
import 'home.widget.dart';

class HomeViewModel extends BaseModel with BaseViewModel {
  @override
  void setContext(BuildContext context) => this.context = context;

  //region Variable Initialization
  final FirestoreService _firestoreService = FirestoreService.instance;

  String? profile = "", displayName = "";
  String uid = "";

  double todayExpense = 0.0;
  double balance = 0.0;
  double dailyFuel = 0.0;

  //endregion

  @override
  Future<void> init() async {
    profile = localManager.getString(Pref.profile);
    displayName = localManager.getString(Pref.displayName);
    uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    notifyListeners();
  }

  AppThemes _appThemes = AppThemes.system;

  void changeTheme() {
    _appThemes =
        getTheme() == AppThemes.light ? AppThemes.dark : AppThemes.light;

    FBAnalytics.logEvent(name: "theme", parameters: {'theme': _appThemes.name});

    context.read<ThemeNotifier>().changeValue(_appThemes);
  }

  getTheme() {
    var theme = localManager.getString(Pref.theme);
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    if (theme == 'system') {
      return isDarkMode ? AppThemes.dark : AppThemes.light;
    }
    if (theme == 'light') {
      return AppThemes.light;
    }
    if (theme == 'dark') {
      return AppThemes.dark;
    }
  }

  void showExpenseDialog() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return ExpenseFormWidget(
            formKey: formKey,
            initialValue: const {},
          );
        }).then((value) async {
      await getExpenses();
      await getBalance();
    });
  }

  void checkBudget() {}

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

  List<QueryDocumentSnapshot> list = [];
  List<Map<String, dynamic>> expenses = [];

  Future getCategory() async {
    setState(ViewState.Busy);
    list = await _firestoreService.fetchCollection(
        "/${FirebaseAuth.instance.currentUser?.uid}/master/category");
    notifyListeners();
    setState(ViewState.Idle);
  }

  Future getExpenses() async {
    todayExpense = 0.0;
    setState(ViewState.Busy);
    expenses = await _firestoreService.fetchExpensesWithCategory();
    for (var item in expenses) {
      todayExpense += double.parse(item["expense"].toString());
    }
    notifyListeners();
    setState(ViewState.Idle);
  }

  Future getBalance() async {
    balance = 0;
    setState(ViewState.Busy);
    balance = await _firestoreService.getBalance(uid);

    int daysRemaining = getRemainingDaysInMonth() + 5;

    // get remaining days
    dailyFuel = balance / daysRemaining.toDouble();
    notifyListeners();
    setState(ViewState.Idle);
  }

  int getRemainingDaysInMonth() {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;

    // Get the first day of the next month
    DateTime firstDayOfNextMonth =
        (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);

    // Last day of the current month is one day before the first day of the next month
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(Duration(days: 1));

    // Calculate the remaining days
    int remainingDays =
        lastDayOfMonth.difference(now).inDays + 1; // +1 to include today

    return remainingDays;
  }
}
