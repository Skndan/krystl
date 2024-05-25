import 'dart:math';

import 'package:flutter/material.dart';
import 'package:krystl/core/extensions/context_extension.dart';
import 'package:krystl/core/extensions/widget_extension.dart';
import 'package:krystl/core/network/firebase_manager.dart';
import 'package:krystl/view/category/category.viewmodel.dart';
import 'package:solar_icons/solar_icons.dart';

import '../../core/base/base_view.dart';

/// Created by Balaji Malathi on 5/25/2024 at 18:20.
class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView>
    with TickerProviderStateMixin {
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
    return BaseView<CategoryViewModel>(
      onModelReady: (CategoryViewModel model) {
        model.setContext(context);
        model.init();
      },
      builder: (context, model, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(SolarIconsBold.addCircle),
          onPressed: (){
            model.addCategory();
          },
        ),
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
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
                            "Categories",
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
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirestoreService.instance
                      .listenToCollection('/${model.uid}/master/category'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // If the connection is still waiting, show a loading indicator
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      // If there is an error with the stream, display an error message
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      // If there is data available, display it
                      final documents = snapshot.data!.docs;
                      return GridView.builder(
                        itemCount: documents.length,
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            color: Color(documents[index]["color"])
                                .withOpacity(0.2),
                            padding: EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  IconData(documents[index]["icon"],
                                      fontFamily: "MaterialIcons"),
                                  color: Color(documents[index]["color"]), size: 36,
                                ),
                                Text(documents[index]["name"], style: context.textTheme.titleLarge,),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      // If there is no data available, display a message
                      return Text('No data available');
                    }
                  },
                ),
              ),
              // ElevatedButton(
              //   style: TextButton.styleFrom(
              //     elevation: 0,
              //     backgroundColor: context.colors.primaryContainer,
              //     foregroundColor: context.colors.onPrimaryContainer,
              //     shape: const RoundedRectangleBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(8)),
              //     ),
              //     minimumSize: Size(context.width - 32, 48),
              //   ),
              //   onPressed: () {
              //     model.addCategory();
              //   },
              //   child: Text(
              //     "Add Category".toUpperCase(),
              //     style: context.textTheme.bodyLarge
              //         ?.copyWith(fontWeight: FontWeight.w700),
              //   ),
              // ).pa(16)
            ],
          ),
        ),
      ),
    );
  }
}
