import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/controllers/reactController.dart';
import 'package:app_bienestarmisena_v1/views/interface/inicio.dart';
import 'package:app_bienestarmisena_v1/views/login/login.dart';

class MenuSidebar extends StatelessWidget {
  const MenuSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final Reactcontroller reactController = Get.find<Reactcontroller>();
    
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Opciones del menú
          _buildMenuItem(
            icon: Icons.home,
            title: 'Inicio',
            onTap: () => Get.off(() => const Inicio()),
          ),
          _buildMenuItem(
            icon: Icons.event,
            title: 'Convocatorias',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.favorite,
            title: 'Favoritos',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.person,
            title: 'Mi Perfil',
            onTap: () {},
          ),
          const Spacer(),
          // Cerrar sesión
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Cerrar Sesión',
            onTap: () {
              reactController.cerrarSesion();
              Get.offAll(() => const Login());
            },
            isLogout: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: isLogout ? Colors.red.shade50 : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout ? Colors.red.shade700 : Colors.blue.shade700,
              size: 24,
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: isLogout ? Colors.red.shade700 : Colors.grey.shade800,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
