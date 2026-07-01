import 'package:flutter/material.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';

class FavoritosLista extends StatelessWidget {
  final List<Convocatoria> items;
  final Function(Convocatoria) onDetalles;
  final Function(Convocatoria) onEliminar;

  const FavoritosLista({
    super.key,
    required this.items,
    required this.onDetalles,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((conv) {
        return _ListaItem(
          conv: conv,
          onDetalles: onDetalles,
          onEliminar: onEliminar,
        );
      }).toList(),
    );
  }
}

class _ListaItem extends StatefulWidget {
  final Convocatoria conv;
  final Function(Convocatoria) onDetalles;
  final Function(Convocatoria) onEliminar;

  const _ListaItem({
    required this.conv,
    required this.onDetalles,
    required this.onEliminar,
  });

  @override
  State<_ListaItem> createState() => _ListaItemState();
}

class _ListaItemState extends State<_ListaItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.network(
              (widget.conv.imageUrl != null && widget.conv.imageUrl!.isNotEmpty)
                  ? widget.conv.imageUrl!
                  : "https://via.placeholder.com/400x250",
              width: 200,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (ctx, e, s) => Container(
                width: 200,
                height: 180,
                color: Colors.grey.shade200,
                child: const Icon(Icons.broken_image_outlined,
                    size: 60, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.campaign,
                          color: Color(0xFF00324D), size: 20),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.conv.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00324D),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
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
                          : (widget.conv.description.length > 150
                              ? "${widget.conv.description.substring(0, 150)}..."
                              : widget.conv.description),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Color(0xFF00324D)),
                      const SizedBox(width: 4),
                      Text(
                        "Apertura: ${widget.conv.openDate.split('T')[0]}",
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.calendar_month,
                          size: 16, color: Colors.redAccent),
                      const SizedBox(width: 4),
                      Text(
                        "Cierre: ${widget.conv.closeDate.split('T')[0]}",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => widget.onDetalles(widget.conv),
                        icon: const Icon(Icons.insert_drive_file, size: 16),
                        label: const Text("Detalles"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00324D),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.check_circle, size: 16),
                        label: const Text("Inscribirse"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF39A900),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
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
