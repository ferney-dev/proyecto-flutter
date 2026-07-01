import 'package:app_bienestarmisena_v1/controllers/ciudad/ciudad_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/empresa/empresa_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/interes/interes_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/usuario/user_interest_controller.dart'
    hide InteresController;
import 'package:app_bienestarmisena_v1/models/empresaModel/empresa_model.dart'
    hide City;
import 'package:app_bienestarmisena_v1/views/requisitos/requisitos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_bienestarmisena_v1/controllers/reactController.dart';
import 'package:app_bienestarmisena_v1/models/interes/interes_model.dart';
import 'package:app_bienestarmisena_v1/models/userInterest/userInterest.dart';
import 'package:app_bienestarmisena_v1/views/login/login.dart';
import 'package:app_bienestarmisena_v1/models/cuidad/cuidad.dart';
import 'package:app_bienestarmisena_v1/widgets/accesibilidad_bar.dart';

class PerfilUsuarioPage extends StatefulWidget {
  const PerfilUsuarioPage({super.key});

  @override
  State<PerfilUsuarioPage> createState() => _PerfilUsuarioPageState();
}

class _PerfilUsuarioPageState extends State<PerfilUsuarioPage> {
  final Reactcontroller reactController = Get.find<Reactcontroller>();
  final InteresController interesController = InteresController();
  final userInterestsController = UserInterestsController();

  List<Interes> interesesDisponibles = [];
  List<UserInterest> interesesUsuario = [];
  bool cargando = true;

  final EmpresaController empresaController = EmpresaController();
  Empresa? empresaUsuario;

