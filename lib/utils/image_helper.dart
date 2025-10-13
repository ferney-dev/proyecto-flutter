import 'dart:math';
import 'package:flutter/material.dart';

/// 🔹 Widget reutilizable para mostrar imágenes de convocatorias.
/// ✅ Si la URL es nula, vacía o falla, muestra una imagen de respaldo aleatoria (no repetida).
/// ✅ Mantiene el mismo diseño y tamaño.
/// ✅ Incluye loader y manejo de error elegante.
class ConvocatoriaImage extends StatefulWidget {
  final String? imageUrl;
  final double height;
  final double width;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const ConvocatoriaImage({
    super.key,
    required this.imageUrl,
    this.height = 180,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  State<ConvocatoriaImage> createState() => _ConvocatoriaImageState();
}

class _ConvocatoriaImageState extends State<ConvocatoriaImage> {
  static final Random _random = Random();
  static final List<int> _usedIndexes = [];

  late String _fallbackImage;

  @override
  void initState() {
    super.initState();
    _fallbackImage = _pickUniqueImage();
  }

  /// 🔹 Escoge una imagen aleatoria sin repetir hasta agotar la lista
  String _pickUniqueImage() {
    if (_usedIndexes.length == _defaultImages.length) {
      _usedIndexes.clear(); // reinicia cuando ya usó las 30
    }
    int index;
    do {
      index = _random.nextInt(_defaultImages.length);
    } while (_usedIndexes.contains(index));
    _usedIndexes.add(index);
    return _defaultImages[index];
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = widget.imageUrl == null || widget.imageUrl!.trim().isEmpty;
    final imageToShow = isEmpty ? _fallbackImage : widget.imageUrl!;

    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
      child: Image.network(
        imageToShow,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
        // 🔹 Loader elegante
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: widget.height,
            width: widget.width,
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(strokeWidth: 2),
          );
        },
        // 🔹 Placeholder si hay error
        errorBuilder: (_, __, ___) => Container(
          height: widget.height,
          width: widget.width,
          color: Colors.grey[200],
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
        ),
      ),
    );
  }

  /// 🖼️ 30 imágenes variadas de convocatorias (educación, reuniones, laptops, jóvenes, etc.)
  static const List<String> _defaultImages = [
    "https://images.unsplash.com/photo-1584697964154-3cde52b6f74b?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1571260899304-425eee4c7efc?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1497493292307-31c376b6e479?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1531482615713-2afd69097998?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1523050854058-8df90110c9f1?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1581090700227-1e37b190418e?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1532619187608-e5375cab36ef?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1565120130282-230ba1c7b0e3?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1553877522-43269d4ea984?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1531482615713-2afd69097998?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1556761175-4b46a572b786?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1517503734587-289c6f8da7a2?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1531482615713-2afd69097998?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1524635962361-d7f8ae9c79b1?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1584697964154-3cde52b6f74b?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1553877522-43269d4ea984?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1581090700227-1e37b190418e?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=800&q=60",
  ];
}
