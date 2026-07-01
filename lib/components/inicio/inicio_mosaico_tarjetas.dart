import 'package:flutter/material.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';
import 'package:app_bienestarmisena_v1/utils/image_helper.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/reactController.dart';

class InicioMosaicoTarjetas extends StatefulWidget {
  final List<Convocatoria> items;
  final Function(Convocatoria) onTarjetaTap;
  final int startIndex;
  final int count;

  const InicioMosaicoTarjetas({
    super.key,
    required this.items,
    required this.onTarjetaTap,
    this.startIndex = 8,
    this.count = 4,
  });

  @override
  State<InicioMosaicoTarjetas> createState() => _InicioMosaicoTarjetasState();
}

class _InicioMosaicoTarjetasState extends State<InicioMosaicoTarjetas> {
  final FavoritesController favController = Get.find<FavoritesController>();
  final Reactcontroller reactController = Get.find<Reactcontroller>();
  final Set<int> favoriteIds = <int>{};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    for (var item in widget.items) {
      if (_isFavorite(item.id)) {
        favoriteIds.add(item.id);
      }
    }
  }

  bool _isFavorite(int callId) {
    return favController.favoritesList.any((fav) => fav.callId == callId);
  }

  Future<void> _toggleFavorite(Convocatoria conv) async {
    final userId = reactController.userId.value;
    
    if (favoriteIds.contains(conv.id)) {
      final fav = favController.favoritesList.firstWhere(
        (f) => f.callId == conv.id,
        orElse: () => favController.favoritesList.first,
      );
      await favController.removeFavorite(fav.id);
      setState(() {
        favoriteIds.remove(conv.id);
      });
      _showAlertDialog('Eliminado de favoritos', Colors.red);
    } else {
      await favController.addFavorite(userId, conv.id);
      setState(() {
        favoriteIds.add(conv.id);
      });
      _showAlertDialog('Agregado a favoritos', Colors.green);
    }
  }

  void _showAlertDialog(String message, Color color) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.star, color: color),
            const SizedBox(width: 8),
            const Text("Favoritos"),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sublist = widget.items.skip(widget.startIndex).take(widget.count).toList();
    if (sublist.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;
        int crossAxisCount = isMobile ? 1 : 2;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 700) {
          crossAxisCount = 3;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.0,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: sublist.length,
          itemBuilder: (context, index) {
            final c = sublist[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () => widget.onTarjetaTap(c),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: ConvocatoriaImage(
                          imageUrl: c.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.mobile_friendly, color: Color(0xFF00324D), size: 16),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  c.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00324D),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                onPressed: () => _toggleFavorite(c),
                                icon: Icon(
                                  favoriteIds.contains(c.id) ? Icons.star : Icons.star_border,
                                  color: favoriteIds.contains(c.id) ? Colors.amber : Colors.grey,
                                  size: 18,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.school, color: Color(0xFF00324D), size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  c.description,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, color: Color(0xFF00324D), size: 12),
                              const SizedBox(width: 2),
                              Text("Apertura: ${c.openDate.split('T')[0]}", style: const TextStyle(fontSize: 11)),
                              const SizedBox(width: 8),
                              const Icon(Icons.calendar_today_outlined, color: Color(0xFF00324D), size: 12),
                              const SizedBox(width: 2),
                              Text("Cierre: ${c.closeDate.split('T')[0]}", style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => widget.onTarjetaTap(c),
                                  icon: const Icon(Icons.file_open, size: 12),
                                  label: const Text("Detalles"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00324D),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.check_circle, size: 12),
                                  label: const Text("Inscribirse"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF39A900),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
