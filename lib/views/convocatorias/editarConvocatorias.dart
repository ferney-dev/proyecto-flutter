import 'package:app_bienestarmisena_v1/controllers/convocatorias.dart';
import 'package:flutter/material.dart';

import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';

class ModalEditarConvocatoria extends StatefulWidget {
  final Convocatoria convocatoria;
  final VoidCallback onSuccess;

  const ModalEditarConvocatoria({
    super.key,
    required this.convocatoria,
    required this.onSuccess,
  });

  @override
  State<ModalEditarConvocatoria> createState() => _ModalEditarConvocatoriaState();
}

class _ModalEditarConvocatoriaState extends State<ModalEditarConvocatoria> {
  final ConvocatoriasController _controller = ConvocatoriasController();

  // Controladores
  late TextEditingController _title;
  late TextEditingController _description;
  late TextEditingController _resources;
  late TextEditingController _callLink;
  late TextEditingController _pageName;
  late TextEditingController _pageUrl;
  late TextEditingController _objective;
  late TextEditingController _notes;
  late TextEditingController _imageUrl;

  String? _openDate;
  String? _closeDate;

  final Color verde = const Color(0xFF39A900);
  final Color verdeOscuro = const Color(0xFF2d8500);

  @override
  void initState() {
    super.initState();

    final c = widget.convocatoria;
    _title = TextEditingController(text: c.title);
    _description = TextEditingController(text: c.description);
    _resources = TextEditingController(text: c.resources);
    _callLink = TextEditingController(text: c.callLink);
    _pageName = TextEditingController(text: c.pageName);
    _pageUrl = TextEditingController(text: c.pageUrl);
    _objective = TextEditingController(text: c.objective);
    _notes = TextEditingController(text: c.notes);
    _imageUrl = TextEditingController(text: c.imageUrl);
    _openDate = c.openDate;
    _closeDate = c.closeDate;
  }

  Future<void> _seleccionarFecha(bool esInicio) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(esInicio ? _openDate ?? "" : _closeDate ?? "") ??
          DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      locale: const Locale('es', 'ES'),
    );

    if (picked != null) {
      setState(() {
        final dateStr = "${picked.year}-${picked.month}-${picked.day}";
        if (esInicio) {
          _openDate = dateStr;
        } else {
          _closeDate = dateStr;
        }
      });
    }
  }

  Future<void> _guardarCambios() async {
    if (_title.text.trim().isEmpty) {
      _mostrarMensaje("⚠️ El título es obligatorio", Colors.orange);
      return;
    }

    final Map<String, dynamic> data = {
      "title": _title.text.trim(),
      "description": _description.text.trim(),
      "resources": _resources.text.trim(),
      "callLink": _callLink.text.trim(),
      "openDate": _openDate ?? "",
      "closeDate": _closeDate ?? "",
      "pageName": _pageName.text.trim(),
      "pageUrl": _pageUrl.text.trim(),
      "objective": _objective.text.trim(),
      "notes": _notes.text.trim(),
      "imageUrl": _imageUrl.text.trim(),
    };

    final actualizada = await _controller.actualizarConvocatoria(widget.convocatoria.id, data);
    if (actualizada) {
      _mostrarMensaje("✅ Convocatoria actualizada correctamente", verde);
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pop(context);
        widget.onSuccess();
      });
    } else {
      _mostrarMensaje("❌ Error al actualizar la convocatoria", Colors.redAccent);
    }
  }

  void _mostrarMensaje(String texto, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 70, vertical: 50),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 950,
        padding: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 25)
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: verde,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit_document, color: Colors.white, size: 28),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Editar Convocatoria",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Formulario
            Padding(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _campoTexto("Título", Icons.title, _title),
                    const SizedBox(height: 15),
                    _campoTexto("Descripción", Icons.text_snippet_rounded, _description),
                    const SizedBox(height: 15),
                    _campoTexto("Objetivo", Icons.flag_rounded, _objective),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: _botonFecha("Fecha de Apertura", _openDate,
                              () => _seleccionarFecha(true)),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _botonFecha("Fecha de Cierre", _closeDate,
                              () => _seleccionarFecha(false)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _campoTexto("Recursos", Icons.attach_money_rounded, _resources),
                    const SizedBox(height: 15),
                    _campoTexto("Notas", Icons.note_alt_rounded, _notes),
                    const SizedBox(height: 15),
                    _campoTexto("Página Fuente", Icons.web, _pageName),
                    const SizedBox(height: 15),
                    _campoTexto("URL Fuente", Icons.link, _pageUrl),
                    const SizedBox(height: 15),
                    _campoTexto("Enlace de Convocatoria", Icons.link_rounded, _callLink),
                    const SizedBox(height: 15),
                    _campoTexto("Imagen URL", Icons.image, _imageUrl),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.black54),
                          label: const Text("Cancelar"),
                        ),
                        ElevatedButton.icon(
                          onPressed: _guardarCambios,
                          icon: const Icon(Icons.save, color: Colors.white),
                          label: const Text("Guardar Cambios"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: verde,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 25),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campoTexto(String label, IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: verdeOscuro),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: verde, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _botonFecha(String label, String? value, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 16)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_month, color: verdeOscuro),
                const SizedBox(width: 10),
                Text(
                  value ?? "Seleccionar fecha",
                  style: TextStyle(
                      color: value == null ? Colors.black38 : Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
