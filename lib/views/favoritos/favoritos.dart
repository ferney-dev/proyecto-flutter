import 'dart:convert';

import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/usuario/user_interest_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/lineas/lineas_controller.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';
import 'package:app_bienestarmisena_v1/models/linea/linea_model.dart';
import 'package:app_bienestarmisena_v1/models/userInterest/userInterest.dart';
import 'package:app_bienestarmisena_v1/views/detalleConvocatori/detalleConvocatoria.dart';
import 'package:app_bienestarmisena_v1/widgets/header.dart';
import 'package:app_bienestarmisena_v1/widgets/accesibilidad_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:app_bienestarmisena_v1/components/favoritos/favoritos_filtros.dart';
import 'package:app_bienestarmisena_v1/components/favoritos/favoritos_tarjeta.dart';
import 'package:app_bienestarmisena_v1/components/favoritos/favoritos_lista.dart';
import 'package:app_bienestarmisena_v1/components/favoritos/favoritos_paginador.dart';

class FavoritosPage extends StatefulWidget {
  final int userId;
  const FavoritosPage({super.key, required this.userId});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  List<Convocatoria> convocatorias = [];
  int paginaActual = 1;
  final int itemsPorPagina = 12;
  bool cargando = true;
  String vista = "Tarjeta"; // ✅ Alternar entre vista Tarjeta / Lista

  final LineasController _lineasController = LineasController();
  final UserInterestsController _interesController = UserInterestsController();
  final FavoritesController _favoritesController =
      Get.put(FavoritesController());

  List<Linea> _lineas = [];
  List<UserInterest> _interesesUsuario = [];

  String categoriaSeleccionada = 'Todas las categorías';
  String interesSeleccionado = 'Sin intereses asociados';

  // 🔹 Filtros
  String categoria = "Todas las categorías";
  String ubicacion = "Todo el país";
  String fecha = "Todas las fechas";
  String ordenarPor = "Más recientes (apertura)";

  final List<String> fechas = [
    "Todas las fechas",
    "Octubre 2025",
    "Noviembre 2025",
    "Diciembre 2025",
  ];

 final List<String> ordenes = [
  "Más recientes (apertura)",
  "Más antiguos (apertura)",
  "Cierre más próximo",
  "Cierre más lejano",
  "Título A–Z",
  "Título Z–A",
];


  @override
  void initState() {
    super.initState();
    _cargarFavoritosUsuario();
    _cargarFiltros(widget.userId); // 👈 nuevo
  }

  Future<void> _eliminarFavorito(Convocatoria conv) async {
    try {
      // 🔹 Paso 1: Buscar el ID del favorito (por usuario + convocatoria)
      final url = Uri.parse(
          "http://localhost:4000/api/v1/favorites/user/${widget.userId}");
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List favoritos = data["data"];

        // Encuentra el favorito correspondiente a la convocatoria
        final fav = favoritos.firstWhere(
          (f) => f["call"]["id"] == conv.id,
          orElse: () => null,
        );

        if (fav != null) {
          final int favId = fav["id"];
          final eliminado = await _favoritesController.removeFavorite(favId);

          if (eliminado) {
            setState(() {
              convocatorias.removeWhere((c) => c.id == conv.id);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("🗑️ Convocatoria eliminada de favoritos"),
                backgroundColor: Colors.redAccent,
                duration: Duration(seconds: 2),
              ),
            );
          }
        } else {
          print(
              "⚠️ No se encontró el favorito correspondiente a esta convocatoria.");
        }
      } else {
        print("⚠️ Error buscando favoritos del usuario (${res.statusCode})");
      }
    } catch (e) {
      print("❌ Error eliminando favorito: $e");
    }
  }

  Future<void> _cargarFiltros(int userId) async {
    try {
      final lineas = await _lineasController.getLineas();
      final intereses = await _interesController.getInteresesByUser(userId);

      setState(() {
        _lineas = lineas;
        _interesesUsuario = intereses;
      });

      print(
          "✅ Filtros cargados: ${_lineas.length} líneas, ${_interesesUsuario.length} intereses");
    } catch (e) {
      print("❌ Error cargando filtros dinámicos: $e");
    }
  }

  // 🔹 Cargar los favoritos desde la API
  Future<void> _cargarFavoritosUsuario() async {
    setState(() => cargando = true);
    try {
      final response =
          await http.get(Uri.parse("http://localhost:4000/api/v1/favorites"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List favoritos = data["data"];

        // 🔸 Filtrar solo los del usuario actual
        final favoritosUsuario = favoritos
            .where((fav) => fav["user"]["id"] == widget.userId)
            .map<Convocatoria>((fav) =>
                Convocatoria.fromJson(fav["call"])) // usa modelo global
            .toList();

        setState(() {
          convocatorias = favoritosUsuario;
          cargando = false;
        });
      } else {
        throw Exception("Error al obtener los favoritos");
      }
    } catch (e) {
      print("❌ Error cargando favoritos: $e");
      setState(() => cargando = false);
    }
  }

  // 🔹 Modal de detalle
  void mostrarModalConvocatoria(Convocatoria c) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ModalConvocatoria(
          convocatoria: c,
          cerrarModal: () => Navigator.of(context).pop(),
        );
      },
    );
  }

 @override
