import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';
import 'package:app_bienestarmisena_v1/utils/image_helper.dart';
import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/reactController.dart';

class InicioTarjetaDestacada extends StatefulWidget {
  final Convocatoria convocatoria;
  final VoidCallback onDetalles;
  final VoidCallback onInscribirse;

  const InicioTarjetaDestacada({
    super.key,
    required this.convocatoria,
    required this.onDetalles,
    required this.onInscribirse,
  });

  @override
  State<InicioTarjetaDestacada> createState() => _InicioTarjetaDestacadaState();
}

class _InicioTarjetaDestacadaState extends State<InicioTarjetaDestacada> {
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
      setState(() {
        isFavorite = false;
      });
      _showAlertDialog('Eliminado de favoritos', Colors.red);
    } else {
      await favController.addFavorite(userId, widget.convocatoria.id);
      setState(() {
        isFavorite = true;
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
            Icon(isFavorite ? Icons.star : Icons.star_border, color: color),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              isMobile
                  ? Column(
                      children: [
                        _buildImage(context),
                        _buildContent(context),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(flex: 1, child: _buildImage(context)),
                        Expanded(flex: 1, child: _buildContent(context)),
                      ],
                    ),
              
              Positioned(
                top: 10,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.yellow[400],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.workspace_premium, size: 16, color: Colors.black),
                      SizedBox(width: 4),
                      Text(
                        "Destacada",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
  }

  Widget _buildImage(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDetalles,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
        child: Stack(
          children: [
            ConvocatoriaImage(
              imageUrl: widget.convocatoria.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.zero,
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.05),
                      Colors.black.withOpacity(0.25),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.mobile_friendly, color: Color(0xFF00324D), size: 22),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.convocatoria.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00324D),
                  ),
                ),
              ),
              IconButton(
                onPressed: _toggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.amber : Colors.grey,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.school, color: Color(0xFF00324D), size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.convocatoria.description,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Color(0xFF00324D), size: 18),
              const SizedBox(width: 4),
              Text("Apertura: ${widget.convocatoria.openDate.split('T')[0]}", style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 16),
              const Icon(Icons.calendar_today_outlined, color: Color(0xFF00324D), size: 18),
              const SizedBox(width: 4),
              Text("Cierre: ${widget.convocatoria.closeDate.split('T')[0]}", style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: widget.onDetalles,
                icon: const Icon(Icons.file_open, size: 16),
                label: const Text("Detalles"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00324D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: widget.onInscribirse,
                icon: const Icon(Icons.check_circle, size: 16),
                label: const Text("Inscribirse"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF39A900),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
