import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final bool active;

  CategoryModel({
    required this.name,
    required this.active,
  });
}

List categoryData = [
  CategoryModel(
    name: "All",
    active: true,
  ),
  CategoryModel(
    name: "Recycling",
    active: false,
  ),
  CategoryModel(
    name: "Education",
    active: false,
  ),
  CategoryModel(
    name: "Green\nTechnology",
    active: false,
  ),
  CategoryModel(
    name: "Waste\nManagement",
    active: false,
  )
];
