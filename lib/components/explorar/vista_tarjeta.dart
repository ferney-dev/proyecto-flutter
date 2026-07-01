import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';
import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/reactController.dart';

class VistaTarjeta extends StatelessWidget {
  final List<Convocatoria> items;
  final Function(Convocatoria) onDetalles;

  const VistaTarjeta({
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
        double cardWidth = constraints.maxWidth;

        if (constraints.maxWidth > 1200) {
          cardWidth = (constraints.maxWidth / 3) - 20;
        } else if (constraints.maxWidth > 800) {
          cardWidth = (constraints.maxWidth / 2) - 20;
        }

        final spacing = isMobile ? 12.0 : 20.0;
        final titleFontSize = isMobile ? 15.0 : 18.0;
        final descFontSize = isMobile ? 12.0 : 14.0;
        final dateFontSize = isMobile ? 11.0 : 13.0;
        final dateSpacing = isMobile ? 6.0 : 10.0;
        final imageHeight = isMobile ? 140.0 : 180.0;
        final padding = isMobile ? 12.0 : 16.0;
        final verticalPadding = isMobile ? 8.0 : 10.0;
        final horizontalPadding = isMobile ? 10.0 : 12.0;
        final buttonPadding = isMobile ? 12.0 : 18.0;
        final buttonTextSize = isMobile ? 11.0 : 13.0;
        final starSize = isMobile ? 24.0 : 28.0;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: WrapAlignment.center,
          children: items.map((conv) {
            return _TarjetaItem(
              conv: conv,
              cardWidth: cardWidth,
              imageHeight: imageHeight,
              padding: padding,
              titleFontSize: titleFontSize,
              descFontSize: descFontSize,
              dateFontSize: dateFontSize,
              dateSpacing: dateSpacing,
              verticalPadding: verticalPadding,
              horizontalPadding: horizontalPadding,
              buttonPadding: buttonPadding,
              buttonTextSize: buttonTextSize,
              starSize: starSize,
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

class _TarjetaItem extends StatefulWidget {
  final Convocatoria conv;
  final double cardWidth;
  final double imageHeight;
  final double padding;
  final double titleFontSize;
  final double descFontSize;
  final double dateFontSize;
  final double dateSpacing;
  final double verticalPadding;
  final double horizontalPadding;
  final double buttonPadding;
  final double buttonTextSize;
  final double starSize;
  final Function(Convocatoria) onDetalles;
  final FavoritesController favController;
  final Reactcontroller reactController;

  const _TarjetaItem({
    required this.conv,
    required this.cardWidth,
    required this.imageHeight,
    required this.padding,
    required this.titleFontSize,
    required this.descFontSize,
    required this.dateFontSize,
    required this.dateSpacing,
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.buttonPadding,
    required this.buttonTextSize,
    required this.starSize,
    required this.onDetalles,
    required this.favController,
    required this.reactController,
  });

  @override
  State<_TarjetaItem> createState() => _TarjetaItemState();
}

class _TarjetaItemState extends State<_TarjetaItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.cardWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            child: GestureDetector(
              onTap: () => widget.onDetalles(widget.conv),
              child: Image.network(
                (widget.conv.imageUrl != null && widget.conv.imageUrl!.isNotEmpty)
                    ? widget.conv.imageUrl!
                    : "https://via.placeholder.com/400x200.png?text=Convocatoria",
                height: widget.imageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, e, s) => Container(
                  height: widget.imageHeight,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 60),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(widget.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.mobile_friendly,
                        color: Color(0xFF00324D), size: 20),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.conv.title,
                        style: TextStyle(
                          fontSize: widget.titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00324D),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => setState(() => isExpanded = !isExpanded),
                  child: Text(
                    isExpanded
                        ? widget.conv.description
                        : (widget.conv.description.length > 100
                            ? "${widget.conv.description.substring(0, 100)}..."
                            : widget.conv.description),
                    style: TextStyle(fontSize: widget.descFontSize, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_month,
                        size: 16, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      "Apertura: ${widget.conv.openDate.split('T')[0]}",
                      style: TextStyle(fontSize: widget.dateFontSize),
                    ),
                    SizedBox(width: widget.dateSpacing),
                    const Icon(Icons.calendar_today_outlined,
                        size: 16, color: Colors.redAccent),
                    const SizedBox(width: 4),
                    Text(
                      "Cierre: ${widget.conv.closeDate.split('T')[0]}",
                      style: TextStyle(fontSize: widget.dateFontSize),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.horizontalPadding,
              vertical: widget.verticalPadding,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => widget.onDetalles(widget.conv),
                    icon: const Icon(Icons.file_open, size: 16),
                    label: const Text("Detalles"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00324D),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.buttonPadding,
                      ),
                      textStyle: TextStyle(fontSize: widget.buttonTextSize),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.check_circle, size: 16),
                    label: const Text("Inscribirse"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF39A900),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.buttonPadding,
                      ),
                      textStyle: TextStyle(fontSize: widget.buttonTextSize),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Obx(() {
                  final isFav = widget.favController.favoritesList.any((f) => f.callId == widget.conv.id);
                  return IconButton(
                    onPressed: () async {
                      if (isFav) {
                        final favToRemove = widget.favController.favoritesList.firstWhere((f) => f.callId == widget.conv.id);
                        await widget.favController.removeFavorite(favToRemove.id);
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
                        await widget.favController.addFavorite(widget.reactController.userId.value, widget.conv.id);
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
                      color: isFav ? Colors.amber : Colors.grey.shade500,
                      size: widget.starSize,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
