import 'dart:math';

import 'package:flutter/material.dart';
import 'package:krystl/core/extensions/context_extension.dart';
import 'package:krystl/core/extensions/widget_extension.dart';
import 'package:krystl/view/budget/budget.viewmodel.dart';
import 'package:solar_icons/solar_icons.dart';

import '../../core/base/base_view.dart';
import '../../core/network/firebase_manager.dart';

/// Created by Balaji Malathi on 5/25/2024 at 22:42.
class BudgetView extends StatefulWidget {
  const BudgetView({super.key});

  @override
  State<BudgetView> createState() => _BudgetViewState();
}

class _BudgetViewState extends State<BudgetView> with TickerProviderStateMixin {
  static const _kBasePadding = 8.0;
  static const kExpandedHeight = 140.0;

  final ValueNotifier<double> _titlePaddingNotifier =
      ValueNotifier(_kBasePadding);

  final _scrollController = ScrollController();

  double get _horizontalTitlePadding {
    const kCollapsedPadding = 60.0;

    if (_scrollController.hasClients) {
      return min(
          _kBasePadding + kCollapsedPadding,
          _kBasePadding +
              (kCollapsedPadding * _scrollController.offset) /
                  (kExpandedHeight - kToolbarHeight));
    }

    return _kBasePadding > 68 ? _kBasePadding : 68;
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      _titlePaddingNotifier.value = _horizontalTitlePadding;
    });
    return BaseView<BudgetViewModel>(
      onModelReady: (BudgetViewModel model) {
        model.setContext(context);
        model.init();
        model.checkBudget();
        // model.getBudget();
      },
      builder: (context, model, child) => Scaffold(
          floatingActionButton: FloatingActionButton(
            child: const Icon(SolarIconsBold.addCircle),
            onPressed: () {
              model.addBudget(null);
            },
          ),
          body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                    expandedHeight: kExpandedHeight,
                    floating: true,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      centerTitle: false,
                      titlePadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 0),
                      title: ValueListenableBuilder<double>(
                        valueListenable: _titlePaddingNotifier,
                        builder: (context, value, child) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: value),
                            child: const Text(
                              "Budget",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        },
                      ),
                    )),
              ];
            },
            body: StreamBuilder(
              stream: FirestoreService.instance
                  .listenToCollection('/${model.uid}/master/budget'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // If the connection is still waiting, show a loading indicator
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // If there is an error with the stream, display an error message
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  // If there is data available, display it
                  final documents = snapshot.data!.docs;
                  // if (documents.isEmpty) {
                  //   return Text('No data available');
                  // }
                  return ListView.separated(
                    itemCount: documents.length,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          // model.addCategory(ColorModel(
                          //     color: documents[index]["color"],
                          //     icon: documents[index]["icon"],
                          //     name: documents[index]["name"],
                          //     id: documents[index].id));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: model.checkYear(documents[index]["month"],
                                  documents[index]["year"]),
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Your budget for ${documents[index]["month"]}",
                                style: context.textTheme.titleLarge?.copyWith(
                                    color: context.colors.onPrimaryContainer),
                              ).pb(24),
                              Text(
                                "\$${documents[index]["budget"]}",
                                style: context.textTheme.displaySmall?.copyWith(
                                    color: context.colors.onPrimaryContainer,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 16,),
                  );
                } else {
                  return const Text('No data available');
                }
              },
            ),
          )),
    );
  }
}
