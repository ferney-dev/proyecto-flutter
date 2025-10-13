import 'package:app_bienestarmisena_v1/controllers/userInterest.dart';
import 'package:app_bienestarmisena_v1/controllers/lineas_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/publicoObjetivo_controller.dart';
import 'package:app_bienestarmisena_v1/models/userInterest/userInterest.dart';
import 'package:app_bienestarmisena_v1/models/linea/linea_model.dart';
import 'package:app_bienestarmisena_v1/models/publicoObejtivoModel/publicoObjetivo.dart';
import 'package:app_bienestarmisena_v1/views/detalleConvocatori/detalleConvocatoria.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:collection/collection.dart'; // ✅ importa esto arriba

import 'package:app_bienestarmisena_v1/controllers/reactController.dart';
import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';
import 'package:app_bienestarmisena_v1/models/Favoritos/favoritos.dart';
import 'package:app_bienestarmisena_v1/controllers/convocatorias.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';
import 'package:app_bienestarmisena_v1/widgets/header.dart';

class ExplorarPage extends StatefulWidget {
  const ExplorarPage({super.key});

  @override
  State<ExplorarPage> createState() => _ExplorarPageState();
}

class _ExplorarPageState extends State<ExplorarPage> {
  // 🔹 Controladores principales
  final ConvocatoriasController _controller = ConvocatoriasController();

  // ✅ Controlador de favoritos gestionado con GetX (solo se declara UNA VEZ)

  final FavoritesController _favController = Get.find<FavoritesController>();

  // ✅ Controlador global reactivo para el usuario
  final Reactcontroller reactController = Get.find<Reactcontroller>();

  final LineasController _lineasController = LineasController();
  final UserInterestsController _interesController = UserInterestsController();

  final PublicoObjetivoController _publicoController =
      PublicoObjetivoController();

  List<Linea> _lineas = [];
  List<UserInterest> _interesesUsuario = [];
  List<PublicoModel> _publicos = [];

  bool _loadingFiltros = true;

  late Future<List<Convocatoria>> _convocatorias;

  @override
  void initState() {
    super.initState();

    // 🔹 Escucha cambios del ID de usuario y recarga favoritos automáticamente
    ever(reactController.userId, (id) {
      if (id != 0) {
        print("✅ Usuario detectado en Explorar: ID $id");
        _favController.loadUserFavorites(id);
        _loadFiltros(id);
      }
    });

    // 🔹 Cargar convocatorias
    _convocatorias = _controller.getConvocatorias();

    // 🔹 Cargar filtros iniciales (si ya hay usuario logueado)
    final int userId =
        int.tryParse(reactController.userId.value.toString()) ?? 0;
    if (userId != 0) {
      _favController.loadUserFavorites(userId);
      _loadFiltros(userId);
    } else {
      print("⚠️ Usuario no autenticado al iniciar, esperando login...");
    }
  }

  // 🔹 Cargar filtros iniciales (líneas, intereses, públicos)

