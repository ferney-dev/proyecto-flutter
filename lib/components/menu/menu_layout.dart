import 'package:flutter/material.dart';
import 'menu_header.dart';
import 'menu_sidebar.dart';

class MenuLayout extends StatelessWidget {
  final Widget child;
  final bool showSidebar;

  const MenuLayout({
    super.key,
    required this.child,
    this.showSidebar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          const MenuHeader(),
          // Contenido principal
          Expanded(
            child: Row(
              children: [
                if (showSidebar) const MenuSidebar(),
                // Contenido
                Expanded(
                  child: Container(
                    color: Colors.grey.shade50,
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
