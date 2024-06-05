import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension WidgetExtension on Widget {
  Widget get toSliver {
    return SliverToBoxAdapter(
      child: this,
    );
  }

  Widget pt(double nn) => Padding(
        padding: EdgeInsets.only(top: nn),
        child: this,
      );

  Widget pb(double nn) => Padding(
        padding: EdgeInsets.only(bottom: nn),
        child: this,
      );

  Widget pl(double nn) => Padding(
    padding: EdgeInsets.only(left: nn),
    child: this,
  );

  Widget pr(double nn) => Padding(
    padding: EdgeInsets.only(right: nn),
    child: this,
  );

  Widget phv(double nn, double mm) => Padding(
    padding: EdgeInsets.symmetric(horizontal: nn, vertical: mm),
    child: this,
  );

  Widget pa(double nn) => Padding(
    padding: EdgeInsets.all(nn),
    child: this,
  );
}


extension ListDivideExt<T extends Widget> on Iterable<T> {
  Iterable<MapEntry<int, Widget>> get enumerate => toList().asMap().entries;

  List<Widget> divide(Widget t) => isEmpty
      ? []
      : (enumerate.map((e) => [e.value, t]).expand((i) => i).toList()
    ..removeLast());

  List<Widget> around(Widget t) => addToStart(t).addToEnd(t);

  List<Widget> addToStart(Widget t) =>
      enumerate.map((e) => e.value).toList()..insert(0, t);

  List<Widget> addToEnd(Widget t) =>
      enumerate.map((e) => e.value).toList()..add(t);

  List<Padding> paddingTopEach(double val) =>
      map((w) => Padding(padding: EdgeInsets.only(top: val), child: w))
          .toList();
}

extension TimestampExtension on Timestamp {
  String toFormattedString() {
    final DateTime dateTime = this.toDate();
    final DateFormat formatter = DateFormat('EEE, dd MMM yy hh:mm a');
    return formatter.format(dateTime);
  }
}

extension DateTimeExtension on DateTime {
  String toFormattedString() {
    final DateFormat formatter = DateFormat('EEE, dd MMM yy hh:mm a');
    return formatter.format(this);
  }
}
