import 'package:flutter/material.dart';

class FavoritosPaginador extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final Function() onPrevious;
  final Function() onNext;

  const FavoritosPaginador({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 20,
            vertical: isMobile ? 10 : 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: isMobile ? null : Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: isMobile ? [] : [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: currentPage > 1 ? onPrevious : null,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                iconSize: isMobile ? 20 : 24,
              ),
              SizedBox(width: isMobile ? 12 : 16),
              Text(
                isMobile ? "$currentPage / $totalPages" : "Página $currentPage de $totalPages ($totalItems favoritos)",
                style: TextStyle(
                  fontSize: isMobile ? 13 : 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: isMobile ? 12 : 16),
              IconButton(
                onPressed: currentPage < totalPages ? onNext : null,
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                iconSize: isMobile ? 20 : 24,
              ),
            ],
          ),
        );
      },
    );
  }
}
