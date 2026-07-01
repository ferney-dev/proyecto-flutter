import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/controllers/inicio/inicio_controller.dart';
import 'package:app_bienestarmisena_v1/models/linea/linea_model.dart';

class InicioFiltrosLineas extends StatelessWidget {
  const InicioFiltrosLineas({super.key});

  @override
  Widget build(BuildContext context) {
    final InicioController controller = Get.find<InicioController>();
    
    return Obx(() {
      if (controller.isLoadingLineas.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Botón "Todos"
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: ElevatedButton.icon(
                  onPressed: () => controller.seleccionarLinea(null),
                  icon: const Icon(Icons.public, color: Colors.white),
                  label: const Text(
                    "Todos",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.lineaSeleccionada.value == null
                        ? Colors.blue.shade400
                        : Colors.grey.shade300,
                    foregroundColor: controller.lineaSeleccionada.value == null
                        ? Colors.white
                        : Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: controller.lineaSeleccionada.value == null ? 4 : 1,
                  ),
                ),
              ),
              
              // Botones dinámicos desde BD
              ...controller.lineas.map((linea) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: ElevatedButton.icon(
                    onPressed: () => controller.seleccionarLinea(linea.id),
                    icon: const Icon(Icons.label_important, size: 18),
                    label: Text(
                      linea.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.lineaSeleccionada.value == linea.id
                          ? Colors.blue.shade400
                          : Colors.grey.shade300,
                      foregroundColor: controller.lineaSeleccionada.value == linea.id
                          ? Colors.white
                          : Colors.grey.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: controller.lineaSeleccionada.value == linea.id ? 4 : 1,
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      );
    });
  }
}
