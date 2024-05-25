import 'package:get_it/get_it.dart';
import 'package:krystl/core/network/network_manager.dart';
import 'package:krystl/view/category/category.viewmodel.dart';
import 'package:krystl/view/home/home.viewmodel.dart';

import 'core/network/firebase_manager.dart';

// Represents compile-time dependency injection
GetIt locator = GetIt.instance;

void setupLocator() {

  // View models
  locator.registerFactory(() => HomeViewModel());
  locator.registerFactory(() => CategoryViewModel());
  // locator.registerFactory(() => HomeViewModel());

  // Dio
  locator.registerFactory(() => NetworkManager());
  locator.registerFactory(() => FirestoreService.instance);
}
