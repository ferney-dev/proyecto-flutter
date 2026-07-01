import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';
import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/reactController.dart';

class VistaTabla extends StatelessWidget {
  final List<Convocatoria> items;
  final Function(Convocatoria) onDetalles;

  const VistaTabla({
    super.key,
    required this.items,
    required this.onDetalles,
  });

  @override
  Widget build(BuildContext context) {
    final FavoritesController favController = Get.find<FavoritesController>();
    final Reactcontroller reactController = Get.find<Reactcontroller>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Center(
      child: Container(
        width: screenWidth * 0.97,
        constraints: const BoxConstraints(
          maxWidth: 1450,
          minWidth: 380,
        ),
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 12 : 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade300, width: 1.3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: isMobile ? 16 : 28,
            horizontalMargin: isMobile ? 12 : 18,
            headingRowHeight: isMobile ? 50 : 55,
            dataRowHeight: isMobile ? 100 : 110,
            dividerThickness: 1.2,
            headingRowColor: MaterialStateProperty.all(Colors.white),
            headingTextStyle: TextStyle(
              fontSize: isMobile ? 13 : 14.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00324D),
            ),
            border: TableBorder(
              horizontalInside: BorderSide(color: Colors.grey.shade200, width: 1),
              verticalInside: BorderSide(color: Colors.grey.shade200, width: 0.6),
              bottom: BorderSide(color: Colors.grey.shade300, width: 1.2),
            ),
            columns: [
              DataColumn(
                label: Row(
                  children: [
                    Icon(Icons.image_outlined, color: Color(0xFF00324D), size: isMobile ? 16 : 18),
                    SizedBox(width: 6),
                    Text("Convocatoria", style: TextStyle(fontSize: isMobile ? 12 : 14)),
                  ],
                ),
              ),
              DataColumn(
                label: Row(
                  children: [
                    Icon(Icons.description_outlined,
                        color: Color(0xFF00324D), size: isMobile ? 16 : 18),
                    SizedBox(width: 6),
                    Text("Descripción", style: TextStyle(fontSize: isMobile ? 12 : 14)),
                  ],
                ),
              ),
              DataColumn(
                label: Row(
                  children: [
                    Icon(Icons.calendar_month,
                        color: Color(0xFF00324D), size: isMobile ? 16 : 18),
                    SizedBox(width: 6),
                    Text("Apertura", style: TextStyle(fontSize: isMobile ? 12 : 14)),
                  ],
                ),
              ),
              DataColumn(
                label: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        color: Color(0xFF00324D), size: isMobile ? 16 : 18),
                    SizedBox(width: 6),
                    Text("Cierre", style: TextStyle(fontSize: isMobile ? 12 : 14)),
                  ],
                ),
              ),
              DataColumn(
                label: Row(
                  children: [
                    Icon(Icons.settings_outlined,
                        color: Color(0xFF00324D), size: isMobile ? 16 : 18),
                    SizedBox(width: 6),
                    Text("Acciones", style: TextStyle(fontSize: isMobile ? 12 : 14)),
                  ],
                ),
              ),
            ],
            rows: items.map((conv) {
              return DataRow(
                color: MaterialStateProperty.all(Colors.grey.shade50),
                cells: [
                  DataCell(
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            (conv.imageUrl != null && conv.imageUrl!.isNotEmpty)
                                ? conv.imageUrl!
                                : "https://via.placeholder.com/400x200.png?text=Convocatoria",
                            width: isMobile ? 70 : 90,
                            height: isMobile ? 50 : 60,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, e, s) => Container(
                              width: isMobile ? 70 : 90,
                              height: isMobile ? 50 : 60,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image_outlined,
                                  size: 28, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            conv.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF00324D),
                              fontSize: isMobile ? 12 : 14.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Text(
                      conv.description.length > 50
                          ? "${conv.description.substring(0, 50)}..."
                          : conv.description,
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 13.2,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      conv.openDate.split('T')[0],
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      conv.closeDate.split('T')[0],
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => onDetalles(conv),
                          icon: const Icon(Icons.info_outline, size: 12),
                          label: const Text("Detalles"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00324D),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 10 : 14,
                                vertical: isMobile ? 8 : 10),
                            textStyle: TextStyle(fontSize: isMobile ? 10 : 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.check_circle_outline, size: 12),
                          label: const Text("Inscribirse"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF39A900),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 10 : 14,
                                vertical: isMobile ? 8 : 10),
                            textStyle: TextStyle(fontSize: isMobile ? 10 : 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Obx(() {
                          final isFav = favController.favoritesList
                              .any((f) => f.callId == conv.id);
                          return IconButton(
                            onPressed: () async {
                              if (isFav) {
                                final favToRemove = favController.favoritesList
                                    .firstWhere((f) => f.callId == conv.id);
                                await favController.removeFavorite(favToRemove.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text("❌ Eliminado de favoritos"),
                                    backgroundColor: Colors.red.shade400,
                                  ),
                                );
                              } else {
                                await favController.addFavorite(
                                  reactController.userId.value,
                                  conv.id,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text("⭐ Agregado a favoritos"),
                                    backgroundColor: Colors.green.shade600,
                                  ),
                                );
                              }
                            },
                            icon: Icon(
                              isFav ? Icons.star : Icons.star_border,
                              color: isFav ? Colors.amber : Colors.grey.shade400,
                              size: isMobile ? 22 : 26,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
