import 'package:app_bienestarmisena_v1/controllers/publico/publico_controller.dart';
import 'package:app_bienestarmisena_v1/models/publicoObejtivoModel/publicoObjetivo.dart';
import 'package:app_bienestarmisena_v1/views/publicoObjetivo/crearPublicoObjetivo.dart';
import 'package:app_bienestarmisena_v1/views/publicoObjetivo/editarPublicoObjetivo.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ViewPublico extends StatefulWidget {
  const ViewPublico({super.key});

  @override
  State<ViewPublico> createState() => _ViewPublicoState();
}

class _ViewPublicoState extends State<ViewPublico> {
  final PublicoObjetivoController _controller = PublicoObjetivoController();
  List<PublicoModel> _publicos = [];
  bool _loading = true;
  String _search = "";

  final Color verde = const Color(0xFF39A900);
  final Color azul = const Color(0xFF0075FF);

  @override
  void initState() {
    super.initState();
    _cargarPublicos();
  }

  Future<void> _cargarPublicos() async {
    setState(() => _loading = true);
    _publicos = await _controller.getPublicoObjetivo();
    setState(() => _loading = false);
  }

  Future<void> _eliminar(int id) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: '¿Eliminar público objetivo?',
      desc: 'Esta acción no se puede deshacer.',
      btnCancelText: 'Cancelar',
      btnOkText: 'Eliminar',
      btnOkColor: Colors.redAccent,
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await _controller.eliminarPublicoObjetivo(id);
        _cargarPublicos();
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: "Eliminado",
          desc: "El público objetivo fue eliminado correctamente ✅",
          btnOkOnPress: () {},
        ).show();
      },
    ).show();
  }

  List<PublicoModel> get _filteredPublicos {
    if (_search.isEmpty) return _publicos;
    return _publicos
        .where((p) => p.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      child: Container(
        width: 1000,
        height: 720,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // 🧭 HEADER FIJO
            Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF39A900), Color(0xFF0075FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: const Text(
                    "Gestión de Público Objetivo",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Administra los públicos objetivo registrados en el sistema",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
                const SizedBox(height: 25),
                // 🔍 BUSCADOR + BOTÓN
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
                          onChanged: (v) => setState(() => _search = v),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search,
                                color: Colors.grey.shade600, size: 22),
                            hintText: "Buscar público objetivo...",
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
                              ModalCrearPublico(onSuccess: _cargarPublicos),
                        );
                      },
                      icon: const Icon(Icons.group_add_rounded, size: 22),
                      label: const Text(
                        "Nuevo Público",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: verde,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 25),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),

            // 📜 LISTA SCROLLEABLE
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredPublicos.isEmpty
                      ? const Center(
                          child: Text(
                            "No hay públicos registrados.",
                            style: TextStyle(
                                fontSize: 16, color: Colors.black54),
                          ),
                        )
                      : Scrollbar(
                          thumbVisibility: true,
                          radius: const Radius.circular(20),
                          child: ListView.separated(
                            padding: const EdgeInsets.only(top: 15),
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 15),
                            itemCount: _filteredPublicos.length,
                            itemBuilder: (context, i) {
                              final p = _filteredPublicos[i];
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOut,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.grey.shade200, width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // 👥 ÍCONO IZQUIERDO
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F7EB),
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      padding: const EdgeInsets.all(14),
                                      child: const FaIcon(
                                        FontAwesomeIcons.users,
                                        color: Color(0xFF39A900),
                                        size: 30,
                                      ),
                                    ),
                                    const SizedBox(width: 18),
                                    // 📄 TEXTO
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            p.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: verde,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          const Text(
                                            "Público objetivo registrado",
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // ✏️ BOTONES
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEAF2FF),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            child: Icon(Icons.edit,
                                                color: azul, size: 20),
                                          ),
                                          onPressed: () async {
                                            await showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  ModalEditarPublico(
                                                publico: p,
                                                onSuccess: _cargarPublicos,
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFECEC),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            child: const Icon(
                                              Icons.delete_forever_rounded,
                                              color: Colors.redAccent,
                                              size: 22,
                                            ),
                                          ),
                                          onPressed: () => _eliminar(p.id),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
