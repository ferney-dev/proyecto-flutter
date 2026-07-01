import 'package:flutter/material.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';

class ModalFooter extends StatelessWidget {
  final Convocatoria convocatoria;
  final VoidCallback onClose;
  final bool isMobile;

  const ModalFooter({
    super.key,
    required this.convocatoria,
    required this.onClose,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 10 : 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      child: isMobile
          ? Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: onClose,
                    icon: const Icon(Icons.close),
                    label: const Text("Cerrar"),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {
                      if (convocatoria.callLink.isNotEmpty) {
                        // TODO: abrir convocatoria.callLink con url_launcher
                      }
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: const Text("Abrir enlace"),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                  label: const Text("Cerrar"),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton.icon(
                  onPressed: () {
                    if (convocatoria.callLink.isNotEmpty) {
                      // TODO: abrir convocatoria.callLink con url_launcher
                    }
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text("Abrir enlace"),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
