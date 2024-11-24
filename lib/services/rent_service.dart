import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/rent_model.dart';

class RentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Map<String, dynamic>>> getAvailableTenants() async {
    final tenantsSnapshot = await _firestore.collection('tenants').get();
    final List<Map<String, dynamic>> availableTenants = [];

    final allRentedTenantsSnapshot = await _firestore.collection('rents').get();

    // Crear un conjunto solo con tenantId cuando esté presente
    final Set<String> rentedTenantIds = allRentedTenantsSnapshot.docs
        .where((doc) => doc.data().containsKey('tenantId'))
        .map((doc) => doc['tenantId'] as String)
        .toSet();

    for (var tenant in tenantsSnapshot.docs) {
      final tenantData = tenant.data();

      if (tenantData['firstName'] == null ||
          tenantData['firstName'].toString().isEmpty) {
        tenantData['firstName'] = 'Sin nombre';
      }

      if (!rentedTenantIds.contains(tenant.id)) {
        availableTenants.add({
          'id': tenant.id,
          'firstName': tenantData['firstName'],
        });
        continue;
      }

      final activeRents = await _firestore
          .collection('rents')
          .where('tenantId', isEqualTo: tenant.id)
          .where('isActive', isEqualTo: true)
          .get();

      if (activeRents.docs.isEmpty) {
        availableTenants.add({
          'id': tenant.id,
          'firstName': tenantData['firstName'],
        });
      }
    }

    return availableTenants;
  }

  Future<List<Map<String, dynamic>>> getAvailableProperties() async {
    final propertiesSnapshot = await _firestore.collection('properties').get();
    final List<Map<String, dynamic>> availableProperties = [];

    final allRentedPropertiesSnapshot =
        await _firestore.collection('rents').get();

    // Crear un conjunto solo con propertyId cuando esté presente en cada documento de rentas
    final Set<String> rentedPropertyIds = allRentedPropertiesSnapshot.docs
        .where((doc) => doc.data().containsKey('propertyId'))
        .map((doc) => doc['propertyId'] as String)
        .toSet();

    for (var property in propertiesSnapshot.docs) {
      final propertyData = property.data();

      // Verificar si el campo 'description' está presente y asignar un valor por defecto si falta
      if (propertyData['description'] == null ||
          propertyData['description'].toString().isEmpty) {
        propertyData['description'] = 'Sin descripción';
      }

      // Si la propiedad no está alquilada, agregarla directamente a la lista
      if (!rentedPropertyIds.contains(property.id)) {
        availableProperties.add({
          'id': property.id,
          'description': propertyData['description'],
        });
        continue;
      }

      // Comprobar si la propiedad tiene un alquiler activo
      final activeRents = await _firestore
          .collection('rents')
          .where('propertyId', isEqualTo: property.id)
          .where('isActive', isEqualTo: true)
          .get();

      // Si no tiene alquiler activo, añadir a la lista de propiedades disponibles
      if (activeRents.docs.isEmpty) {
        availableProperties.add({
          'id': property.id,
          'description': propertyData['description'],
        });
      }
    }

    return availableProperties;
  }

  // Subir archivo de contrato
  Future<String> uploadAgreement(File file, String rentId) async {
    final storageRef = _storage.ref().child('agreements/$rentId');
    final uploadTask = await storageRef.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }

  // Crear nuevo alquiler
  Future<void> createRent(Rent rent, File? agreementFile) async {
    // Generar ID único para el alquiler
    final String rentId = _firestore.collection('rents').doc().id;
    rent = rent.copyWith(
      id: rentId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: true,
    );

    // Si hay archivo de contrato, subirlo primero
    if (agreementFile != null) {
      final String agreementUrl = await uploadAgreement(agreementFile, rentId);
      rent = rent.copyWith(agreementUrl: agreementUrl);
    }

    // Guardar el alquiler en Firestore
    await _firestore.collection('rents').doc(rentId).set(rent.toFirestore());
  }
}
