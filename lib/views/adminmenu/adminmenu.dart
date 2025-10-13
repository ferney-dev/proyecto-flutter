// Corregido "cuidad" a "ciudad"
import 'package:app_bienestarmisena_v1/views/RequirementCategory/requisitosCategoria.dart';
import 'package:app_bienestarmisena_v1/views/RequisitosCheck/RequirementChecks.dart';
import 'package:app_bienestarmisena_v1/views/adicionalInteresConvocatoria/interesConvocatoria.dart';
import 'package:app_bienestarmisena_v1/views/ciudad/cuidad.dart';
import 'package:app_bienestarmisena_v1/views/convocatorias/convocatorias.dart';
import 'package:app_bienestarmisena_v1/views/departamento/departamento.dart';
import 'package:app_bienestarmisena_v1/views/empresa/empresa.dart';
import 'package:app_bienestarmisena_v1/views/entidadInstitucion/entidadInstitucion.dart';
import 'package:app_bienestarmisena_v1/views/favoritosCrud/favoritos.dart';
import 'package:app_bienestarmisena_v1/views/grupoRequisitos/grupoRequisitos.dart';
import 'package:app_bienestarmisena_v1/views/interes/interes.dart';
import 'package:app_bienestarmisena_v1/views/linea/linea.dart';
import 'package:app_bienestarmisena_v1/views/publicoObjetivo/publicoObjetivo.dart';
import 'package:app_bienestarmisena_v1/views/requisitosE/requisitos.dart';
import 'package:app_bienestarmisena_v1/views/rol/rol.dart';
import 'package:app_bienestarmisena_v1/views/userInterests/userInterests.dart';
import 'package:app_bienestarmisena_v1/views/usuarios/usuarios.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/controllers/reactController.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final Reactcontroller reactController = Get.find<Reactcontroller>();
  bool modoOscuro = false;
  String searchTerm = '';

