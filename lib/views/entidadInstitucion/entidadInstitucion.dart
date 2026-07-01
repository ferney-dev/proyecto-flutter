import 'package:app_bienestarmisena_v1/controllers/entidad/entidad_controller.dart';
import 'package:app_bienestarmisena_v1/models/entidadInstitucion/entidadInstitucionModel.dart';
import 'package:app_bienestarmisena_v1/views/entidadInstitucion/crearEntidadInstitucion.dart';
import 'package:app_bienestarmisena_v1/views/entidadInstitucion/editarEntidadInstitucion.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ViewInstitution extends StatefulWidget {
  const ViewInstitution({super.key});

  @override
  State<ViewInstitution> createState() => _ViewInstitutionState();
}

class _ViewInstitutionState extends State<ViewInstitution> {
  final InstitutionController _controller = InstitutionController();
  List<InstitutionModel> _institutions = [];
  bool _loading = true;
  String _search = "";

  final Color verde = const Color(0xFF39A900);
  final Color azul = const Color(0xFF0075FF);

  @override
  void initState() {
    super.initState();
    _loadInstitutions();
  }

  Future<void> _loadInstitutions() async {
    setState(() => _loading = true);
    _institutions = await _controller.getInstitutions();
    setState(() => _loading = false);
  }

  // 🔎 Filtrado
  List<InstitutionModel> get _filteredInstitutions {
    if (_search.isEmpty) return _institutions;
    return _institutions
        .where((i) =>
            i.name.toLowerCase().contains(_search.toLowerCase()) ||
            i.website.toLowerCase().contains(_search.toLowerCase()))
        .toList();
  }

  // 🗑️ Eliminar institución
  Future<void> _deleteInstitution(int id) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      title: '¿Eliminar institución?',
      desc: 'Esta acción no se puede deshacer.',
      btnCancelText: 'Cancelar',
      btnOkText: 'Eliminar',
      btnOkColor: Colors.redAccent,
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await _controller.eliminarInstitution(id);
        _loadInstitutions();
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: "Eliminada",
          desc: "Institución eliminada correctamente ✅",
          btnOkOnPress: () {},
        ).show();
      },
    ).show();
  }

  // 🌐 Abrir sitio web
  Future<void> _openWebsite(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: "Error",
        desc: "No se pudo abrir el sitio web.",
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      child: Container(
        width: 1050,
        height: 750,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🧭 CABECERA
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF39A900), Color(0xFF0075FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                "Gestión de Instituciones",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Administra las entidades académicas y empresariales del sistema",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 35),

            // 🔍 Buscador + botón
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (v) => setState(() => _search = v),
                      decoration: const InputDecoration(
                        hintText: "Buscar instituciones...",
                        hintStyle: TextStyle(color: Colors.black38),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (_) => ModalCrearInstitution(
                        onSuccess: _loadInstitutions,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_business_rounded, size: 22),
                  label: const Text(
                    "Nueva Institución",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: verde,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 25),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    elevation: 5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 🧱 LISTA — cada contenedor por fila
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredInstitutions.isEmpty
                      ? const Center(
                          child: Text(
                            "No hay instituciones registradas.",
                            style: TextStyle(
                                fontSize: 16, color: Colors.black54),
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 18),
                          itemCount: _filteredInstitutions.length,
                          itemBuilder: (context, i) {
                            final inst = _filteredInstitutions[i];
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border:
                                    Border.all(color: Colors.grey.shade200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // 🏛️ ICONO IZQUIERDO
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE9F8FF),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    padding: const EdgeInsets.all(14),
                                    child: const FaIcon(
                                      FontAwesomeIcons.university,
                                      color: Color(0xFF0075FF),
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 18),

                                  // 🧾 INFO
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          inst.name,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: verde,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        GestureDetector(
                                          onTap: () =>
                                              _openWebsite(inst.website),
                                          child: Text(
                                            inst.website,
                                            style: TextStyle(
                                              color: azul,
                                              fontSize: 15,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          "Institución registrada en el sistema",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // ✏️ BOTONES DERECHA
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEAF2FF),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: Icon(
                                            Icons.edit,
                                            color: azul,
                                            size: 22,
                                          ),
                                        ),
                                        onPressed: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (_) =>
                                                ModalEditarInstitution(
                                              institution: inst,
                                              onSuccess: _loadInstitutions,
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFECEC),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: const Icon(
                                            Icons.delete_forever_rounded,
                                            color: Colors.redAccent,
                                            size: 22,
                                          ),
                                        ),
                                        onPressed: () =>
                                            _deleteInstitution(inst.id),
                                      ),
                                    ],
                                  ),
                                ],
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
