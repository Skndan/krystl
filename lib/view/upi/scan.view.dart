import 'package:flutter/material.dart';
import 'package:krystl/core/navigation/router_service.dart';
import 'package:krystl/product/navigation/route_constant.dart';
import 'package:krystl/view/upi/qr.scanner.widget.dart';

/// Created by Balaji Malathi on 1/25/2025 at 19:52.
class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Scan any UPI',
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: QrScannerView(
          onDetect: (upi) {
            // open amount pop up with
            RouterService.instance
                .pushAndReplace(RouterConstant.upi, data: {"upi": upi});
          },
        ));
  }
}
