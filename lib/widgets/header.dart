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

    final String userName = reactController.userName.value;
    final int userId = reactController.userId.value;
    final int roleId = reactController.roleId.value; // 👈 Asegúrate de que tu Reactcontroller tenga esto

    // ✅ Muestra la primera letra del nombre o "?" si está vacío
    final String firstLetter =
        userName.isNotEmpty ? userName[0].toUpperCase() : "?";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Logos superiores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("img/sena.png", width: 100, height: 100),
              Image.asset("img/convo2.png", width: 120, height: 120),
            ],
          ),

          const SizedBox(height: 12),

          // 🔹 Menú superior con buscador y navegación
          Row(
            children: [
              // 🔍 Barra de búsqueda
              SizedBox(
                width: 340,
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar...",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                ),
              ),
              const Spacer(),

              // 🔹 Opciones de navegación
              Row(
                children: [
                  _navItem(
                    context,
                    Icons.local_offer,
                    "Descubrir",
                    selected == "Descubrir",
                    const Inicio(),
                  ),
                  const SizedBox(width: 16),

                  _navItem(
                    context,
                    Icons.explore,
                    "Explorar",
                    selected == "Explorar",
                    const ExplorarPage(),
                  ),
                  const SizedBox(width: 16),

                  _navItem(
                    context,
                    Icons.bookmark_border,
                    "Favoritos",
                    selected == "Favoritos",
                    FavoritosPage(userId: userId),
                  ),
                  const SizedBox(width: 16),

                  // ✅ Solo visible si el rol del usuario es 2 (Administrador)
                  if (roleId == 2) ...[
                    _navItem(
                      context,
                      Icons.admin_panel_settings, // 🛡️ Ícono de admin
                      "Admin",
                      selected == "Admin",
                      const AdminPanel(),
                    ),
                    const SizedBox(width: 16),
                  ],

                  // 🔹 Avatar del usuario que lleva al perfil
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PerfilUsuarioPage(),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey.shade700,
                      child: Text(
                        firstLetter,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 Función para crear los botones del menú
  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label,
    bool isSelected,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected ? const Color(0xFF39A900) : Colors.black,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: isSelected ? const Color(0xFF39A900) : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
