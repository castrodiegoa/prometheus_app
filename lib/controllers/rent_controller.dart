import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/rent_model.dart';
import '../services/rent_service.dart';

class RentController extends GetxController {
  final RentService _rentService = RentService();

  // Variables observables
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);
  final RxString totalPersons = ''.obs;
  final RxDouble amount = 0.0.obs;
  final Rx<File?> agreementFile = Rx<File?>(null);
  var selectedTenantId = ''.obs;
  var selectedPropertyId = ''.obs;

  // Listas para los dropdowns
  final RxList<Map<String, dynamic>> availableTenants =
      RxList<Map<String, dynamic>>([]);
  final RxList<Map<String, dynamic>> availableProperties =
      RxList<Map<String, dynamic>>([]);

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

// Método para actualizar las fechas
  void updateStartDate(DateTime date) {
    startDate.value = date;
    endDate.value =
        null; // Reinicia la fecha de fin cuando se cambia la fecha de inicio
    update(); // Forzamos la actualización
  }

  void updateEndDate(DateTime date) {
    endDate.value = date;
    update(); // Forzamos la actualización
  }

  // Cargar datos iniciales
  Future<void> loadInitialData() async {
    availableTenants.value = await _rentService.getAvailableTenants();
    availableProperties.value = await _rentService.getAvailableProperties();
  }

  // Validar fechas
  bool validateDates() {
    if (startDate.value == null || endDate.value == null) return false;
    return endDate.value!.isAfter(startDate.value!) &&
        endDate.value!.month > startDate.value!.month;
  }

  // Crear nuevo alquiler
  Future<void> createRent() async {
    if (!validateDates()) {
      Get.snackbar('Error', 'Las fechas no son válidas');
      return;
    }

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      final rent = Rent(
        id: '', // Se generará en el servicio
        startDate: startDate.value!,
        endDate: endDate.value!,
        totalPersons: totalPersons.value,
        amount: amount.value,
        agreementUrl: '', // Se actualizará después de subir el archivo
        isActive: true,
        tenantId: selectedTenantId.value,
        propertyId: selectedPropertyId.value,
        userId: currentUser.uid,
      );

      await _rentService.createRent(rent, agreementFile.value);
      Get.snackbar('Éxito', 'Alquiler creado correctamente');
      Get.back(); // Volver a la página anterior
    } catch (e) {
      Get.snackbar('Error', 'No se pudo crear el alquiler: ${e.toString()}');
    }
  }

  // Actualizar archivo de contrato
  void setAgreementFile(File file) {
    agreementFile.value = file;
  }
}
