import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/controllers/reactController.dart';
import 'package:app_bienestarmisena_v1/widgets/accesibilidad_bar.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final Reactcontroller reactController = Get.find<Reactcontroller>();
    
    return Column(
      children: [
        // Barra de accesibilidad
        const AccesibilidadBar(showScrollButtons: false),
        
        // Header original
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Logo
              Image.asset(
                "assets/img/convo2.png",
                height: 40,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 15),
              // Título
              const Text(
                "Mi Bienestar SENA",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // Info usuario
              Obx(() => Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: reactController.userImage.value.isNotEmpty
                        ? NetworkImage(reactController.userImage.value)
                        : null,
                    child: reactController.userImage.value.isEmpty
                        ? const Icon(Icons.person, color: Colors.blue)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reactController.userName.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        reactController.userEmail.value,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
            ],
          ),
        ),
      ],
    );
  }
}
