import 'package:flutter/material.dart';

/// Tabs 1st level
enum Tab1 {
  preview,
  code,
  ;

  TabInfo get tabInfo => TabInfo(name, iconData);

  IconData get iconData {
    switch (this) {
      case preview:
        return Icons.phone_android;
      case code:
        return Icons.code;
    }
  }

  String get label {
    return name.capitalize();
  }

  /// Get enum by specified index
  /*
  static _Tab1? getEnum(int idx) {
    for (final _Tab1 tab in _Tab1.values) {
      if (tab.index == idx) {
        return tab;
      }
    }
    return null;
  }
   */
}

class TabInfo {
  String name;
  IconData iconData;

  TabInfo(this.name, this.iconData);
}

/// String extension
extension StringExtension on String {
  /// capitalize
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
