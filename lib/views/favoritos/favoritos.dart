import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/userInterest.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:get/get.dart';
// 🧩 Widgets y controladores
import 'package:app_bienestarmisena_v1/widgets/header.dart';
import 'package:app_bienestarmisena_v1/views/detalleConvocatori/detalleConvocatoria.dart';
import 'package:app_bienestarmisena_v1/controllers/lineas_controller.dart';

import 'package:app_bienestarmisena_v1/models/linea/linea_model.dart';
import 'package:app_bienestarmisena_v1/models/userInterest/userInterest.dart';

// 🧩 Modelos
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';

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

 @override
Widget build(BuildContext context) {
  final inicio = (paginaActual - 1) * itemsPorPagina;
  final fin = (inicio + itemsPorPagina > convocatorias.length)
      ? convocatorias.length
      : inicio + itemsPorPagina;

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
  body: SafeArea(
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
                      color: Colors.black.withOpacity(0.06),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 22),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: Colors.grey.shade300, width: 1.4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 18,
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // 🔸 Línea
                          _buildFilterField(
                            icon: Icons.category_outlined,
                            label: "Línea",
                            value: categoriaSeleccionada,
                            items: [
                              'Todas las categorías',
                              ..._lineas.map((l) => l.name).toList(),
                            ],
                            onChanged: (v) {
                              setState(() => categoriaSeleccionada = v!);
                            },
                            width: 420, // 📏 Más anchos
                          ),

                          // 🔸 Interés Usuario
                          _buildFilterField(
                            icon: Icons.interests_outlined,
                            label: "Interés Usuario",
                            value: interesSeleccionado,
                            items: _interesesUsuario.isNotEmpty
                                ? [
                                    'Sin intereses asociados',
                                    ..._interesesUsuario
                                        .map((i) => i.interestName)
                                        .toList(),
                                  ]
                                : ['Sin intereses asociados'],
                            onChanged: (v) {
                              setState(() => interesSeleccionado = v!);
                            },
                            width: 420,
                          ),

                          // 🔸 Ordenar por
                          _buildFilterField(
                            icon: Icons.sort_rounded,
                            label: "Ordenar por",
                            value: ordenarPor,
                            items: ordenes,
                            onChanged: (v) =>
                                setState(() => ordenarPor = v!),
                            width: 420,
                          ),

                          // 🔸 Vista (Tarjeta / Lista)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1.2),
                            ),
                            child: ToggleButtons(
                              borderRadius: BorderRadius.circular(30),
                              selectedColor: Colors.white,
                              fillColor: const Color(0xFF00A884),
                              color: Colors.grey.shade600,
                              constraints: const BoxConstraints(
                                  minWidth: 58, minHeight: 46),
                              isSelected: [
                                vista == "Tarjeta",
                                vista == "Lista"
                              ],
                              onPressed: (index) {
                                setState(() {
                                  vista = index == 0 ? "Tarjeta" : "Lista";
                                });
                              },
                              children: const [
                                Icon(Icons.grid_view_rounded, size: 24),
                                Icon(Icons.view_list_rounded, size: 24),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                    else if (vista == "Tarjeta") ...[
                      // 🔸 Vista tipo Tarjeta (grid)
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: paginaFiltrada.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.88, // 📏 más equilibrado
                          crossAxisSpacing: 22,
                          mainAxisSpacing: 22,
                        ),
                        itemBuilder: (context, index) {
                          final conv = paginaFiltrada[index];
                          return _buildCard(context, conv);
                        },
                      ),
                    ] else ...[
                      // 🔸 Vista tipo Lista (cards horizontales)
                      Column(
                        children: paginaFiltrada
                            .map((conv) => _buildListCard(context, conv))
                            .toList(),
                      ),
                    ],

                    const SizedBox(height: 26),

                    // ===========================================
                    // 🔹 Paginador
                    // ===========================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: paginaActual > 1
                              ? () => setState(() => paginaActual--)
                              : null,
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        ),
                        Text(
                          "Página $paginaActual de $totalPaginas (${convocatorias.length} favoritos)",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          onPressed: paginaActual < totalPaginas
                              ? () => setState(() => paginaActual++)
                              : null,
                          icon: const Icon(Icons.arrow_forward_ios_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
  ),
);

  }

