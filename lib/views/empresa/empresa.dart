import 'package:app_bienestarmisena_v1/models/empresaModel/empresa_model.dart';
import 'package:app_bienestarmisena_v1/views/empresa/crearEmpresa.dart';
import 'package:app_bienestarmisena_v1/views/empresa/editarEmpresa.dart';
import 'package:flutter/material.dart';

import 'package:app_bienestarmisena_v1/controllers/empresa/empresa_controller.dart';
import 'package:app_bienestarmisena_v1/views/empresa/EditarEmpresa.dart' hide ModalEditarEmpresa;
import 'package:app_bienestarmisena_v1/views/empresa/CrearEmpresa.dart' hide ModalCrearEmpresa;

class ViewEmpresa extends StatefulWidget {
  const ViewEmpresa({super.key});

  @override
  State<ViewEmpresa> createState() => _ViewEmpresaState();
}

class _ViewEmpresaState extends State<ViewEmpresa> {
  final EmpresaController _controller = EmpresaController();
  List<Empresa> _empresas = [];
  List<Empresa> _filtradas = [];
  bool _loading = true;
  String _busqueda = "";

  final Color verde = const Color(0xFF39A900);
  final Color azul = const Color(0xFF0075FF);

  @override
  void initState() {
    super.initState();
    _cargarEmpresas();
  }

  Future<void> _cargarEmpresas() async {
    setState(() => _loading = true);
    _empresas = await _controller.getEmpresas();
    _filtradas = _empresas;
    setState(() => _loading = false);
  }

  void _filtrarEmpresas(String valor) {
    setState(() {
      _busqueda = valor.toLowerCase();
      _filtradas = _empresas.where((e) {
        return (e.name ?? '').toLowerCase().contains(_busqueda) ||
            (e.economicSector ?? '').toLowerCase().contains(_busqueda) ||
            (e.city?.name ?? '').toLowerCase().contains(_busqueda);
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

  Future<void> _eliminarEmpresa(int id) async {
    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("¿Eliminar empresa?",
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
      final eliminado = await _controller.eliminarEmpresa(id);
      if (eliminado) {
        _mostrarMensaje("🗑️ Empresa eliminada correctamente", verde);
        _cargarEmpresas();
      } else {
        _mostrarMensaje("❌ Error al eliminar la empresa", Colors.redAccent);
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
        width: 1000,
        height: 720,
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
            // 🔹 CABECERA
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF39A900), Color(0xFF0075FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                "Gestión de Empresas",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Administra las empresas registradas en el sistema",
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
            const SizedBox(height: 30),

            // 🔍 BUSCADOR + NUEVA EMPRESA
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
                      onChanged: _filtrarEmpresas,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search,
                            color: Colors.grey.shade600, size: 22),
                        hintText: "Buscar empresas...",
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
                      builder: (_) => ModalCrearEmpresa(
                        onSuccess: _cargarEmpresas,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 22),
                  label: const Text("Nueva Empresa",
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

            // 🔹 LISTA DE EMPRESAS
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtradas.isEmpty
                      ? const Center(
                          child: Text(
                            "No se encontraron empresas.",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filtradas.length,
                          itemBuilder: (context, i) {
                            final e = _filtradas[i];
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
                                    horizontal: 20, vertical: 12),
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F7EB),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.business,
                                      color: verde, size: 28),
                                ),
                                title: Text(
                                  e.name ?? "Sin nombre",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade900,
                                    fontSize: 17,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, right: 40),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Sector: ${e.economicSector ?? "No especificado"}",
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14),
                                      ),
                                      Text(
                                        "Ciudad: ${e.city?.name ?? "Sin ciudad"}",
                                        style: const TextStyle(
                                            color: Colors.black45,
                                            fontSize: 13),
                                      ),
                                      Text(
                                        "Empleados: ${e.employeeCount ?? 0}",
                                        style: const TextStyle(
                                            color: Colors.black45,
                                            fontSize: 13),
                                      ),
                                    ],
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
                                          builder: (_) => ModalEditarEmpresa(
                                            empresa: e,
                                            onSuccess: _cargarEmpresas,
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
                                          _eliminarEmpresa(e.id ?? 0),
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
