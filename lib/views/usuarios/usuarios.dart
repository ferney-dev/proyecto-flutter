import 'package:app_bienestarmisena_v1/controllers/usuario.dart';
import 'package:app_bienestarmisena_v1/models/usuarioModel/usuariosModel.dart';
import 'package:app_bienestarmisena_v1/views/usuarios/crearUsuario.dart';
import 'package:app_bienestarmisena_v1/views/usuarios/editarUsuario.dart';
import 'package:flutter/material.dart';

class ViewUsuario extends StatefulWidget {
  const ViewUsuario({super.key});

  @override
  State<ViewUsuario> createState() => _ViewUsuarioState();
}

class _ViewUsuarioState extends State<ViewUsuario> {
  final UserController _controller = UserController();
  List<UserModel> _usuarios = [];
  List<UserModel> _filtrados = [];
  bool _loading = true;
  String _busqueda = "";

  final Color verde = const Color(0xFF39A900);
  final Color azul = const Color(0xFF0075FF);

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  Future<void> _cargarUsuarios() async {
    setState(() => _loading = true);
    _usuarios = await _controller.getUsers();
    _filtrados = _usuarios;
    setState(() => _loading = false);
  }

  void _filtrarUsuarios(String valor) {
    setState(() {
      _busqueda = valor.toLowerCase();
      _filtrados = _usuarios
          .where((u) =>
              u.name.toLowerCase().contains(_busqueda) ||
              u.email.toLowerCase().contains(_busqueda) ||
              (u.roleName ?? '').toLowerCase().contains(_busqueda))
          .toList();
    });
  }

  // 🔹 Mensaje tipo SnackBar
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

  // 🔹 Confirmación nativa para eliminar
  Future<void> _eliminar(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "¿Eliminar usuario?",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Esta acción no se puede deshacer.",
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:
                const Text("Cancelar", style: TextStyle(color: Colors.black54)),
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

    if (confirmar == true) {
      final eliminado = await _controller.eliminarUsuario(id);
      if (eliminado) {
        _mostrarMensaje("🗑️ Usuario eliminado correctamente", verde);
        _cargarUsuarios();
      } else {
        _mostrarMensaje("❌ Error al eliminar usuario", Colors.redAccent);
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
            // 🔹 Cabecera con gradiente
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF39A900), Color(0xFF0075FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                "Gestión de Usuarios",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Administra los usuarios registrados del sistema",
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
            const SizedBox(height: 30),

            // 🔍 Buscador + botón nuevo usuario
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
                      onChanged: _filtrarUsuarios,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search,
                            color: Colors.grey.shade600, size: 22),
                        hintText: "Buscar usuarios...",
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
                          ModalCrearUsuario(onSuccess: _cargarUsuarios),
                    );
                  },
                  icon: const Icon(Icons.person_add, size: 22),
                  label: const Text("Nuevo Usuario",
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

            // 🔹 Lista de usuarios
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtrados.isEmpty
                      ? const Center(
                          child: Text(
                            "No se encontraron usuarios.",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filtrados.length,
                          itemBuilder: (context, i) {
                            final u = _filtrados[i];
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
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: u.imgUser != null
                                      ? NetworkImage(u.imgUser!)
                                      : const NetworkImage(
                                          "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                                ),
                                title: Text(
                                  u.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade900,
                                      fontSize: 16),
                                ),
                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, right: 40),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        u.email,
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(height: 3),
                                      if (u.phone != null &&
                                          u.phone!.isNotEmpty)
                                        Text(
                                          "Teléfono: ${u.phone}",
                                          style: const TextStyle(
                                              color: Colors.black45,
                                              fontSize: 13),
                                        ),
                                      Text(
                                        "Estado: ${u.isActive == true ? "Activo" : "Inactivo"}",
                                        style: TextStyle(
                                          color: u.isActive == true
                                              ? verde
                                              : Colors.redAccent,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        "Rol: ${u.roleName ?? "Sin rol asignado"}",
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
                                          builder: (_) => ModalEditarUsuario(
                                              usuario: u,
                                              onSuccess: _cargarUsuarios),
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
                                      onPressed: () => _eliminar(u.id),
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
