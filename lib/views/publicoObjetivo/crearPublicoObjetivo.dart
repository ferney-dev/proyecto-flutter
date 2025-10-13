import 'package:app_bienestarmisena_v1/controllers/publicoObjetivo_controller.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ModalCrearPublico extends StatefulWidget {
  final VoidCallback onSuccess;
  const ModalCrearPublico({super.key, required this.onSuccess});

  @override
  State<ModalCrearPublico> createState() => _ModalCrearPublicoState();
}

class _ModalCrearPublicoState extends State<ModalCrearPublico> {
  final _controller = PublicoObjetivoController();
  final _name = TextEditingController();

  final Color verde = const Color(0xFF39A900);
  final Color verdeOscuro = const Color(0xFF2d8500);

  Future<void> _guardar() async {
    if (_name.text.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        title: "Atención",
        desc: "El nombre es obligatorio",
        btnOkOnPress: () {},
      ).show();
      return;
    }

    await _controller.crearPublicoObjetivo({"name": _name.text.trim()});

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: "Creado",
      desc: "Público objetivo agregado correctamente 🎉",
      btnOkOnPress: () {
        Navigator.pop(context);
        widget.onSuccess();
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.white, Color(0xFFE9FBE5)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Nuevo Público",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: verde)),
            const SizedBox(height: 20),
            TextField(
              controller: _name,
              decoration: InputDecoration(
                labelText: "Nombre del público",
                labelStyle: TextStyle(color: verdeOscuro),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: verde),
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text("Guardar",
                  style: TextStyle(color: Colors.white)),
              onPressed: _guardar,
            ),
          ],
        ),
      ),
    );
  }
}