  Future<void> _loadFiltros(int userId) async {
    try {
      print("🔄 Cargando filtros iniciales...");

      // ================================================================
      // 🔸 1. Cargar líneas
      // ================================================================
      final lineas = await _lineasController.getLineas();
      print("📦 Líneas recibidas: ${lineas.length}");

      // ================================================================
      // 🔸 2. Cargar intereses del usuario (solo si está autenticado)
      // ================================================================
      List<UserInterest> intereses = [];
      if (userId != 0) {
        intereses = await _interesController.getInteresesByUser(userId);
        print(
            "💡 Intereses cargados para usuario $userId: ${intereses.length}");
      } else {
        print("⚠️ Usuario no autenticado, se omite carga de intereses.");
      }

      // ================================================================
      // 🔸 3. Cargar públicos objetivos
      // ================================================================
      final publicos = await _publicoController.getPublicoObjetivo();
      print("👥 Públicos recibidos: ${publicos.length}");

      // ================================================================
      // 🔸 4. Actualizar estado
      // ================================================================
      setState(() {
        _lineas = lineas;
        _interesesUsuario = intereses;
        _publicos = publicos;
        _loadingFiltros = false;
      });

      print("✅ Filtros cargados correctamente:");
      print("   - Líneas: ${_lineas.length}");
      print("   - Intereses: ${_interesesUsuario.length}");
      print("   - Públicos: ${_publicos.length}");
    } catch (e) {
      // ================================================================
      // ⚠️ 5. Manejo de errores con logs de diagnóstico
      // ================================================================
      print("❌ Error al cargar filtros: $e");
      print("🔗 Endpoints de conexión:");
      print("   • Líneas → ${_lineasController.baseUrl}");
      print("   • Intereses → ${_interesController.baseUrl}");
      print("   • Públicos → ${_publicoController.baseUrl}");

      // Evita quedarse en modo carga infinito
      setState(() => _loadingFiltros = false);
    }
  }

  // ===============================
  // 🔹 Filtros
  // ===============================
  String categoriaSeleccionada = 'Todas las categorías';
  String interesSeleccionado = 'Sin intereses asociados';
  String publicoSeleccionado = 'Sin públicos registrados';

  DateTime? fechaSeleccionada; // será null si no hay filtro activo

  String visualizacionSeleccionada = 'Tarjeta';

  int _currentPage = 1;
  final int _itemsPerPage = 12;

  final List<String> visualizaciones = [
    'Tarjeta',
    'Lista',
    'Tabla',
    'Mosaico',
  ];

  void _nextPage(int totalItems) {
    if (_currentPage * _itemsPerPage < totalItems) {
      setState(() => _currentPage++);
    }
  }

  void _prevPage() {
    if (_currentPage > 1) {
      setState(() => _currentPage--);
    }
  }

  // ===============================
  // 🔹 Mostrar modal de detalles
  // ===============================
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

