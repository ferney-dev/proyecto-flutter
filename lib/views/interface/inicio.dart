import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

// ✅ Controladores
import 'package:app_bienestarmisena_v1/controllers/reactController.dart';
import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/inicio/inicio_controller.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';

// ✅ Widgets y componentes
import 'package:app_bienestarmisena_v1/widgets/carousel_convocatorias.dart';
import 'package:app_bienestarmisena_v1/widgets/header.dart';
import 'package:app_bienestarmisena_v1/components/inicio/inicio_filtros_lineas.dart';
import 'package:app_bienestarmisena_v1/components/inicio/inicio_paginador.dart';
import 'package:app_bienestarmisena_v1/components/inicio/inicio_tarjeta_destacada.dart';
import 'package:app_bienestarmisena_v1/components/inicio/inicio_fila_tarjetas.dart';
import 'package:app_bienestarmisena_v1/components/inicio/inicio_grid_tarjetas.dart';
import 'package:app_bienestarmisena_v1/components/inicio/inicio_mosaico_tarjetas.dart';
import 'package:app_bienestarmisena_v1/components/inicio/animated_rainbow_line.dart';
import 'package:app_bienestarmisena_v1/views/detalleConvocatori/detalleConvocatoria.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final InicioController inicioController = Get.put(InicioController());
  final Reactcontroller reactController = Get.find<Reactcontroller>();
  final FavoritesController favController = Get.find<FavoritesController>();

  late Future<List<Convocatoria>> convocatorias;

  @override
  void initState() {
    super.initState();
    convocatorias = inicioController.convocatorias;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              constraints: const BoxConstraints(maxWidth: 1390),
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Header(selected: "Descubrir"),
                  const SizedBox(height: 40),
                  const CarouselConvocatorias(),
                  const SizedBox(height: 50),
                  Row(
                    children: const [
                      Icon(Icons.explore, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        "Convocatorias",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const AnimatedRainbowLine(),
                  const SizedBox(height: 24),
                  const InicioFiltrosLineas(),
                  const SizedBox(height: 30),
                  FutureBuilder<List<Convocatoria>>(
                    future: convocatorias,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      final data = snapshot.data ?? [];
                      
                      return Obx(() {
                        final convocatoriasFiltradas = inicioController.getConvocatoriasFiltradas(data);
                      
                        if (convocatoriasFiltradas.isEmpty) {
                          return const Center(
                            child: Text(
                              "No hay convocatorias disponibles para esta línea.",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          );
                        }
                        
                        final currentItems = inicioController.getPaginatedItems(convocatoriasFiltradas);
                        final totalItems = convocatoriasFiltradas.length;
                        
                        // Calcular índices dinámicos basados en la paginación
                        // Cada página muestra 12 items distribuidos así:
                        // - Tarjeta destacada: índice 0
                        // - Fila: índices 1-2
                        // - Grid: índices 3-6
                        // - Mosaico: índices 7-11
                        
                        return Column(
                          children: [
                            if (currentItems.isNotEmpty)
                              InicioTarjetaDestacada(
                                convocatoria: currentItems[0],
                                onDetalles: () => mostrarModalConvocatoria(context, currentItems[0]),
                                onInscribirse: () {},
                              ),
                            const SizedBox(height: 30),
                            InicioFilaTarjetas(
                              items: currentItems,
                              startIndex: 1,
                              count: 2,
                              onTarjetaTap: (c) => mostrarModalConvocatoria(context, c),
                            ),
                            const SizedBox(height: 30),
                            InicioGridTarjetas(
                              items: currentItems,
                              startIndex: 3,
                              count: 4,
                              onTarjetaTap: (c) => mostrarModalConvocatoria(context, c),
                            ),
                            const SizedBox(height: 30),
                            InicioMosaicoTarjetas(
                              items: currentItems,
                              startIndex: 7,
                              count: 5,
                              onTarjetaTap: (c) => mostrarModalConvocatoria(context, c),
                            ),
                            const SizedBox(height: 20),
                            InicioPaginador(
                              totalItems: totalItems,
                              itemsPerPage: inicioController.itemsPerPage,
                            ),
                          ],
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
