import 'dart:async';
/// Created by Balaji Malathi on 5/26/2024 at 22:57.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlutterUpiApps {
  static const String payTM = "net.one97.paytm";
  static const String googlePay = "com.google.android.apps.nbu.paisa.user";
  static const String bhimUpi = "in.org.npci.upiapp";
  static const String phonePe = "com.phonepe.app";
  static const String miPay = "com.mipay.wallet.in";
  static const String amazonPay = "in.amazon.mShop.android.shopping";
  static const String trueCallerUPI = "com.truecaller";
  static const String myAirtelUPI = "com.myairtelapp";
}

class FlutterUpiResponse {
  String txnId = '';
  String responseCode = '';
  String approvalRefNo = '';
  String status = '';
  String txnRef = '';

  FlutterUpiResponse(String responseString) {
    List<String> parts = responseString.split('&');

    for (int i = 0; i < parts.length; ++i) {
      String key = parts[i].split('=')[0];
      String value = parts[i].split('=')[1];
      if (key == "txnId") {
        txnId = value;
      } else if (key == "responseCode") {
        responseCode = value;
      } else if (key == "ApprovalRefNo") {
        approvalRefNo = value;
      } else if (key.toLowerCase() == "status") {
        status = value;
      } else if (key == "txnRef") {
        txnRef = value;
      }
    }
  }
}

class FlutterUpi {
  static const MethodChannel _channel = const MethodChannel('skndan.com/flutter_upi');
  static Future<String> initiateTransaction(
      {required String app,
        required String pa,
        required String pn,
        String? mc,
        required String tr,
        required String tn,
        required String am,
        required String cu,
        required String url}) async {
    final String response = await _channel.invokeMethod('initiateTransaction', {
      "app": app,
      'pa': pa,
      'pn': pn,
      'mc': mc,
      'tr': tr,
      'tn': tn,
      'am': am,
      'cu': cu,
      'url': url
    });
    return response;
  }
}
