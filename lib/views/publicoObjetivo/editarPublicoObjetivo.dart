import 'package:app_bienestarmisena_v1/controllers/publicoObjetivo_controller.dart';
import 'package:app_bienestarmisena_v1/models/publicoObejtivoModel/publicoObjetivo.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ModalEditarPublico extends StatefulWidget {
  final PublicoModel publico;
  final VoidCallback onSuccess;
  const ModalEditarPublico(
      {super.key, required this.publico, required this.onSuccess});

  @override
  State<ModalEditarPublico> createState() => _ModalEditarPublicoState();
}

class _ModalEditarPublicoState extends State<ModalEditarPublico> {
  final _controller = PublicoObjetivoController();
  late TextEditingController _name;

  final Color verde = const Color(0xFF39A900);
  final Color verdeOscuro = const Color(0xFF2d8500);

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.publico.name);
  }

  Future<void> _actualizar() async {
    await _controller.editarPublicoObjetivo(widget.publico.id, {
      "name": _name.text.trim(),
    });

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: "Actualizado",
      desc: "Público objetivo actualizado correctamente ✅",
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
          gradient:
              const LinearGradient(colors: [Colors.white, Color(0xFFE9FBE5)]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Editar Público",
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
              label: const Text("Actualizar",
                  style: TextStyle(color: Colors.white)),
              onPressed: _actualizar,
            ),
          ],
        ),
      ),
    );
  }
}
