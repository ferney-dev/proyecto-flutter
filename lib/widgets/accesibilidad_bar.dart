import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/controllers/accesibilidad/accesibilidad_controller.dart';

class AccesibilidadBar extends StatelessWidget {
  final ScrollController? scrollController;
  final bool showScrollButtons;

  const AccesibilidadBar({
    super.key,
    this.scrollController,
    this.showScrollButtons = true,
  });

  @override
  Widget build(BuildContext context) {
    final accesibilidadController = Get.find<AccesibilidadController>();
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 20,
        vertical: isMobile ? 8 : 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(isMobile ? 16 : 20),
          bottomRight: Radius.circular(isMobile ? 16 : 20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Espacio izquierdo
          const SizedBox(width: 8),

          // Botones de scroll (flechas arriba/abajo) - izquierda
          if (showScrollButtons && scrollController != null)
            Row(
              children: [
                _buildCircleButton(
                  context: context,
                  icon: Icons.keyboard_arrow_up,
                  tooltip: "Subir",
                  onPressed: () {
                    scrollController!.animateTo(
                      scrollController!.offset - 200,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  isMobile: isMobile,
                ),
                const SizedBox(width: 8),
                _buildCircleButton(
                  context: context,
                  icon: Icons.keyboard_arrow_down,
                  tooltip: "Bajar",
                  onPressed: () {
                    scrollController!.animateTo(
                      scrollController!.offset + 200,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  isMobile: isMobile,
                ),
              ],
            ),

          const Spacer(),

          // Botón de modo oscuro - arriba derecha
          Obx(() => _buildCircleButton(
                context: context,
                icon: accesibilidadController.isDarkMode.value
                    ? Icons.light_mode
                    : Icons.dark_mode,
                tooltip: accesibilidadController.isDarkMode.value
                    ? "Modo claro"
                    : "Modo oscuro",
                onPressed: accesibilidadController.toggleDarkMode,
                isMobile: isMobile,
              )),

          const SizedBox(width: 12),

          // Botones de tamaño de fuente - círculo con 3 iconos
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 6 : 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Disminuir tamaño
                  Obx(() => _buildSmallIconButton(
                        context: context,
                        icon: Icons.remove,
                        tooltip: "Disminuir tamaño",
                        onPressed: accesibilidadController.fontScale.value > 0.8
                            ? accesibilidadController.decreaseFontSize
                            : null,
                        isMobile: isMobile,
                      )),
                  
                  // Restablecer tamaño
                  Obx(() => _buildSmallIconButton(
                        context: context,
                        icon: Icons.refresh,
                        tooltip: "Restablecer",
                        onPressed: accesibilidadController.fontScale.value != 1.0
                            ? accesibilidadController.resetFontSize
                            : null,
                        isMobile: isMobile,
                      )),
                  
                  // Aumentar tamaño
                  Obx(() => _buildSmallIconButton(
                        context: context,
                        icon: Icons.add,
                        tooltip: "Aumentar tamaño",
                        onPressed: accesibilidadController.fontScale.value < 1.4
                            ? accesibilidadController.increaseFontSize
                            : null,
                        isMobile: isMobile,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    required bool isMobile,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Theme.of(context).colorScheme.onPrimary,
          size: isMobile ? 20 : 24,
        ),
        tooltip: tooltip,
        padding: EdgeInsets.all(isMobile ? 8 : 10),
        constraints: const BoxConstraints(),
      ),
    );
  }

  Widget _buildSmallIconButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
    required bool isMobile,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: onPressed != null
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.primary.withOpacity(0.4),
        size: isMobile ? 16 : 18,
      ),
      tooltip: tooltip,
      padding: EdgeInsets.all(isMobile ? 4 : 6),
      constraints: const BoxConstraints(),
    );
  }
}
