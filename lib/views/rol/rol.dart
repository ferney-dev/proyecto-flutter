import 'package:app_bienestarmisena_v1/controllers/rol/rol_controller.dart';
import 'package:app_bienestarmisena_v1/models/rol/rol.dart';
import 'package:app_bienestarmisena_v1/views/rol/crearRol.dart';
import 'package:app_bienestarmisena_v1/views/rol/editarRol.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ViewRoles extends StatefulWidget {
  const ViewRoles({super.key});

  @override
  State<ViewRoles> createState() => _ViewRolesState();
}

class _ViewRolesState extends State<ViewRoles> {
  final RolesController _controller = RolesController();
  List<Rol> roles = [];
  bool cargando = true;
  String searchTerm = "";

  final Color verde = const Color(0xFF39A900);
  final Color azul = const Color(0xFF0075FF);

  @override
  void initState() {
    super.initState();
    _cargarRoles();
  }

  Future<void> _cargarRoles() async {
    try {
      final data = await _controller.obtenerRoles();
      setState(() {
        roles = data;
        cargando = false;
      });
    } catch (e) {
      setState(() => cargando = false);
      _mostrarMensaje("Error al cargar roles", Colors.redAccent);
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

  void _confirmarEliminar(Rol rol) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: '¿Eliminar Rol?',
      desc: 'Se eliminará el rol "${rol.name}" permanentemente.',
      btnCancelText: "Cancelar",
      btnCancelOnPress: () {},
      btnOkText: "Eliminar",
      btnOkColor: Colors.redAccent,
      btnOkOnPress: () async {
        final eliminado = await _controller.eliminarRol(rol.id);
        if (eliminado) {
          _mostrarMensaje("✅ Rol eliminado correctamente", Colors.green);
          _cargarRoles();
        } else {
          _mostrarMensaje("❌ Error al eliminar rol", Colors.redAccent);
        }
      },
    ).show();
  }

  List<Rol> get _filteredRoles {
    if (searchTerm.isEmpty) return roles;
    return roles
        .where((r) => r.name.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      child: Container(
        width: 950,
        height: 700,
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
            // 🧭 HEADER
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF39A900), Color(0xFF0075FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                "Gestión de Roles del Sistema",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Administra los permisos y roles disponibles para los usuarios",
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
            const SizedBox(height: 30),

            // 🔍 BUSCADOR + BOTÓN NUEVO
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
                        hintText: "Buscar rol...",
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
                      builder: (_) => ModalCrearRol(onSuccess: _cargarRoles),
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline, size: 22),
                  label: const Text(
                    "Nuevo Rol",
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
                    elevation: 4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // 📋 LISTA DE ROLES SCROLLEABLE
            Expanded(
              child: cargando
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredRoles.isEmpty
                      ? const Center(
                          child: Text(
                            "No hay roles registrados.",
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
                            itemCount: _filteredRoles.length,
                            itemBuilder: (context, i) {
                              final rol = _filteredRoles[i];
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
                                    // 🧩 ICONO IZQUIERDO
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE9F8FF),
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      padding: const EdgeInsets.all(14),
                                      child: const FaIcon(
                                        FontAwesomeIcons.userShield,
                                        color: Color(0xFF0075FF),
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 18),

                                    // 📄 INFO ROL
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            rol.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: verde,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          const Text(
                                            "Rol registrado en el sistema",
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
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) => ModalEditarRol(
                                                rol: rol,
                                                onSuccess: _cargarRoles,
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
                                              _confirmarEliminar(rol),
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
