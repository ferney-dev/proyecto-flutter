import 'package:app_bienestarmisena_v1/controllers/userInterest.dart';
import 'package:app_bienestarmisena_v1/models/userInterest/userInterest.dart';
import 'package:flutter/material.dart';
import 'package:app_bienestarmisena_v1/views/userInterests/crearUserInterest.dart';
import 'package:app_bienestarmisena_v1/views/userInterests/editarUserInterest.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ViewUserInterests extends StatefulWidget {
  const ViewUserInterests({super.key});

  @override
  State<ViewUserInterests> createState() => _ViewUserInterestsState();
}

class _ViewUserInterestsState extends State<ViewUserInterests> {
  final UserInterestsController _controller = UserInterestsController();
  List<UserInterest> lista = [];
  bool cargando = true;
  String searchTerm = "";

  final Color verde = const Color(0xFF39A900);
  final Color azul = const Color(0xFF0075FF);

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final data = await _controller.obtenerUserInterests();
      setState(() {
        lista = data;
        cargando = false;
      });
    } catch (e) {
      setState(() => cargando = false);
      _mostrarMensaje("❌ Error al cargar datos", Colors.redAccent);
    }
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

  void _confirmarEliminar(UserInterest item) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: '¿Eliminar Relación?',
      desc:
          'Se eliminará el vínculo entre "${item.userName}" y "${item.interestName}".',
      btnCancelText: "Cancelar",
      btnCancelOnPress: () {},
      btnOkText: "Eliminar",
      btnOkColor: Colors.redAccent,
      btnOkOnPress: () async {
        final eliminado = await _controller.eliminarUserInterest(
            item.userId, item.interestId);
        if (eliminado) {
          _mostrarMensaje("✅ Relación eliminada correctamente", Colors.green);
          _cargarDatos();
        } else {
          _mostrarMensaje("❌ Error al eliminar", Colors.redAccent);
        }
      },
    ).show();
  }

  List<UserInterest> get _filteredList {
    if (searchTerm.isEmpty) return lista;
    return lista
        .where((item) =>
            item.userName.toLowerCase().contains(searchTerm.toLowerCase()) ||
            item.interestName.toLowerCase().contains(searchTerm.toLowerCase()))
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
            // 🧭 CABECERA FIJA
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF39A900), Color(0xFF0075FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                "Gestión de Intereses por Usuario",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Administra las relaciones entre usuarios e intereses del sistema",
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
            const SizedBox(height: 30),

            // 🔍 BUSCADOR + NUEVO
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
                      onChanged: (v) => setState(() => searchTerm = v),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search,
                            color: Colors.grey.shade600, size: 22),
                        hintText: "Buscar por usuario o interés...",
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) =>
                          ModalCrearUserInterest(onSuccess: _cargarDatos),
                    );
                  },
                  icon: const Icon(Icons.add_link, size: 22),
                  label: const Text(
                    "Nueva Relación",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
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
            const SizedBox(height: 25),

            // 📜 LISTA SCROLLEABLE
            Expanded(
              child: cargando
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredList.isEmpty
                      ? const Center(
                          child: Text(
                            "No hay relaciones registradas.",
                            style: TextStyle(
                                fontSize: 16, color: Colors.black54),
                          ),
                        )
                      : Scrollbar(
                          thumbVisibility: true,
                          radius: const Radius.circular(20),
                          child: ListView.separated(
                            padding: const EdgeInsets.only(top: 10),
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 15),
                            itemCount: _filteredList.length,
                            itemBuilder: (context, i) {
                              final item = _filteredList[i];
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
                                    // 👤 IMAGEN USUARIO
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundImage: item.userImage != null
                                          ? NetworkImage(item.userImage!)
                                          : const NetworkImage(
                                              "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                                    ),
                                    const SizedBox(width: 18),

                                    // 📄 DETALLES
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.userName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: verde,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const FaIcon(
                                                FontAwesomeIcons.solidHeart,
                                                color: Colors.redAccent,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Interés: ${item.interestName}",
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 14),
                                              ),
                                            ],
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
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  ModalEditarUserInterest(
                                                item: item,
                                                onSuccess: _cargarDatos,
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
                                          onPressed: () =>
                                              _confirmarEliminar(item),
                                        ),
                                      ],
                                    ),
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
