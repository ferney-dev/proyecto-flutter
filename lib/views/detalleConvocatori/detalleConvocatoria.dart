import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';

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
                  // 🔹 ENCABEZADO
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    decoration: const BoxDecoration(
                      color: Color(0xFF00324D),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.bullhorn,
                            color: Colors.yellow, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            conv.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: widget.cerrarModal,
                          icon: const Icon(Icons.close, color: Colors.white),
                        )
                      ],
                    ),
                  ),

                  // 🔹 IMAGEN PRINCIPAL
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        (conv.imageUrl != null && conv.imageUrl!.isNotEmpty)
    ? conv.imageUrl!
    : "https://via.placeholder.com/400x200.png?text=Convocatoria",

                        width: double.infinity,
                        height: 240,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 240,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.broken_image, size: 50),
                        ),
                      ),
                    ),
                  ),

                  // 🔹 INFO GENERAL
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: infoCard(
                            FontAwesomeIcons.calendarAlt,
                            "Apertura",
                            conv.openDate.split("T").first,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: infoCard(
                            FontAwesomeIcons.calendarTimes,
                            "Cierre",
                            conv.closeDate.split("T").first,
                            Colors.red,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: infoCard(
                            FontAwesomeIcons.building,
                            "Institución",
                            conv.institutionName ?? "No disponible",
                            Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 🔹 PESTAÑAS
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          tabButton("descripcion", Icons.description,
                              "Descripción", Colors.blue),
                          tabButton(
                              "objetivo", Icons.flag, "Objetivo", Colors.green),
                          tabButton("recursos", Icons.bookmark, "Recursos",
                              Colors.orange),
                          tabButton("notas", Icons.note, "Notas", Colors.teal),
                          tabButton(
                              "enlace", Icons.link, "Más info", Colors.purple),
                        ],
                      ),
                    ),
                  ),

                  const Divider(),

                  // 🔹 CONTENIDO
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: SingleChildScrollView(
                        child: pestanaContenido(conv, pestanaActiva),
                      ),
                    ),
                  ),

                  // 🔹 BOTONES FINALES
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: widget.cerrarModal,
                          icon: const Icon(Icons.close),
                          label: const Text("Cerrar"),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton.icon(
                          onPressed: () {
                            if (conv.callLink.isNotEmpty) {
                              // TODO: abrir conv.callLink con url_launcher
                            }
                          },
                          icon: const Icon(Icons.open_in_new),
                          label: const Text("Abrir enlace"),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Tarjeta informativa (usada arriba)
  Widget infoCard(IconData icon, String label, String value, Color color) {
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
              textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // 🔹 Botones de pestañas
  Widget tabButton(String id, IconData icon, String label, Color color) {
    final bool activo = pestanaActiva == id;
    return GestureDetector(
      onTap: () => setState(() => pestanaActiva = id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: activo ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: activo ? Border.all(color: color, width: 2) : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: activo ? color : Colors.grey),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    color: activo ? color : Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  // 🔹 Contenido por pestaña
  Widget pestanaContenido(Convocatoria conv, String id) {
    switch (id) {
      case "descripcion":
        return Text(conv.description.isNotEmpty
            ? conv.description
            : "Sin descripción disponible.");

      case "objetivo":
        return Text(conv.objective.isNotEmpty
            ? conv.objective
            : "Sin objetivo definido.");

      case "recursos":
        return Text(conv.resources.isNotEmpty
            ? conv.resources
            : "Sin información de recursos.");

      case "notas":
        return Text(
            conv.notes.isNotEmpty ? conv.notes : "No hay notas adicionales.");

      // ✅ “Más info” muestra todos los detalles
      case "enlace":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            detalleItem("Línea de Convocatoria", conv.lineaName),
            detalleItem("Interés Asociado", conv.interestName),
            detalleItem("Público Objetivo", conv.publicoObjetivoName),
            detalleItem("Institución", conv.institutionName),
            detalleItem("Usuario", conv.userName),
            const Divider(),
            detalleItem("Creador", conv.userName),
            if (conv.userImage != null && conv.userImage!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      conv.userImage!,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, size: 60),
                    ),
                  ),
                ),
              ),
            const Divider(),
            detalleItem("Fecha de Apertura", conv.openDate.split("T").first),
            detalleItem("Fecha de Cierre", conv.closeDate.split("T").first),
            detalleItem("Enlace de Inscripción", conv.callLink),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  // 🔹 Helper visual para mostrar cada dato
  Widget detalleItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• $label: ",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black)),
          Expanded(
            child: Text(value ?? "No disponible",
                style: const TextStyle(fontSize: 15, color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
