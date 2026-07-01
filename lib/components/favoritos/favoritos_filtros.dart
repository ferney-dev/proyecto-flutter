import 'package:flutter/material.dart';
import 'package:app_bienestarmisena_v1/models/linea/linea_model.dart';
import 'package:app_bienestarmisena_v1/models/userInterest/userInterest.dart';

class FavoritosFiltros extends StatelessWidget {
  final List<Linea> lineas;
  final List<UserInterest> interesesUsuario;
  final String categoriaSeleccionada;
  final String interesSeleccionado;
  final String ordenarPor;
  final String vista;
  final List<String> ordenes;
  final Function(String) onCategoriaChanged;
  final Function(String) onInteresChanged;
  final Function(String) onOrdenarChanged;
  final Function(String) onVistaChanged;

  const FavoritosFiltros({
    super.key,
    required this.lineas,
    required this.interesesUsuario,
    required this.categoriaSeleccionada,
    required this.interesSeleccionado,
    required this.ordenarPor,
    required this.vista,
    required this.ordenes,
    required this.onCategoriaChanged,
    required this.onInteresChanged,
    required this.onOrdenarChanged,
    required this.onVistaChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 22, vertical: isMobile ? 16 : 22),
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade300, width: 1.4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: isMobile
              ? Column(
                  children: [
                    _buildFilterField(
                      icon: Icons.category_outlined,
                      label: "Línea",
                      value: categoriaSeleccionada,
                      items: [
                        'Todas las categorías',
                        ...lineas.map((l) => l.name).toList(),
                      ],
                      onChanged: (v) => onCategoriaChanged(v!),
                      width: double.infinity,
                    ),
                    const SizedBox(height: 16),
                    _buildFilterField(
                      icon: Icons.interests_outlined,
                      label: "Interés Usuario",
                      value: interesSeleccionado,
                      items: interesesUsuario.isNotEmpty
                          ? [
                              'Sin intereses asociados',
                              ...interesesUsuario
                                  .map((i) => i.interestName)
                                  .toList(),
                            ]
                          : ['Sin intereses asociados'],
                      onChanged: (v) => onInteresChanged(v!),
                      width: double.infinity,
                    ),
                    const SizedBox(height: 16),
                    _buildFilterField(
                      icon: Icons.sort_rounded,
                      label: "Ordenar por",
                      value: ordenarPor,
                      items: ordenes,
                      onChanged: (v) => onOrdenarChanged(v!),
                      width: double.infinity,
                    ),
                    const SizedBox(height: 16),
                    _buildVistaToggle(vista, onVistaChanged),
                  ],
                )
              : Wrap(
                  spacing: 20,
                  runSpacing: 18,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _buildFilterField(
                      icon: Icons.category_outlined,
                      label: "Línea",
                      value: categoriaSeleccionada,
                      items: [
                        'Todas las categorías',
                        ...lineas.map((l) => l.name).toList(),
                      ],
                      onChanged: (v) => onCategoriaChanged(v!),
                      width: 420,
                    ),
                    _buildFilterField(
                      icon: Icons.interests_outlined,
                      label: "Interés Usuario",
                      value: interesSeleccionado,
                      items: interesesUsuario.isNotEmpty
                          ? [
                              'Sin intereses asociados',
                              ...interesesUsuario
                                  .map((i) => i.interestName)
                                  .toList(),
                            ]
                          : ['Sin intereses asociados'],
                      onChanged: (v) => onInteresChanged(v!),
                      width: 420,
                    ),
                    _buildFilterField(
                      icon: Icons.sort_rounded,
                      label: "Ordenar por",
                      value: ordenarPor,
                      items: ordenes,
                      onChanged: (v) => onOrdenarChanged(v!),
                      width: 420,
                    ),
                    _buildVistaToggle(vista, onVistaChanged),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildFilterField({
    required IconData icon,
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    double width = 250,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF00324D), size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF00324D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1.3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: value,
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey),
                items: items
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 14.5),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVistaToggle(String vista, Function(String) onVistaChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
      ),
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(30),
        selectedColor: Colors.white,
        fillColor: const Color(0xFF00A884),
        color: Colors.grey.shade600,
        constraints: const BoxConstraints(minWidth: 58, minHeight: 46),
        isSelected: [
          vista == "Tarjeta",
          vista == "Lista"
        ],
        onPressed: (index) {
          onVistaChanged(index == 0 ? "Tarjeta" : "Lista");
        },
        children: const [
          Icon(Icons.grid_view_rounded, size: 24),
          Icon(Icons.view_list_rounded, size: 24),
        ],
      ),
    );
  }
}
