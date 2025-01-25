import 'package:flutter/material.dart';
import 'package:flutter_upi_pay/Src/payment.dart';
import 'package:krystl/core/extensions/string_extension.dart';
import 'package:krystl/product/components/keypad.dart';

import '../../product/package/flutter_upi.dart';

/// Created by Balaji Malathi on 5/26/2024 at 22:53.
class UpiView extends StatefulWidget {
  final String upi;

  const UpiView({super.key, required this.upi});

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

    return response;
  }

  String value = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(
          'Send Money',
          style:
              Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close)),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(value.toAmount,
                style:
                    const TextStyle(fontSize: 56, fontWeight: FontWeight.bold)),

            Keypad(
              onChanged: (value) {
                setState(() {
                  this.value = value;
                });
              },
            ),
            ElevatedButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  elevation: 0,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor:
                      Theme.of(context).colorScheme.onPrimaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  minimumSize:
                      Size((MediaQuery.of(context).size.width) - 16, 48),
                ),
                child: Text(
                  "data",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ))
          ],
        ),
      ),
    );
  }
}
