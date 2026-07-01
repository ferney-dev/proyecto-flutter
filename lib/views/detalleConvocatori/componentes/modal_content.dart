import 'package:flutter/material.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';

class ModalContent extends StatelessWidget {
  final Convocatoria convocatoria;
  final String pestanaActiva;
  final bool isMobile;

  const ModalContent({
    super.key,
    required this.convocatoria,
    required this.pestanaActiva,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: pestanaContenido(convocatoria, pestanaActiva, isMobile),
    );
  }

  Widget pestanaContenido(Convocatoria conv, String id, bool isMobile) {
    switch (id) {
      case "descripcion":
        return Text(
          conv.description.isNotEmpty
              ? conv.description
              : "Sin descripción disponible.",
          style: TextStyle(fontSize: isMobile ? 14 : 15, height: 1.5),
        );

      case "objetivo":
        return Text(
          conv.objective.isNotEmpty
              ? conv.objective
              : "Sin objetivo definido.",
          style: TextStyle(fontSize: isMobile ? 14 : 15, height: 1.5),
        );

      case "recursos":
        return Text(
          conv.resources.isNotEmpty
              ? conv.resources
              : "Sin información de recursos.",
          style: TextStyle(fontSize: isMobile ? 14 : 15, height: 1.5),
        );

      case "notas":
        return Text(
          conv.notes.isNotEmpty ? conv.notes : "No hay notas adicionales.",
          style: TextStyle(fontSize: isMobile ? 14 : 15, height: 1.5),
        );

      case "enlace":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            detalleItem("Línea de Convocatoria", conv.lineaName, isMobile),
            detalleItem("Interés Asociado", conv.interestName, isMobile),
            detalleItem("Público Objetivo", conv.publicoObjetivoName, isMobile),
            detalleItem("Institución", conv.institutionName, isMobile),
            detalleItem("Usuario", conv.userName, isMobile),
            const Divider(),
            detalleItem("Creador", conv.userName, isMobile),
            if (conv.userImage != null && conv.userImage!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      conv.userImage!,
                      height: isMobile ? 60 : 80,
                      width: isMobile ? 60 : 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, size: 60),
                    ),
                  ),
                ),
              ),
            const Divider(),
            detalleItem("Fecha de Apertura", conv.openDate.split("T").first, isMobile),
            detalleItem("Fecha de Cierre", conv.closeDate.split("T").first, isMobile),
            detalleItem("Enlace de Inscripción", conv.callLink, isMobile),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget detalleItem(String label, String? value, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 4 : 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• $label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 13 : 15,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value ?? "No disponible",
              style: TextStyle(
                fontSize: isMobile ? 13 : 15,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
