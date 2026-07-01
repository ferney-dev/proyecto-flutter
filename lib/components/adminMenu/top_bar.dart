import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final bool isMobile;
  final String searchTerm;
  final Function(String) onSearchChanged;
  final VoidCallback? onMenuPressed;

  const TopBar({
    super.key,
    required this.isMobile,
    required this.searchTerm,
    required this.onSearchChanged,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: onMenuPressed,
            ),
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: "Buscar módulos...",
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade500),
                ),
              ),
            ),
          ),
          if (!isMobile) ...[
            const SizedBox(width: 24),
            _buildActionButton(Icons.notifications_rounded, Colors.grey.shade600),
            const SizedBox(width: 12),
            _buildActionButton(Icons.account_circle_rounded, Colors.blue.shade600),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