// 🔹 Lista de módulos mejorada con íconos, colores y descripciones únicas
final List<Map<String, dynamic>> modulos = [
  {
    "nombre": "Línea Aplicable",
    "descripcion":
        "Define las líneas estratégicas o temáticas que orientan las convocatorias.",
    "icon": Icons.route_rounded,
    "color": Colors.indigoAccent,
    "total": 12
  },
  {
    "nombre": "Público Objetivo",
    "descripcion":
        "Identifica los sectores o perfiles a los que se dirigen las convocatorias.",
    "icon": Icons.people_alt_rounded,
    "color": Colors.deepPurpleAccent,
    "total": 8
  },
  {
    "nombre": "Entidad / Institución",
    "descripcion":
        "Organismos públicos o privados que gestionan y financian convocatorias.",
    "icon": Icons.account_balance_rounded,
    "color": Colors.amberAccent,
    "total": 6
  },
  {
    "nombre": "Convocatorias",
    "descripcion":
        "Gestiona la información de todas las convocatorias activas y archivadas.",
    "icon": Icons.announcement_rounded,
    "color": Colors.pinkAccent,
    "total": 24
  },
  {
    "nombre": "Usuarios",
    "descripcion":
        "Administra los usuarios registrados, roles asignados y estado de sus cuentas.",
    "icon": Icons.person_4_rounded,
    "color": Colors.cyanAccent,
    "total": 41
  },
  {
    "nombre": "Intereses",
    "descripcion":
        "Temas o áreas preferidas por los usuarios para personalizar su experiencia.",
    "icon": Icons.favorite_rounded,
    "color": Colors.lightGreen,
    "total": 13
  },
  {
    "nombre": "Roles",
    "descripcion":
        "Define los niveles de acceso y permisos dentro del sistema.",
    "icon": Icons.admin_panel_settings_rounded,
    "color": Colors.orangeAccent,
    "total": 5
  },
  {
    "nombre": "Usuario - Interés",
    "descripcion":
        "Relaciona los usuarios con sus intereses para mejorar la segmentación.",
    "icon": Icons.merge_type_rounded,
    "color": Colors.deepOrangeAccent,
    "total": 18
  },
  {
    "nombre": "Empresa",
    "descripcion":
        "Información de empresas participantes o vinculadas a las convocatorias.",
    "icon": Icons.business_center_rounded,
    "color": Colors.teal,
    "total": 9
  },
  {
    "nombre": "Departamento",
    "descripcion":
        "Divisiones territoriales administrativas donde se ubican las entidades.",
    "icon": Icons.map_rounded,
    "color": const Color.fromARGB(255, 64, 124, 255),
    "total": 18
  },
  {
    "nombre": "Ciudad",
    "descripcion":
        "Gestión de ciudades y municipios participantes en el sistema.",
    "icon": Icons.location_city_rounded,
    "color": const Color.fromARGB(255, 0, 150, 2),
    "total": 9
  },
  {
    "nombre": "Grupo de Requisitos",
    "descripcion":
        "Agrupaciones de requisitos que deben cumplir los postulantes a una convocatoria.",
    "icon": Icons.folder_special_rounded,
    "color": Colors.deepPurple,
    "total": 9
  },
  {
    "nombre": "Checkear Requisitos",
    "descripcion":
        "Valida el cumplimiento de requisitos por parte de los postulantes.",
    "icon": Icons.fact_check_rounded,
    "color": Colors.blueAccent,
    "total": 9
  },
  {
    "nombre": "Requisitos Categoría",
    "descripcion":
        "Clasifica los diferentes tipos de requisitos por categoría y tipo.",
    "icon": Icons.category_rounded,
    "color": Colors.deepOrange,
    "total": 9
  },
  {
    "nombre": "Interés Adicional Convocatorias",
    "descripcion":
        "Asocia convocatorias con intereses adicionales para una mejor recomendación.",
    "icon": Icons.extension_rounded,
    "color": Colors.greenAccent,
    "total": 9
  },
  {
    "nombre": "Requisitos",
    "descripcion":
        "Lista y administra todos los documentos y condiciones requeridas.",
    "icon": Icons.description_rounded,
    "color": Colors.blueGrey,
    "total": 9
  },
  {
    "nombre": "Favoritos",
    "descripcion":
        "Muestra las convocatorias guardadas por los usuarios como favoritas.",
    "icon": Icons.star_rounded,
    "color": Colors.amber,
    "total": 9
  },
];


  // 🔹 Mapeo de módulos a vistas para simplificar el código
  final Map<String, Widget> _vistasModulos = {
    "Línea Aplicable": const ViewLinea(),
    "Usuarios": const ViewUsuario(),
    "Intereses": const ViewInteres(),
    "Roles": const ViewRoles(),
    "Usuario - Interés": const ViewUserInterests(),
    "Público Objetivo": const ViewPublico(),
    "Entidad / Institución": const ViewInstitution(),
    "Empresa": const ViewEmpresa(),
    "Convocatorias": const ViewConvocatorias(),
    "Departamento": const ViewDepartments(),
    "Ciudad": const ViewCities(),
    "Grupo-Requisitos": const ViewRequirementGroups(),
    "checkear Requisitos": const ViewRequirementChecks(),
    "Requisitos Categoria": const ViewRequirementCategories(),
    "Interes Adicional Convocatorias": const ViewCallAdditionalInterests(),
     "Requisitos": const ViewRequirements(),
    "Favoritos": const ViewFavoritos(),

    // Actualizado para coincidir con el nombre corregido
  };

  // 🔹 Mostrar el modal correspondiente simplificado
  void _mostrarModal(BuildContext context, String nombre) {
    final vista = _vistasModulos[nombre];
    if (vista != null) {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: vista,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final modulosFiltrados = modulos
        .where(
            (m) => m["nombre"].toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();

    final fondo =
        modoOscuro ? const Color(0xFF101418) : const Color(0xFFF8FAFB);
    final texto = modoOscuro ? Colors.white : Colors.black87;
    final subtitulo = modoOscuro ? Colors.white60 : Colors.black54;
    final tarjeta = modoOscuro ? const Color(0xFF1E2329) : Colors.white;

    return Scaffold(
      backgroundColor: fondo,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: modoOscuro ? const Color(0xFF1E2329) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F7EB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(Icons.settings_applications_rounded,
                        color: Color(0xFF39A900), size: 30),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Panel de Administración",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: texto),
                  ),
                ],
              ),
              Row(
                children: [
                  // 🔹 Barra de búsqueda añadida
                  Container(
                    width: 250,
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: modoOscuro
                          ? const Color(0xFF2A2F35)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      onChanged: (value) => setState(() => searchTerm = value),
                      decoration: InputDecoration(
                        hintText: "Buscar módulo...",
                        hintStyle: TextStyle(color: subtitulo),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: subtitulo),
                        contentPadding: const EdgeInsets.only(bottom: 10),
                      ),
                      style: TextStyle(color: texto),
                    ),
                  ),
                  const SizedBox(width: 15),
                  _buildIconButton(
                    modoOscuro
                        ? Icons.wb_sunny_rounded
                        : Icons.nightlight_round,
                    color: modoOscuro ? Colors.amberAccent : Colors.blueGrey,
                    onTap: () => setState(() => modoOscuro = !modoOscuro),
                  ),
                  const SizedBox(width: 10),
                  _buildIconButton(Icons.logout_rounded,
                      color: Colors.redAccent, onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Sesión cerrada")));
                    Navigator.pop(context);
                  }),
                ],
              ),
            ],
          ),
        ),
      ),

      // 🔹 CUERPO PRINCIPAL
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔸 MÉTRICAS SUPERIORES (4 pequeñas)
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.6,
              children: [
                _metricCard(
                    "Total Registros",
                    "86",
                    "+12%",
                    Icons.storage_rounded,
                    Colors.blueAccent,
                    tarjeta,
                    texto,
                    subtitulo),
                _metricCard(
                    "Convocatorias",
                    "26",
                    "+5%",
                    Icons.campaign_rounded,
                    Colors.pinkAccent,
                    tarjeta,
                    texto,
                    subtitulo),
                _metricCard("Usuarios", "41", "+8%", Icons.people_alt_rounded,
                    Colors.green, tarjeta, texto, subtitulo),
                _metricCard(
                    "Empresas",
                    "9",
                    "+2%",
                    Icons.business_center_rounded,
                    Colors.teal,
                    tarjeta,
                    texto,
                    subtitulo),
              ],
            ),
            const SizedBox(height: 40),

            // 🔸 Título de módulos
            Text("Módulos del Sistema",
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: texto)),
            const SizedBox(height: 6),
            Text("Gestiona todos los componentes de la plataforma",
                style: TextStyle(color: subtitulo)),
            const SizedBox(height: 25),

            // 🔸 TARJETAS DE MÓDULOS
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: modulosFiltrados.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final modulo = modulosFiltrados[index];
                return GestureDetector(
                  onTap: () => _mostrarModal(context, modulo["nombre"]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: tarjeta,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            color: modulo["color"].withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(modulo["icon"],
                              color: modulo["color"], size: 26),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          modulo["nombre"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: texto),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          modulo["descripcion"],
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12, color: subtitulo, height: 1.3),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: modulo["color"].withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${modulo["total"]} registros",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: modulo["color"]),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Tarjeta de Métrica superior
  Widget _metricCard(String title, String value, String change, IconData icon,
      Color color, Color tarjeta, Color texto, Color subtitulo) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tarjeta,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black12.withOpacity(0.08),
              blurRadius: 5,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  style: TextStyle(
                      color: subtitulo,
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
              Text(value,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: texto)),
              Text(change,
                  style: const TextStyle(fontSize: 11, color: Colors.green)),
            ],
          )
        ],
      ),
    );
  }

  // 🔹 Botón del AppBar
  Widget _buildIconButton(IconData icon,
      {required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
