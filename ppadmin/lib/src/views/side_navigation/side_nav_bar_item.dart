import 'package:flutter/material.dart';

/// This acts as a data holder to provide [icon] and [label]
class SideNavBarItem {
  /// The [Image] you want to display
  final String image;

  /// Information about the navigatable route
  final String label;

  const SideNavBarItem({required this.image, required this.label});
}
