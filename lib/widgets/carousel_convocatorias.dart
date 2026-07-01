import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app_bienestarmisena_v1/controllers/convocatorias/convocatorias_controller.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';
import 'package:app_bienestarmisena_v1/components/carousel/carousel_item.dart';
import 'package:app_bienestarmisena_v1/components/carousel/carousel_indicators.dart';

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
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    if (_loading) {
      return SizedBox(
        height: isMobile ? 250 : 380,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_convocatorias.isEmpty) {
      return SizedBox(
        height: isMobile ? 250 : 380,
        child: const Center(child: Text("No hay convocatorias disponibles")),
      );
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _convocatorias.length,
          options: CarouselOptions(
            height: isMobile ? 250 : 380,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
          itemBuilder: (context, index, realIdx) {
            return CarouselItem(
              convocatoria: _convocatorias[index],
              isMobile: isMobile,
              onDetails: () {
                // TODO: abrir modal detalles
              },
            );
          },
        ),
        SizedBox(height: isMobile ? 8 : 12),
        CarouselIndicators(
          itemCount: _convocatorias.length,
          currentIndex: _currentIndex,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
        ),
      ],
    );
  }
}
