import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ✅ Controladores globales
import 'controllers/reactController.dart';
import 'controllers/favorites_controller.dart';

// ✅ Vistas principales
import 'package:app_bienestarmisena_v1/views/interface/principal.dart';
import 'package:app_bienestarmisena_v1/views/interface/homePrincipal.dart';
import 'package:app_bienestarmisena_v1/views/login/login.dart';
import 'package:app_bienestarmisena_v1/views/registro/registro.dart';
import 'package:app_bienestarmisena_v1/views/recuperarContraseña/recuperarContraseña.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Registrar controladores globales de manera PERMANENTE
  Get.put(Reactcontroller(), permanent: true);
  Get.put(FavoritesController(), permanent: true);

  // ✅ Iniciar la app principal
  runApp(const Principal());
}

// ✅ Lista global de opciones del menú (opcional)
List menuOption = [
  HomePrincipal(),
  Login(),
  Registro(),
  OlvidarContrasena(),
 
];
