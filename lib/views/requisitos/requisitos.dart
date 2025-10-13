
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RequisitosPage extends StatefulWidget {
  final int companyId; // 🔹 ID de la empresa logueada
  const RequisitosPage({super.key, required this.companyId});

  @override
  State<RequisitosPage> createState() => _RequisitosPageState();
}

class _RequisitosPageState extends State<RequisitosPage> {
  List categorias = [];
  List grupos = [];
  List requisitos = [];
  List requirementChecks = [];

  int categoriaActiva = 0;
  String busqueda = "";
  bool mostrarFiltros = false;
  String filtroEstado = "Todos";
  Map<int, bool> acordeonesAbiertos = {};
  bool cargando = true;

  // ==========================================================
  // 🔹 Cargar datos del backend
  // ==========================================================
  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

 Future<void> _cargarDatos() async {
  try {
    setState(() => cargando = true);

    print("🚀 Cargando datos para empresa ID: ${widget.companyId}");

    final endpoints = {
      "categorias": "http://localhost:4000/api/v1/requirementCategories",
      "grupos": "http://localhost:4000/api/v1/requirementGroups",
      "requisitos": "http://localhost:4000/api/v1/requirements",
      "checks": "http://localhost:4000/api/v1/requirementChecks",
    };

    final res = await Future.wait(endpoints.values.map((e) => http.get(Uri.parse(e))));

    // ⚙️ Función de parseo flexible para cualquier formato
    dynamic _extraer(dynamic body) {
      try {
        final data = jsonDecode(body);
        if (data is List) return data;
        if (data is Map && data["data"] is List) return data["data"];
        if (data is Map && data["data"] is Map && data["data"]["rows"] is List) {
          return data["data"]["rows"];
        }
        return [];
      } catch (_) {
        return [];
      }
    }

    final categoriasData = _extraer(res[0].body);
    final gruposData = _extraer(res[1].body);
    final requisitosData = _extraer(res[2].body);
    final checksData = _extraer(res[3].body);

    print("📦 Categorías recibidas: ${categoriasData.length}");
    print("📦 Grupos recibidos: ${gruposData.length}");
    print("📦 Requisitos recibidos: ${requisitosData.length}");
    print("📦 Checks recibidos: ${checksData.length}");

    if (categoriasData.isEmpty && gruposData.isEmpty && requisitosData.isEmpty) {
      print("⚠️ Verifica que tu backend devuelva JSON válido o accesible desde Flutter.");
    }

    // Filtrar los checks de esta empresa
    final checksEmpresa = checksData
        .where((c) => c["companyId"] == widget.companyId)
        .toList();

    final completados = <int, bool>{};
    for (var c in checksEmpresa) {
      completados[c["requirementId"]] = true;
    }

    final requisitosMarcados = requisitosData.map((r) {
      final completo = completados[r["id"]] ?? false;
      return {...r, "completo": completo};
    }).toList();

    setState(() {
      categorias = categoriasData;
      grupos = gruposData;
      requisitos = requisitosMarcados;
      requirementChecks = checksEmpresa;
      categoriaActiva = categorias.isNotEmpty ? categorias.first["id"] : 0;
      cargando = false;
    });

    print("✅ Datos cargados correctamente en el estado.");
  } catch (e) {
    print("❌ Error crítico al cargar datos: $e");
    setState(() => cargando = false);
  }
}


