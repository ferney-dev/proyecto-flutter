import 'package:app_bienestarmisena_v1/controllers/entidadInstitucion_controller.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ModalCrearInstitution extends StatefulWidget {
  final VoidCallback onSuccess;
  const ModalCrearInstitution({super.key, required this.onSuccess});

  @override
  State<ModalCrearInstitution> createState() => _ModalCrearInstitutionState();
}

class _ModalCrearInstitutionState extends State<ModalCrearInstitution> {
  final _controller = InstitutionController();
  final _name = TextEditingController();
  final _website = TextEditingController();

  final Color verde = const Color(0xFF39A900);
  final Color verdeOscuro = const Color(0xFF2d8500);

  Future<void> _guardar() async {
    if (_name.text.isEmpty || _website.text.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        title: "Atención",
        desc: "Todos los campos son obligatorios",
        btnOkOnPress: () {},
      ).show();
      return;
    }

    await _controller.crearInstitution({
      "name": _name.text.trim(),
      "website": _website.text.trim(),
    });

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: "Creado",
      desc: "Institución agregada correctamente 🎉",
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
        width: 450,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFE9FBE5)]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Nueva Institución",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: verde)),
            const SizedBox(height: 20),
            TextField(
              controller: _name,
              decoration: InputDecoration(
                labelText: "Nombre de la institución",
                labelStyle: TextStyle(color: verdeOscuro),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _website,
              decoration: InputDecoration(
                labelText: "Sitio web",
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
