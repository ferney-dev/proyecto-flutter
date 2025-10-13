import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';
import 'package:app_bienestarmisena_v1/models/Favoritos/favoritos.dart';

class ModalEditarFavorito extends StatefulWidget {
  final FavoriteModel favorito;
  final VoidCallback onSuccess;
  const ModalEditarFavorito({super.key, required this.favorito, required this.onSuccess});

  @override
  State<ModalEditarFavorito> createState() => _ModalEditarFavoritoState();
}

class _ModalEditarFavoritoState extends State<ModalEditarFavorito> {
  final FavoritesController _controller = Get.find<FavoritesController>();

  late TextEditingController _userCtrl;
  late TextEditingController _callCtrl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _userCtrl = TextEditingController(text: widget.favorito.userId.toString());
    _callCtrl = TextEditingController(text: widget.favorito.callId.toString());
  }

  Future<void> _actualizar() async {
    if (_userCtrl.text.isEmpty || _callCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Todos los campos son obligatorios")),
      );
      return;
    }

    setState(() => _loading = true);
    final ok = await _controller.editarFavorite(
      widget.favorito.id,
      int.parse(_userCtrl.text),
      int.parse(_callCtrl.text),
    );
    setState(() => _loading = false);

    if (ok) {
      widget.onSuccess();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Favorito actualizado correctamente")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Error al actualizar favorito")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editar Favorito"),
      content: SizedBox(
        width: 400,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: _userCtrl, decoration: const InputDecoration(labelText: "User ID")),
          const SizedBox(height: 10),
          TextField(controller: _callCtrl, decoration: const InputDecoration(labelText: "Call ID")),
        ]),
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
