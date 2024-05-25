/// Created by Balaji Malathi on 5/25/2024 at 18:20.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/base/base_model.dart';
import '../../core/network/firebase_manager.dart';
import 'category.model.dart';
import 'category.widget.dart';

class CategoryViewModel extends BaseModel with BaseViewModel {
  @override
  void setContext(BuildContext context) => this.context = context;

  //region Variable Initialization
  final FirestoreService _fsService = FirestoreService.instance;
  String uid = "";
  //endregion

  @override
  void init() {
    uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  void addCategory(CategoryModel? document) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return CategoryFormWidget(
            formKey: formKey,
            initialValue: document?.toJson() ?? {},
          );
        }).then((value) {});
  }
}
