import 'package:app_bienestarmisena_v1/views/interface/inicio.dart';
import 'package:app_bienestarmisena_v1/views/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'App Mi Bienestar SENA',
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}