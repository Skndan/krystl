import 'dart:convert';
/// Created by Balaji Malathi on 5/25/2024 at 22:09.

class CategoryModel {
  String id;
  int color;
  int icon;
  String name;

  CategoryModel({
    required this.id,
    required this.color,
    required this.icon,
    required this.name,
  });

  factory CategoryModel.fromRawJson(String str) => CategoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["id"],
    color: json["color"],
    icon: json["icon"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "color": color,
    "icon": icon,
    "name": name,
  };
}
