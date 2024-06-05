import 'package:flutter/material.dart';
import 'package:krystl/view/category/category.view.dart';

import '../../view/budget/budget.view.dart';
import '../../view/history/history.view.dart';
import '../../view/home/home.view.dart';
import '../../view/splash.view.dart';
import '../../view/upi/upi.view.dart';
import 'route_constant.dart';

/// Navigation Route which generate the routes
/// All the routes have to be declared in this file.
///
/// [Navigator] can also be used in the framework to enable the flexibility,
/// when you don't want to use the [RouterGenerator]
///
/// [RouterGenerator.instance] should be called followed by the [Router] to
/// navigate
///
class RouterGenerator {
  static final RouterGenerator _instance = RouterGenerator._init();

  static RouterGenerator get instance => _instance;

  RouterGenerator._init();

  Route<dynamic> generateRoute(RouteSettings settings) {
    Map args = {};
    if (settings.arguments != null) {
      args = settings.arguments as Map<dynamic, dynamic>;
    }
    switch (settings.name) {
      case RouterConstant.root:
        return navigate(const SplashView(), settings);
      case RouterConstant.home:
        return navigate(const HomeView(), settings);
      case RouterConstant.category:
        return navigate(const CategoryView(), settings);
      case RouterConstant.budget:
        return navigate(const BudgetView(), settings);
      case RouterConstant.upi:
        return navigate(const UpiView(), settings);
      case RouterConstant.history:
        return navigate(const HistoryView(), settings);
      default:
        return MaterialPageRoute(
          builder: (context) => const NotFoundNavigationWidget(),
        );
    }
  }

  // Function is used to create the navigation
  ///  * [Widget] is the scaffold
  ///  * [RouteSettings] is the Settings where it contains the route name and arguments
  ///
  MaterialPageRoute navigate(Widget widget, RouteSettings route) {
    return MaterialPageRoute(
      settings: route,
      builder: (context) => widget,
    );
  }
}

/// [NotFoundNavigationWidget] is the widget which will be used to show when the
/// route is not defined in the NavigationRoute
///
class NotFoundNavigationWidget extends StatelessWidget {
  const NotFoundNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Error Route"));
  }
}
