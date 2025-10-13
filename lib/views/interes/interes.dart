
import 'package:app_bienestarmisena_v1/controllers/interesController.dart';
import 'package:app_bienestarmisena_v1/models/interes/interes_model.dart';
import 'package:app_bienestarmisena_v1/views/interes/crearInteres.dart';
import 'package:app_bienestarmisena_v1/views/interes/editarInteres.dart';
import 'package:flutter/material.dart';

class ViewInteres extends StatefulWidget {
  const ViewInteres({super.key});

  @override
  State<ViewInteres> createState() => _ViewInteresState();
}

class _ViewInteresState extends State<ViewInteres> {
  final InteresController _controller = InteresController();
  List<Interes> _intereses = [];
  List<Interes> _filtrados = [];
  bool _loading = true;
  String _busqueda = "";

  final Color verde = const Color(0xFF39A900);
  final Color azul = const Color(0xFF0075FF);

  @override
  void initState() {
    super.initState();
    _cargarIntereses();
  }

  Future<void> _cargarIntereses() async {
    setState(() => _loading = true);
    _intereses = await _controller.getIntereses();
    _filtrados = _intereses;
    setState(() => _loading = false);
  }

  void _filtrar(String valor) {
    setState(() {
      _busqueda = valor.toLowerCase();
      _filtrados = _intereses
          .where((i) =>
              i.name.toLowerCase().contains(_busqueda) ||
              i.description.toLowerCase().contains(_busqueda))
          .toList();
    });
  }

  void _mostrarMensaje(String texto, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(texto, style: const TextStyle(fontSize: 15)),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ));
  }

  Future<void> _eliminar(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("¿Eliminar interés?",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Esta acción no se puede deshacer."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancelar")),
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

    if (confirmar == true) {
      final eliminado = await _controller.eliminarInteres(id);
      if (eliminado) {
        _mostrarMensaje("🗑️ Interés eliminado correctamente", verde);
        _cargarIntereses();
      } else {
        _mostrarMensaje("❌ Error al eliminar interés", Colors.redAccent);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        width: 950,
        height: 700,
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
                "Gestión de Intereses",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text("Administra los intereses disponibles del sistema",
                style: TextStyle(color: Colors.black54, fontSize: 15)),
            const SizedBox(height: 30),

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
                      onChanged: _filtrar,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search,
                            color: Colors.grey.shade600, size: 22),
                        hintText: "Buscar intereses...",
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
                          ModalCrearInteres(onSuccess: _cargarIntereses),
                    );
                  },
                  icon: const Icon(Icons.add, size: 22),
                  label: const Text("Nuevo Interés",
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

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtrados.isEmpty
                      ? const Center(
                          child: Text(
                            "No se encontraron intereses.",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filtrados.length,
                          itemBuilder: (context, i) {
                            final it = _filtrados[i];
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
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F7EB),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.interests_rounded,
                                      color: verde, size: 28),
                                ),
                                title: Text(it.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade900,
                                        fontSize: 16)),
                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, right: 40),
                                  child: Text(it.description,
                                      style: const TextStyle(
                                          color: Colors.black54, fontSize: 14),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis),
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
                                          builder: (_) => ModalEditarInteres(
                                              interes: it,
                                              onSuccess: _cargarIntereses),
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
                                      onPressed: () => _eliminar(it.id),
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