  Future<void> _mostrarFormularioEmpresa(BuildContext context) async {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController addressCtrl = TextEditingController();
    final TextEditingController phoneCtrl = TextEditingController();
    final TextEditingController sectorCtrl = TextEditingController();
    final TextEditingController webCtrl = TextEditingController();
    final TextEditingController descCtrl = TextEditingController();
    final TextEditingController deptCtrl = TextEditingController();

    City? selectedCity;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Registrar Empresa"),
              content: SingleChildScrollView(
                child: FutureBuilder<List<City>>(
                  future: CitiesController().getCities(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text(
                          "No se encontraron ciudades disponibles.");
                    }

                    final cities = snapshot.data!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: nameCtrl,
                          decoration: const InputDecoration(
                              labelText: "Nombre o Razón Social"),
                        ),
                        TextField(
                          controller: addressCtrl,
                          decoration:
                              const InputDecoration(labelText: "Dirección"),
                        ),
                        TextField(
                          controller: phoneCtrl,
                          decoration:
                              const InputDecoration(labelText: "Teléfono"),
                        ),
                        const SizedBox(height: 10),

                        // 🏙️ Seleccionar ciudad
                        DropdownButtonFormField<City>(
                          decoration:
                              const InputDecoration(labelText: "Ciudad"),
                          value: cities.contains(selectedCity)
                              ? selectedCity
                              : null, // ✅ Verificación
                          items: cities.map((city) {
                            return DropdownMenuItem<City>(
                              value: city,
                              child: Text(city.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCity = value;
                              deptCtrl.text = value?.department?.name ?? "";
                            });
                          },
                        ),

                        const SizedBox(height: 10),

                        // 🏛️ Campo de departamento (autocompletado)
                        TextField(
                          controller: deptCtrl,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Departamento (autocompletado)",
                            filled: true,
                            fillColor: Color(0xFFF1F1F1),
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: sectorCtrl,
                          decoration: const InputDecoration(
                              labelText: "Sector Económico"),
                        ),
                        TextField(
                          controller: webCtrl,
                          decoration:
                              const InputDecoration(labelText: "Página Web"),
                        ),
                        TextField(
                          controller: descCtrl,
                          decoration:
                              const InputDecoration(labelText: "Descripción"),
                        ),
                      ],
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedCity == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Selecciona una ciudad antes de continuar."),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    final body = {
                      "name": nameCtrl.text,
                      "address": addressCtrl.text,
                      "phone": phoneCtrl.text,
                      "cityId": selectedCity!.id,
                      "departmentId": selectedCity!.departmentId,
                      "sector": sectorCtrl.text,
                      "website": webCtrl.text,
                      "description": descCtrl.text,
                      "userId": reactController.userId.value,
                    };

                    final ok = await EmpresaController().crearEmpresa(body);
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(ok
                            ? "Empresa registrada con éxito 🎉"
                            : "Error al registrar empresa"),
                        backgroundColor: ok ? Colors.green : Colors.red,
                      ),
                    );

                    await _cargarEmpresaUsuario();
                  },
                  child: const Text("Guardar"),
                ),
              ],
            );
          },
        );
      },
    );

    showDialog(
      context: context,
      builder: (_) {
        City? selectedCity;
        String? selectedDept;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Registrar Empresa"),
              content: SingleChildScrollView(
                child: FutureBuilder<List<City>>(
                  future: CitiesController().getCities(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text(
                          "No se encontraron ciudades disponibles.");
                    }

                    final cities = snapshot.data!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: nameCtrl,
                          decoration: const InputDecoration(
                              labelText: "Nombre o Razón Social"),
                        ),
                        TextField(
                          controller: addressCtrl,
                          decoration:
                              const InputDecoration(labelText: "Dirección"),
                        ),
                        TextField(
                          controller: phoneCtrl,
                          decoration:
                              const InputDecoration(labelText: "Teléfono"),
                        ),
                        const SizedBox(height: 10),

                        // 🏙️ Seleccionar ciudad
                        DropdownButtonFormField<City>(
                          decoration:
                              const InputDecoration(labelText: "Ciudad"),
                          value: selectedCity,
                          items: cities.map((city) {
                            return DropdownMenuItem<City>(
                              value: city,
                              child: Text(city.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCity = value;
                              selectedDept = value?.department?.name ?? "";
                              deptCtrl.text = selectedDept ?? "";
                            });
                          },
                        ),

                        const SizedBox(height: 10),

                        // 🏛️ Departamento autocompletado
                        TextField(
                          controller: deptCtrl,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Departamento (autocompletado)",
                            filled: true,
                            fillColor: Color(0xFFF1F1F1),
                          ),
                        ),

                        TextField(
                          controller: sectorCtrl,
                          decoration: const InputDecoration(
                              labelText: "Sector Económico"),
                        ),
                        TextField(
                          controller: webCtrl,
                          decoration:
                              const InputDecoration(labelText: "Página Web"),
                        ),
                        TextField(
                          controller: descCtrl,
                          decoration:
                              const InputDecoration(labelText: "Descripción"),
                        ),
                      ],
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedCity == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Selecciona una ciudad antes de continuar."),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    final body = {
                      "name": nameCtrl.text,
                      "address": addressCtrl.text,
                      "phone": phoneCtrl.text,
                      "cityId": selectedCity!.id, // ✅ ID real
                      "departmentId": selectedCity!.departmentId, // ✅ ID real
                      "sector": sectorCtrl.text,
                      "website": webCtrl.text,
                      "description": descCtrl.text,
                      "userId": reactController.userId.value,
                    };

                    final ok = await EmpresaController().crearEmpresa(body);
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(ok
                            ? "Empresa registrada con éxito 🎉"
                            : "Error al registrar empresa"),
                        backgroundColor: ok ? Colors.green : Colors.red,
                      ),
                    );

                    await _cargarEmpresaUsuario();
                  },
                  child: const Text("Guardar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _cargarDatos();
    _cargarEmpresaUsuario(); // ✅ Nuevo
  }

  Future<void> _cargarEmpresaUsuario() async {
    try {
      final userEmail = reactController.userEmail.value;

      if (userEmail.isEmpty) {
        print("⚠️ No se encontró el correo del usuario en sesión.");
        return;
      }

      // 🔹 Trae todas las empresas desde el backend
      final empresas = await empresaController.getEmpresas();

      // 🔹 Busca la empresa del usuario por el campo 'email'
      final empresaDelUsuario = empresas.firstWhere(
        (e) =>
            e.email != null &&
            e.email!.toLowerCase() == userEmail.toLowerCase(),
        orElse: () => Empresa(id: null, name: ''),
      );

      if (empresaDelUsuario.id != null) {
        // ✅ Guardamos la empresa encontrada en el estado local
        setState(() => empresaUsuario = empresaDelUsuario);

        // ✅ Guardamos el ID en el Reactcontroller (para usarlo globalmente)
        reactController.setEmpresaId(empresaDelUsuario.id!);

        print("✅ Empresa encontrada: ${empresaUsuario!.name}");
        print(
            "🏢 ID Empresa guardado en Reactcontroller: ${reactController.empresaId.value}");
      } else {
        print("ℹ️ No se encontró empresa asociada al correo $userEmail");
      }
    } catch (e) {
      print("❌ Error al cargar empresa del usuario: $e");
    }
  }

  Future<void> _cargarDatos() async {
    try {
      setState(() => cargando = true);
      final todos = await interesController.getIntereses();
      final userInterests =
          await userInterestsController.obtenerUserInterests();

      final userId = reactController.userId.value;

      final propios = userInterests
          .where((u) => u.userId.toString() == userId.toString())
          .toList();

      setState(() {
        interesesDisponibles = todos;
        interesesUsuario = propios;
      });
    } catch (e) {
      print("❌ Error cargando intereses: $e");
    } finally {
      setState(() => cargando = false);
    }
  }

  Future<void> _agregarInteres() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        final noAsignados = interesesDisponibles
            .where((i) => !interesesUsuario.any((ui) => ui.interestId == i.id))
            .toList();

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Selecciona intereses para agregar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (noAsignados.isEmpty)
                const Text("Ya tienes todos los intereses asignados")
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: noAsignados.length,
                    itemBuilder: (context, index) {
                      final interes = noAsignados[index];
                      return ListTile(
                        leading:
                            const Icon(Icons.star, color: Color(0xFF39A900)),
                        title: Text(interes.name),
                        onTap: () async {
                          if (interesesUsuario.length >= 5) return;
                          await userInterestsController.crearUserInterest({
                            "userId": reactController.userId.value,
                            "interestId": interes.id,
                          });
                          Navigator.pop(context);
                          _cargarDatos();
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _cerrarSesion() {
    reactController.clearUser();
    Get.offAll(() => const Login());
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final isMobile = ancho < 600;
    final maxAncho = ancho > 1200 ? 1200.0 : ancho * 0.95;

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Azul claro de fondo
      body: Column(
        children: [
          // Barra de accesibilidad
          AccesibilidadBar(
            scrollController: null,
            showScrollButtons: false,
          ),
          
          // Contenido principal
          Expanded(
            child: cargando
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxAncho),
                        child: Column(
                          children: [
                            // ====================== ENCABEZADO ======================
                            Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 30 : 40, 
                            horizontal: isMobile ? 16 : 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF64B5F6), // Azul claro
                              const Color(0xFF42A5F5), // Azul medio
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(isMobile ? 30 : 40),
                            bottomRight: Radius.circular(isMobile ? 30 : 40),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Botón de regresar
                            Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            SizedBox(height: isMobile ? 15 : 20),

                            // 🔹 Imagen del usuario
                            Obx(() {
                              final imageUrl = reactController.userImage.value;
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: isMobile ? 45 : 55,
                                  backgroundColor: Colors.white,
                                  backgroundImage: imageUrl.isNotEmpty
                                      ? NetworkImage(imageUrl)
                                      : const AssetImage(
                                              'assets/images/default_user.png')
                                          as ImageProvider,
                                ),
                              );
                            }),

                            SizedBox(height: isMobile ? 12 : 15),

                            // 🔹 Nombre del usuario
                            Obx(() => Text(
                                  reactController.userName.value.isNotEmpty
                                      ? reactController.userName.value
                                      : "Usuario sin nombre",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isMobile ? 20 : 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),

                            SizedBox(height: 8),

                            // 🔹 Correo del usuario
                            Obx(() => Text(
                                  reactController.userEmail.value.isNotEmpty
                                      ? reactController.userEmail.value
                                      : "Correo no registrado",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: isMobile ? 13 : 15,
                                  ),
                                )),

                            SizedBox(height: isMobile ? 15 : 20),

                            // 🔹 Intereses
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: interesesUsuario.isEmpty
                                  ? [
                                      Text(
                                        "No tienes intereses registrados",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: isMobile ? 12 : 14,
                                        ),
                                      )
                                    ]
                                  : interesesUsuario.map((ui) {
                                      final interes =
                                          interesesDisponibles.firstWhere(
                                        (i) => i.id == ui.interestId,
                                        orElse: () => Interes(
                                          id: 0,
                                          name: 'Desconocido',
                                          description: '',
                                        ),
                                      );
                                      return Chip(
                                        label: Text(
                                          interes.name,
                                          style: const TextStyle(
                                              color: Color(0xFF1976D2)),
                                        ),
                                        backgroundColor: Colors.white,
                                        deleteIcon: const Icon(Icons.close,
                                            color: Colors.red, size: 18),
                                        onDeleted: () async {
                                          await userInterestsController
                                              .eliminarUserInterest(
                                                  reactController.userId.value,
                                                  interes.id);
                                          _cargarDatos();
                                        },
                                      );
                                    }).toList(),
                            ),

                            SizedBox(height: isMobile ? 10 : 12),

                            // Botón agregar intereses
                            if (interesesUsuario.length < 5)
                              IconButton(
                                onPressed: _agregarInteres,
                                icon: const Icon(Icons.add_circle_outline,
                                    size: 28, color: Colors.white),
                              ),
                          ],
                        ),
                      ),

                      // ====================== SECCIÓN EMPRESA ======================
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16 : 25,
                          vertical: isMobile ? 20 : 25,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(isMobile ? 20 : 25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Título con icono
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF64B5F6).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      FontAwesomeIcons.building,
                                      color: Color(0xFF1976D2),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    "Información de la Empresa",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1976D2),
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 20),

                              // Mensaje si no hay empresa
                              if (empresaUsuario == null)
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF3E0),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFFFB74D),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.info_outline,
                                        color: Color(0xFFFF9800),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          "Aún no tienes una empresa registrada. Crea una para gestionar requisitos.",
                                          style: TextStyle(
                                            color: Colors.orange.shade800,
                                            fontSize: isMobile ? 13 : 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              if (empresaUsuario == null) const SizedBox(height: 20),

                              // Campos editables responsive
                              if (empresaUsuario != null)
                                _buildEmpresaFields(isMobile),

                              const SizedBox(height: 30),

                              // Botones de acción
                              _buildActionButtons(isMobile),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpresaFields(bool isMobile) {
    if (isMobile) {
      // Diseño en columna para móvil
      return Column(
        children: [
          _campoEditableResponsive(
            icono: FontAwesomeIcons.building,
            etiqueta: "Razón Social",
            valorInicial: empresaUsuario?.name ?? "",
            campo: "name",
            isMobile: isMobile,
          ),
          _campoEditableResponsive(
            icono: FontAwesomeIcons.locationDot,
            etiqueta: "Dirección",
            valorInicial: empresaUsuario?.address ?? "",
            campo: "address",
            isMobile: isMobile,
          ),
          _campoEditableResponsive(
            icono: FontAwesomeIcons.phone,
            etiqueta: "Teléfono",
            valorInicial: empresaUsuario?.phone ?? "",
            campo: "phone",
            isMobile: isMobile,
          ),
          _campoEditableResponsive(
            icono: FontAwesomeIcons.city,
            etiqueta: "Ciudad",
            valorInicial: empresaUsuario?.city?.name ?? "",
            campo: "city",
            isMobile: isMobile,
          ),
          _campoEditableResponsive(
            icono: FontAwesomeIcons.globe,
            etiqueta: "Página Web",
            valorInicial: empresaUsuario?.website ?? "",
            campo: "website",
            isMobile: isMobile,
          ),
          _campoEditableResponsive(
            icono: FontAwesomeIcons.briefcase,
            etiqueta: "Sector Económico",
            valorInicial: empresaUsuario?.economicSector ?? "",
            campo: "economicSector",
            isMobile: isMobile,
          ),
          _campoEditableResponsive(
            icono: FontAwesomeIcons.users,
            etiqueta: "Número Empleados",
            valorInicial: empresaUsuario?.employeeCount?.toString() ?? "",
            campo: "employeeCount",
            isMobile: isMobile,
          ),
          const SizedBox(height: 10),
          const Text(
            "Descripción:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          _campoEditableResponsive(
            icono: FontAwesomeIcons.quoteLeft,
            etiqueta: "",
            valorInicial: empresaUsuario?.description ?? "",
            campo: "description",
            multilinea: true,
            isMobile: isMobile,
          ),
        ],
      );
    } else {
      // Diseño en 3 columnas para desktop
      return LayoutBuilder(
        builder: (context, constraints) {
          final anchoColumna = (constraints.maxWidth - 40) / 3;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ======= COLUMNA 1 =======
              SizedBox(
                width: anchoColumna,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _campoEditable3Col(
                      icono: FontAwesomeIcons.building,
                      etiqueta: "Razón Social",
                      valorInicial: empresaUsuario?.name ?? "",
                      campo: "name",
                    ),
                    _campoEditable3Col(
                      icono: FontAwesomeIcons.locationDot,
                      etiqueta: "Dirección",
                      valorInicial: empresaUsuario?.address ?? "",
                      campo: "address",
                    ),
                    _campoEditable3Col(
                      icono: FontAwesomeIcons.phone,
                      etiqueta: "Teléfono",
                      valorInicial: empresaUsuario?.phone ?? "",
                      campo: "phone",
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),

              // ======= COLUMNA 2 =======
              SizedBox(
                width: anchoColumna,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _campoEditable3Col(
                      icono: FontAwesomeIcons.users,
                      etiqueta: "Número Empleados",
                      valorInicial: empresaUsuario?.employeeCount?.toString() ?? "",
                      campo: "employeeCount",
                    ),
                    _campoEditable3Col(
                      icono: FontAwesomeIcons.city,
                      etiqueta: "Ciudad",
                      valorInicial: empresaUsuario?.city?.name ?? "",
                      campo: "city",
                    ),
                    _campoEditable3Col(
                      icono: FontAwesomeIcons.globe,
                      etiqueta: "Página Web",
                      valorInicial: empresaUsuario?.website ?? "",
                      campo: "website",
                    ),
                    _campoEditable3Col(
                      icono: FontAwesomeIcons.briefcase,
                      etiqueta: "Sector Económico",
                      valorInicial: empresaUsuario?.economicSector ?? "",
                      campo: "economicSector",
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),

              // ======= COLUMNA 3 (DESCRIPCIÓN) =======
              SizedBox(
                width: anchoColumna,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Descripción:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    _campoEditable3Col(
                      icono: FontAwesomeIcons.quoteLeft,
                      etiqueta: "",
                      valorInicial: empresaUsuario?.description ?? "",
                      campo: "description",
                      multilinea: true,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildActionButtons(bool isMobile) {
    if (isMobile) {
      // Botones en columna para móvil
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                final empresaId = reactController.empresaId.value;
                if (empresaId != null && empresaId > 0) {
                  Get.to(() => RequisitosPage(companyId: empresaId));
                } else {
                  Get.snackbar(
                    "Error",
                    "No se encontró una empresa asociada al usuario.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.assignment, color: Colors.white),
              label: const Text(
                "Gestión de Requisitos",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 8),
                        Text("Cerrar Sesión"),
                      ],
                    ),
                    content: const Text("¿Estás seguro de que deseas cerrar sesión?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancelar"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _cerrarSesion();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Cerrar Sesión"),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                "Cerrar Sesión",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (empresaUsuario == null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final userName = reactController.userName.value;
                  final userEmail = reactController.userEmail.value;

                  if (userName.isEmpty || userEmail.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Debe iniciar sesión con un usuario válido."),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final empresaNombre =
                      "Empresa de ${userName[0].toUpperCase()}${userName.substring(1)}";

                  final body = {
                    "name": empresaNombre,
                    "address": "",
                    "phone": "",
                    "website": "",
                    "economicSector": "",
                    "description": "",
                    "employeeCount": 0,
                    "legalDocument": null,
                    "email": userEmail,
                  };

                  final ok = await empresaController.crearEmpresa(body);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(ok
                          ? "Empresa '$empresaNombre' creada correctamente ✅"
                          : "Error al crear la empresa ❌"),
                      backgroundColor: ok ? Colors.green : Colors.red,
                    ),
                  );

                  await _cargarEmpresaUsuario();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF39A900),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.add_business, color: Colors.white),
                label: const Text(
                  "Crear Empresa",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      );
    } else {
      // Botones en fila para desktop
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              final empresaId = reactController.empresaId.value;
              if (empresaId != null && empresaId > 0) {
                Get.to(() => RequisitosPage(companyId: empresaId));
              } else {
                Get.snackbar(
                  "Error",
                  "No se encontró una empresa asociada al usuario.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.assignment, color: Colors.white),
            label: const Text(
              "Gestión de Requisitos",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 25),
          if (empresaUsuario == null)
            ElevatedButton.icon(
              onPressed: () async {
                final userName = reactController.userName.value;
                final userEmail = reactController.userEmail.value;

                if (userName.isEmpty || userEmail.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Debe iniciar sesión con un usuario válido."),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final empresaNombre =
                    "Empresa de ${userName[0].toUpperCase()}${userName.substring(1)}";

                final body = {
                  "name": empresaNombre,
                  "address": "",
                  "phone": "",
                  "website": "",
                  "economicSector": "",
                  "description": "",
                  "employeeCount": 0,
                  "legalDocument": null,
                  "email": userEmail,
                };

                final ok = await empresaController.crearEmpresa(body);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ok
                        ? "Empresa '$empresaNombre' creada correctamente ✅"
                        : "Error al crear la empresa ❌"),
                    backgroundColor: ok ? Colors.green : Colors.red,
                  ),
                );

                await _cargarEmpresaUsuario();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF39A900),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add_business, color: Colors.white),
              label: const Text(
                "Crear Empresa",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(width: 25),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text("Cerrar Sesión"),
                    ],
                  ),
                  content: const Text("¿Estás seguro de que deseas cerrar sesión?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _cerrarSesion();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Cerrar Sesión"),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              "Cerrar Sesión",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _campoEditableResponsive({
    required IconData icono,
    required String etiqueta,
    required String valorInicial,
    required String campo,
    bool multilinea = false,
    required bool isMobile,
  }) {
    final TextEditingController controller = TextEditingController(text: valorInicial);
    bool editando = false;

    return StatefulBuilder(
      builder: (context, setStateCampo) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: multilinea ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Icon(icono, size: isMobile ? 16 : 18, color: const Color(0xFF1976D2)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: !editando,
                  maxLines: multilinea ? 4 : 1,
                  decoration: InputDecoration(
                    labelText: etiqueta.isNotEmpty ? etiqueta : null,
                    filled: true,
                    fillColor: editando
                        ? const Color(0xFFE3F2FD)
                        : const Color(0xFFF5F5F5),
                    suffixIcon: IconButton(
                      icon: Icon(
                        editando ? Icons.check_circle : Icons.edit,
                        color: editando ? const Color(0xFF1976D2) : Colors.grey.shade700,
                      ),
                      onPressed: () async {
                        if (!editando) {
                          setStateCampo(() => editando = true);
                        } else {
                          final body = {
                            "name": empresaUsuario?.name ?? "",
                            "address": empresaUsuario?.address ?? "",
                            "phone": empresaUsuario?.phone ?? "",
                            "cityId": empresaUsuario?.city?.id ?? 0,
                            "departmentId": empresaUsuario?.city?.departmentId ?? 0,
                            "website": empresaUsuario?.website ?? "",
                            "economicSector": empresaUsuario?.economicSector ?? "",
                            "description": empresaUsuario?.description ?? "",
                            "employeeCount": empresaUsuario?.employeeCount ?? 0,
                            "email": reactController.userEmail.value,
                            campo: controller.text,
                          };

                          bool ok;
                          if (empresaUsuario == null) {
                            ok = await empresaController.crearEmpresa(body);
                            if (ok) {
                              final nuevasEmpresas = await empresaController.getEmpresas();
                              final userEmail = reactController.userEmail.value.toLowerCase();
                              final nueva = nuevasEmpresas.firstWhere(
                                (e) => e.email != null && e.email!.toLowerCase() == userEmail,
                                orElse: () => Empresa(id: null, name: ""),
                              );
                              if (nueva.id != null) {
                                setState(() {
                                  empresaUsuario = nueva;
                                  reactController.setEmpresaId(nueva.id!);
                                });
                              }
                            }
                          } else {
                            ok = await empresaController.actualizarEmpresa(empresaUsuario!.id!, body);
                          }

                          if (ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Campo '$etiqueta' guardado correctamente ✅"),
                                backgroundColor: const Color(0xFF1976D2),
                              ),
                            );
                            await _cargarEmpresaUsuario();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Error al guardar ❌"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }

                          setStateCampo(() => editando = false);
                        }
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: editando ? const Color(0xFF1976D2) : Colors.grey.shade300,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _campoEditable3Col({
    required IconData icono,
    required String etiqueta,
    required String valorInicial,
    required String campo,
    bool multilinea = false,
  }) {
    final TextEditingController controller =
        TextEditingController(text: valorInicial);
    bool editando = false;

    return StatefulBuilder(
      builder: (context, setStateCampo) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icono, size: 18, color: Colors.black87),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: !editando,
                  maxLines: multilinea ? 4 : 1,
                  decoration: InputDecoration(
                    labelText: etiqueta.isNotEmpty ? etiqueta : null,
                    filled: true,
                    fillColor: editando
                        ? const Color(0xFFDFFFD8)
                        : const Color(0xFFEFFFEA),
                    suffixIcon: IconButton(
                      icon: Icon(
                        editando ? Icons.check_circle : Icons.edit,
                        color: editando ? Colors.green : Colors.grey.shade700,
                      ),
                      onPressed: () async {
                        if (!editando) {
                          setStateCampo(() => editando = true);
                        } else {
                          final body = {
                            "name": empresaUsuario?.name ?? "",
                            "address": empresaUsuario?.address ?? "",
                            "phone": empresaUsuario?.phone ?? "",
                            "cityId": empresaUsuario?.city?.id ?? 0,
                            "departmentId":
                                empresaUsuario?.city?.departmentId ?? 0,
                            "website": empresaUsuario?.website ?? "",
                            "economicSector":
                                empresaUsuario?.economicSector ?? "",
                            "description": empresaUsuario?.description ?? "",
                            "employeeCount": empresaUsuario?.employeeCount ?? 0,
                            "email": reactController.userEmail.value,
                            campo: controller
                                .text, // 👈 este es el que realmente se actualiza
                          };

                          bool ok;
                          if (empresaUsuario == null) {
                            ok = await empresaController.crearEmpresa(body);
                            if (ok) {
                              final nuevasEmpresas =
                                  await empresaController.getEmpresas();
                              final userEmail =
                                  reactController.userEmail.value.toLowerCase();

                              final nueva = nuevasEmpresas.firstWhere(
                                (e) =>
                                    e.email != null &&
                                    e.email!.toLowerCase() == userEmail,
                                orElse: () => Empresa(id: null, name: ""),
                              );

                              if (nueva.id != null) {
                                setState(() {
                                  empresaUsuario = nueva;
                                  reactController.setEmpresaId(nueva.id!);
                                });
                              }
                            }
                          } else {
                            ok = await empresaController.actualizarEmpresa(
                                empresaUsuario!.id!, body);
                          }

                          if (ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Campo '$etiqueta' guardado correctamente ✅",
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                            await _cargarEmpresaUsuario();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Error al guardar ❌"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }

                          setStateCampo(() => editando = false);
                        }
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _datoItem(IconData icono, String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 16, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$titulo: ",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 13.5),
                children: [
                  TextSpan(
                      text: valor,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black87)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
