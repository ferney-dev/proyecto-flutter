import 'package:app_bienestarmisena_v1/controllers/convocatorias.dart';
import 'package:app_bienestarmisena_v1/views/convocatorias/crearConvocatorias.dart';
import 'package:app_bienestarmisena_v1/views/convocatorias/editarConvocatorias.dart';
import 'package:flutter/material.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';

class ViewConvocatorias extends StatefulWidget {
  const ViewConvocatorias({super.key});

  @override
  State<ViewConvocatorias> createState() => _ViewConvocatoriasState();
}

class _ViewConvocatoriasState extends State<ViewConvocatorias> {
  final ConvocatoriasController _controller = ConvocatoriasController();
  List<Convocatoria> _convocatorias = [];
  List<Convocatoria> _filtradas = [];
  bool _loading = true;
  String _busqueda = "";

  final Color verde = const Color(0xFF39A900);
  final Color azul = const Color(0xFF0075FF);

  @override
  void initState() {
    super.initState();
    _cargarConvocatorias();
  }

  Future<void> _cargarConvocatorias() async {
    setState(() => _loading = true);
    _convocatorias = await _controller.getConvocatorias();
    _filtradas = _convocatorias;
    setState(() => _loading = false);
  }

  void _filtrarConvocatorias(String valor) {
    setState(() {
      _busqueda = valor.toLowerCase();
      _filtradas = _convocatorias.where((c) {
        return c.title.toLowerCase().contains(_busqueda) ||
            c.pageName.toLowerCase().contains(_busqueda) ||
            c.objective.toLowerCase().contains(_busqueda);
      }).toList();
    });
  }

  void _mostrarMensaje(String texto, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto, style: const TextStyle(fontSize: 15)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _eliminarConvocatoria(int id) async {
    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("¿Eliminar convocatoria?",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Esta acción no se puede deshacer."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar",
                style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.delete, color: Colors.white, size: 18),
            label: const Text("Eliminar"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );

    if (confirmacion == true) {
      // Aquí debes agregar en el controller el método eliminarConvocatoria(id)
      _mostrarMensaje("🗑️ Convocatoria eliminada correctamente", verde);
      _cargarConvocatorias();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        width: 1100,
        height: 750,
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF39A900), Color(0xFF0075FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                "Gestión de Convocatorias",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Administra las convocatorias disponibles",
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
            const SizedBox(height: 30),

            // Buscador y botón
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: _filtrarConvocatorias,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search,
                            color: Colors.grey.shade600, size: 22),
                        hintText: "Buscar convocatorias...",
                        hintStyle: const TextStyle(color: Colors.black38),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton.icon(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (_) =>
                          ModalCrearConvocatoria(onSuccess: _cargarConvocatorias),
                    );
                  },
                  icon: const Icon(Icons.add, size: 22),
                  label: const Text("Nueva Convocatoria",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: verde,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 25),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Lista
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtradas.isEmpty
                      ? const Center(
                          child: Text(
                            "No se encontraron convocatorias.",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filtradas.length,
                          itemBuilder: (context, i) {
                            final c = _filtradas[i];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F7EB),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.event, color: verde, size: 28),
                                ),
                                title: Text(
                                  c.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade900,
                                      fontSize: 17),
                                ),
                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, right: 40),
                                  child: Text(
                                    c.objective.isNotEmpty
                                        ? c.objective
                                        : "Sin descripción",
                                    style: const TextStyle(
                                        color: Colors.black54, fontSize: 14),
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEAF2FF),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Icon(Icons.edit,
                                            color: azul, size: 20),
                                      ),
                                      onPressed: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (_) => ModalEditarConvocatoria(
                                            convocatoria: c,
                                            onSuccess: _cargarConvocatorias,
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 6),
                                    IconButton(
                                      icon: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFECEC),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: const Icon(Icons.delete,
                                            color: Colors.redAccent, size: 20),
                                      ),
                                      onPressed: () =>
                                          _eliminarConvocatoria(c.id),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
