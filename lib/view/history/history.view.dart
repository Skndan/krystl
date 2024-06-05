import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krystl/core/extensions/context_extension.dart';
import 'package:krystl/core/extensions/widget_extension.dart';
import 'package:solar_icons/solar_icons.dart';

import '../../core/base/base_view.dart';
import '../../core/network/firebase_manager.dart';
import 'expense.model.dart';
import 'history.viewmodel.dart';

/// Created by Balaji Malathi on 6/5/2024 at 22:31.
class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {

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
    return BaseView<HistoryViewModel>(
      onModelReady: (HistoryViewModel model) {
        model.setContext(context);
        model.init();
        // model.checkBudget();
        // model.getBudget();
      },
      builder: (context, model, child) => Scaffold(
          floatingActionButton: FloatingActionButton(
            child: const Icon(SolarIconsBold.addCircle),
            onPressed: () {
              // model.addBudget(null);
            },
          ),
          body: FutureBuilder<List<Expense>>(
            future: model.fetchExpenses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No expenses found'));
              }

              final groupedExpenses = model.groupExpensesByDate(snapshot.data!);

              return CustomScrollView(
                controller: _scrollController,
                slivers: _buildSlivers(groupedExpenses),
              );
            },
          )),
    );
  }


  List<Widget> _buildSlivers(Map<String, List<Expense>> groupedExpenses) {
    final List<Widget> slivers = [];
    slivers.add(SliverAppBar(
        expandedHeight: kExpandedHeight,
        floating: true,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          centerTitle: false,
          titlePadding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
          title: ValueListenableBuilder<double>(
            valueListenable: _titlePaddingNotifier,
            builder: (context, value, child) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: value),
                child: const Text(
                  "History",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
          ),
        )));

    groupedExpenses.forEach((date, expenses) {
      slivers.add(
        SliverPersistentHeader(
          delegate: _SliverHeaderDelegate(
            child: Container(
              height: 56,
              color: context.colors.surface,
              child: Center(
                child: Text(
                  DateFormat('dd MMM yyyy').format(DateTime.parse(date)),
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colors.primary
                  ),
                ),
              ),
            ),
          ),
          pinned: true
        ),
      );

      slivers.add(
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final expense = expenses[index];
              return
                ListTile(
                  leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                          Color(expense.category.color).withOpacity(0.2)),
                      child: Icon(
                        IconData(expense.category.icon,
                            fontFamily: "MaterialIcons"),
                        color: Color(expense.category.color),
                        size: 20,
                      )),
                  title: Text(
                    expense.category.name,
                    style: context.textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    expense.createdAt.toFormattedString(),
                    style: context.textTheme.titleSmall,
                  ),
                  trailing: Text("₹${expense.expense}",
                      style: context.textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  onTap: () {},
                );
            },
            childCount: expenses.length,
          ),
        ),
      );
    });

    return slivers;
  }

}


class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get minExtent => 56;

  @override
  double get maxExtent => 56;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate != this;
  }
}
