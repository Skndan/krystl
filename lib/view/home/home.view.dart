import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:krystl/core/extensions/context_extension.dart';
import 'package:krystl/core/extensions/widget_extension.dart';
import 'package:krystl/core/navigation/router_service.dart';
import 'package:krystl/view/home/home.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

import '../../core/base/base_view.dart';
import '../../core/enums/app_theme.dart';
import '../../core/notifier/theme_notifier.dart';
import '../../product/components/avatar.dart';
import '../../product/navigation/route_constant.dart';

/// Created by Balaji Malathi on 5/25/2024 at 13:50.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeNotifier>().currentThemeEnum;

    return BaseView<HomeViewModel>(
      onModelReady: (HomeViewModel model) {
        model.setContext(context);
        model.init();
        model.checkBudget();
        model.getExpenses();
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: (model.profile != null || model.profile == "")
              ? Center(
                  child: Avatar(
                          image:
                              FirebaseAuth.instance.currentUser?.photoURL ?? '')
                      .pl(16))
              : const SizedBox.shrink(),
          title: SvgPicture.asset(
            theme == AppThemes.light
                ? "assets/svg/logo-lite.svg"
                : "assets/svg/logo-dark.svg",
            height: 40,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                model.changeTheme();
              },
              icon: theme == AppThemes.dark
                  ? const Icon(SolarIconsBold.moonStars)
                  : const Icon(SolarIconsBold.sunfog),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () async {
            model.getExpenses();
            // await GoogleSignIn().signOut();
            // RouterService.instance.pushAndClear(RouterConstant.root);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${FirebaseAuth.instance.currentUser?.displayName}",
                    style: context.textTheme.headlineLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ).pt(16),
                  Container(
                    height: 105,
                    decoration: BoxDecoration(
                        color: context.colors.primaryContainer,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16))),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Your Balance",
                                style: context.textTheme.titleMedium?.copyWith(
                                    color: context.colors.onPrimaryContainer)),
                            Text("\$5",
                                style: context.textTheme.headlineLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: context.colors.onPrimaryContainer)),
                          ],
                        ),
                      ],
                    ).phv(16, 14),
                  ).pt(24),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 105,
                          decoration: BoxDecoration(
                              color: context.colors.tertiaryContainer,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16))),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Burned Today",
                                      style: context.textTheme.titleMedium
                                          ?.copyWith(
                                              color: context
                                                  .colors.onTertiaryContainer)),
                                  Text("\$5",
                                      style: context.textTheme.headlineLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: context
                                                  .colors.onTertiaryContainer)),
                                ],
                              ),
                            ],
                          ).phv(16, 14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 105,
                          decoration: BoxDecoration(
                              color: context.colors.secondaryContainer,
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(16))),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Daily Fuel",
                                      style: context.textTheme.titleMedium
                                          ?.copyWith(
                                              color: context
                                                  .colors.onSecondaryContainer)),
                                  Text("\$5",
                                      style: context.textTheme.headlineLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: context
                                                  .colors.onSecondaryContainer)),
                                ],
                              ),
                            ],
                          ).phv(16, 14),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            RouterService.instance.pushTo(RouterConstant.budget);
                          },
                          child: SizedBox(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: context.colors.primary,
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    SolarIconsBold.moneyBag,
                                    color: context.colors.primaryContainer,
                                  ).pa(24),
                                ).pb(8),
                                Text(
                                  "Budget",
                                  style: context.textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: context.colors.primary,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  SolarIconsBold.file,
                                  color: context.colors.primaryContainer,
                                ).pa(24),
                              ).pb(8),
                              Text(
                                "History",
                                style: context.textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            RouterService.instance
                                .pushTo(RouterConstant.category);
                          },
                          child: SizedBox(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: context.colors.secondary,
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    SolarIconsBold.fileCheck,
                                    color: context.colors.secondaryContainer,
                                  ).pa(24),
                                ).pb(8),
                                Text(
                                  "Categories",
                                  style: context.textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            model.showExpenseDialog();
                          },
                          child: SizedBox(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: context.colors.tertiaryContainer,
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    SolarIconsBold.circleTopUp,
                                    color: context.colors.tertiary,
                                  ).pa(24),
                                ).pb(8),
                                Text(
                                  "Expense",
                                  style: context.textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ).pt(36),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Today’s Expenses",
                        style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.0,
                            fontSize: 18),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Text("View All",
                              style: context.textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600)))
                    ],
                  ).pt(24),
                ],
              ).phv(16, 0),
              ...model.expenses.map((e) => ListTile(
                    leading: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Color(e["category"]["color"]).withOpacity(0.2)),
                        child: Icon(
                            IconData(e["category"]["icon"],
                                fontFamily: "MaterialIcons"),
                            color: Color(e["category"]["color"]), size: 20,)),
                    title: Text(e["category"]["name"], style: context.textTheme.titleMedium,),
                    trailing: Text("\$${e["expense"]}",
                        style: context.textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    onTap: () {},
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
