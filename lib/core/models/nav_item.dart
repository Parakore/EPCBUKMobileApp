import 'package:flutter/material.dart';

class NavItem {
  final String? sectionTitle; // if set, this is a section separator
  final String? id;
  final IconData? icon;
  final String? label;
  final String? badge;
  final bool isAlertBadge;
  final String? route;

  const NavItem.section(this.sectionTitle)
      : id = null,
        icon = null,
        label = null,
        badge = null,
        isAlertBadge = false,
        route = null;

  const NavItem.item({
    required String this.id,
    required IconData this.icon,
    required String this.label,
    required String this.route,
    this.badge,
    this.isAlertBadge = false,
  }) : sectionTitle = null;

  bool get isSection => sectionTitle != null;
}
