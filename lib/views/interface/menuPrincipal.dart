import 'package:app_bienestarmisena_v1/views/login/login.dart';
import 'package:app_bienestarmisena_v1/views/interface/inicio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/controllers/reactController.dart';
import 'package:app_bienestarmisena_v1/controllers/accesibilidad/accesibilidad_controller.dart';
import 'package:app_bienestarmisena_v1/components/menu/menu_layout.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    final accesibilidadController = Get.find<AccesibilidadController>();
    
    return Obx(() => GetMaterialApp(
      title: 'App Mi Bienestar SENA',
      debugShowCheckedModeBanner: false,
      theme: accesibilidadController.lightTheme,
      darkTheme: accesibilidadController.darkTheme,
      themeMode: accesibilidadController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      home: _getInitialScreen(),
    ));
  }

  Widget _getInitialScreen() {
    final Reactcontroller reactController = Get.find<Reactcontroller>();
    
    if (reactController.userId.value > 0) {
      return const MenuLayout(
        showSidebar: true,
        child: Inicio(),
      );
    }
    
    return const Login();
  }
}
