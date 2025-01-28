import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_upi_india/flutter_upi_india.dart';
import 'package:krystl/view/upi/upi.model.dart';

import '../../core/base/base_model.dart';
/// Created by Balaji Malathi on 5/26/2024 at 22:53.

class UpiViewModel extends BaseModel with BaseViewModel {
  @override
  void setContext(BuildContext context) => this.context = context;

  //region Variable Initialization
  String uid = "";

  UpiPayment? upiPayment;

  List<ApplicationMeta> apps = [];

  //endregion
  @override
  void init() {
    uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    getUpiApps();
  }

  Future getUpiApps() async {
    apps = await UpiPay.getInstalledUpiApplications(
        statusType: UpiApplicationDiscoveryAppStatusType.all);
    notifyListeners();
  }

  void parseUpi(String upi) {
    try {
      upiPayment = UpiPayment.fromUri(upi);
    } on FormatException {
      debugPrint("Format Exception");
    }
  }

}
