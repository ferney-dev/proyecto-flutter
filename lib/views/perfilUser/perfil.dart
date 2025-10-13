import 'package:app_bienestarmisena_v1/controllers/cuidadController.dart';
import 'package:app_bienestarmisena_v1/controllers/empresa_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/interesController.dart';
import 'package:app_bienestarmisena_v1/controllers/userInterest.dart'
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
    final maxAncho = ancho > 1200 ? 1200.0 : ancho * 0.95;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: cargando
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 40, horizontal: 20),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF00324D), Color(0xFF001F33)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // 🔹 Imagen del usuario
                            Obx(() {
                              final imageUrl = reactController.userImage.value;
                              return CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.grey.shade300,
                                backgroundImage: imageUrl.isNotEmpty
                                    ? NetworkImage(imageUrl)
                                    : const AssetImage(
                                            'assets/images/default_user.png')
                                        as ImageProvider,
                              );
                            }),

                            const SizedBox(height: 15),

                            // 🔹 Nombre del usuario y empresa
                            // 🔹 Nombre del usuario + iconos de empresa
                            // 🔹 Nombre del usuario y empresa + icono crear si no existe
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // 🧍 Nombre del usuario
                                    Obx(() => Text(
                                          reactController
                                                  .userName.value.isNotEmpty
                                              ? reactController.userName.value
                                              : "Usuario sin nombre",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                    const SizedBox(width: 10),

                                    // 🏢 Si no hay empresa, mostrar el ícono de crear empresa
                                    if (empresaUsuario == null)
                                      IconButton(
                                        icon: const Icon(
                                          FontAwesomeIcons.plusCircle,
                                          color: Colors.greenAccent,
                                          size: 22,
                                        ),
                                        tooltip: "Crear empresa",
                                        onPressed: () async {
                                          final userName =
                                              reactController.userName.value;
                                          final userEmail =
                                              reactController.userEmail.value;

                                          // Si no hay nombre o correo, prevenir creación
                                          if (userName.isEmpty ||
                                              userEmail.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Debe iniciar sesión con un usuario válido."),
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
                                            "legalDocument":
                                                null, // 👈 Documento opcional
                                            "email": userEmail,
                                          };

                                          final ok = await empresaController
                                              .crearEmpresa(body);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(ok
                                                  ? "Empresa '$empresaNombre' creada correctamente ✅"
                                                  : "Error al crear la empresa ❌"),
                                              backgroundColor: ok
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          );

                                          await _cargarEmpresaUsuario(); // Recargar datos
                                        },
                                      ),

                                    // 🖊️ Icono de editar empresa (solo si existe)
                                    if (empresaUsuario != null)
                                      IconButton(
                                        icon: const Icon(
                                          FontAwesomeIcons.penToSquare,
                                          color: Colors.white70,
                                          size: 20,
                                        ),
                                        tooltip: "Editar datos de la empresa",
                                        onPressed: () =>
                                            _mostrarFormularioEmpresa(context),
                                      ),
                                  ],
                                ),

                                const SizedBox(height: 4),

                                // ✅ Mostrar nombre de empresa si existe
                                if (empresaUsuario != null)
                                  Text(
                                    "— ${empresaUsuario!.name}",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 8),

