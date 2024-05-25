import 'dart:async';

import 'package:krystl/core/base/base_view.dart';
import 'package:krystl/core/enums/connectivity.dart';
import 'package:krystl/core/enums/view_state.dart';
import 'package:krystl/core/cache/local_manager.dart';
import 'package:krystl/core/navigation/router_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

export 'package:krystl/core/enums/view_state.dart';

/// [BaseModel] extends with ViewModel in the [BaseView]
///
class BaseModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  /// [ViewState] is handling the State of the Page
  ///
  /// [ViewState.Idle] is the default state of the page
  ///
  /// Before calling the the API or async function in order to display content on the
  /// page, use setState to define the state of the page, example,
  /// ```dart
  /// setState(ViewState.busy);
  /// await Future();
  /// setState(ViewState.idle);
  /// ```
  ///
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  NetworkStatus _connectivityStatus = NetworkStatus.offline;

  NetworkStatus get network => _connectivityStatus;

  StreamController<NetworkStatus> connectionStatusController =
      StreamController<NetworkStatus>();

  BaseModel() {
    // Subscribe to the connectivity Changed Steam
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Use Connectivity() here to gather more info if you need t
      connectionStatusController.add(_getStatusFromResult(result));
    });
  }

  // Convert from the third part enum to our own enum
  NetworkStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        setNetwork(NetworkStatus.mobile);
        return NetworkStatus.mobile;
      case ConnectivityResult.wifi:
        setNetwork(NetworkStatus.wifi);
        return NetworkStatus.wifi;
      case ConnectivityResult.none:
        setNetwork(NetworkStatus.offline);
        return NetworkStatus.offline;
      default:
        setNetwork(NetworkStatus.offline);
        return NetworkStatus.offline;
    }
  }

  void setNetwork(NetworkStatus conStatus) {
    _connectivityStatus = conStatus;

    const snackBar = SnackBar(
      content: Text('You are offline'),
      backgroundColor: Colors.red,
      duration: Duration(days: 365),
    );

    BuildContext context = RouterService.instance.navigatorKey.currentContext!;

    if (conStatus == NetworkStatus.offline) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
    }
    notifyListeners();
  }

  /// Triggers when app opens
  Future<void> refreshNetwork() async {
    var result = await Connectivity().checkConnectivity();

    switch (result) {
      case ConnectivityResult.mobile:
        setNetwork(NetworkStatus.mobile);
        break;
      case ConnectivityResult.wifi:
        setNetwork(NetworkStatus.wifi);
        break;
      case ConnectivityResult.none:
        setNetwork(NetworkStatus.offline);
        break;
      default:
        setNetwork(NetworkStatus.offline);
    }
  }
}

/// [BaseViewModel] is a mixin class to reuse the variables and functions on ViewModel to extend the
/// [BuildContext], [LocalManager] and [RouterService], so we do not need to
/// initialize to use, it will be auto initialized when they are invoked in the ViewModel
abstract mixin class BaseViewModel {

  /// [BuildContext] is used to identify the context of the page, it will be utilized in the ViewModel
  /// to handle the [Navigator] or [BottomSheet] or [Dialog]
  ///
  late BuildContext context;


  LocalManager localManager = LocalManager.instance;


  RouterService navigationService = RouterService.instance;

  /// Function used to initialize the [BuildContext] for the ViewModel
  ///
  void setContext(BuildContext context);

  /// [init] will be called first when the ViewModel is declared
  ///
  void init() {}

  final formKey = GlobalKey<FormBuilderState>();

}
