import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app_bienestarmisena_v1/controllers/convocatorias.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';
import 'package:url_launcher/url_launcher.dart';

class CarouselConvocatorias extends StatefulWidget {
  const CarouselConvocatorias({super.key});

  @override
  State<CarouselConvocatorias> createState() => _CarouselConvocatoriasState();
}

class _CarouselConvocatoriasState extends State<CarouselConvocatorias> {
  final ConvocatoriasController _controller = ConvocatoriasController();
  List<Convocatoria> _convocatorias = [];
  int _currentIndex = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadConvocatorias();
  }

  Future<void> _loadConvocatorias() async {
    try {
      final data = await _controller.getConvocatorias();
      setState(() {
        _convocatorias = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      debugPrint("❌ Error cargando convocatorias: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_convocatorias.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(child: Text("No hay convocatorias disponibles")),
      );
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _convocatorias.length,
          options: CarouselOptions(
            height: 380,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
          itemBuilder: (context, index, realIdx) {
            final convocatoria = _convocatorias[index];

            return Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: (convocatoria.imageUrl != null &&
                              convocatoria.imageUrl!.isNotEmpty)
                          ? NetworkImage(convocatoria.imageUrl!)
                          : const AssetImage("assets/img/default.jpg")
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.white, size: 28),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "⚡ Convocatoria Destacada",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          convocatoria.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          convocatoria.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                final url = Uri.parse(convocatoria.callLink);
                                if (await canLaunchUrl(url)) {
                                  launchUrl(url,
                                      mode: LaunchMode.externalApplication);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.cyanAccent,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                              icon: const Icon(Icons.check_circle),
                              label: const Text(
                                "Inscríbete Ahora",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: () {
                                // TODO: abrir modal detalles
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(
                                    color: Colors.white.withOpacity(0.6)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                              icon: const Icon(Icons.remove_red_eye),
                              label: const Text(
                                "Ver Detalles",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _convocatorias.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => setState(() => _currentIndex = entry.key),
              child: Container(
                width: _currentIndex == entry.key ? 14 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _currentIndex == entry.key
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
