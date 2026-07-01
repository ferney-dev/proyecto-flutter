import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/controllers/inicio/inicio_controller.dart';

class InicioPaginador extends StatelessWidget {
  final int totalItems;
  final int itemsPerPage;

  const InicioPaginador({
    super.key,
    required this.totalItems,
    required this.itemsPerPage,
  });

  @override
  Widget build(BuildContext context) {
    final InicioController controller = Get.find<InicioController>();
    final totalPages = (totalItems / itemsPerPage).ceil();
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Obx(() => Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20, vertical: isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isMobile ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Información de página (ocultar en móvil)
          if (!isMobile)
            Text(
              "Mostrando ${((controller.currentPage.value - 1) * itemsPerPage) + 1}-${(controller.currentPage.value * itemsPerPage).clamp(1, totalItems)} de $totalItems",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          
          // Controles de paginación
          Row(
            children: [
              IconButton(
                onPressed: controller.currentPage.value > 1 
                    ? controller.prevPage 
                    : null,
                icon: const Icon(Icons.chevron_left),
                style: IconButton.styleFrom(
                  backgroundColor: controller.currentPage.value > 1 
                      ? Colors.blue.shade100 
                      : Colors.grey.shade200,
                  foregroundColor: controller.currentPage.value > 1 
                      ? Colors.blue.shade700 
                      : Colors.grey.shade400,
                ),
              ),
              
              // Números de página
              ..._buildPageNumbers(context, controller, totalPages),
              
              IconButton(
                onPressed: controller.currentPage.value < totalPages
                    ? () => controller.nextPage(totalItems)
                    : null,
                icon: const Icon(Icons.chevron_right),
                style: IconButton.styleFrom(
                  backgroundColor: controller.currentPage.value < totalPages
                      ? Colors.blue.shade100 
                      : Colors.grey.shade200,
                  foregroundColor: controller.currentPage.value < totalPages
                      ? Colors.blue.shade700 
                      : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  List<Widget> _buildPageNumbers(BuildContext context, InicioController controller, int totalPages) {
    final List<Widget> pageNumbers = [];
    final currentPage = controller.currentPage.value;
    
    // Mostrar máximo 5 números de página
    int startPage = (currentPage - 2).clamp(1, totalPages);
    int endPage = (currentPage + 2).clamp(startPage, totalPages);
    
    // Ajustar para mostrar siempre 5 páginas si es posible
    if (endPage - startPage < 4) {
      if (startPage == 1) {
        endPage = (startPage + 4).clamp(startPage, totalPages);
      } else {
        startPage = (endPage - 4).clamp(1, endPage);
      }
    }
    
    for (int i = startPage; i <= endPage; i++) {
      pageNumbers.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: InkWell(
            onTap: () => controller.goToPage(i),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: i == currentPage 
                    ? Colors.blue.shade600 
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: i == currentPage 
                    ? null 
                    : Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: Text(
                  '$i',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: i == currentPage 
                        ? Colors.white 
                        : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    return pageNumbers;
  }
}
