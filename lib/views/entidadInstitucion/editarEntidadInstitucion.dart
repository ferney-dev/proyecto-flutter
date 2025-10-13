import 'package:app_bienestarmisena_v1/controllers/entidadInstitucion_controller.dart';
import 'package:app_bienestarmisena_v1/models/entidadInstitucion/entidadInstitucionModel.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ModalEditarInstitution extends StatefulWidget {
  final InstitutionModel institution;
  final VoidCallback onSuccess;
  const ModalEditarInstitution(
      {super.key, required this.institution, required this.onSuccess});

  @override
  State<ModalEditarInstitution> createState() => _ModalEditarInstitutionState();
}

class _ModalEditarInstitutionState extends State<ModalEditarInstitution> {
  final _controller = InstitutionController();
  late TextEditingController _name;
  late TextEditingController _website;

  final Color verde = const Color(0xFF39A900);
  final Color verdeOscuro = const Color(0xFF2d8500);

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.institution.name);
    _website = TextEditingController(text: widget.institution.website);
  }

  Future<void> _actualizar() async {
    await _controller.editarInstitution(widget.institution.id, {
      "name": _name.text.trim(),
      "website": _website.text.trim(),
    });

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: "Actualizado",
      desc: "Institución actualizada correctamente ✅",
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
            Text("Editar Institución",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: verde)),
            const SizedBox(height: 20),
            TextField(
              controller: _name,
              decoration: InputDecoration(
                labelText: "Nombre",
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
