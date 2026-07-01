import 'package:get/get.dart';
import 'package:app_bienestarmisena_v1/controllers/convocatorias/convocatorias_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/lineas/lineas_controller.dart';
import 'package:app_bienestarmisena_v1/controllers/reactController.dart';
import 'package:app_bienestarmisena_v1/controllers/favorites_controller.dart';
import 'package:app_bienestarmisena_v1/models/convocatorias/convocatoriasModel.dart';
import 'package:app_bienestarmisena_v1/models/linea/linea_model.dart';

class InicioController extends GetxController {
  final ConvocatoriasController convocatoriasController = ConvocatoriasController();
  final LineasController lineasController = LineasController();
  final Reactcontroller reactController = Get.find<Reactcontroller>();
  final FavoritesController favController = Get.find<FavoritesController>();

  late Future<List<Convocatoria>> convocatorias;
  
  var lineas = <Linea>[].obs;
  var isLoadingLineas = true.obs;
  var lineaSeleccionada = Rxn<int>();
  
  var currentPage = 1.obs;
  final int itemsPerPage = 12;

  @override
  void onInit() {
    super.onInit();
    
    ever(reactController.userId, (id) {
      if (id != 0) {
        favController.loadUserFavorites(id);
      }
    });

    convocatorias = convocatoriasController.getConvocatorias();
    loadLineas();
  }

  Future<void> loadLineas() async {
    final lineasData = await lineasController.getLineas();
    lineas.value = lineasData;
    isLoadingLineas.value = false;
  }

  void nextPage(int totalItems) {
    if (currentPage.value * itemsPerPage < totalItems) {
      currentPage.value++;
    }
  }

  void prevPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }

  void goToPage(int page) {
    currentPage.value = page;
  }

  void seleccionarLinea(int? lineaId) {
    lineaSeleccionada.value = lineaId;
  }

  List<Convocatoria> getConvocatoriasFiltradas(List<Convocatoria> data) {
    if (lineaSeleccionada.value == null) {
      return data;
    }
    return data.where((c) => c.lineId == lineaSeleccionada.value).toList();
  }

  List<Convocatoria> getPaginatedItems(List<Convocatoria> convocatoriasFiltradas) {
    final totalItems = convocatoriasFiltradas.length;
    final startIndex = (currentPage.value - 1) * itemsPerPage;
    final endIndex = (currentPage.value * itemsPerPage).clamp(0, totalItems);
    return convocatoriasFiltradas.sublist(startIndex, endIndex);
  }
}
