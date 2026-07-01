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
import 'package:app_bienestarmisena_v1/components/adminMenu/sidebar.dart';
import 'package:app_bienestarmisena_v1/components/adminMenu/top_bar.dart';
import 'package:app_bienestarmisena_v1/components/adminMenu/stats_grid.dart';
import 'package:app_bienestarmisena_v1/components/adminMenu/module_card.dart';
import 'package:app_bienestarmisena_v1/components/adminMenu/bottom_nav_bar.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final Reactcontroller reactController = Get.find<Reactcontroller>();
  int _selectedIndex = 0;
  String searchTerm = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> modulos = [
    {
      "nombre": "Línea Aplicable",
      "descripcion": "Líneas estratégicas para convocatorias",
      "icon": Icons.route_rounded,
      "color": const Color(0xFF6366F1),
      "total": 12,
      "categoria": "Gestión"
    },
    {
      "nombre": "Público Objetivo",
      "descripcion": "Sectores y perfiles objetivo",
      "icon": Icons.people_alt_rounded,
      "color": const Color(0xFF8B5CF6),
      "total": 8,
      "categoria": "Gestión"
    },
    {
      "nombre": "Entidad / Institución",
      "descripcion": "Organismos gestores",
      "icon": Icons.account_balance_rounded,
      "color": const Color(0xFFF59E0B),
      "total": 6,
      "categoria": "Gestión"
    },
    {
      "nombre": "Convocatorias",
      "descripcion": "Gestión de convocatorias",
      "icon": Icons.announcement_rounded,
      "color": const Color(0xFFEC4899),
      "total": 24,
      "categoria": "Principal"
    },
    {
      "nombre": "Usuarios",
      "descripcion": "Administración de usuarios",
      "icon": Icons.person_4_rounded,
      "color": const Color(0xFF06B6D4),
      "total": 41,
      "categoria": "Principal"
    },
    {
      "nombre": "Intereses",
      "descripcion": "Temas de interés",
      "icon": Icons.favorite_rounded,
      "color": const Color(0xFF10B981),
      "total": 13,
      "categoria": "Gestión"
    },
    {
      "nombre": "Roles",
      "descripcion": "Permisos y accesos",
      "icon": Icons.admin_panel_settings_rounded,
      "color": const Color(0xFFF97316),
      "total": 5,
      "categoria": "Seguridad"
    },
    {
      "nombre": "Usuario - Interés",
      "descripcion": "Relación usuario-interés",
      "icon": Icons.merge_type_rounded,
      "color": const Color(0xFFEF4444),
      "total": 18,
      "categoria": "Gestión"
    },
    {
      "nombre": "Empresa",
      "descripcion": "Empresas vinculadas",
      "icon": Icons.business_center_rounded,
      "color": const Color(0xFF14B8A6),
      "total": 9,
      "categoria": "Gestión"
    },
    {
      "nombre": "Departamento",
      "descripcion": "Divisiones territoriales",
      "icon": Icons.map_rounded,
      "color": const Color(0xFF3B82F6),
      "total": 18,
      "categoria": "Ubicación"
    },
    {
      "nombre": "Ciudad",
      "descripcion": "Ciudades y municipios",
      "icon": Icons.location_city_rounded,
      "color": const Color(0xFF22C55E),
      "total": 9,
      "categoria": "Ubicación"
    },
    {
      "nombre": "Grupo de Requisitos",
      "descripcion": "Agrupación de requisitos",
      "icon": Icons.folder_special_rounded,
      "color": const Color(0xFF7C3AED),
      "total": 9,
      "categoria": "Requisitos"
    },
    {
      "nombre": "Checkear Requisitos",
      "descripcion": "Validación de requisitos",
      "icon": Icons.fact_check_rounded,
      "color": const Color(0xFF0EA5E9),
      "total": 9,
      "categoria": "Requisitos"
    },
    {
      "nombre": "Requisitos Categoría",
      "descripcion": "Categorías de requisitos",
      "icon": Icons.category_rounded,
      "color": const Color(0xFFDC2626),
      "total": 9,
      "categoria": "Requisitos"
    },
    {
      "nombre": "Interés Adicional",
      "descripcion": "Intereses adicionales",
      "icon": Icons.extension_rounded,
      "color": const Color(0xFF84CC16),
      "total": 9,
      "categoria": "Gestión"
    },
    {
      "nombre": "Requisitos",
      "descripcion": "Documentos requeridos",
      "icon": Icons.description_rounded,
      "color": const Color(0xFF64748B),
      "total": 9,
      "categoria": "Requisitos"
    },
    {
      "nombre": "Favoritos",
      "descripcion": "Convocatorias guardadas",
      "icon": Icons.star_rounded,
      "color": const Color(0xFFEAB308),
      "total": 9,
      "categoria": "Principal"
    },
  ];

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
    "Grupo de Requisitos": const ViewRequirementGroups(),
    "Checkear Requisitos": const ViewRequirementChecks(),
    "Requisitos Categoría": const ViewRequirementCategories(),
    "Interés Adicional": const ViewCallAdditionalInterests(),
    "Requisitos": const ViewRequirements(),
    "Favoritos": const ViewFavoritos(),
  };

  void _mostrarModal(BuildContext context, String nombre) {
    final vista = _vistasModulos[nombre];
    if (vista != null) {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: vista,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final modulosFiltrados = modulos
        .where((m) => m["nombre"].toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          if (!isMobile) _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(isMobile),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isMobile ? 16 : 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWelcomeSection(isMobile),
                        const SizedBox(height: 32),
                        _buildStatsGrid(isMobile),
                        const SizedBox(height: 32),
                        _buildModulesSection(isMobile, modulosFiltrados),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isMobile ? _buildBottomNavBar() : null,
    );
  }

  Widget _buildSidebar() {
    return Sidebar(
      selectedIndex: _selectedIndex,
      onItemSelected: (index) => setState(() => _selectedIndex = index),
      onLogout: () => Navigator.pop(context),
    );
  }


  Widget _buildTopBar(bool isMobile) {
    return TopBar(
      isMobile: isMobile,
      searchTerm: searchTerm,
      onSearchChanged: (value) => setState(() => searchTerm = value),
      onMenuPressed: isMobile ? () => _scaffoldKey.currentState?.openDrawer() : null,
    );
  }


  Widget _buildWelcomeSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bienvenido, ${reactController.userName.value}",
          style: TextStyle(
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Gestiona todos los componentes de la plataforma",
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(bool isMobile) {
    return StatsGrid(isMobile: isMobile);
  }

  Widget _buildModulesSection(bool isMobile, List<dynamic> modulosFiltrados) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Módulos del Sistema",
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            if (!isMobile)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${modulosFiltrados.length} módulos",
                  style: TextStyle(
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 2 : 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isMobile ? 1.0 : 1.2,
          ),
          itemCount: modulosFiltrados.length,
          itemBuilder: (context, index) {
            final modulo = modulosFiltrados[index];
            return _buildModuleCard(modulo, isMobile);
          },
        ),
      ],
    );
  }

  Widget _buildModuleCard(dynamic modulo, bool isMobile) {
    return ModuleCard(
      modulo: modulo,
      isMobile: isMobile,
      onTap: () => _mostrarModal(context, modulo["nombre"]),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavBar(
      selectedIndex: _selectedIndex,
      onItemSelected: (index) => setState(() => _selectedIndex = index),
    );
  }

}
