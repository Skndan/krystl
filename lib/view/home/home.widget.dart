import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:krystl/core/extensions/context_extension.dart';
import 'package:krystl/core/extensions/widget_extension.dart';
import 'package:krystl/view/home/home.viewmodel.dart';

import '../../core/base/base_view.dart';
import '../../core/enums/view_state.dart';
import '../../core/network/firebase_manager.dart';

/// Created by Balaji Malathi on 5/25/2024 at 22:06.
const scaleFraction = 0.7;
const fullScale = 1.0;
const pageHeight = 150.0;

class ExpenseFormWidget extends StatefulWidget {
  final Map<String, dynamic> initialValue;

  const ExpenseFormWidget({
    super.key,
    required this.initialValue,
  });

  @override
  State<ExpenseFormWidget> createState() => _ExpenseFormWidgetState();
}

class _ExpenseFormWidgetState extends State<ExpenseFormWidget> {
  final FirestoreService _firestoreService = FirestoreService.instance;

  late PageController pageController;

  int currentPage = 0;

  double viewPortFraction = 0.3;

  double page = 0.0;

  @override
  void initState() {
    pageController = PageController(
        initialPage: currentPage, viewportFraction: viewPortFraction);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                    color: const Color(0xFF79747E),
                    borderRadius: BorderRadius.circular(2)),
              ).pa(16),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Add Expense',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                BaseView<HomeViewModel>(
                  onModelReady: (HomeViewModel model) {
                    model.setContext(context);
                    model.init();
                    model.setInitialValue(widget.initialValue);
                    model.initHome();
                  },
                  builder: (context, model, child) => model.state ==
                          ViewState.busy
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            StatefulBuilder(builder: (context, state) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: pageHeight,
                                    child: NotificationListener<
                                        ScrollNotification>(
                                      onNotification:
                                          (ScrollNotification notification) {
                                        if (notification
                                            is ScrollUpdateNotification) {
                                          updated(state);
                                          // setState(() {
                                          //   page = pageController.page!;
                                          // });
                                          return true;
                                        }
                                        return false;
                                      },
                                      child: PageView.builder(
                                        onPageChanged: (pos) {
                                          updated3(state, pos);
                                        },
                                        physics: const BouncingScrollPhysics(),
                                        controller: pageController,
                                        itemCount: model.list.length,
                                        itemBuilder: (context, index) {
                                          final scale = max(
                                              scaleFraction,
                                              (fullScale -
                                                      (index - page).abs()) +
                                                  viewPortFraction);
                                          return circleOffer(
                                              model.list[index], scale / 1.2);
                                        },
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      model.list[currentPage]['name'] ?? '',
                                      textAlign: TextAlign.center,
                                      style: context.textTheme.titleLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  FormBuilder(
                                    key: model.formKey,
                                    child: FormBuilderTextField(
                                      name: "expense",
                                      focusNode: model.textSecondFocusNode,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        hintText: 'How much you spent?',
                                        labelText: "Expense",
                                        fillColor: context.colors.primary,
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: FormBuilderValidators.compose(
                                          [FormBuilderValidators.required()]),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                    ),
                                  ),
                                ].divide(const SizedBox(
                                  height: 16,
                                )),
                              );
                            }),
                            Row(
                              children: [
                                _buildActionButton(
                                  context,
                                  label: widget.initialValue["id"] != null
                                      ? "UPDATE"
                                      : "ADD & CLOSE",
                                  onPressed: () => model.handleSave(currentPage,
                                      closeAfterSave: true),
                                ).pr(16),
                                _buildActionButton(
                                  context,
                                  label: widget.initialValue["id"] != null
                                      ? "UPDATE"
                                      : "ADD",
                                  onPressed: () => model.handleSave(currentPage,
                                      closeAfterSave: false),
                                ),
                              ],
                            ).phv(0, 16),
                          ],
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: TextButton.styleFrom(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: Size((MediaQuery.of(context).size.width / 2) - 24, 48),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      ),
    );
  }

  Future<void> updated(StateSetter updateState) async {
    updateState(() {
      page = pageController.page!;
    });
  }

  Future<void> updated3(StateSetter updateState, int pos) async {
    updateState(() {
      currentPage = pos;
    });
  }

  Widget circleOffer(QueryDocumentSnapshot<Object?> item, double scale) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: pageHeight * scale,
        width: pageHeight * scale,
        decoration: BoxDecoration(
            color: Color(item["color"]).withOpacity(0.2),
            shape: BoxShape.circle),
        child: Icon(
          IconData(item["icon"], fontFamily: "MaterialIcons"),
          color: Color(item["color"]),
        ),
      ),
    );
  }
}
