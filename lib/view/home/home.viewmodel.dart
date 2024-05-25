import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:krystl/core/extensions/widget_extension.dart';
import 'package:provider/provider.dart';

import '../../core/base/base_model.dart';
import '../../core/enums/app_theme.dart';
import '../../core/enums/pref.dart';
import '../../core/notifier/theme_notifier.dart';
import '../../product/analytics/firebase.dart';

class HomeViewModel extends BaseModel with BaseViewModel {

    @override
    void setContext(BuildContext context) => this.context = context;

    //region Variable Initialization
    //endregion

    String? profile = "", displayName = "";

    @override
    Future<void> init() async {
        profile = localManager.getString(Pref.profile);
        displayName = localManager.getString(Pref.displayName);
        notifyListeners();
    }


    AppThemes _appThemes = AppThemes.system;
    void changeTheme() {
        _appThemes =
        getTheme() == AppThemes.light ? AppThemes.dark : AppThemes.light;

        FBAnalytics.logEvent(name: "theme", parameters: {'theme': _appThemes.name});

        context.read<ThemeNotifier>().changeValue(_appThemes);
    }

    getTheme() {
        var theme = localManager.getString(Pref.theme);
        var brightness = MediaQuery
            .of(context)
            .platformBrightness;
        bool isDarkMode = brightness == Brightness.dark;
        if (theme == 'system') {
            return isDarkMode ? AppThemes.dark : AppThemes.light;
        }
        if (theme == 'light') {
            return AppThemes.light;
        }
        if (theme == 'dark') {
            return AppThemes.dark;
        }
    }

  void showExpenseDialog() {
        showModalBottomSheet(context: context,
            isScrollControlled: true,
            builder: (context) {
            return ExpenseFormWidget();
        });
  }


 }

class ExpenseFormWidget extends StatefulWidget {
  const ExpenseFormWidget({
    super.key,
  });

  @override
  State<ExpenseFormWidget> createState() => _ExpenseFormWidgetState();
}

class _ExpenseFormWidgetState extends State<ExpenseFormWidget> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
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
                                        color: Color(0xFF79747E),
                                    ).pa(16),
                                ],
                            ),
                            Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                        Text(
                                            'Add Expense',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                            ),
                                        ),
                                        FilledButton(
                                            onPressed: () {
                                                Navigator.pop(context);
                                            },
                                            child: Text('Submit'),
                                        ),
                                    ],
                                ),
                            ),
                        ],
                    ),
                ),
            );
        },
    );
  }
}
