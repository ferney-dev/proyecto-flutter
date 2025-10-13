import 'package:app_bienestarmisena_v1/controllers/interesAdicionalConvocatoria_controller.dart';
import 'package:app_bienestarmisena_v1/models/interesAdicionalConvocatoriaModel/interesAdicionalConvocatoria.dart';
import 'package:flutter/material.dart';

class ModalEditarCallAdditionalInterest extends StatefulWidget {
  final CallAdditionalInterest item;
  final VoidCallback onSuccess;
  const ModalEditarCallAdditionalInterest(
      {super.key, required this.item, required this.onSuccess});

  @override
  State<ModalEditarCallAdditionalInterest> createState() =>
      _ModalEditarCallAdditionalInterestState();
}

class _ModalEditarCallAdditionalInterestState
    extends State<ModalEditarCallAdditionalInterest> {
  final CallAdditionalInterestsController _controller =
      CallAdditionalInterestsController();

  late TextEditingController _newInterestIdCtrl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _newInterestIdCtrl =
        TextEditingController(text: widget.item.interestId.toString());
  }

  Future<void> _actualizar() async {
    if (_newInterestIdCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Debes ingresar un nuevo interestId")));
      return;
    }

    setState(() => _loading = true);
    final ok = await _controller.editarCallAdditionalInterest(
      widget.item.callId,
      widget.item.interestId,
      int.parse(_newInterestIdCtrl.text),
    );
    setState(() => _loading = false);

    if (ok) {
      widget.onSuccess();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Registro actualizado correctamente")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Error al actualizar registro")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editar CallAdditionalInterest"),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Call ID: ${widget.item.callId}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _newInterestIdCtrl,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: "Nuevo Interest ID"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: _loading ? null : _actualizar,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0075FF)),
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Actualizar"),
        ),
      ],
    );
  }
}
