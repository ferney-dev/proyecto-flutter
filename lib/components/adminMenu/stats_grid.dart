import 'package:flutter/material.dart';

class StatsGrid extends StatelessWidget {
  final bool isMobile;

  const StatsGrid({
    super.key,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      {"label": "Total Registros", "value": "86", "icon": Icons.storage_rounded, "color": Colors.blue},
      {"label": "Convocatorias", "value": "26", "icon": Icons.campaign_rounded, "color": Colors.pink},
      {"label": "Usuarios", "value": "41", "icon": Icons.people_rounded, "color": Colors.green},
      {"label": "Empresas", "value": "9", "icon": Icons.business_rounded, "color": Colors.orange},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isMobile ? 1.4 : 1.6,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (stat["color"] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(stat["icon"] as IconData, color: stat["color"] as Color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      stat["value"] as String,
                      style: TextStyle(
                        fontSize: isMobile ? 22 : 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Text(
                      stat["label"] as String,
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
