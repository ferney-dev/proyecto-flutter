import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';

class ModalHeader extends StatelessWidget {
  final Convocatoria convocatoria;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onClose;
  final bool isMobile;

  const ModalHeader({
    super.key,
    required this.convocatoria,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onClose,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 12 : 16,
        horizontal: isMobile ? 16 : 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF00324D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          const FaIcon(
            FontAwesomeIcons.bullhorn,
            color: Colors.yellow,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              convocatoria.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 16 : 20,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: onToggleFavorite,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
              size: isMobile ? 22 : 24,
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
