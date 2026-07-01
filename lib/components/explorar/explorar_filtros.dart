import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/models/linea/linea_model.dart';
import 'package:app_bienestarmisena_v1/models/userInterest/userInterest.dart';
import 'package:app_bienestarmisena_v1/models/publicoObejtivoModel/publicoObjetivo.dart';

class ExplorarFiltros extends StatelessWidget {
  final List<Linea> lineas;
  final List<UserInterest> interesesUsuario;
  final List<PublicoModel> publicos;
  final String categoriaSeleccionada;
  final String interesSeleccionado;
  final String publicoSeleccionado;
  final DateTime? fechaSeleccionada;
  final String visualizacionSeleccionada;
  final List<String> visualizaciones;
  final Function(String) onCategoriaChanged;
  final Function(String) onInteresChanged;
  final Function(String) onPublicoChanged;
  final Function(DateTime?) onFechaChanged;
  final Function(String) onVisualizacionChanged;
  final bool loading;

  const ExplorarFiltros({
    super.key,
    required this.lineas,
    required this.interesesUsuario,
    required this.publicos,
    required this.categoriaSeleccionada,
    required this.interesSeleccionado,
    required this.publicoSeleccionado,
    required this.fechaSeleccionada,
    required this.visualizacionSeleccionada,
    required this.visualizaciones,
    required this.onCategoriaChanged,
    required this.onInteresChanged,
    required this.onPublicoChanged,
    required this.onFechaChanged,
    required this.onVisualizacionChanged,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 800;

          if (loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // En móvil: 2 filtros por fila
          // En desktop: scroll horizontal con todos los filtros
          if (isMobile) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterItem(
                        label: "Categoría",
                        icon: FontAwesomeIcons.tags,
                        value: categoriaSeleccionada,
                        items: [
                          'Todas las categorías',
                          ...lineas.map((l) => l.name).toList(),
                        ],
                        onChanged: onCategoriaChanged,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFilterItem(
                        label: "Interés",
                        icon: FontAwesomeIcons.userCheck,
                        value: interesSeleccionado,
                        items: interesesUsuario.isNotEmpty
                            ? [
                                'Sin intereses',
                                ...interesesUsuario.map((i) => i.interestName).toList(),
                              ]
                            : ['Sin intereses'],
                        onChanged: onInteresChanged,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterItem(
                        label: "Público",
                        icon: FontAwesomeIcons.users,
                        value: publicoSeleccionado,
                        items: publicos.isNotEmpty
                            ? [
                                'Sin públicos',
                                ...publicos.map((p) => p.name).toList(),
                              ]
                            : ['Sin públicos'],
                        onChanged: onPublicoChanged,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDatePicker(
                        label: "Fecha",
                        icon: FontAwesomeIcons.calendarDays,
                        fechaSeleccionada: fechaSeleccionada,
                        onFechaChanged: onFechaChanged,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildFilterItem(
                  label: "Visualización",
                  icon: FontAwesomeIcons.tableCellsLarge,
                  value: visualizacionSeleccionada,
                  items: visualizaciones,
                  onChanged: onVisualizacionChanged,
                ),
              ],
            );
          }

          // Desktop: scroll horizontal
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilterItem(
                  label: "Categoría",
                  icon: FontAwesomeIcons.tags,
                  value: categoriaSeleccionada,
                  items: [
                    'Todas las categorías',
                    ...lineas.map((l) => l.name).toList(),
                  ],
                  onChanged: onCategoriaChanged,
                  width: constraints.maxWidth * 0.19,
                ),
                const SizedBox(width: 16),
                _buildFilterItem(
                  label: "Interés Usuario",
                  icon: FontAwesomeIcons.userCheck,
                  value: interesSeleccionado,
                  items: interesesUsuario.isNotEmpty
                      ? [
                          'Sin intereses asociados',
                          ...interesesUsuario.map((i) => i.interestName).toList(),
                        ]
                      : ['Sin intereses asociados'],
                  onChanged: onInteresChanged,
                  width: constraints.maxWidth * 0.19,
                ),
                const SizedBox(width: 16),
                _buildFilterItem(
                  label: "Público Objetivo",
                  icon: FontAwesomeIcons.users,
                  value: publicoSeleccionado,
                  items: publicos.isNotEmpty
                      ? [
                          'Sin públicos registrados',
                          ...publicos.map((p) => p.name).toList(),
                        ]
                      : ['Sin públicos registrados'],
                  onChanged: onPublicoChanged,
                  width: constraints.maxWidth * 0.19,
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: constraints.maxWidth * 0.19,
                  child: _buildDatePicker(
                    label: "Fecha de inicio",
                    icon: FontAwesomeIcons.calendarDays,
                    fechaSeleccionada: fechaSeleccionada,
                    onFechaChanged: onFechaChanged,
                  ),
                ),
                const SizedBox(width: 16),
                _buildFilterItem(
                  label: "Visualización",
                  icon: FontAwesomeIcons.tableCellsLarge,
                  value: visualizacionSeleccionada,
                  items: visualizaciones,
                  onChanged: onVisualizacionChanged,
                  width: constraints.maxWidth * 0.19,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterItem({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
    double? width,
  }) {
    final cleanItems = items.where((e) => e.trim().isNotEmpty).toSet().toList();
    final safeValue = cleanItems.contains(value) ? value : cleanItems.first;

    return SizedBox(
      width: width ?? double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF00324D), size: 16),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00324D),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: safeValue,
                isExpanded: true,
                dropdownColor: Colors.white,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF00324D),
                  size: 20,
                ),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                ),
                items: cleanItems.map((e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text(
                      e,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) => onChanged(val!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required IconData icon,
    required DateTime? fechaSeleccionada,
    required Function(DateTime?) onFechaChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF00324D), size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF00324D),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: Get.context!,
              initialDate: fechaSeleccionada ?? DateTime.now(),
              firstDate: DateTime(2024, 1, 1),
              lastDate: DateTime(2026, 12, 31),
            );
            if (picked != null) {
              onFechaChanged(picked);
            }
          },
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    fechaSeleccionada != null
                        ? "${fechaSeleccionada.year}-${fechaSeleccionada.month.toString().padLeft(2, '0')}-${fechaSeleccionada.day.toString().padLeft(2, '0')}"
                        : "Cualquier fecha",
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF00324D)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
