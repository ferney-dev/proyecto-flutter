import 'package:flutter/material.dart';

class ModalTabs extends StatelessWidget {
  final String pestanaActiva;
  final Function(String) onTabChange;
  final bool isMobile;

  const ModalTabs({
    super.key,
    required this.pestanaActiva,
    required this.onTabChange,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12),
        child: Row(
          children: [
            tabButton("descripcion", Icons.description, "Descripción", Colors.blue),
            tabButton("objetivo", Icons.flag, "Objetivo", Colors.green),
            tabButton("recursos", Icons.bookmark, "Recursos", Colors.orange),
            tabButton("notas", Icons.note, "Notas", Colors.teal),
            tabButton("enlace", Icons.link, "Más info", Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget tabButton(String id, IconData icon, String label, Color color) {
    final bool activo = pestanaActiva == id;
    return GestureDetector(
      onTap: () => onTabChange(id),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 6 : 8,
          horizontal: isMobile ? 10 : 14,
        ),
        margin: EdgeInsets.symmetric(horizontal: isMobile ? 3 : 5),
        decoration: BoxDecoration(
          color: activo ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: activo ? Border.all(color: color, width: 2) : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: isMobile ? 16 : 18,
              color: activo ? color : Colors.grey,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: activo ? color : Colors.grey,
                fontSize: isMobile ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
