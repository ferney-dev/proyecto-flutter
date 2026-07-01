import 'package:app_bienestarmisena_v1/controllers/usuario/user_interest_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/lineas/lineas_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/publico/publico_controller.dart';
import 'package:app_bienestarmisena_v1/models/userInterest/userInterest.dart';
import 'package:app_bienestarmisena_v1/models/linea/linea_model.dart';
import 'package:app_bienestarmisena_v1/models/publicoObejtivoModel/publicoObjetivo.dart';
import 'package:app_bienestarmisena_v1/views/detalleConvocatori/detalleConvocatoria.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:app_bienestarmisena_v1/controllers/reactController.dart';
import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/convocatorias/convocatorias_controller.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';
import 'package:app_bienestarmisena_v1/widgets/header.dart';
import 'package:app_bienestarmisena_v1/widgets/accesibilidad_bar.dart';
import 'package:app_bienestarmisena_v1/components/explorar/explorar_filtros.dart';
import 'package:app_bienestarmisena_v1/components/explorar/explorar_paginador.dart';
import 'package:app_bienestarmisena_v1/components/explorar/vista_tarjeta.dart';
import 'package:app_bienestarmisena_v1/components/explorar/vista_lista.dart';
import 'package:app_bienestarmisena_v1/components/explorar/vista_tabla.dart';
import 'package:app_bienestarmisena_v1/components/explorar/vista_mosaico.dart';

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
  void mostrarModalConvocatoria(Convocatoria c) {
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          const AccesibilidadBar(showScrollButtons: false),
          Expanded(
            child: SafeArea(
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
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.grey.shade300, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
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
                            ExplorarFiltros(
                              lineas: _lineas,
                              interesesUsuario: _interesesUsuario,
                              publicos: _publicos,
                              categoriaSeleccionada: categoriaSeleccionada,
                              interesSeleccionado: interesSeleccionado,
                              publicoSeleccionado: publicoSeleccionado,
                              fechaSeleccionada: fechaSeleccionada,
                              visualizacionSeleccionada: visualizacionSeleccionada,
                              visualizaciones: visualizaciones,
                              onCategoriaChanged: (val) {
                                setState(() {
                                  categoriaSeleccionada = val;
                                  _currentPage = 1;
                                });
                              },
                              onInteresChanged: (val) {
                                setState(() {
                                  interesSeleccionado = val;
                                  _currentPage = 1;
                                });
                              },
                              onPublicoChanged: (val) {
                                setState(() {
                                  publicoSeleccionado = val;
                                  _currentPage = 1;
                                });
                              },
                              onFechaChanged: (val) {
                                setState(() {
                                  fechaSeleccionada = val;
                                  _currentPage = 1;
                                });
                              },
                              onVisualizacionChanged: (val) {
                                setState(() {
                                  visualizacionSeleccionada = val;
                                });
                              },
                              loading: _loadingFiltros,
                            ),

                            const SizedBox(height: 30),

                            // ==================================================
                            // 🔹 Vista seleccionada (Tarjeta / Lista / Tabla / Mosaico)
                            // ==================================================
                            if (visualizacionSeleccionada == 'Tarjeta')
                              VistaTarjeta(
                                items: pageItems,
                                onDetalles: mostrarModalConvocatoria,
                              ),
                            if (visualizacionSeleccionada == 'Lista')
                              VistaLista(
                                items: pageItems,
                                onDetalles: mostrarModalConvocatoria,
                              ),
                            if (visualizacionSeleccionada == 'Tabla')
                              VistaTabla(
                                items: pageItems,
                                onDetalles: mostrarModalConvocatoria,
                              ),
                            if (visualizacionSeleccionada == 'Mosaico')
                              VistaMosaico(
                                items: pageItems,
                                onDetalles: mostrarModalConvocatoria,
                              ),

                            const SizedBox(height: 20),

                            // ==================================================
                            // 🔹 Paginador
                            // ==================================================
                            ExplorarPaginador(
                              currentPage: _currentPage,
                              totalItems: totalItems,
                              itemsPerPage: _itemsPerPage,
                              onNextPage: () => _nextPage(totalItems),
                              onPrevPage: _prevPage,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

}
