import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/base/base_model.dart';
/// Created by Balaji Malathi on 5/26/2024 at 22:53.

class UpiViewModel extends BaseModel with BaseViewModel {
  @override
  void setContext(BuildContext context) => this.context = context;

  //region Variable Initialization
  String uid = "";

  //endregion
  @override
  void init() {
    uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  }
}
