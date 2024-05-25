import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:krystl/core/extensions/context_extension.dart';
import 'package:krystl/core/extensions/widget_extension.dart';

import '../../core/network/firebase_manager.dart';

/// Created by Balaji Malathi on 5/25/2024 at 23:00.

class BudgetFormWidget extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final Map<String, dynamic> initialValue;

  const BudgetFormWidget({
    super.key,
    required this.formKey,
    required this.initialValue,
  });

  @override
  State<BudgetFormWidget> createState() => _BudgetFormWidgetState();
}

class _BudgetFormWidgetState extends State<BudgetFormWidget> {
  DateTime currentDate = DateTime.now();
  FirestoreService _firestoreService = FirestoreService.instance;
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
                    'Add Budget',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ).pb(16),
                  FormBuilder(
                    key: widget.formKey,
                    initialValue: widget.initialValue,
                    child: Column(
                      children: [
                        FormBuilderDropdown<String>(
                          name: "month",
                          autofocus: true,
                          items: [
                            "January",
                            "February",
                            "March",
                            "April",
                            "May",
                            "June",
                            "July",
                            "August",
                            "September",
                            "October",
                            "November",
                            "December"
                          ]
                              .map((gender) => DropdownMenuItem(
                            alignment: AlignmentDirectional.centerStart,
                            value: gender,
                            child: Text(gender),
                          ))
                              .toList(),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()]),
                        ),
                        FormBuilderTextField(
                          name: "budget",
                          decoration: InputDecoration(
                            hintText: 'Enter your budget',
                            labelText: "Budget",
                            fillColor: context.colors.primary,
                          ),
                          keyboardType: TextInputType.number,
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()]),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ].divide(SizedBox(height: 16,)),
                    ),
                  ),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      elevation: 0,
                      backgroundColor: context.colors.primaryContainer,
                      foregroundColor: context.colors.onPrimaryContainer,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      minimumSize: Size(context.width - 32, 48),
                    ),
                    onPressed: () async {
                      if (widget.formKey.currentState?.saveAndValidate() ??
                          false) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        var formVal = widget.formKey.currentState!.value;

                        var dd = {
                          "month": formVal["month"],
                          "year": 2024,
                          "budget": formVal["budget"],
                          "balance": formVal["budget"],
                          "createdAt": DateTime.now()
                        };
                        //
                        if (widget.initialValue["id"] != null) {
                          await _firestoreService
                              .update(
                                  '/${FirebaseAuth.instance.currentUser?.uid}/master/budget',
                                  widget.initialValue["id"],
                                  dd)
                              .then((s) {
                            Navigator.pop(context);
                          });
                        } else {
                          await _firestoreService
                              .insert(
                                  '/${FirebaseAuth.instance.currentUser?.uid}/master/budget',
                                  dd)
                              .then((s) {
                            Navigator.pop(context);
                          });
                        }
                        // debugPrint(dd.toString());
                      } else {
                        debugPrint(
                            widget.formKey.currentState?.value.toString());
                        debugPrint('validation failed');
                      }
                    },
                    child: Text(
                      widget.initialValue["id"] != null ? "UPDATE" : "ADD",
                      style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.colors.onPrimaryContainer),
                    ),
                  ).phv(0, 16)
                ]),
          ),
        ],
      ),
    );
  }
}

class MonthPicker extends StatefulWidget {
  MonthPicker(
      {required this.initialYear,
      required this.startYear,
      required this.endYear,
      this.currentYear,
      required this.month,
      Key? key})
      : super(key: key);
  late int initialYear;
  late int startYear;
  late int endYear;
  late int? currentYear;
  late int month;

  @override
  State<MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker> {
  final List<String> _monthList = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  List<String> _yearList = [];
  late int selectedMonthIndex;
  late int selectedYearIndex;
  String selectedMonth = "";
  String selectedYear = "";

  @override
  void initState() {
    for (int i = widget.startYear; i <= widget.endYear; i++) {
      _yearList.add(i.toString());
    }
    selectedMonthIndex = widget.month - 1;
    selectedYearIndex = _yearList.indexOf(
        widget.currentYear?.toString() ?? widget.initialYear.toString());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        selectedMonth = _monthList[selectedMonthIndex];
        selectedYear = _yearList[selectedYearIndex];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: DropdownButton<String>(
            underline: Container(),
            items: _monthList.map((e) {
              return DropdownMenuItem<String>(value: e, child: Text(e));
            }).toList(),
            value: selectedMonth,
            onChanged: (val) {
              setState(() {
                selectedMonthIndex = _monthList.indexOf(val!);
                selectedMonth = val;
              });
            },
          ),
        ),
        Expanded(
          child: DropdownButton<String>(
            underline: Container(),
            items: _yearList.map((e) {
              return DropdownMenuItem<String>(value: e, child: Text(e));
            }).toList(),
            value: selectedYear,
            onChanged: (val) {
              setState(() {
                selectedYear = val ?? "";
              });
            },
          ),
        )
      ],
    );
  }
}
