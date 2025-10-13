import 'package:app_bienestarmisena_v1/views/favoritosCrud/crearFavoritos.dart';
import 'package:app_bienestarmisena_v1/views/favoritosCrud/editarFavoritos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';
import 'package:app_bienestarmisena_v1/models/Favoritos/favoritos.dart';

class ViewFavoritos extends StatelessWidget {
  const ViewFavoritos({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesController controller = Get.put(FavoritesController());

    final Color verde = const Color(0xFF39A900);
    final Color azul = const Color(0xFF0075FF);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 950,
        height: 700,
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF39A900), Color(0xFF0075FF)],
              ).createShader(bounds),
              child: const Text(
                "Gestión de Favoritos",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Administra los favoritos registrados por los usuarios",
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
            const SizedBox(height: 25),

            // 🔍 Buscador
            TextField(
              onChanged: (value) {
                final term = value.toLowerCase();
                controller.favoritesList.refresh(); // actualiza UI
                controller.favoritesList.value = controller.favoritesList
                    .where((f) =>
                        (f.call?['title'] ?? '').toString().toLowerCase().contains(term) ||
                        f.userId.toString().contains(term))
                    .toList();
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Buscar por usuario o convocatoria...",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // ➕ Botón de crear
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => ModalCrearFavorito(
                      onSuccess: () => controller.loadUserFavorites(0), // refresca
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Nuevo Favorito"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: verde,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 📋 Lista reactiva
            Expanded(
              child: Obx(() {
                if (controller.favoritesList.isEmpty) {
                  return const Center(child: Text("No hay favoritos registrados"));
                }
                return ListView.builder(
                  itemCount: controller.favoritesList.length,
                  itemBuilder: (_, i) {
                    final FavoriteModel fav = controller.favoritesList[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 3,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(fav.call?['imageUrl'] ??
                              "https://cdn-icons-png.flaticon.com/512/1077/1077035.png"),
                          radius: 28,
                        ),
                        title: Text(
                          fav.call?['title'] ?? 'Convocatoria desconocida',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Usuario ID: ${fav.userId}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: azul),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (_) => ModalEditarFavorito(
                                    favorito: fav,
                                    onSuccess: () => controller.loadUserFavorites(0),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text("¿Eliminar favorito?"),
                                    content: const Text("Esta acción no se puede deshacer."),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text("Cancelar"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                        ),
                                        child: const Text("Eliminar"),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await controller.removeFavorite(fav.id);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
