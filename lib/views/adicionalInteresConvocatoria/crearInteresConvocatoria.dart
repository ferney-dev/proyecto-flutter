import 'package:app_bienestarmisena_v1/controllers/interes/interes_adicional_controller.dart';
import 'package:flutter/material.dart';

class ModalCrearCallAdditionalInterest extends StatefulWidget {
  final VoidCallback onSuccess;
  const ModalCrearCallAdditionalInterest({super.key, required this.onSuccess});

  @override
  State<ModalCrearCallAdditionalInterest> createState() =>
      _ModalCrearCallAdditionalInterestState();
}

class _ModalCrearCallAdditionalInterestState
    extends State<ModalCrearCallAdditionalInterest> {
  final CallAdditionalInterestsController _controller =
      CallAdditionalInterestsController();

  final TextEditingController _callIdCtrl = TextEditingController();
  final TextEditingController _interestIdCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _guardar() async {
    if (_callIdCtrl.text.isEmpty || _interestIdCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Todos los campos son obligatorios")));
      return;
    }

    setState(() => _loading = true);
    final ok = await _controller.crearCallAdditionalInterest(
        int.parse(_callIdCtrl.text), int.parse(_interestIdCtrl.text));
    setState(() => _loading = false);

    if (ok) {
      widget.onSuccess();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Registro creado correctamente")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Error al crear registro")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Crear CallAdditionalInterest"),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _callIdCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Call ID"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _interestIdCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Interest ID"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: _loading ? null : _guardar,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF39A900)),
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Guardar"),
        ),
      ],
    );
  }
}
