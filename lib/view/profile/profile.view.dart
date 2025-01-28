import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:krystl/core/base/base_view.dart';
import 'package:krystl/core/extensions/widget_extension.dart';
import 'package:krystl/core/notifier/theme_notifier.dart';
import 'package:krystl/product/components/avatar.dart';
import 'package:krystl/view/profile/profile.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

import '../../core/enums/app_theme.dart';

class NotificationSetting {
  final String title;
  bool isEnabled;

  NotificationSetting({required this.title, this.isEnabled = true});
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _notificationsExpanded = false;
  List<NotificationSetting> _notificationSettings = [
    NotificationSetting(title: 'Push Notifications'),
    NotificationSetting(title: 'Email Notifications'),
    NotificationSetting(title: 'SMS Notifications'),
    NotificationSetting(title: 'In-App Notifications'),
  ];

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
    var theme = context.watch<ThemeNotifier>().currentThemeEnum;
    _scrollController.addListener(() {
      _titlePaddingNotifier.value = _horizontalTitlePadding;
    });

    return BaseView<ProfileViewModel>(
      onModelReady: (ProfileViewModel model) {
        model.setContext(context);
        model.init();
      },
      builder: (context, model, child) => Scaffold(
        // appBar: AppBar(
        //   title: const Text('Settings'),
        // ),
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
                            "Your Profile",
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
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Profile Card
              Row(
                children: [
                  Center(
                      child: Avatar(
                              image:
                                  FirebaseAuth.instance.currentUser?.photoURL ??
                                      '')
                          .phv(16, 0)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(FirebaseAuth.instance.currentUser?.displayName ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w500)),
                      Text(FirebaseAuth.instance.currentUser?.email ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.8))),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),
              // Change Theme
              ListTile(
                leading: Icon(theme == AppThemes.dark
                    ? SolarIconsBold.moon
                    : SolarIconsBold.sun),
                title: Text(
                    theme == AppThemes.dark ? 'Dark Mode' : 'Light Mode',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500)),
                trailing: Switch(
                  value: theme == AppThemes.dark,
                  onChanged: (bool value) {
                    model.changeTheme();
                  },
                ),
              ),
              // Notifications
              ExpansionTile(
                leading: const Icon(SolarIconsBold.bell),
                title: Text('Notifications',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500)),
                children: [
                  for (var setting in _notificationSettings)
                    SwitchListTile(
                      title: Text(setting.title),
                      value: setting.isEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          setting.isEnabled = value;
                        });
                      },
                    ),
                ],
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    _notificationsExpanded = expanded;
                  });
                },
              ),

              // Logout
              ListTile(
                leading: const Icon(SolarIconsBold.logout_2),
                title: Text('Logout',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500)),
                onTap: () {
                  // TODO: Implement logout functionality
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Logout'),
                            onPressed: () {
                              // TODO: Implement actual logout logic
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

              // Export Data
              ListTile(
                leading: const Icon(SolarIconsBold.export),
                title: Text('Export Data',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500)),
                onTap: () {
                  // TODO: Implement data export functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Exporting data...')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
