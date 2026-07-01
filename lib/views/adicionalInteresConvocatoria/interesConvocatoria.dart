import 'package:app_bienestarmisena_v1/controllers/interes/interes_adicional_controller.dart';
import 'package:app_bienestarmisena_v1/models/interesAdicionalConvocatoriaModel/interesAdicionalConvocatoria.dart';
import 'package:app_bienestarmisena_v1/views/adicionalInteresConvocatoria/crearInteresConvocatoria.dart';
import 'package:app_bienestarmisena_v1/views/adicionalInteresConvocatoria/editarInteresConvocatoria.dart';
import 'package:flutter/material.dart';

class ViewCallAdditionalInterests extends StatefulWidget {
  const ViewCallAdditionalInterests({super.key});

  @override
  State<ViewCallAdditionalInterests> createState() =>
      _ViewCallAdditionalInterestsState();
}

class _ViewCallAdditionalInterestsState
    extends State<ViewCallAdditionalInterests> {
  final CallAdditionalInterestsController _controller =
      CallAdditionalInterestsController();
  List<CallAdditionalInterest> _items = [];
  List<CallAdditionalInterest> _filtered = [];
  bool _loading = true;
  String _search = "";

  final Color verde = const Color(0xFF39A900);
  final Color azul = const Color(0xFF0075FF);

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => _loading = true);
    _items = await _controller.getCallAdditionalInterests();
    _filtered = _items;
    setState(() => _loading = false);
  }

  void _filter(String value) {
    setState(() {
      _search = value.toLowerCase();
      _filtered = _items.where((e) {
        final callTitle = (e.call?['title'] ?? '').toString().toLowerCase();
        final interestName = (e.interest?['name'] ?? '').toString().toLowerCase();
        return callTitle.contains(_search) || interestName.contains(_search);
      }).toList();
    });
  }

  Future<void> _deleteItem(int callId, int interestId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("¿Eliminar relación?"),
        content: const Text("Esta acción no se puede deshacer."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text("Eliminar"),
          )
        ],
      ),
    );

    if (confirm == true) {
      final ok = await _controller.eliminarCallAdditionalInterest(callId, interestId);
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("🗑️ Eliminado correctamente")),
        );
        _loadItems();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
      child: Container(
        width: 1000,
        height: 700,
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
        ),
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF39A900), Color(0xFF0075FF)],
              ).createShader(bounds),
              child: const Text(
                "Call Additional Interests",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: _filter,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Buscar por convocatoria o interés...",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton.icon(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (_) => ModalCrearCallAdditionalInterest(onSuccess: _loadItems),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Nuevo registro"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: verde,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtered.isEmpty
                      ? const Center(child: Text("No hay registros"))
                      : ListView.builder(
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) {
                            final item = _filtered[i];
                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 4,
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                title: Text(
                                  item.call?['title'] ?? 'Sin título',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "Interés: ${item.interest?['name'] ?? 'N/A'}",
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (_) => ModalEditarCallAdditionalInterest(
                                            item: item,
                                            onSuccess: _loadItems,
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.edit, color: azul),
                                    ),
                                    IconButton(
                                      onPressed: () => _deleteItem(item.callId, item.interestId),
                                      icon: const Icon(Icons.delete, color: Colors.redAccent),
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
