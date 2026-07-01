import 'package:flutter/material.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';

class FavoritosTarjeta extends StatelessWidget {
  final List<Convocatoria> items;
  final Function(Convocatoria) onDetalles;
  final Function(Convocatoria) onEliminar;

  const FavoritosTarjeta({
    super.key,
    required this.items,
    required this.onDetalles,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final crossAxisCount = isMobile ? 1 : (constraints.maxWidth < 1200 ? 2 : 3);

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.88,
            crossAxisSpacing: 22,
            mainAxisSpacing: 22,
          ),
          itemBuilder: (context, index) {
            return _TarjetaItem(
              conv: items[index],
              onDetalles: onDetalles,
              onEliminar: onEliminar,
            );
          },
        );
      },
    );
  }
}

class _TarjetaItem extends StatefulWidget {
  final Convocatoria conv;
  final Function(Convocatoria) onDetalles;
  final Function(Convocatoria) onEliminar;

  const _TarjetaItem({
    required this.conv,
    required this.onDetalles,
    required this.onEliminar,
  });

  @override
  State<_TarjetaItem> createState() => _TarjetaItemState();
}

class _TarjetaItemState extends State<_TarjetaItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => widget.onDetalles(widget.conv),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: 220,
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                      image: DecorationImage(
                        image: NetworkImage(
                          (widget.conv.imageUrl != null &&
                                  widget.conv.imageUrl!.isNotEmpty)
                              ? widget.conv.imageUrl!
                              : "https://via.placeholder.com/400x200",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.campaign,
                              color: Color(0xFF00324D), size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              widget.conv.title,
                              style: const TextStyle(
                                color: Color(0xFF00324D),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => setState(() => isExpanded = !isExpanded),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.description_outlined,
                                color: Color(0xFF00324D), size: 18),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                widget.conv.description.isNotEmpty
                                    ? widget.conv.description
                                    : "Sin descripción disponible.",
                                maxLines: isExpanded ? null : 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 16, color: Color(0xFF00324D)),
                                const SizedBox(width: 4),
                                Text(
                                  "Apertura: ${widget.conv.openDate.split('T')[0]}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month,
                                    size: 16, color: Colors.redAccent),
                                const SizedBox(width: 4),
                                Text(
                                  "Cierre: ${widget.conv.closeDate.split('T')[0]}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => widget.onDetalles(widget.conv),
                              icon: const Icon(Icons.insert_drive_file, size: 18),
                              label: const Text("Detalles"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00324D),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
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
                              icon: const Icon(Icons.check_circle, size: 18),
                              label: const Text("Inscribirse"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF39A900),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
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
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => widget.onEliminar(widget.conv),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