// ===============================
// 🔹 Campo de filtro reutilizable
// ===============================
Widget _buildFilterField({
  required IconData icon,
  required String label,
  required String value,
  required List<String> items,
  required Function(String?) onChanged,
  double width = 250, // ✅ parámetro opcional con valor por defecto
}) {
  return SizedBox(
    width: width, // 📏 ahora funciona correctamente
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Etiqueta superior con ícono
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

        // 🔹 Dropdown estilizado
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1.3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
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


  // ✅ Tarjeta estilo moderno (similar al diseño React)
  Widget _buildCard(BuildContext context, Convocatoria conv) {
    bool isExpanded = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🖼 Imagen superior con efecto hover
                    GestureDetector(
                      onTap: () => mostrarModalConvocatoria(context, conv),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          height: 220,
                          width: double.infinity,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            image: DecorationImage(
                              image: NetworkImage(
                                (conv.imageUrl != null &&
                                        conv.imageUrl!.isNotEmpty)
                                    ? conv.imageUrl!
                                    : "https://via.placeholder.com/400x200",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 📄 Contenido textual
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 Título
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.campaign,
                                  color: Color(0xFF00324D), size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  conv.title,
                                  style: const TextStyle(
                                    color: Color(0xFF00324D),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          // 🔹 Descripción expandible
                          GestureDetector(
                            onTap: () =>
                                setState(() => isExpanded = !isExpanded),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.description_outlined,
                                    color: Color(0xFF00324D), size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    conv.description.isNotEmpty
                                        ? conv.description
                                        : "Sin descripción disponible.",
                                    maxLines: isExpanded ? null : 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // 🔹 Fechas apertura y cierre
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
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
                                        size: 16, color: Color(0xFF00324D)),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Apertura: ${conv.openDate.split('T')[0]}",
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month,
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

                          const SizedBox(height: 12),

                          // 🔹 Botones inferiores
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      mostrarModalConvocatoria(context, conv),
                                  icon: const Icon(Icons.insert_drive_file,
                                      size: 18),
                                  label: const Text("Detalles"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00324D),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon:
                                      const Icon(Icons.check_circle, size: 18),
                                  label: const Text("Inscribirse"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF39A900),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // 🔹 Botón eliminar favorito (arriba a la derecha)
                // 🔹 Botón eliminar favorito (arriba a la derecha)
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => _eliminarFavorito(conv), // ✅ AQUÍ
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.red,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ✅ Vista tipo lista con diseño moderno (basado en el diseño React)
  Widget _buildListCard(BuildContext context, Convocatoria conv) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🖼 Imagen izquierda con efecto hover (en web)
                Expanded(
                  flex: 2,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => mostrarModalConvocatoria(context, conv),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              (conv.imageUrl != null &&
                                      conv.imageUrl!.isNotEmpty)
                                  ? conv.imageUrl!
                                  : "https://via.placeholder.com/400x200",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 📄 Contenido derecho
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 Título con ícono
                        Row(
                          children: [
                            const Icon(Icons.campaign,
                                color: Color(0xFF00324D), size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                conv.title,
                                style: const TextStyle(
                                  color: Color(0xFF00324D),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        Divider(color: Colors.grey.shade300, thickness: 1),

                        // 🔹 Descripción
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.school_outlined,
                                color: Color(0xFF00324D), size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                conv.description.isNotEmpty
                                    ? (conv.description.length > 200
                                        ? "${conv.description.substring(0, 200)}..."
                                        : conv.description)
                                    : "Sin descripción disponible.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // 🔹 Fechas apertura / cierre
                        Wrap(
                          spacing: 20,
                          runSpacing: 8,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 16, color: Color(0xFF00324D)),
                                const SizedBox(width: 6),
                                Text(
                                  "Apertura: ${conv.openDate.split('T')[0]}",
                                  style: const TextStyle(fontSize: 13.5),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.calendar_month,
                                    size: 16, color: Colors.redAccent),
                                const SizedBox(width: 6),
                                Text(
                                  "Cierre: ${conv.closeDate.split('T')[0]}",
                                  style: const TextStyle(fontSize: 13.5),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),
                        Divider(color: Colors.grey.shade300, thickness: 1),

                        // 🔹 Botones
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () =>
                                  mostrarModalConvocatoria(context, conv),
                              icon:
                                  const Icon(Icons.insert_drive_file, size: 18),
                              label: const Text("Detalles"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00324D),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.check_circle, size: 18),
                              label: const Text("Inscribirse"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF39A900),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 🔹 Botón eliminar favorito
            // 🔹 Botón eliminar favorito
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => _eliminarFavorito(conv), // ✅ Acción real
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Modal de detalle
  void mostrarModalConvocatoria(BuildContext context, Convocatoria c) {
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
}
