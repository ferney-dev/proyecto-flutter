import 'dart:convert';
import 'package:app_bienestarmisena_v1/models/registroUser/registro.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class UserController extends GetxController {
  final RxBool loading = false.obs;

  Future<bool> registerUser(User user) async {
    try {
      loading.value = true;

      final response = await http.post(
        Uri.parse(User.apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error en conexión: $e");
      return false;
    } finally {
      loading.value = false;
    }
  }
}
