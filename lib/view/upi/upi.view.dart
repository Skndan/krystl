import 'package:flutter/material.dart';
import 'package:flutter_upi_pay/Src/payment.dart';
import 'package:krystl/product/components/keypad.dart';

import '../../product/package/flutter_upi.dart';

/// Created by Balaji Malathi on 5/26/2024 at 22:53.
class UpiView extends StatefulWidget {
  const UpiView({super.key});

  @override
  State<UpiView> createState() => _UpiViewState();
}

class _UpiViewState extends State<UpiView> {
  late GlobalKey<ScaffoldState> _key;

  @override
  void initState() {
    super.initState();
    _key = GlobalKey<ScaffoldState>();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<String> initTransaction(String app) async {
    String response = await FlutterUpi.initiateTransaction(
        app: app,
        pa: "apoorvaagarwal@upi",
        pn: "Apoorva Agarwal",
        tr: "TR1234",
        tn: "This is a test transaction",
        am: "5.00",
        cu: "INR",
        url: "https://www.google.com");
    print(response);

    return response;
  }

  String value = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text('Flutter UPI Plugin Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("${value}"),
            Keypad(onChanged: (value) {
              print(value);
              setState(() {

                this.value = value;
              });
            },),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: FutureBuilder(
            //     future: initTransaction(FlutterUpiApps.googlePay),
            //     builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting ||
            //           snapshot.data == null) {
            //         return Text("Processing or Yet to start...");
            //       } else {
            //         switch (snapshot.data.toString()) {
            //           case 'app_not_installed':
            //             return Text("Application not installed.");
            //             break;
            //           case 'invalid_params':
            //             return Text("Request parameters are wrong");
            //             break;
            //           case 'user_canceled':
            //             return Text("User canceled the flow");
            //             break;
            //           case 'null_response':
            //             return Text("No data received");
            //             break;
            //           default:
            //             {
            //               FlutterUpiResponse flutterUpiResponse =
            //               FlutterUpiResponse(snapshot.data);
            //               print(flutterUpiResponse.txnId);
            //               return Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: <Widget>[
            //                   Row(
            //                     mainAxisAlignment:
            //                     MainAxisAlignment.spaceBetween,
            //                     children: <Widget>[
            //                       Expanded(
            //                           flex: 2, child: Text("Transaction ID")),
            //                       Expanded(
            //                           flex: 3,
            //                           child: Text(flutterUpiResponse.txnId)),
            //                     ],
            //                   ),
            //                   Row(
            //                     mainAxisAlignment:
            //                     MainAxisAlignment.spaceBetween,
            //                     children: <Widget>[
            //                       Expanded(
            //                           flex: 2,
            //                           child: Text("Transaction Reference")),
            //                       Expanded(
            //                           flex: 3,
            //                           child: Text(flutterUpiResponse.txnRef)),
            //                     ],
            //                   ),
            //                   Row(
            //                     mainAxisAlignment:
            //                     MainAxisAlignment.spaceBetween,
            //                     children: <Widget>[
            //                       Expanded(
            //                           flex: 2,
            //                           child: Text("Transaction Status")),
            //                       Expanded(
            //                           flex: 3,
            //                           child: Text(flutterUpiResponse.status)),
            //                     ],
            //                   ),
            //                   Row(
            //                     mainAxisAlignment:
            //                     MainAxisAlignment.spaceBetween,
            //                     children: <Widget>[
            //                       Expanded(
            //                         flex: 2,
            //                         child: Text("Approval Reference Number"),
            //                       ),
            //                       Expanded(
            //                         flex: 3,
            //                         child: Text(
            //                             flutterUpiResponse.approvalRefNo ??
            //                                 ""),
            //                       ),
            //                     ],
            //                   ),
            //                   Row(
            //                     mainAxisAlignment:
            //                     MainAxisAlignment.spaceBetween,
            //                     children: <Widget>[
            //                       Expanded(
            //                         flex: 2,
            //                         child: Text("Response Code"),
            //                       ),
            //                       Expanded(
            //                         flex: 3,
            //                         child:
            //                         Text(flutterUpiResponse.responseCode),
            //                       ),
            //                     ],
            //                   ),
            //                 ],
            //               );
            //             }
            //         }
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Divider(
              height: 1.0,
              color: Colors.white,
            ),
            FilledButton(
              child: Text(
                "Pay Now with Google Pay",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                FlutterPayment flutterPayment = FlutterPayment();
                flutterPayment.launchUpi(
                    upiId: "7402187405@ybl",
                    name: "tester",
                    amount: "1",
                    message: "test",
                    currency: "INR");
                // initTransaction(FlutterUpiApps.googlePay);
                // setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