  // ===============================
  // 🔹 UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<List<Convocatoria>>(
          future: _convocatorias,
          builder: (context, snapshot) {
            // 🌀 Mientras carga
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // ⚠️ Si no hay datos
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No hay convocatorias disponibles"),
              );
            }

            // ✅ Convocatorias cargadas
            final allConvocatorias = snapshot.data!;

            final filteredConvocatorias = allConvocatorias.where((conv) {
              // 1) Línea → por ID
              final lineaSeleccionada = _lineas
                  .firstWhereOrNull((l) => l.name == categoriaSeleccionada);
              final lineaIdSeleccionada = lineaSeleccionada?.id;

              final matchesLinea =
                  categoriaSeleccionada == 'Todas las categorías' ||
                      (lineaIdSeleccionada != null &&
                          conv.lineId == lineaIdSeleccionada);

              // 2) Interés → por ID (desde los intereses del usuario)
              final interesSeleccionadoObj = _interesesUsuario.firstWhereOrNull(
                  (i) => i.interestName == interesSeleccionado);
              final interesIdSeleccionado = interesSeleccionadoObj?.interestId;

              final matchesInteres =
                  interesSeleccionado == 'Sin intereses asociados' ||
                      (interesIdSeleccionado != null &&
                          conv.interestId == interesIdSeleccionado);

              // 3) Público objetivo → por ID (desde _publicos)
              final publicoSeleccionadoObj = _publicos
                  .firstWhereOrNull((p) => p.name == publicoSeleccionado);
              final publicoIdSeleccionado = publicoSeleccionadoObj?.id;

              final matchesPublico =
                  publicoSeleccionado == 'Sin públicos registrados' ||
                      (publicoIdSeleccionado != null &&
                          conv.targetAudienceId == publicoIdSeleccionado);

              // 4) Fecha (comparar con openDate y closeDate)
              bool matchesFecha = true;
              if (fechaSeleccionada != null) {
                try {
                  final open = DateTime.parse(conv.openDate);
                  final close = DateTime.parse(conv.closeDate);
                  matchesFecha = fechaSeleccionada!.isAfter(open) &&
                      fechaSeleccionada!.isBefore(close);
                } catch (e) {
                  matchesFecha = true; // si hay error en formato, no filtra
                }
              }

              return matchesLinea &&
                  matchesInteres &&
                  matchesPublico &&
                  matchesFecha;
            }).toList();

            // ============================================================
            // 🔹 PAGINACIÓN
            // ============================================================
            final totalItems = filteredConvocatorias.length;
            final startIndex = (_currentPage - 1) * _itemsPerPage;
            final endIndex =
                (_currentPage * _itemsPerPage).clamp(0, totalItems);
            final pageItems =
                filteredConvocatorias.sublist(startIndex, endIndex);

            // ============================================================
            // 🔹 INTERFAZ PRINCIPAL
            // ============================================================
            return SingleChildScrollView(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.97,
                  constraints:
                      const BoxConstraints(maxWidth: 1430, minWidth: 900),
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(20),
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
                      const Header(selected: "Explorar"),
                      const SizedBox(height: 24),

                      // ==================================================
                      // 🔹 FILTROS (responsivos y con scroll horizontal)
                      // ==================================================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1.5),
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

                            if (_loadingFiltros) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            return SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 🔸 Categoría
      _buildFilterItem(
        label: "Categoría",
        icon: FontAwesomeIcons.tags,
        value: categoriaSeleccionada,
        items: [
          'Todas las categorías',
          ..._lineas.map((l) => l.name).toList(),
        ],
        onChanged: (val) => setState(() {
          categoriaSeleccionada = val;
          _currentPage = 1;
        }),
        width: isMobile ? 240 : constraints.maxWidth * 0.19,
      ),

      const SizedBox(width: 16),

      // 🔸 Interés Usuario
      _buildFilterItem(
        label: "Interés Usuario",
        icon: FontAwesomeIcons.userCheck,
        value: interesSeleccionado,
        items: _interesesUsuario.isNotEmpty
            ? [
                'Sin intereses asociados',
                ..._interesesUsuario.map((i) => i.interestName).toList(),
              ]
            : ['Sin intereses asociados'],
        onChanged: (val) => setState(() {
          interesSeleccionado = val;
          _currentPage = 1;
        }),
        width: isMobile ? 240 : constraints.maxWidth * 0.19,
      ),

      const SizedBox(width: 16),

      // 🔸 Público Objetivo
      _buildFilterItem(
        label: "Público Objetivo",
        icon: FontAwesomeIcons.users,
        value: publicoSeleccionado,
        items: _publicos.isNotEmpty
            ? [
                'Sin públicos registrados',
                ..._publicos.map((p) => p.name ?? '').toList(),
              ]
            : ['Sin públicos registrados'],
        onChanged: (val) => setState(() {
          publicoSeleccionado = val;
          _currentPage = 1;
        }),
        width: isMobile ? 240 : constraints.maxWidth * 0.19,
      ),

      const SizedBox(width: 16),

      // 🔸 Fecha de inicio
      SizedBox(
        width: isMobile ? 240 : constraints.maxWidth * 0.19,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.calendarDays,
                      color: Color(0xFF00324D), size: 18),
                  SizedBox(width: 6),
                  Text(
                    "Fecha de inicio",
                    style: TextStyle(
                      fontSize: 13.5,
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
                  context: context,
                  initialDate: fechaSeleccionada ?? DateTime.now(),
                  firstDate: DateTime(2024, 1, 1),
                  lastDate: DateTime(2026, 12, 31),
                );
                if (picked != null) {
                  setState(() => fechaSeleccionada = picked);
                }
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
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
                    Text(
                      fechaSeleccionada != null
                          ? "${fechaSeleccionada!.year}-${fechaSeleccionada!.month.toString().padLeft(2, '0')}-${fechaSeleccionada!.day.toString().padLeft(2, '0')}"
                          : "Cualquier fecha",
                      style: const TextStyle(
                        fontSize: 14.5,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF00324D)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      const SizedBox(width: 16),

      // 🔸 Visualización
      _buildFilterItem(
        label: "Visualización",
        icon: FontAwesomeIcons.tableCellsLarge,
        value: visualizacionSeleccionada,
        items: visualizaciones,
        onChanged: (val) =>
            setState(() => visualizacionSeleccionada = val),
        width: isMobile ? 240 : constraints.maxWidth * 0.19,
      ),
    ],
  ),
);

                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ==================================================
                      // 🔹 Vista seleccionada (Tarjeta / Lista / Tabla / Mosaico)
                      // ==================================================
                      if (visualizacionSeleccionada == 'Tarjeta')
                        _vistaTarjeta(pageItems),
                      if (visualizacionSeleccionada == 'Lista')
                        _vistaLista(pageItems),
                      if (visualizacionSeleccionada == 'Tabla')
                        _vistaTabla(pageItems),
                      if (visualizacionSeleccionada == 'Mosaico')
                        _vistaMosaico(pageItems),

                      const SizedBox(height: 20),

                      // ==================================================
                      // 🔹 Paginador
                      // ==================================================
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
                            onPressed: _currentPage * _itemsPerPage < totalItems
                                ? () => _nextPage(totalItems)
                                : null,
                            child: const Text("Siguiente"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ===============================
// 🔹 Vista tipo Tarjeta moderna con estrella animada (Responsive)
// ===============================

  Widget _vistaTarjeta(List<Convocatoria> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        double cardWidth = constraints.maxWidth;

        if (constraints.maxWidth > 1200) {
          crossAxisCount = 3;
          cardWidth = (constraints.maxWidth / 3) - 20;
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 2;
          cardWidth = (constraints.maxWidth / 2) - 20;
        }

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: items.map((conv) {
            bool isExpanded = false;

            return StatefulBuilder(
              builder: (context, setLocalState) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    width: cardWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 Imagen
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                          ),
                          child: GestureDetector(
                            onTap: () =>
                                mostrarModalConvocatoria(context, conv),
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 250),
                              scale: 1.0,
                              child: Image.network(
                                (conv.imageUrl != null &&
                                        conv.imageUrl!.isNotEmpty)
                                    ? conv.imageUrl!
                                    : "https://via.placeholder.com/400x200.png?text=Convocatoria",
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, e, s) => Container(
                                  height: 180,
                                  color: Colors.grey[300],
                                  child:
                                      const Icon(Icons.broken_image, size: 60),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // 🔹 Contenido
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Título
                              Row(
                                children: [
                                  const Icon(Icons.mobile_friendly,
                                      color: Color(0xFF00324D), size: 20),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      conv.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF00324D),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Descripción
                              GestureDetector(
                                onTap: () => setLocalState(
                                    () => isExpanded = !isExpanded),
                                child: Text(
                                  isExpanded
                                      ? conv.description
                                      : (conv.description.length > 120
                                          ? "${conv.description.substring(0, 120)}..."
                                          : conv.description),
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Fechas
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month,
                                      size: 16, color: Colors.green),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Apertura: ${conv.openDate.split('T')[0]}",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.calendar_today_outlined,
                                      size: 16, color: Colors.redAccent),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Cierre: ${conv.closeDate.split('T')[0]}",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const Divider(height: 1),

                        // 🔹 Botones inferiores
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              // Detalles
                              ElevatedButton.icon(
                                onPressed: () =>
                                    mostrarModalConvocatoria(context, conv),
                                icon: const Icon(Icons.file_open, size: 16),
                                label: const Text("Detalles"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00324D),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Inscribirse
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.check_circle, size: 16),
                                label: const Text("Inscribirse"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF39A900),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const Spacer(),

                              // 🌟 Favorito (con estado reactivo GetX)
                              Obx(() {
                                final isFav = _favController.favoritesList
                                    .any((f) => f.callId == conv.id);

                                return IconButton(
                                  onPressed: () async {
                                    if (isFav) {
                                      // Eliminar de favoritos
                                      final favToRemove = _favController
                                          .favoritesList
                                          .firstWhere(
                                              (f) => f.callId == conv.id);
                                      final ok = await _favController
                                          .removeFavorite(favToRemove.id);
                                      if (ok) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: const Text(
                                              "❌ Eliminado de favoritos"),
                                          backgroundColor: Colors.red.shade400,
                                        ));
                                      }
                                    } else {
                                      // Agregar a favoritos
                                      final newFav =
                                          await _favController.addFavorite(
                                        reactController.userId.value,
                                        conv.id,
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
                                    size: 28,
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
              },
            );
          }).toList(),
        );
      },
    );
  }

/// ===============================
// 🔹 Vista tipo Lista moderna con imagen lateral (responsive y alineada)
// ===============================
Widget _vistaLista(List<Convocatoria> items) {
  return Column(
    children: items.map((conv) {
      bool isExpanded = false;

      return StatefulBuilder(
        builder: (context, setLocalState) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade300, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bool isMobile = constraints.maxWidth < 750;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===============================
                    // 🖼️ Imagen lateral
                    // ===============================
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                      ),
                      child: Image.network(
                        (conv.imageUrl != null && conv.imageUrl!.isNotEmpty)
                            ? conv.imageUrl!
                            : "https://via.placeholder.com/400x250.png?text=Convocatoria",
                        width: isMobile ? 130 : 250,
                        height: isMobile ? 130 : 220,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, e, s) => Container(
                          width: isMobile ? 130 : 250,
                          height: isMobile ? 130 : 220,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image_outlined,
                              size: 60, color: Colors.grey),
                        ),
                      ),
                    ),

                    // ===============================
                    // 📄 Contenido derecho
                    // ===============================
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔸 Título con ícono
                            Row(
                              children: [
                                const Icon(Icons.campaign_outlined,
                                    color: Color(0xFF00324D), size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    conv.title,
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF00324D),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),
                            Container(
                              height: 1,
                              color: Colors.grey.shade300,
                              margin:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                            ),

                            // 🔹 Descripción expandible
                            GestureDetector(
                              onTap: () => setLocalState(
                                  () => isExpanded = !isExpanded),
                              child: Text(
                                isExpanded
                                    ? conv.description
                                    : (conv.description.length > 200
                                        ? "${conv.description.substring(0, 200)}..."
                                        : conv.description),
                                style: const TextStyle(
                                  fontSize: 14.2,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // 🔹 Fechas
                            Row(
                              children: [
                                const Icon(Icons.calendar_month,
                                    color: Colors.green, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  "Apertura: ${conv.openDate.split('T')[0]}",
                                  style: const TextStyle(
                                      fontSize: 13.5,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 18),
                                const Icon(Icons.event_busy_outlined,
                                    color: Colors.redAccent, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  "Cierre: ${conv.closeDate.split('T')[0]}",
                                  style: const TextStyle(
                                      fontSize: 13.5,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),
                            Container(
                              height: 1,
                              color: Colors.grey.shade300,
                              margin:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                            ),

                            // 🔹 Botones inferiores alineados
                            Row(
                              children: [
                                // 🔵 Botón Detalles
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      mostrarModalConvocatoria(context, conv),
                                  icon: const Icon(Icons.info_outline, size: 16),
                                  label: const Text("Detalles"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00324D),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 10),
                                    textStyle: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                // 🟢 Botón Inscribirse
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                      Icons.check_circle_outline, size: 16),
                                  label: const Text("Inscribirse"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF39A900),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 10),
                                    textStyle: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),

                                const Spacer(),

                                // ⭐ Favorito reactivo
                                Obx(() {
                                  final isFav = _favController.favoritesList
                                      .any((f) => f.callId == conv.id);

                                  return IconButton(
                                    tooltip: isFav
                                        ? "Eliminar de favoritos"
                                        : "Agregar a favoritos",
                                    onPressed: () async {
                                      if (isFav) {
                                        final favToRemove = _favController
                                            .favoritesList
                                            .firstWhere((f) =>
                                                f.callId == conv.id);
                                        final ok = await _favController
                                            .removeFavorite(favToRemove.id);
                                        if (ok) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                  "❌ Eliminado de favoritos"),
                                              backgroundColor:
                                                  Colors.red.shade400,
                                            ),
                                          );
                                        }
                                      } else {
                                        final newFav =
                                            await _favController.addFavorite(
                                          reactController.userId.value,
                                          conv.id,
                                        );
                                        if (newFav != null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                  "⭐ Agregado a favoritos"),
                                              backgroundColor:
                                                  Colors.green.shade600,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    icon: AnimatedRotation(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      turns: isFav ? 1 : 0,
                                      child: Icon(
                                        isFav
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: isFav
                                            ? Colors.amber
                                            : Colors.grey.shade400,
                                        size: 28,
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
                );
              },
            ),
          );
        },
      );
    }).toList(),
  );
}


// ===============================
// 🔹 Vista tipo Tabla (estilo moderno y uniforme con filtros)
// ===============================
Widget _vistaTabla(List<Convocatoria> items) {
  final screenWidth = MediaQuery.of(context).size.width;

  return Center(
    child: Container(
      width: screenWidth * 0.97, // 📏 Igual que los filtros
      constraints: const BoxConstraints(
        maxWidth: 1450,
        minWidth: 380,
      ),
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300, width: 1.3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      // 🔹 Scroll horizontal para pantallas pequeñas
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 28,
          horizontalMargin: 18,
          headingRowHeight: 55,
          dataRowHeight: 110,
          dividerThickness: 1.2,
          headingRowColor: MaterialStateProperty.all(Colors.white),
          headingTextStyle: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00324D),
          ),
          border: TableBorder(
            horizontalInside: BorderSide(color: Colors.grey.shade200, width: 1),
            verticalInside: BorderSide(color: Colors.grey.shade200, width: 0.6),
            bottom: BorderSide(color: Colors.grey.shade300, width: 1.2),
          ),

          // ===========================================
          // 🔹 Columnas principales
          // ===========================================
          columns: const [
            DataColumn(
              label: Row(
                children: [
                  Icon(Icons.image_outlined, color: Color(0xFF00324D), size: 18),
                  SizedBox(width: 6),
                  Text("Convocatoria"),
                ],
              ),
            ),
            DataColumn(
              label: Row(
                children: [
                  Icon(Icons.description_outlined,
                      color: Color(0xFF00324D), size: 18),
                  SizedBox(width: 6),
                  Text("Descripción"),
                ],
              ),
            ),
            DataColumn(
              label: Row(
                children: [
                  Icon(Icons.calendar_month,
                      color: Color(0xFF00324D), size: 18),
                  SizedBox(width: 6),
                  Text("Apertura"),
                ],
              ),
            ),
            DataColumn(
              label: Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      color: Color(0xFF00324D), size: 18),
                  SizedBox(width: 6),
                  Text("Cierre"),
                ],
              ),
            ),
            DataColumn(
              label: Row(
                children: [
                  Icon(Icons.settings_outlined,
                      color: Color(0xFF00324D), size: 18),
                  SizedBox(width: 6),
                  Text("Acciones"),
                ],
              ),
            ),
          ],

          // ===========================================
          // 🔹 Filas dinámicas con diseño limpio
          // ===========================================
          rows: items.map((conv) {
            bool isExpanded = false;

            return DataRow(
              color: MaterialStateProperty.all(Colors.grey.shade50),
              cells: [
                // 🖼️ Imagen + título
                DataCell(
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          (conv.imageUrl != null && conv.imageUrl!.isNotEmpty)
                              ? conv.imageUrl!
                              : "https://via.placeholder.com/400x200.png?text=Convocatoria",
                          width: 90,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, e, s) => Container(
                            width: 90,
                            height: 60,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.broken_image_outlined,
                                size: 28, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          conv.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF00324D),
                            fontSize: 14.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // 📝 Descripción expandible
                DataCell(
                  StatefulBuilder(builder: (context, setStateLocal) {
                    return GestureDetector(
                      onTap: () => setStateLocal(() => isExpanded = !isExpanded),
                      child: Text(
                        isExpanded
                            ? conv.description
                            : (conv.description.length > 100
                                ? "${conv.description.substring(0, 100)}..."
                                : conv.description),
                        style: const TextStyle(
                          fontSize: 13.2,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    );
                  }),
                ),

                // 📅 Apertura
                DataCell(Row(
                  children: [
                    const Icon(Icons.calendar_month,
                        size: 16, color: Color(0xFF00324D)),
                    const SizedBox(width: 6),
                    Text(
                      conv.openDate.split('T')[0],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )),

                // 📅 Cierre
                DataCell(Row(
                  children: [
                    const Icon(Icons.event_busy_outlined,
                        size: 16, color: Color(0xFF00324D)),
                    const SizedBox(width: 6),
                    Text(
                      conv.closeDate.split('T')[0],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )),

                // ⚙️ Acciones con mejor alineación visual
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // 🔹 Detalles
                    ElevatedButton.icon(
                      onPressed: () =>
                          mostrarModalConvocatoria(context, conv),
                      icon: const Icon(Icons.info_outline, size: 14),
                      label: const Text("Detalles"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00324D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        textStyle: const TextStyle(fontSize: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // ✅ Inscribirse
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.check_circle_outline, size: 14),
                      label: const Text("Inscribirse"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF39A900),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        textStyle: const TextStyle(fontSize: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // ⭐ Favorito animado
                    Obx(() {
                      final isFav = _favController.favoritesList
                          .any((f) => f.callId == conv.id);

                      return IconButton(
                        onPressed: () async {
                          if (isFav) {
                            final favToRemove = _favController.favoritesList
                                .firstWhere((f) => f.callId == conv.id);
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
                            final newFav = await _favController.addFavorite(
                              reactController.userId.value,
                              conv.id,
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
                        icon: AnimatedRotation(
                          duration: const Duration(milliseconds: 600),
                          turns: isFav ? 1 : 0,
                          child: Icon(
                            isFav ? Icons.star : Icons.star_border,
                            color: isFav
                                ? Colors.amber
                                : Colors.grey.shade400,
                            size: 26,
                          ),
                        ),
                      );
                    }),
                  ],
                )),
              ],
            );
          }).toList(),
        ),
      ),
    ),
  );
}

  // ===============================
// 🔹 Vista tipo Mosaico (moderna, responsive y animada con favoritos reactivos)
// ===============================
  Widget _vistaMosaico(List<Convocatoria> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1; // 📱 móvil por defecto
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4; // 🖥 escritorio
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 2; // 💻 tablet
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (context, index) {
            final c = items[index];

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
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
              child: InkWell(
                onTap: () => mostrarModalConvocatoria(context, c),
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🖼 Imagen superior
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.network(
                        (c.imageUrl != null && c.imageUrl!.isNotEmpty)
                            ? c.imageUrl!
                            : "https://via.placeholder.com/400x200.png?text=Convocatoria",
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, error, stackTrace) => Container(
                          height: 150,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.broken_image, size: 50),
                        ),
                      ),
                    ),

                    // 🔹 Contenido
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🧾 Título
                            Row(
                              children: [
                                const Icon(Icons.mobile_friendly,
                                    color: Color(0xFF00324D), size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    c.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF00324D),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // 📝 Descripción
                            Text(
                              c.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),

                            const Spacer(),

                            // 📅 Fechas
                            Container(
                              margin: const EdgeInsets.only(top: 6, bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_month,
                                          size: 14, color: Color(0xFF00324D)),
                                      const SizedBox(width: 4),
                                      Text(
                                        c.openDate.split('T')[0],
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time,
                                          size: 14, color: Colors.redAccent),
                                      const SizedBox(width: 4),
                                      Text(
                                        c.closeDate.split('T')[0],
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // 🔘 Botones + ⭐
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        mostrarModalConvocatoria(context, c),
                                    icon: const Icon(Icons.file_open, size: 14),
                                    label: const Text("Detalles"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF00324D),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      textStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.check_circle,
                                        size: 14),
                                    label: const Text("Inscribirse"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF39A900),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      textStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),

                                // 🌟 Favorito reactivo con Obx
                                Obx(() {
                                  final isFav = _favController.favoritesList
                                      .any((f) => f.callId == c.id);

                                  return IconButton(
                                    onPressed: () async {
                                      if (isFav) {
                                        // ✅ Eliminar de favoritos
                                        final favToRemove = _favController
                                            .favoritesList
                                            .firstWhere(
                                                (f) => f.callId == c.id);
                                        final ok = await _favController
                                            .removeFavorite(favToRemove.id);
                                        if (ok) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                  "❌ Eliminado de favoritos"),
                                              backgroundColor:
                                                  Colors.red.shade400,
                                            ),
                                          );
                                        }
                                      } else {
                                        // ✅ Agregar a favoritos
                                        final newFav =
                                            await _favController.addFavorite(
                                          reactController.userId.value,
                                          c.id,
                                        );
                                        if (newFav != null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                  "⭐ Agregado a favoritos"),
                                              backgroundColor:
                                                  Colors.green.shade600,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    icon: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        AnimatedRotation(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          turns: isFav ? 1 : 0,
                                          child: Icon(
                                            isFav
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: isFav
                                                ? Colors.amber
                                                : Colors.grey.shade400,
                                            size: 26,
                                          ),
                                        ),
                                        if (isFav) ...[
                                          Positioned(
                                            top: 0,
                                            right: 2,
                                            child: Text("✨",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors
                                                        .yellow.shade600)),
                                          ),
                                          Positioned(
                                            bottom: 1,
                                            left: 3,
                                            child: Text("✦",
                                                style: TextStyle(
                                                    fontSize: 9,
                                                    color: Colors
                                                        .orange.shade400)),
                                          ),
                                        ],
                                      ],
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
              ),
            );
          },
        );
      },
    );
  }

  // ===============================
  // 🔹 Dropdown genérico
  // ===============================
  // ✅ Versión mejorada que evita el error de valores duplicados o inexistentes
  Widget _buildFilterItem({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
    double? width,
  }) {
    // 🔹 Limpia los valores duplicados y nulos
    final cleanItems = items.where((e) => e.trim().isNotEmpty).toSet().toList();

    // 🔹 Verifica si el valor actual existe dentro de los items
    final safeValue = cleanItems.contains(value) ? value : cleanItems.first;

   return SizedBox(
  width: width ?? 300,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 🔹 Etiqueta con ícono y título
      Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color(0xFF00324D),
              size: 18,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF00324D),
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),

      // 🔹 Contenedor del dropdown con diseño adaptable
      Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
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
            value: safeValue, // ✅ Valor seguro y sin null
            isExpanded: true,
            dropdownColor: Colors.white,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF00324D),
              size: 22,
            ),
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
            ),
            items: cleanItems.map((e) {
              return DropdownMenuItem<String>(
                value: e,
                child: Text(
                  e,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
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
}
