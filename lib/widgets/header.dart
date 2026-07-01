import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ✅ Importaciones necesarias
import 'package:app_bienestarmisena_v1/controllers/reactController.dart';
import 'package:app_bienestarmisena_v1/views/interface/inicio.dart';
import 'package:app_bienestarmisena_v1/views/explorar/explorar.dart';
import 'package:app_bienestarmisena_v1/views/favoritos/favoritos.dart';
import 'package:app_bienestarmisena_v1/views/perfilUser/perfil.dart';

// ✅ Nueva importación para el menú de administrador
import 'package:app_bienestarmisena_v1/views/adminmenu/adminmenu.dart';

// ✅ Componentes del header
import 'package:app_bienestarmisena_v1/components/header/header_search_bar.dart';
import 'package:app_bienestarmisena_v1/components/header/header_nav_item.dart';
import 'package:app_bienestarmisena_v1/components/header/header_user_avatar.dart';

class Header extends StatelessWidget {
  final String selected; // 🔹 Opción seleccionada en el menú

  const Header({
    super.key,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Obtiene el controlador global del usuario logueado
    final Reactcontroller reactController = Get.find<Reactcontroller>();

    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Obx(() {
      final String userName = reactController.userName.value;
      final int userId = reactController.userId.value;
      final int roleId = reactController.roleId.value; // 👈 Asegúrate de que tu Reactcontroller tenga esto

      // Debug para verificar el roleId
      debugPrint("🔍 Header - roleId: $roleId, userName: $userName");

      // ✅ Muestra la primera letra del nombre o "?" si está vacío
      final String firstLetter =
          userName.isNotEmpty ? userName[0].toUpperCase() : "?";

      // 🔹 Función para navegar (definida dentro del Obx)
      void navigateTo(Widget page) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Logos superiores
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset("assets/img/sena.png", width: isMobile ? 60 : 100, height: isMobile ? 60 : 100),
                Image.asset("assets/img/convo2.png", width: isMobile ? 80 : 120, height: isMobile ? 80 : 120),
              ],
            ),

            const SizedBox(height: 12),

            // 🔹 Menú superior con buscador y navegación
            isMobile ? _buildMobileMenu(context, roleId, userName, firstLetter, selected, navigateTo) : _buildDesktopMenu(context, roleId, userName, firstLetter, selected, navigateTo),
          ],
        ),
      );
    });
  }

  Widget _buildDesktopMenu(BuildContext context, int roleId, String userName, String firstLetter, String selected, Function(Widget) navigateTo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 🔍 Barra de búsqueda
        const HeaderSearchBar(isMobile: false),
        const SizedBox(height: 16),

        // 🔹 Opciones de navegación
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeaderNavItem(
              icon: Icons.local_offer,
              label: "Descubrir",
              isSelected: selected == "Descubrir",
              onTap: () => navigateTo(const Inicio()),
            ),
            const SizedBox(width: 30),

            HeaderNavItem(
              icon: Icons.explore,
              label: "Explorar",
              isSelected: selected == "Explorar",
              onTap: () => navigateTo(const ExplorarPage()),
            ),
            const SizedBox(width: 30),

            HeaderNavItem(
              icon: Icons.bookmark_border,
              label: "Favoritos",
              isSelected: selected == "Favoritos",
              onTap: () => navigateTo(FavoritosPage(userId: Get.find<Reactcontroller>().userId.value)),
            ),
            const SizedBox(width: 30),

            // ✅ Solo visible si el rol del usuario es administrador (roleId 1, 2, o 3)
            if (roleId == 1 || roleId == 2 || roleId == 3) ...[
              HeaderNavItem(
                icon: Icons.admin_panel_settings,
                label: "administrador",
                isSelected: selected == "administrador",
                onTap: () => navigateTo(const AdminPanel()),
              ),
              const SizedBox(width: 30),
            ],

            // 🔹 Avatar del usuario
            HeaderUserAvatar(
              firstLetter: firstLetter,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PerfilUsuarioPage()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileMenu(BuildContext context, int roleId, String userName, String firstLetter, String selected, Function(Widget) navigateTo) {
    return Column(
      children: [
        // 🔍 Barra de búsqueda en móvil
        const HeaderSearchBar(isMobile: true),
        const SizedBox(height: 12),
        // 🔹 Opciones de navegación en móvil
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              _buildMobileNavItem(
                icon: Icons.local_offer,
                label: "Descubrir",
                isSelected: selected == "Descubrir",
                onTap: () => navigateTo(const Inicio()),
              ),
              const SizedBox(width: 8),

              _buildMobileNavItem(
                icon: Icons.explore,
                label: "Explorar",
                isSelected: selected == "Explorar",
                onTap: () => navigateTo(const ExplorarPage()),
              ),
              const SizedBox(width: 8),

              _buildMobileNavItem(
                icon: Icons.bookmark_border,
                label: "Favoritos",
                isSelected: selected == "Favoritos",
                onTap: () => navigateTo(FavoritosPage(userId: Get.find<Reactcontroller>().userId.value)),
              ),
              const SizedBox(width: 8),

              // ✅ Solo visible si el rol del usuario es administrador (roleId 1, 2, o 3)
              if (roleId == 1 || roleId == 2 || roleId == 3) ...[
                _buildMobileNavItem(
                  icon: Icons.admin_panel_settings,
                  label: "Admin",
                  isSelected: selected == "Admin",
                  onTap: () => navigateTo(const AdminPanel()),
                ),
                const SizedBox(width: 8),
              ],

              // 🔹 Avatar del usuario
              HeaderUserAvatar(
                firstLetter: firstLetter,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PerfilUsuarioPage()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.blue.shade600 : Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.blue.shade600 : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
