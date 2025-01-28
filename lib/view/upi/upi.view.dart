import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_upi_india/flutter_upi_india.dart';
import 'package:krystl/core/base/base_view.dart';
import 'package:krystl/core/extensions/string_extension.dart';
import 'package:krystl/product/components/keypad.dart';
import 'package:krystl/view/upi/upi.viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/v8.dart';

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

  static const platform = MethodChannel('com.skndan.krystl/launch');

  @override
  void initState() {
    super.initState();
    _key = GlobalKey<ScaffoldState>();
  }

  String value = "";

  @override
  Widget build(BuildContext context) {
    return BaseView<UpiViewModel>(
          onModelReady: (UpiViewModel model) {
            model.setContext(context);
            model.init();
            model.parseUpi(widget.upi);
          },
          builder: (context, model, child) => Scaffold(
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
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Text(widget.upi),
                  Text(
                    'Paying to',
                    style:
                    Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
                  ),
                  Text(model.upiPayment?.payeeName ?? '',
                      style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(value.toAmount,
                      style:
                      const TextStyle(fontSize: 56, fontWeight: FontWeight.bold)),
                  Keypad(
                    onChanged: (value) {
                      setState(() {
                        this.value = value;
                        model.upiPayment?.amount = value;
                      });
                    },
                  ),
                  _androidApps(model)
                ],
              ),
            ),
          ),
    );
  }

  Widget _androidApps(UpiViewModel model) {
    return Container(
      margin: EdgeInsets.only(top: 32, bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
           _appsGrid(model.apps.map((e) => e).toList(), model),
        ],
      ),
    );
  }


  GridView _appsGrid(List<ApplicationMeta> apps, UpiViewModel model) {
    apps.sort((a, b) => a.upiApplication
        .getAppName()
        .toLowerCase()
        .compareTo(b.upiApplication.getAppName().toLowerCase()));
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      // childAspectRatio: 1.6,
      physics: NeverScrollableScrollPhysics(),
      children: apps
          .map(
            (it) => Material(
          key: ObjectKey(it.upiApplication),
          // color: Colors.grey[200],
          child: InkWell(
            onTap: Platform.isAndroid ? () async => await _onTap(it, model) : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                it.iconImage(48),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  alignment: Alignment.center,
                  child: Text(
                    it.upiApplication.getAppName(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          .toList(),
    );
  }


  Future<void> _onTap(ApplicationMeta app, UpiViewModel model) async {
    try {
      model.upiPayment?.transactionNote = "test";
      model.upiPayment?.transactionId = UuidV8().toString();

      print(model.upiPayment.toString());
      await platform.invokeMethod('launchUpi', {
        'uri': model.upiPayment.toString(),
        'packageName': app.packageName,
      });
    } on PlatformException catch (e) {
      print('Error launching UPI intent: $e');
    }
  }

}
