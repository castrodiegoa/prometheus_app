import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/rent_model.dart';
import '../services/rent_service.dart';

class RentController extends GetxController {
  final RentService _rentService = RentService();
  var isLoading = false.obs;

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

  // Lista de alquileres
  final RxList<Rent> allRents = RxList<Rent>([]);

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

  void resetFormState() {
    startDate.value = null;
    endDate.value = null;
    amount.value = 0.0;
    totalPersons.value = '';
    selectedTenantId.value = '';
    selectedPropertyId.value = '';
    agreementFile.value = null;
  }

  void updateEndDate(DateTime date) {
    endDate.value = date;
    update(); // Forzamos la actualización
  }

  // Cargar datos iniciales
  Future<void> loadInitialData() async {
    isLoading.value = true; // Establece la carga a verdadera
    availableTenants.assignAll(await _rentService.getAvailableTenants());
    availableProperties.assignAll(await _rentService.getAvailableProperties());
    availableTenants.refresh();
    availableProperties.refresh();
    isLoading.value = false; // Finaliza la carga
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

      await _rentService.createRent(rent);
      Get.snackbar('Éxito', 'Alquiler creado correctamente');
      Get.back(); // Volver a la página anterior
    } catch (e) {
      Get.snackbar('Error', 'No se pudo crear el alquiler: ${e.toString()}');
    }
  }

  // Actualizar alquiler
  Future<void> updateRent(String rentId) async {
    if (!validateDates()) {
      Get.snackbar('Error', 'Las fechas no son válidas');
      return;
    }

    try {
      final rent = Rent(
        id: rentId,
        startDate: startDate.value!,
        endDate: endDate.value!,
        totalPersons: totalPersons.value,
        amount: amount.value,
        agreementUrl: '', // Se actualizará después de subir el archivo
        isActive: true,
        tenantId: selectedTenantId.value,
        propertyId: selectedPropertyId.value,
        userId: FirebaseAuth.instance.currentUser?.uid ?? '',
      );

      await _rentService.updateRent(rent);
      Get.snackbar('Éxito', 'Alquiler actualizado correctamente');
      Get.back(); // Volver a la página anterior
    } catch (e) {
      Get.snackbar(
          'Error', 'No se pudo actualizar el alquiler: ${e.toString()}');
    }
  }

  // Eliminar alquiler
  Future<void> deleteRent(String rentId) async {
    try {
      await _rentService.deleteRent(rentId);
      Get.snackbar('Éxito', 'Alquiler eliminado correctamente');
      Get.back(); // Volver a la página anterior
    } catch (e) {
      Get.snackbar('Error', 'No se pudo eliminar el alquiler: ${e.toString()}');
    }
  }

  Future<List<Rent>> getRents(String userId) async {
    return await _rentService.getRents(userId);
  }
}
