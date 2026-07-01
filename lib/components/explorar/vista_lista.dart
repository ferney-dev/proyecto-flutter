import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';
import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/reactController.dart';

class VistaLista extends StatelessWidget {
  final List<Convocatoria> items;
  final Function(Convocatoria) onDetalles;

  const VistaLista({
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

        return Column(
          children: items.map((conv) {
            return _ListaItem(
              conv: conv,
              isMobile: isMobile,
              onDetalles: onDetalles,
              favController: favController,
              reactController: reactController,
            );
          }).toList(),
        );
      },
    );
  }
}

class _ListaItem extends StatefulWidget {
  final Convocatoria conv;
  final bool isMobile;
  final Function(Convocatoria) onDetalles;
  final FavoritesController favController;
  final Reactcontroller reactController;

  const _ListaItem({
    required this.conv,
    required this.isMobile,
    required this.onDetalles,
    required this.favController,
    required this.reactController,
  });

  @override
  State<_ListaItem> createState() => _ListaItemState();
}

class _ListaItemState extends State<_ListaItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: widget.isMobile ? 8 : 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              bottomLeft: Radius.circular(18),
            ),
            child: Image.network(
              (widget.conv.imageUrl != null && widget.conv.imageUrl!.isNotEmpty)
                  ? widget.conv.imageUrl!
                  : "https://via.placeholder.com/400x250.png?text=Convocatoria",
              width: widget.isMobile ? 130 : 250,
              height: widget.isMobile ? 130 : 220,
              fit: BoxFit.cover,
              errorBuilder: (ctx, e, s) => Container(
                width: widget.isMobile ? 130 : 250,
                height: widget.isMobile ? 130 : 220,
                color: Colors.grey.shade200,
                child: const Icon(Icons.broken_image_outlined,
                    size: 60, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(widget.isMobile ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.campaign_outlined,
                          color: Color(0xFF00324D), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.conv.title,
                          style: TextStyle(
                            fontSize: widget.isMobile ? 16 : 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00324D),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 1,
                    color: Colors.grey.shade300,
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => isExpanded = !isExpanded),
                    child: Text(
                      isExpanded
                          ? widget.conv.description
                          : (widget.conv.description.length > 100
                              ? "${widget.conv.description.substring(0, 100)}..."
                              : widget.conv.description),
                      style: TextStyle(
                        fontSize: widget.isMobile ? 12 : 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month,
                          color: Colors.green, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        "Apertura: ${widget.conv.openDate.split('T')[0]}",
                        style: TextStyle(
                            fontSize: widget.isMobile ? 12 : 13.5,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 18),
                      const Icon(Icons.event_busy_outlined,
                          color: Colors.redAccent, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        "Cierre: ${widget.conv.closeDate.split('T')[0]}",
                        style: TextStyle(
                            fontSize: widget.isMobile ? 12 : 13.5,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 1,
                    color: Colors.grey.shade300,
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => widget.onDetalles(widget.conv),
                        icon: const Icon(Icons.info_outline, size: 16),
                        label: const Text("Detalles"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00324D),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: widget.isMobile ? 12 : 18,
                              vertical: widget.isMobile ? 8 : 10),
                          textStyle: TextStyle(fontSize: widget.isMobile ? 11 : 13),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.check_circle_outline, size: 16),
                        label: const Text("Inscribirse"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF39A900),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: widget.isMobile ? 12 : 18,
                              vertical: widget.isMobile ? 8 : 10),
                          textStyle: TextStyle(fontSize: widget.isMobile ? 11 : 13),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const Spacer(),
                      Obx(() {
                        final isFav = widget.favController.favoritesList
                            .any((f) => f.callId == widget.conv.id);
                        return IconButton(
                          tooltip: isFav
                              ? "Eliminar de favoritos"
                              : "Agregar a favoritos",
                          onPressed: () async {
                            if (isFav) {
                              final favToRemove = widget.favController.favoritesList
                                  .firstWhere((f) => f.callId == widget.conv.id);
                              final ok = await widget.favController
                                  .removeFavorite(favToRemove.id);
                              if (ok) {
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
                              }
                            } else {
                              final newFav = await widget.favController.addFavorite(
                                widget.reactController.userId.value,
                                widget.conv.id,
                              );
                              if (newFav != null) {
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
                            }
                          },
                          icon: AnimatedRotation(
                            duration: const Duration(milliseconds: 400),
                            turns: isFav ? 1 : 0,
                            child: Icon(
                              isFav ? Icons.star : Icons.star_border,
                              color: isFav ? Colors.amber : Colors.grey.shade400,
                              size: widget.isMobile ? 24 : 28,
                            ),
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
    );
  }
}
