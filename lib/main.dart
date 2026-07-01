import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'controllers/reactController.dart';
import 'controllers/favorites_controller.dart';
import 'controllers/accesibilidad/accesibilidad_controller.dart';
import 'package:app_bienestarmisena_v1/views/interface/menuPrincipal.dart';
import 'package:app_bienestarmisena_v1/views/login/login.dart';
import 'package:app_bienestarmisena_v1/views/registro/registro.dart';
import 'package:app_bienestarmisena_v1/views/recuperarContraseña/recuperarContraseña.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Cargar variables de entorno desde .env
  await dotenv.load(fileName: ".env");

  // ✅ Registrar controladores globales de manera PERMANENTE
  Get.put(Reactcontroller(), permanent: true);
  Get.put(FavoritesController(), permanent: true);
  Get.put(AccesibilidadController(), permanent: true);

  // ✅ Iniciar la app principal
  runApp(const MenuPrincipal());
}

// ✅ Lista global de opciones del menú (opcional)
List menuOption = [
  Login(),
  Registro(),
  OlvidarContrasena(),
];
