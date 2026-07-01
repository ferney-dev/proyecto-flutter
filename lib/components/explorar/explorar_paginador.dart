import 'package:flutter/material.dart';

class ExplorarPaginador extends StatelessWidget {
  final int currentPage;
  final int totalItems;
  final int itemsPerPage;
  final Function() onNextPage;
  final Function() onPrevPage;

  const ExplorarPaginador({
    super.key,
    required this.currentPage,
    required this.totalItems,
    required this.itemsPerPage,
    required this.onNextPage,
    required this.onPrevPage,
  });

  @override
  Widget build(BuildContext context) {
    final totalPages = (totalItems / itemsPerPage).ceil();
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (totalItems == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: isMobile ? 10 : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isMobile ? null : Border.all(color: Colors.grey.shade300, width: 1.2),
        boxShadow: isMobile ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Botón anterior
          _buildPageButton(
            icon: Icons.chevron_left,
            label: isMobile ? "" : "Anterior",
            onPressed: currentPage > 1 ? onPrevPage : null,
            isMobile: isMobile,
          ),
          
          SizedBox(width: isMobile ? 12 : 16),
          
          // Indicador de página
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 10 : 16,
              vertical: isMobile ? 6 : 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF00324D),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "$currentPage / $totalPages",
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 13 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          SizedBox(width: isMobile ? 12 : 16),
          
          // Botón siguiente
          _buildPageButton(
            icon: Icons.chevron_right,
            label: isMobile ? "" : "Siguiente",
            onPressed: currentPage * itemsPerPage < totalItems ? onNextPage : null,
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required bool isMobile,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: isMobile ? 18 : 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed != null ? const Color(0xFF00324D) : Colors.grey.shade300,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 20,
          vertical: isMobile ? 10 : 12,
        ),
        textStyle: TextStyle(
          fontSize: isMobile ? 13 : 14,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBackgroundColor: Colors.grey.shade300,
      ),
    );
  }
}
