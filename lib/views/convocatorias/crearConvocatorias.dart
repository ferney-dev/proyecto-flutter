import 'package:app_bienestarmisena_v1/controllers/convocatorias.dart';
import 'package:flutter/material.dart';

class ModalCrearConvocatoria extends StatefulWidget {
  final VoidCallback onSuccess;
  const ModalCrearConvocatoria({super.key, required this.onSuccess});

  @override
  State<ModalCrearConvocatoria> createState() => _ModalCrearConvocatoriaState();
}

class _ModalCrearConvocatoriaState extends State<ModalCrearConvocatoria> {
  final ConvocatoriasController _controller = ConvocatoriasController();

  // Controladores
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _resources = TextEditingController();
  final TextEditingController _callLink = TextEditingController();
  final TextEditingController _pageName = TextEditingController();
  final TextEditingController _pageUrl = TextEditingController();
  final TextEditingController _objective = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  final TextEditingController _imageUrl = TextEditingController();

  String? _openDate;
  String? _closeDate;

  final Color verde = const Color(0xFF39A900);
  final Color verdeOscuro = const Color(0xFF2d8500);

  Future<void> _seleccionarFecha(bool esInicio) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

  Future<void> _guardar() async {
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

    final creada = await _controller.crearConvocatoria(data);
    if (creada) {
      _mostrarMensaje("✅ Convocatoria creada correctamente", verde);
      Future.delayed(const Duration(milliseconds: 400), () {
        Navigator.pop(context);
        widget.onSuccess();
      });
    } else {
      _mostrarMensaje("❌ Error al crear la convocatoria", Colors.redAccent);
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
                  const Icon(Icons.event, color: Colors.white, size: 28),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Registrar Nueva Convocatoria",
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
                    _campoTexto("Título", Icons.title, _title,
                        "Ej: Convocatoria Innovación 2025"),
                    const SizedBox(height: 15),
                    _campoTexto("Descripción", Icons.text_snippet_rounded,
                        _description, "Breve descripción del objetivo."),
                    const SizedBox(height: 15),
                    _campoTexto("Objetivo", Icons.flag_rounded, _objective,
                        "Objetivo general de la convocatoria."),
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
                    _campoTexto("Recursos", Icons.attach_money_rounded,
                        _resources, "Ej: 10.000.000"),
                    const SizedBox(height: 15),
                    _campoTexto("Notas", Icons.note_alt_rounded, _notes,
                        "Observaciones o requisitos adicionales."),
                    const SizedBox(height: 15),
                    _campoTexto("Página Fuente", Icons.web, _pageName,
                        "Ej: Ministerio de Ciencia"),
                    const SizedBox(height: 15),
                    _campoTexto("URL Fuente", Icons.link, _pageUrl,
                        "https://minciencias.gov.co/..."),
                    const SizedBox(height: 15),
                    _campoTexto("Enlace de Convocatoria", Icons.link_rounded,
                        _callLink, "https://..."),
                    const SizedBox(height: 15),
                    _campoTexto("Imagen URL", Icons.image, _imageUrl,
                        "https://ejemplo.com/banner.png"),
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
                          onPressed: _guardar,
                          icon: const Icon(Icons.save, color: Colors.white),
                          label: const Text("Guardar Convocatoria"),
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

  Widget _campoTexto(
      String label, IconData icon, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: verdeOscuro),
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Colors.grey.shade300, width: 1),
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
            style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
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
                Text(value ?? "Seleccionar fecha",
                    style: TextStyle(
                        color: value == null
                            ? Colors.black38
                            : Colors.black87)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
