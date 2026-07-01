import 'package:flutter/material.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/reactController.dart';
import 'package:app_bienestarmisena_v1/views/detalleConvocatori/componentes/modal_header.dart';
import 'package:app_bienestarmisena_v1/views/detalleConvocatori/componentes/modal_info_cards.dart';
import 'package:app_bienestarmisena_v1/views/detalleConvocatori/componentes/modal_tabs.dart';
import 'package:app_bienestarmisena_v1/views/detalleConvocatori/componentes/modal_content.dart';
import 'package:app_bienestarmisena_v1/views/detalleConvocatori/componentes/modal_footer.dart';

class ModalConvocatoria extends StatefulWidget {
  final Convocatoria convocatoria;
  final VoidCallback cerrarModal;

  const ModalConvocatoria({
    super.key,
    required this.convocatoria,
    required this.cerrarModal,
  });

  @override
  State<ModalConvocatoria> createState() => _ModalConvocatoriaState();
}

class _ModalConvocatoriaState extends State<ModalConvocatoria> {
  String pestanaActiva = "descripcion";
  final FavoritesController favController = Get.find<FavoritesController>();
  final Reactcontroller reactController = Get.find<Reactcontroller>();
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  void _checkFavorite() {
    isFavorite = favController.favoritesList.any((fav) => fav.callId == widget.convocatoria.id);
  }

  Future<void> _toggleFavorite() async {
    final userId = reactController.userId.value;
    
    if (isFavorite) {
      final fav = favController.favoritesList.firstWhere(
        (f) => f.callId == widget.convocatoria.id,
        orElse: () => favController.favoritesList.first,
      );
      await favController.removeFavorite(fav.id);
      setState(() => isFavorite = false);
      _showSnackBar('Eliminado de favoritos', Colors.red);
    } else {
      await favController.addFavorite(userId, widget.convocatoria.id);
      setState(() => isFavorite = true);
      _showSnackBar('Agregado a favoritos', Colors.green);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.white),
            const SizedBox(width: 8),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final conv = widget.convocatoria;

    return GestureDetector(
      onTap: widget.cerrarModal,
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Evitar cierre al hacer tap dentro
            child: Container(
              width: isMobile
                  ? MediaQuery.of(context).size.width * 0.95
                  : MediaQuery.of(context).size.width * 0.60,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.92,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  ModalHeader(
                    convocatoria: conv,
                    isFavorite: isFavorite,
                    onToggleFavorite: _toggleFavorite,
                    onClose: widget.cerrarModal,
                    isMobile: isMobile,
                  ),

                  // 🔹 IMAGEN PRINCIPAL
                  Padding(
                    padding: EdgeInsets.all(isMobile ? 8 : 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        (conv.imageUrl != null && conv.imageUrl!.isNotEmpty)
    ? conv.imageUrl!
    : "https://via.placeholder.com/400x200.png?text=Convocatoria",

                        width: double.infinity,
                        height: isMobile ? 180 : 240,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: isMobile ? 180 : 240,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.broken_image, size: 50),
                        ),
                      ),
                    ),
                  ),

                  ModalInfoCards(
                    convocatoria: conv,
                    isMobile: isMobile,
                  ),

                  const SizedBox(height: 8),

                  ModalTabs(
                    pestanaActiva: pestanaActiva,
                    onTabChange: (id) => setState(() => pestanaActiva = id),
                    isMobile: isMobile,
                  ),

                  const Divider(),

                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: isMobile ? 12 : 16,
                        vertical: isMobile ? 6 : 8,
                      ),
                      padding: EdgeInsets.all(isMobile ? 12 : 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ModalContent(
                        convocatoria: conv,
                        pestanaActiva: pestanaActiva,
                        isMobile: isMobile,
                      ),
                    ),
                  ),

                  ModalFooter(
                    convocatoria: conv,
                    onClose: widget.cerrarModal,
                    isMobile: isMobile,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
