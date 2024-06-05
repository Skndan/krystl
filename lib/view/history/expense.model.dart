import 'dart:convert';

class Expense {
  int expense;
  Category category;
  DateTime createdAt;
  DateTime? expenseAt;

  Expense({
    required this.expense,
    required this.category,
    required this.createdAt,
    this.expenseAt,
  });

  factory Expense.fromRawJson(String str) => Expense.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        expense: json["expense"],
        createdAt: json["createdAt"],
        expenseAt: json["expenseAt"],
        category: Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "expense": expense,
        "createdAt": createdAt,
        "expenseAt": expenseAt,
        "category": category.toJson(),
      };
}

class Category {
  String name;
  int icon;
  int color;

  Category({
    required this.name,
    required this.icon,
    required this.color,
  });

  factory Category.fromRawJson(String str) =>
      Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        icon: json["icon"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "icon": icon,
        "color": color,
      };
}