  // ==========================================================
  // 🔹 Guardar cambios en los requirementChecks
  // ==========================================================
  Future<void> _guardarCambios() async {
    try {
      final seleccionados = requisitos
          .where((r) => r["completo"] == true)
          .map((r) => {
                "requirementId": r["id"],
                "companyId": widget.companyId,
              })
          .toList();

      print("💾 Guardando ${seleccionados.length} requisitos seleccionados...");

      final res = await http.post(
        Uri.parse("http://localhost:4000/api/v1/requirementChecks"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"checks": seleccionados}),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Requisitos guardados correctamente"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print("⚠️ Error al guardar: ${res.statusCode} ${res.body}");
        throw Exception("Error al guardar los checks: ${res.body}");
      }
    } catch (e) {
      print("❌ Error al guardar checks: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Error al guardar los requisitos"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ==========================================================
  // 🔹 Filtrar por categoría / búsqueda / estado
  // ==========================================================
  List filtrarRequisitosPorCategoria(int categoriaId) {
    final gruposCategoria =
        grupos.where((g) => g["categoryId"] == categoriaId).toList();
    final idsGrupos = gruposCategoria.map((g) => g["id"]).toList();

    var filtrados = requisitos
        .where((r) => idsGrupos.contains(r["groupId"]))
        .where((r) =>
            r["name"].toString().toLowerCase().contains(busqueda.toLowerCase()))
        .toList();

    if (filtroEstado == "Completados") {
      filtrados = filtrados.where((r) => r["completo"]).toList();
    } else if (filtroEstado == "Pendientes") {
      filtrados = filtrados.where((r) => !r["completo"]).toList();
    }

    return filtrados;
  }

  // ==========================================================
  // 🔹 INTERFAZ GRÁFICA
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final requisitosCategoria = filtrarRequisitosPorCategoria(categoriaActiva);
    final total = requisitosCategoria.length;
    final completados = requisitosCategoria.where((r) => r["completo"]).length;
    final progreso = total > 0 ? ((completados / total) * 100).round() : 0;

    final ancho = MediaQuery.of(context).size.width;
    final maxAncho = ancho > 1100 ? 1100.0 : ancho * 0.95;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxAncho),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ============================
                // 🔹 ENCABEZADO AZUL
                // ============================
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00324D), Color(0xFF005B8C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(FontAwesomeIcons.fileAlt,
                              color: Colors.white, size: 28),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Gestión de Requisitos",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              Text(
                                "Cada usuario o empresa puede marcar sus propios requisitos",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(
                                  value: total > 0 ? completados / total : 0,
                                  strokeWidth: 6,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                  backgroundColor: Colors.white24,
                                ),
                              ),
                              Text(
                                "$progreso%",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          const Text("Completado",
                              style:
                                  TextStyle(color: Colors.white70, fontSize: 12))
                        ],
                      )
                    ],
                  ),
                ),

                // ============================
                // 🔹 TABS CATEGORÍAS
                // ============================
                if (categorias.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "⚠️ No hay categorías registradas.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  Container(
                    color: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Row(
                      children: categorias.map((cat) {
                        final isActive = cat["id"] == categoriaActiva;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() {
                              categoriaActiva = cat["id"];
                            }),
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFF00324D)
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(cat["name"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isActive
                                          ? Colors.white
                                          : Colors.black87,
                                    )),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                // ============================
                // 🔹 CONTENEDOR PRINCIPAL
                // ============================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  child: Column(
                    children: [
                      // 🔹 BUSCADOR + FILTROS
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search,
                                    color: Colors.grey),
                                hintText: "Buscar requisitos...",
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                              onChanged: (val) =>
                                  setState(() => busqueda = val),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () =>
                                setState(() => mostrarFiltros = !mostrarFiltros),
                            icon: const Icon(Icons.filter_list,
                                size: 18, color: Colors.white),
                            label: const Text("Filtros",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00324D),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 16),

                      if (mostrarFiltros)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _botonFiltro("Todos"),
                            const SizedBox(width: 8),
                            _botonFiltro("Completados"),
                            const SizedBox(width: 8),
                            _botonFiltro("Pendientes"),
                          ],
                        ),

                      const SizedBox(height: 16),

                      // 🔹 ACORDEONES DE REQUISITOS
                      if (grupos.isEmpty)
                        const Text("No hay grupos ni requisitos disponibles.",
                            style: TextStyle(color: Colors.grey))
                      else
                        ...grupos
                            .where((g) => g["categoryId"] == categoriaActiva)
                            .map((grupo) {
                          final items = requisitosCategoria
                              .where((r) => r["groupId"] == grupo["id"])
                              .toList();
                          final abierto =
                              acordeonesAbiertos[grupo["id"]] ?? false;

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(grupo["name"],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF00324D))),
                                  trailing: Icon(
                                    abierto
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: Colors.black54,
                                  ),
                                  onTap: () => setState(() =>
                                      acordeonesAbiertos[grupo["id"]] =
                                          !abierto),
                                ),
                                if (abierto)
                                  Column(
                                    children: items.map((item) {
                                      return ListTile(
                                        leading: Checkbox(
                                          value: item["completo"],
                                          onChanged: (val) => setState(() {
                                            item["completo"] = val ?? false;
                                          }),
                                        ),
                                        title: Text(
                                          item["name"],
                                          style: TextStyle(
                                            decoration: item["completo"]
                                                ? TextDecoration.lineThrough
                                                : null,
                                            color: item["completo"]
                                                ? Colors.grey
                                                : Colors.black,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )
                              ],
                            ),
                          );
                        }).toList(),

                      const SizedBox(height: 30),

                      // 🔹 BOTONES FINALES
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white),
                            label: const Text("Cancelar",
                                style: TextStyle(color: Colors.white)),
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 92, 77, 77),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: _guardarCambios,
                            icon: const Icon(Icons.check, color: Colors.white),
                            label: const Text("Guardar Cambios",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00324D),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // 🔹 Botón de filtro
  // ==========================================================
  Widget _botonFiltro(String texto) {
    final activo = filtroEstado == texto;
    return ElevatedButton.icon(
      onPressed: () => setState(() => filtroEstado = texto),
      icon: Icon(
        texto == "Completados"
            ? Icons.check_circle
            : texto == "Pendientes"
                ? Icons.hourglass_bottom
                : Icons.filter_alt,
        size: 18,
        color: Colors.white,
      ),
      label: Text(texto, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: activo
            ? const Color.fromARGB(255, 175, 181, 172)
            : const Color(0xFF00324D),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