// 🔹 Correo y documento de la empresa
                            Column(
                              children: [
                                Obx(() => Text(
                                      reactController.userEmail.value.isNotEmpty
                                          ? reactController.userEmail.value
                                          : "Correo no registrado",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 15,
                                      ),
                                    )),
                                const SizedBox(height: 3),

                                // ✅ Mostrar documento legal de la empresa
                                Text(
                                  "Documento empresa: ${empresaUsuario?.legalDocument != null && empresaUsuario!.legalDocument!.isNotEmpty ? empresaUsuario!.legalDocument! : 'No registrado'}",
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // 🔹 Intereses (igual que antes)
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.center,
                              children: interesesUsuario.isEmpty
                                  ? [
                                      const Text(
                                        "No tienes intereses registrados",
                                        style: TextStyle(color: Colors.white70),
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
                                        label: Text(interes.name,
                                            style: const TextStyle(
                                                color: Colors.black)),
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

                            const SizedBox(height: 12),

                            // Botón agregar intereses
                            if (interesesUsuario.length < 5)
                              IconButton(
                                onPressed: _agregarInteres,
                                icon: const Icon(Icons.add_circle_outline,
                                    size: 32, color: Colors.white),
                              ),
                          ],
                        ),
                      ),

                      // ====================== CONTENEDOR DATOS + BOTONES ======================
                      // ====================== CONTENEDOR DATOS + BOTONES ======================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Información de la Empresa",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),

                            if (empresaUsuario == null)
                              const Text(
                                "Aún no tienes una empresa registrada. Completa los campos para crearla automáticamente.",
                                style: TextStyle(color: Colors.grey),
                              ),

                            const SizedBox(height: 20),

                            // 🧩 Tres columnas con campos editables
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final anchoColumna =
                                    (constraints.maxWidth - 40) / 3;
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ======= COLUMNA 1 =======
                                    SizedBox(
                                      width: anchoColumna,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _campoEditable3Col(
                                            icono: FontAwesomeIcons.building,
                                            etiqueta: "Razón Social",
                                            valorInicial:
                                                empresaUsuario?.name ?? "",
                                            campo: "name",
                                          ),
                                          _campoEditable3Col(
                                            icono: FontAwesomeIcons.locationDot,
                                            etiqueta: "Dirección",
                                            valorInicial:
                                                empresaUsuario?.address ?? "",
                                            campo: "address",
                                          ),
                                          _campoEditable3Col(
                                            icono: FontAwesomeIcons.map,
                                            etiqueta: "Departamento",
                                            valorInicial: empresaUsuario
                                                    ?.city?.departmentId
                                                    ?.toString() ??
                                                "",
                                            campo: "department",
                                          ),
                                          _campoEditable3Col(
                                            icono: FontAwesomeIcons.phone,
                                            etiqueta: "Teléfono",
                                            valorInicial:
                                                empresaUsuario?.phone ?? "",
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _campoEditable3Col(
                                            icono: FontAwesomeIcons.users,
                                            etiqueta: "Número Empleados",
                                            valorInicial: empresaUsuario
                                                    ?.employeeCount
                                                    ?.toString() ??
                                                "",
                                            campo: "employeeCount",
                                          ),
                                          _campoEditable3Col(
                                            icono: FontAwesomeIcons.city,
                                            etiqueta: "Ciudad",
                                            valorInicial:
                                                empresaUsuario?.city?.name ??
                                                    "",
                                            campo: "city",
                                          ),
                                          _campoEditable3Col(
                                            icono: FontAwesomeIcons.globe,
                                            etiqueta: "Página Web",
                                            valorInicial:
                                                empresaUsuario?.website ?? "",
                                            campo: "website",
                                          ),
                                          _campoEditable3Col(
                                            icono: FontAwesomeIcons.briefcase,
                                            etiqueta: "Sector Económico",
                                            valorInicial: empresaUsuario
                                                    ?.economicSector ??
                                                "",
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Descripción:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          const SizedBox(height: 6),
                                          _campoEditable3Col(
                                            icono: FontAwesomeIcons.quoteLeft,
                                            etiqueta: "",
                                            valorInicial:
                                                empresaUsuario?.description ??
                                                    "",
                                            campo: "description",
                                            multilinea: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),

                            const SizedBox(height: 30),

                            // 🔹 Botones inferiores (sin cambios)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // 🔹 Supongamos que tu controlador global guarda el ID de la empresa
                                    // (puede ser reactController.empresaId.value o empresaController.empresaId)
                                    final empresaId =
                                        reactController.empresaId.value;

                                    // Verificamos que exista antes de navegar
                                    if (empresaId != null && empresaId > 0) {
                                      Get.to(() =>
                                          RequisitosPage(companyId: empresaId));
                                    } else {
                                      // Si no hay empresa registrada, mostramos un aviso
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
                                    backgroundColor: const Color(0xFF39A900),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.assignment,
                                      color: Colors.white),
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
                                ElevatedButton.icon(
                                  onPressed: _cerrarSesion,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade600,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  icon: const Icon(Icons.logout,
                                      color: Colors.white),
                                  label: const Text(
                                    "Cerrar Sesión",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
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
