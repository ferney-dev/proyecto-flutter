import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_bienestarmisena_v1/controllers/usuario/user_interest_controller.dart';
import 'package:app_bienestarmisena_v1/models/userInterest/userInterest.dart';

class ModalEditarUserInterest extends StatefulWidget {
  final UserInterest item;
  final VoidCallback onSuccess;

  const ModalEditarUserInterest({
    super.key,
    required this.item,
    required this.onSuccess,
  });

  @override
  State<ModalEditarUserInterest> createState() =>
      _ModalEditarUserInterestState();
}

class _ModalEditarUserInterestState extends State<ModalEditarUserInterest> {
  final UserInterestsController _controller = UserInterestsController();

  List<Map<String, dynamic>> _usuarios = [];
  List<Map<String, dynamic>> _intereses = [];

  int? _usuarioSeleccionado;
  int? _interesSeleccionado;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _usuarioSeleccionado = widget.item.userId;
    _interesSeleccionado = widget.item.interestId;
    _cargarListas();
  }

  Future<void> _cargarListas() async {
    try {
      final resUsuarios =
          await http.get(Uri.parse("http://localhost:4000/api/v1/users"));
      final resIntereses =
          await http.get(Uri.parse("http://localhost:4000/api/v1/interests"));

      if (resUsuarios.statusCode == 200 && resIntereses.statusCode == 200) {
        final dataUsuarios = jsonDecode(resUsuarios.body);
        final dataIntereses = jsonDecode(resIntereses.body);

        setState(() {
          _usuarios = List<Map<String, dynamic>>.from(dataUsuarios["data"]);
          _intereses = List<Map<String, dynamic>>.from(dataIntereses["data"]);
          _cargando = false;
        });
      } else {
        _mostrarMensaje("❌ Error al cargar listas", Colors.redAccent);
      }
    } catch (e) {
      _mostrarMensaje("❌ Error de conexión", Colors.redAccent);
    }
  }

  Future<void> _guardar() async {
    if (_usuarioSeleccionado == null || _interesSeleccionado == null) {
      _mostrarMensaje("⚠️ Debes seleccionar un usuario y un interés", Colors.orange);
      return;
    }

    final editado = await _controller.editarUserInterest(
      widget.item.userId,
      widget.item.interestId,
      {
        "userId": _usuarioSeleccionado,
        "interestId": _interesSeleccionado,
      },
    );

    if (editado) {
      _mostrarMensaje("✅ Relación actualizada correctamente", Colors.green);
      Navigator.pop(context);
      widget.onSuccess();
    } else {
      _mostrarMensaje("❌ Error al actualizar", Colors.redAccent);
    }
  }

  void _mostrarMensaje(String texto, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(texto), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 150, vertical: 100),
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: _cargando
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Editar Relación Usuario - Interés",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // 🔹 Selector de Usuario
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: "Seleccionar Usuario",
                      border: OutlineInputBorder(),
                    ),
                    value: _usuarioSeleccionado,
                    items: _usuarios
                        .map((u) => DropdownMenuItem<int>(
                              value: u["id"],
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundImage: u["imgUser"] != null
                                        ? NetworkImage(u["imgUser"])
                                        : const NetworkImage(
                                            "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(u["name"]),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() {
                      _usuarioSeleccionado = val;
                    }),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Selector de Interés
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: "Seleccionar Interés",
                      border: OutlineInputBorder(),
                    ),
                    value: _interesSeleccionado,
                    items: _intereses
                        .map((i) => DropdownMenuItem<int>(
                              value: i["id"],
                              child: Text(i["name"]),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() {
                      _interesSeleccionado = val;
                    }),
                  ),
                  const SizedBox(height: 30),

                  // 🔹 Botón Guardar Cambios
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _guardar,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        "Guardar Cambios",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0075FF),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