Widget build(BuildContext context) {
  // 🔹 1️⃣ Aplica filtros dinámicos
  final filtradas = convocatorias.where((conv) {
    // Línea seleccionada
    final lineaSeleccionada =
        _lineas.firstWhereOrNull((l) => l.name == categoriaSeleccionada);
    final lineaIdSeleccionada = lineaSeleccionada?.id;

    final matchLinea = categoriaSeleccionada == 'Todas las categorías' ||
        (lineaIdSeleccionada != null && conv.lineId == lineaIdSeleccionada);

    // Interés seleccionado
    final interesSeleccionadoObj = _interesesUsuario
        .firstWhereOrNull((i) => i.interestName == interesSeleccionado);
    final interesIdSeleccionado = interesSeleccionadoObj?.interestId;

    final matchInteres = interesSeleccionado == 'Sin intereses asociados' ||
        (interesIdSeleccionado != null &&
            conv.interestId == interesIdSeleccionado);

    return matchLinea && matchInteres;
  }).toList();

  // 🔹 2️⃣ Aplica ordenamiento según el campo seleccionado
  filtradas.sort((a, b) {
    switch (ordenarPor) {
      case "Más recientes (apertura)":
        return DateTime.parse(b.openDate)
            .compareTo(DateTime.parse(a.openDate));
      case "Más antiguos (apertura)":
        return DateTime.parse(a.openDate)
            .compareTo(DateTime.parse(b.openDate));
      case "Cierre más próximo":
        return DateTime.parse(a.closeDate)
            .compareTo(DateTime.parse(b.closeDate));
      case "Cierre más lejano":
        return DateTime.parse(b.closeDate)
            .compareTo(DateTime.parse(a.closeDate));
      case "Título A–Z":
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      case "Título Z–A":
        return b.title.toLowerCase().compareTo(a.title.toLowerCase());
      default:
        return 0;
    }
  });

  // 🔹 3️⃣ Paginación sobre las filtradas
  final inicio2 = (paginaActual - 1) * itemsPorPagina;
  final fin2 = (inicio2 + itemsPorPagina > filtradas.length)
      ? filtradas.length
      : inicio2 + itemsPorPagina;
  final paginaFiltrada = filtradas.sublist(inicio2, fin2);

  final totalPaginas =
      (convocatorias.length / itemsPorPagina).ceil().clamp(1, 9999);

  // 🔹 Continúa con tu Scaffold...



    return Scaffold(
  backgroundColor: Colors.white,
  body: Column(
    children: [
      const AccesibilidadBar(showScrollButtons: false),
      Expanded(
        child: SafeArea(
          child: cargando
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Center(
              child: Container(
                // 📏 Más ancho (de 97% → 99%)
                width: MediaQuery.of(context).size.width * 0.99,
                constraints: const BoxConstraints(
                  maxWidth: 1550, // 📏 más amplio para pantallas grandes
                  minWidth: 900,
                ),
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),

                // ===========================================
                // 🔹 Contenido principal
                // ===========================================
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Encabezado
                    const Header(selected: "Favoritos"),
                    const SizedBox(height: 25),

                    // ===========================================
                    // 🔸 Contenedor de filtros
                    // ===========================================
                    FavoritosFiltros(
                      lineas: _lineas,
                      interesesUsuario: _interesesUsuario,
                      categoriaSeleccionada: categoriaSeleccionada,
                      interesSeleccionado: interesSeleccionado,
                      ordenarPor: ordenarPor,
                      vista: vista,
                      ordenes: ordenes,
                      onCategoriaChanged: (val) {
                        setState(() => categoriaSeleccionada = val);
                      },
                      onInteresChanged: (val) {
                        setState(() => interesSeleccionado = val);
                      },
                      onOrdenarChanged: (val) {
                        setState(() => ordenarPor = val);
                      },
                      onVistaChanged: (val) {
                        setState(() => vista = val);
                      },
                    ),

                    // ===========================================
                    // 🔹 Contenido de resultados
                    // ===========================================
                    const SizedBox(height: 20),

                    if (convocatorias.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Text(
                            "No tienes convocatorias guardadas ❤️",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    else if (vista == "Tarjeta")
                      FavoritosTarjeta(
                        items: paginaFiltrada,
                        onDetalles: mostrarModalConvocatoria,
                        onEliminar: _eliminarFavorito,
                      )
                    else
                      FavoritosLista(
                        items: paginaFiltrada,
                        onDetalles: mostrarModalConvocatoria,
                        onEliminar: _eliminarFavorito,
                      ),

                    const SizedBox(height: 26),

                    // ===========================================
                    // 🔹 Paginador
                    // ===========================================
                    FavoritosPaginador(
                      currentPage: paginaActual,
                      totalPages: totalPaginas,
                      totalItems: convocatorias.length,
                      onPrevious: () => setState(() => paginaActual--),
                      onNext: () => setState(() => paginaActual++),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  ),
);
}
}
