import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';
import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/reactController.dart';

class VistaMosaico extends StatelessWidget {
  final List<Convocatoria> items;
  final Function(Convocatoria) onDetalles;

  const VistaMosaico({
    super.key,
    required this.items,
    required this.onDetalles,
  });

  @override
  Widget build(BuildContext context) {
    final FavoritesController favController = Get.find<FavoritesController>();
    final Reactcontroller reactController = Get.find<Reactcontroller>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        int crossAxisCount = 1;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 2;
        }

        final mainAxisSpacing = isMobile ? 12.0 : 20.0;
        final crossAxisSpacing = isMobile ? 12.0 : 20.0;
        final childAspectRatio = isMobile ? 0.75 : 0.78;
        final imageHeight = isMobile ? 120.0 : 150.0;
        final padding = isMobile ? 10.0 : 12.0;
        final titleFontSize = isMobile ? 13.0 : 15.0;
        final descFontSize = isMobile ? 11.0 : 13.0;
        final marginVertical = isMobile ? 4.0 : 6.0;
        final marginBottom = isMobile ? 6.0 : 8.0;
        final paddingHorizontal = isMobile ? 8.0 : 10.0;
        final paddingVertical = isMobile ? 4.0 : 6.0;
        final dateFontSize = isMobile ? 10.0 : 12.0;
        final buttonPadding = isMobile ? 6.0 : 8.0;
        final buttonTextSize = isMobile ? 10.0 : 12.0;
        final starSize = isMobile ? 22.0 : 26.0;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final c = items[index];

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () => onDetalles(c),
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.network(
                        (c.imageUrl != null && c.imageUrl!.isNotEmpty)
                            ? c.imageUrl!
                            : "https://via.placeholder.com/400x200.png?text=Convocatoria",
                        height: imageHeight,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, error, stackTrace) => Container(
                          height: imageHeight,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.broken_image, size: 50),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.mobile_friendly,
                                    color: Color(0xFF00324D), size: 16),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    c.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF00324D),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isMobile ? 4 : 6),
                            Text(
                              c.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: descFontSize,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              margin: EdgeInsets.only(top: marginVertical, bottom: marginBottom),
                              padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontal,
                                vertical: paddingVertical,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_month,
                                          size: 14, color: Color(0xFF00324D)),
                                      const SizedBox(width: 4),
                                      Text(
                                        c.openDate.split('T')[0],
                                        style: TextStyle(fontSize: dateFontSize),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time,
                                          size: 14, color: Colors.redAccent),
                                      const SizedBox(width: 4),
                                      Text(
                                        c.closeDate.split('T')[0],
                                        style: TextStyle(fontSize: dateFontSize),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => onDetalles(c),
                                    icon: const Icon(Icons.file_open, size: 12),
                                    label: const Text("Detalles"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF00324D),
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(vertical: buttonPadding),
                                      textStyle: TextStyle(fontSize: buttonTextSize),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.check_circle, size: 12),
                                    label: const Text("Inscribirse"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF39A900),
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(vertical: buttonPadding),
                                      textStyle: TextStyle(fontSize: buttonTextSize),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Obx(() {
                                  final isFav = favController.favoritesList.any((f) => f.callId == c.id);
                                  return IconButton(
                                    onPressed: () async {
                                      if (isFav) {
                                        final favToRemove = favController.favoritesList.firstWhere((f) => f.callId == c.id);
                                        await favController.removeFavorite(favToRemove.id);
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Row(
                                              children: [
                                                Icon(Icons.star_border, color: Colors.red),
                                                SizedBox(width: 8),
                                                Text("Favoritos"),
                                              ],
                                            ),
                                            content: const Text("❌ Eliminado de favoritos"),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text("OK"),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        await favController.addFavorite(reactController.userId.value, c.id);
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Row(
                                              children: [
                                                Icon(Icons.star, color: Colors.green),
                                                SizedBox(width: 8),
                                                Text("Favoritos"),
                                              ],
                                            ),
                                            content: const Text("⭐ Agregado a favoritos"),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text("OK"),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                    icon: Icon(
                                      isFav ? Icons.star : Icons.star_border,
                                      color: isFav ? Colors.amber : Colors.grey.shade400,
                                      size: starSize,
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
