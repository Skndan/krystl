import 'dart:convert';

/// Created by Balaji Malathi on 5/25/2024 at 22:56.

class BudgetModel {
  String id;
  String month;
  int year;
  int budget;
  int balance;
  int createdAt;

  BudgetModel({
    required this.id,
    required this.month,
    required this.year,
    required this.budget,
    required this.balance,
    required this.createdAt,
  });

  factory BudgetModel.fromRawJson(String str) => BudgetModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BudgetModel.fromJson(Map<String, dynamic> json) => BudgetModel(
    id: json["id"],
    month: json["month"],
    year: json["year"],
    budget: json["budget"],
    balance: json["balance"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "month": month,
    "year": year,
    "budget": budget,
    "balance": balance,
    "createdAt": createdAt,
  };
}
