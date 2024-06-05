import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:krystl/core/extensions/context_extension.dart';

/// Created by Balaji Malathi on 5/25/2024 at 22:42.

import '../../core/base/base_model.dart';
import 'budget.model.dart';
import 'budget.widget.dart';

class BudgetViewModel extends BaseModel with BaseViewModel {
  @override
  void setContext(BuildContext context) => this.context = context;

  //region Variable Initialization
  String uid = "";

  //endregion
  @override
  void init() {
    uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  void checkBudget() {}

  void addBudget(BudgetModel? document) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return BudgetFormWidget(
            formKey: formKey,
            initialValue: document?.toJson() ?? {},
          );
        }).then((value) {});
  }

  DateTime now = DateTime.now();
  Map<String, int> monthMap = {
    'January': 1,
    'February': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'September': 9,
    'October': 10,
    'November': 11,
    'December': 12,
  };

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

  Color checkYear(month, year) {
    int? givenMonth = monthMap[month];
    if (now.year == year && now.month == givenMonth) {
      return context.colors.primaryContainer;
    } else {
      return context.colors.primaryContainer.withOpacity(0.2);
    }
  }

  Color checkYearText(month, year) {
    int? givenMonth = monthMap[month];
    if (now.year == year && now.month == givenMonth) {
      return context.colors.onSecondary;
    } else {
      return context.colors.primary;
    }
  }

}
