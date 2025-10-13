import 'package:app_bienestarmisena_v1/controllers/lineas_controller.dart';
import 'package:app_bienestarmisena_v1/models/linea/linea_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:app_bienestarmisena_v1/utils/image_helper.dart';
// ✅ Controladores
import 'package:app_bienestarmisena_v1/controllers/reactController.dart';
import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/convocatorias.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ✅ Widgets y modelos
import 'package:app_bienestarmisena_v1/widgets/carousel_convocatorias.dart';
import 'package:app_bienestarmisena_v1/widgets/header.dart';
import 'package:app_bienestarmisena_v1/models/Favoritos/favoritos.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';
import 'package:app_bienestarmisena_v1/views/detalleConvocatori/detalleConvocatoria.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final ConvocatoriasController _controller = ConvocatoriasController();

  final Reactcontroller reactController = Get.find<Reactcontroller>();
  final FavoritesController _favController = Get.find<FavoritesController>();

  late Future<List<Convocatoria>> _convocatorias;

  // 🔹 Controlador de líneas
  final LineasController _lineasController = LineasController();
  List<Linea> _lineas = [];
  bool _isLoadingLineas = true;
  int? _lineaSeleccionada;

  // 🔹 Paginación
  int _currentPage = 1;
  final int _itemsPerPage = 12;

  @override
  void initState() {
    super.initState();

    ever(reactController.userId, (id) {
      if (id != 0) {
        print("✅ Usuario logueado detectado: ID $id");
        _favController.loadUserFavorites(id);
      }
    });

    _convocatorias = _controller.getConvocatorias();
    _loadLineas();
  }

  Future<void> _loadLineas() async {
    final lineas = await _lineasController.getLineas();
    setState(() {
      _lineas = lineas;
      _isLoadingLineas = false;
    });
  }

  void _nextPage(int totalItems) {
    setState(() {
      if (_currentPage * _itemsPerPage < totalItems) _currentPage++;
    });
  }

  void _prevPage() {
    setState(() {
      if (_currentPage > 1) _currentPage--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.97,
              constraints: const BoxConstraints(maxWidth: 1390, minWidth: 600),
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(
                    selected: "Descubrir",
                  ),

                  const SizedBox(height: 24),

                  CarouselConvocatorias(),

                  const SizedBox(height: 30),
                  Row(
                    children: const [
                      Icon(Icons.explore, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        "Convocatorias",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.green,
                          Colors.yellow,
                          Colors.pink,
                          Colors.blue,
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 🔹 Filtros
                  // 🔹 Filtros dinámicos (líneas)
                  _isLoadingLineas
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // Botón "Todos"
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() => _lineaSeleccionada = null);
                                  },
                                  icon: const Icon(Icons.public,
                                      color: Colors.white),
                                  label: const Text(
                                    "Todos",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _lineaSeleccionada == null
                                        ? Colors.green
                                        : Colors.grey.shade700,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),

                              // 🔹 Botones dinámicos desde BD
                              ..._lineas.map((linea) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _lineaSeleccionada = linea.id;
                                      });
                                    },
                                    icon: const Icon(Icons.label_important,
                                        color: Colors.white),
                                    label: Text(
                                      linea.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          _lineaSeleccionada == linea.id
                                              ? Colors.green
                                              : Colors.grey.shade700,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),

                  const SizedBox(height: 30),

                  // 🔹 FUTURE BUILDER DE CONVOCATORIAS
                  FutureBuilder<List<Convocatoria>>(
                    future: _convocatorias,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      final data = snapshot.data ?? [];

// 🔹 Si hay línea seleccionada, filtra las convocatorias por su lineId
                      final convocatoriasFiltradas = _lineaSeleccionada == null
                          ? data
                          : data
                              .where((c) => c.lineId == _lineaSeleccionada)
                              .toList();

// 🔹 Si no hay convocatorias
                      if (convocatoriasFiltradas.isEmpty) {
                        return const Center(
                          child: Text(
                            "No hay convocatorias disponibles para esta línea.",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        );
                      }
// 🔹 Paginación con las filtradas
                      final int totalItems = convocatoriasFiltradas.length;
                      final int startIndex = (_currentPage - 1) * _itemsPerPage;
                      final int endIndex =
                          (_currentPage * _itemsPerPage).clamp(0, totalItems);
                      final List<Convocatoria> currentItems =
                          convocatoriasFiltradas.sublist(startIndex, endIndex);

                      //-----------------------------------------------------------------------------------------------------------------------
                      return Column(
                        children: [
                          // 1️⃣ Tarjeta destacada
                          _buildDestacada(context, currentItems.first),

                          const SizedBox(height: 30),

                          // 2️⃣ Tres tarjetas en fila horizontal
                          _buildFilaTres(context, currentItems),

                          const SizedBox(height: 30),

                          // 3️⃣ Grid de 4 tarjetas en 2 columnas
                          _buildGrid(
                            context,
                            currentItems,
                          ), // 👈 ya corregido internamente con ctx

                          const SizedBox(height: 30),

                          // 4️⃣ Mosaico de 4 tarjetas pequeñas
                          _buildMosaico(
                            context,
                            currentItems,
                          ), // 👈 ya corregido internamente con ctx

                          const SizedBox(height: 20),

                          // 🔹 Paginador
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: _currentPage > 1 ? _prevPage : null,
                                child: const Text("Anterior"),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                "Página $_currentPage / ${(totalItems / _itemsPerPage).ceil()}",
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                onPressed:
                                    _currentPage * _itemsPerPage < totalItems
                                        ? () => _nextPage(totalItems)
                                        : null,
                                child: const Text("Siguiente"),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Widget destacada fija
  // 🔹 Widget destacada desde la BD con hover + modal
  Widget _buildDestacada(BuildContext context, Convocatoria c) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700; // ✅ responsive

        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          tween: Tween<double>(begin: 1.0, end: 1.0),
          builder: (context, scale, child) {
            return MouseRegion(
              onEnter: (_) => scale = 1.03, // hover en web
              onExit: (_) => scale = 1.0,
              child: AnimatedScale(
                scale: scale,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                child: GestureDetector(
                  onTap: () {
                    // 👉 al dar tap en móvil abre modal
                    mostrarModalConvocatoria(context, c);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        isMobile
                            ? Column(
                                children: [
                                  _buildImage(context, c), // 📱 imagen arriba
                                  _buildContent(
                                    context,
                                    c,
                                  ), // 📱 contenido abajo
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: _buildImage(context, c),
                                  ), // 💻 imagen izquierda
                                  Expanded(
                                    flex: 1,
                                    child: _buildContent(context, c),
                                  ), // 💻 contenido derecha
                                ],
                              ),

                        // 🔹 Etiqueta destacada
                        Positioned(
                          top: 10,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.yellow[400],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.workspace_premium,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Destacada",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 🔹 Imagen con zoom al tocar
  Widget _buildImage(BuildContext context, Convocatoria c) {
    return GestureDetector(
      onTap: () =>
          mostrarModalConvocatoria(context, c), // 👉 abre modal desde la imagen
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          child: Stack(
            children: [
              // 🖼 Imagen con soporte de fallback automático
              ConvocatoriaImage(
                imageUrl: c.imageUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.zero,
              ),

              // 🌈 Degradado elegante para contraste (por si agregas texto o íconos)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.05),
                        Colors.black.withOpacity(0.25),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // 👁️ Ícono inferior derecho (solo decorativo o para acción)
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.visibility,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Contenido de la tarjeta
  Widget _buildContent(BuildContext context, Convocatoria c) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Row(
            children: [
              const Icon(
                Icons.mobile_friendly,
                color: Color(0xFF00324D),
                size: 22,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  c.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00324D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Descripción
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.school, color: Color(0xFF00324D), size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  c.description,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Fechas
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: Color(0xFF00324D),
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                "Apertura: ${c.openDate.split('T')[0]}",
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.calendar_today_outlined,
                color: Color(0xFF00324D),
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                "Cierre: ${c.closeDate.split('T')[0]}",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Botones
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  mostrarModalConvocatoria(context, c);
                },
                icon: const Icon(Icons.file_open, size: 16),
                label: const Text("Detalles"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00324D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check_circle, size: 16),
                label: const Text("Inscribirse"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF39A900),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Spacer(),
              Obx(() {
                final isFav = _favController.favoritesList
                    .any((f) => f.callId == c.id); // ✅ verifica si es favorito

                return IconButton(
                  onPressed: () async {
                    if (isFav) {
                      // ✅ Eliminar de favoritos
                      final favToRemove = _favController.favoritesList
                          .firstWhere((f) => f.callId == c.id);
                      final ok =
                          await _favController.removeFavorite(favToRemove.id);
                      if (ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("❌ Eliminado de favoritos"),
                            backgroundColor: Colors.red.shade400,
                          ),
                        );
                      }
                    } else {
                      // ✅ Agregar a favoritos
                      final newFav = await _favController.addFavorite(
                        reactController.userId.value, // ID del usuario logueado
                        c.id, // ID de la convocatoria
                      );

                      if (newFav != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("⭐ Agregado a favoritos"),
                            backgroundColor: Colors.green.shade600,
                          ),
                        );
                      }
                    }
                  },
                  icon: Icon(
                    isFav ? Icons.star : Icons.star_border,
                    color: isFav ? Colors.amber : Colors.grey.shade500,
                    size: 26,
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 Función global para mostrar el modal (se usa en TODAS las tarjetas)
  void mostrarModalConvocatoria(BuildContext context, Convocatoria c) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ModalConvocatoria(
          convocatoria:
              c, // 👈 aquí ya pasamos el objeto Convocatoria directamente
          cerrarModal: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  Widget _buildFilaTres(BuildContext context, List<Convocatoria> items) {
    // 🔹 Tomamos desde el índice 1 (segunda convocatoria) y mostramos 3
    final sublist = items.skip(1).take(3).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1; // 📱 móvil por defecto
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 3; // 💻 escritorio
        } else if (constraints.maxWidth > 700) {
          crossAxisCount = 2; // 📲 tablet
        }

        final itemWidth = (constraints.maxWidth / crossAxisCount) - 16;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: sublist.map((c) {
            return SizedBox(
              width: itemWidth,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =====================================================
                    // 🖼️ Imagen superior (con fallback automático)
                    // =====================================================
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () => mostrarModalConvocatoria(context, c),
                        splashColor: Colors.black.withOpacity(0.1),
                        highlightColor: Colors.transparent,
                        child: Stack(
                          children: [
                            ConvocatoriaImage(
                              imageUrl: c.imageUrl,
                              height: 180,
                              width: double.infinity,
                              borderRadius: BorderRadius.zero,
                              fit: BoxFit.cover,
                            ),
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.05),
                                      Colors.black.withOpacity(0.25),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.visibility,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // =====================================================
                    // 🧾 Contenido textual
                    // =====================================================
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 Título
                          Row(
                            children: [
                              const Icon(Icons.mobile_friendly,
                                  color: Color(0xFF00324D), size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  c.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00324D),
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // 🔹 Descripción
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.school,
                                  color: Color(0xFF00324D), size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  c.description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    height: 1.4,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // 🔹 Fechas
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Color(0xFF00324D), size: 16),
                              const SizedBox(width: 4),
                              Text(
                                "Apertura: ${c.openDate.split('T')[0]}",
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.event_busy,
                                  color: Colors.redAccent, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                "Cierre: ${c.closeDate.split('T')[0]}",
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // =====================================================
                    // 🔘 Botones inferiores y favorito
                    // =====================================================
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          // 📄 Botón Detalles
                          Expanded(
                            flex: 4,
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  mostrarModalConvocatoria(context, c),
                              icon: const Icon(Icons.file_open, size: 16),
                              label: const Text("Detalles"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00324D),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                textStyle: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // ✅ Botón Inscribirse
                          Expanded(
                            flex: 4,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.check_circle, size: 16),
                              label: const Text("Inscribirse"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF39A900),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                textStyle: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),

                          // ⭐ Favorito
                          Obx(() {
                            final isFav = _favController.favoritesList
                                .any((f) => f.callId == c.id);
                            return IconButton(
                              onPressed: () async {
                                if (isFav) {
                                  final favToRemove = _favController
                                      .favoritesList
                                      .firstWhere((f) => f.callId == c.id);
                                  final ok = await _favController
                                      .removeFavorite(favToRemove.id);
                                  if (ok) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                            "❌ Eliminado de favoritos"),
                                        backgroundColor: Colors.red.shade400,
                                      ),
                                    );
                                  }
                                } else {
                                  final newFav =
                                      await _favController.addFavorite(
                                    reactController.userId.value,
                                    c.id,
                                  );
                                  if (newFav != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                            "⭐ Agregado a favoritos"),
                                        backgroundColor: Colors.green.shade600,
                                      ),
                                    );
                                  }
                                }
                              },
                              icon: Icon(
                                isFav ? Icons.star : Icons.star_border,
                                color:
                                    isFav ? Colors.amber : Colors.grey.shade500,
                                size: 26,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildGrid(BuildContext context, List<Convocatoria> items) {
    final sublist = items.skip(4).take(4).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        // 📱 Ajustes de diseño según ancho
        bool isMobile = constraints.maxWidth < 600;
        int crossAxisCount =
            isMobile ? 1 : (constraints.maxWidth < 900 ? 2 : 2);
        double imageHeight = isMobile ? 180 : 190;
        double aspectRatio = isMobile ? 0.80 : 1.70;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sublist.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: aspectRatio, // 🔹 Responsive
          ),
          itemBuilder: (ctx, index) {
            final c = sublist[index];

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🖼 Imagen adaptativa
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                    child: InkWell(
                      onTap: () => mostrarModalConvocatoria(ctx, c),
                      child: Stack(
                        children: [
                          // 🔹 Imagen principal (con fallback automático)
                          ConvocatoriaImage(
                            imageUrl: c.imageUrl,
                            height: imageHeight,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(0),
                            fit: BoxFit.cover,
                          ),

                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.visibility,
                                  color: Colors.white, size: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 🧾 Contenido textual compacto
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 Título
                          Text(
                            c.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF00324D),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),

                          // 🔹 Descripción adaptativa
                          Flexible(
                            child: Text(
                              c.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[800],
                                height: 1.3,
                              ),
                              maxLines: isMobile ? 5 : 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // 🔹 Fechas
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 13, color: Colors.green),
                                    const SizedBox(width: 4),
                                    Text(
                                      c.openDate.split('T')[0],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.event_busy,
                                        size: 13, color: Colors.redAccent),
                                    const SizedBox(width: 4),
                                    Text(
                                      c.closeDate.split('T')[0],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // 🔹 Botones (Detalles, Inscribirse, Favorito)
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: isMobile ? 38 : 34,
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        mostrarModalConvocatoria(context, c),
                                    icon: const Icon(Icons.file_open, size: 14),
                                    label: const Text("Detalles"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF00324D),
                                      foregroundColor: Colors.white,
                                      textStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: SizedBox(
                                  height: isMobile ? 38 : 34,
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.check_circle,
                                        size: 14),
                                    label: const Text("Inscribirse"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF39A900),
                                      foregroundColor: Colors.white,
                                      textStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              // 🌟 Favoritos
                              Obx(() {
                                final isFav = _favController.favoritesList
                                    .any((f) => f.callId == c.id);
                                return SizedBox(
                                  height: isMobile ? 38 : 34,
                                  width: 38,
                                  child: IconButton(
                                    tooltip: isFav
                                        ? "Eliminar de favoritos"
                                        : "Agregar a favoritos",
                                    padding: EdgeInsets.zero,
                                    onPressed: () async {
                                      if (isFav) {
                                        final favToRemove = _favController
                                            .favoritesList
                                            .firstWhere(
                                                (f) => f.callId == c.id);
                                        final ok = await _favController
                                            .removeFavorite(favToRemove.id);
                                        if (ok) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: const Text(
                                                "❌ Eliminado de favoritos"),
                                            backgroundColor:
                                                Colors.red.shade400,
                                          ));
                                        }
                                      } else {
                                        final newFav =
                                            await _favController.addFavorite(
                                          reactController.userId.value,
                                          c.id,
                                        );
                                        if (newFav != null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: const Text(
                                                "⭐ Agregado a favoritos"),
                                            backgroundColor:
                                                Colors.green.shade600,
                                          ));
                                        }
                                      }
                                    },
                                    icon: Icon(
                                      isFav ? Icons.star : Icons.star_border,
                                      color: isFav
                                          ? Colors.amber
                                          : Colors.grey.shade500,
                                      size: 22,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

Widget _buildMosaico(BuildContext context, List<Convocatoria> items) {
  final sublist = (items.length > 8)
      ? items.sublist(8, items.length >= 12 ? 12 : items.length)
      : [];

  if (sublist.isEmpty) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Text(
          "📭 No hay más convocatorias disponibles.",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  return LayoutBuilder(
    builder: (context, constraints) {
      int crossAxisCount = 1;
      double childAspectRatio = 0.72;

      if (constraints.maxWidth > 1200) {
        crossAxisCount = 4; // 💻 Escritorio
        childAspectRatio = 0.85;
      } else if (constraints.maxWidth > 800) {
        crossAxisCount = 2; // 📱 Tablet
        childAspectRatio = 0.78;
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sublist.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 22,
          crossAxisSpacing: 22,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (ctx, index) {
          final c = sublist[index];

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🖼 Imagen más alta y adaptativa
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  child: GestureDetector(
                    onTap: () => mostrarModalConvocatoria(context, c),
                    child: Stack(
                      children: [
                        ConvocatoriaImage(
                          imageUrl: c.imageUrl,
                          height: constraints.maxWidth < 600 ? 160 : 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00324D).withOpacity(0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.visibility,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 🧾 Contenido textual flexible
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 Título
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.title,
                                color: Color(0xFF00324D), size: 18),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                c.title,
                                style: const TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00324D),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // 🔹 Descripción
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.description,
                                color: Color(0xFF00324D), size: 17),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                c.description.isNotEmpty
                                    ? c.description
                                    : "Sin descripción disponible.",
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        // 🔹 Fechas bien alineadas
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month,
                                      size: 16, color: Color(0xFF00324D)),
                                  const SizedBox(width: 4),
                                  Text(
                                    c.openDate.split('T')[0],
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.event_busy,
                                      size: 16, color: Color(0xFF00324D)),
                                  const SizedBox(width: 4),
                                  Text(
                                    c.closeDate.split('T')[0],
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 🔹 Línea divisoria
                Container(
                  height: 1,
                  color: Colors.grey.shade200,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),

                // 🔹 Botones bien centrados
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botón Detalles
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => mostrarModalConvocatoria(context, c),
                          icon: const Icon(Icons.info_outline, size: 16),
                          label: const Text("Detalles"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00324D),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Botón Inscribirse
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.check_circle_outline, size: 16),
                          label: const Text("Inscribirse"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF39A900),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),

                      // 🌟 Favorito
                      Obx(() {
                        final isFav = _favController.favoritesList
                            .any((f) => f.callId == c.id);
                        return IconButton(
                          padding: EdgeInsets.zero,
                          tooltip: isFav
                              ? "Eliminar de favoritos"
                              : "Agregar a favoritos",
                          onPressed: () async {
                            if (isFav) {
                              final favToRemove = _favController.favoritesList
                                  .firstWhere((f) => f.callId == c.id);
                              final ok = await _favController
                                  .removeFavorite(favToRemove.id);
                              if (ok) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        const Text("❌ Eliminado de favoritos"),
                                    backgroundColor: Colors.red.shade400,
                                  ),
                                );
                              }
                            } else {
                              final newFav =
                                  await _favController.addFavorite(
                                reactController.userId.value,
                                c.id,
                              );
                              if (newFav != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        const Text("⭐ Agregado a favoritos"),
                                    backgroundColor: Colors.green.shade600,
                                  ),
                                );
                              }
                            }
                          },
                          icon: Icon(
                            isFav ? Icons.star : Icons.star_border,
                            color: isFav
                                ? Colors.amber
                                : const Color(0xFF00324D),
                            size: 24,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

}
