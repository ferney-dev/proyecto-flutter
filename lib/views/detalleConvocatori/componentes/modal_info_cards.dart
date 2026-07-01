import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';

class ModalInfoCards extends StatelessWidget {
  final Convocatoria convocatoria;
  final bool isMobile;

  const ModalInfoCards({
    super.key,
    required this.convocatoria,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 6 : 8,
      ),
      child: isMobile
          ? Column(
              children: [
                infoCard(
                  FontAwesomeIcons.calendarAlt,
                  "Apertura",
                  convocatoria.openDate.split("T").first,
                  Colors.blue,
                ),
                const SizedBox(height: 8),
                infoCard(
                  FontAwesomeIcons.calendarTimes,
                  "Cierre",
                  convocatoria.closeDate.split("T").first,
                  Colors.red,
                ),
                const SizedBox(height: 8),
                infoCard(
                  FontAwesomeIcons.building,
                  "Institución",
                  convocatoria.institutionName ?? "No disponible",
                  Colors.purple,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: infoCard(
                    FontAwesomeIcons.calendarAlt,
                    "Apertura",
                    convocatoria.openDate.split("T").first,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: infoCard(
                    FontAwesomeIcons.calendarTimes,
                    "Cierre",
                    convocatoria.closeDate.split("T").first,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: infoCard(
                    FontAwesomeIcons.building,
                    "Institución",
                    convocatoria.institutionName ?? "No disponible",
                    Colors.purple,
                  ),
                ),
              ],
            ),
    );
  }

  Widget infoCard(IconData icon, String label, String value, Color color) {
    return Container(
      constraints: const BoxConstraints(minHeight: 80),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
