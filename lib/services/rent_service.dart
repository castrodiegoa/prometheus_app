import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rent_model.dart';

class RentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAvailableTenants() async {
    final tenantsSnapshot = await _firestore.collection('tenants').get();
    final List<Map<String, dynamic>> availableTenants = [];

    final allRentedTenantsSnapshot = await _firestore.collection('rents').get();

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

    final Set<String> rentedPropertyIds = allRentedPropertiesSnapshot.docs
        .where((doc) => doc.data().containsKey('propertyId'))
        .map((doc) => doc['propertyId'] as String)
        .toSet();

    for (var property in propertiesSnapshot.docs) {
      final propertyData = property.data();

      if (propertyData['description'] == null ||
          propertyData['description'].toString().isEmpty) {
        propertyData['description'] = 'Sin descripción';
      }

      if (!rentedPropertyIds.contains(property.id)) {
        availableProperties.add({
          'id': property.id,
          'description': propertyData['description'],
        });
        continue;
      }

      final activeRents = await _firestore
          .collection('rents')
          .where('propertyId', isEqualTo: property.id)
          .where('isActive', isEqualTo: true)
          .get();

      if (activeRents.docs.isEmpty) {
        availableProperties.add({
          'id': property.id,
          'description': propertyData['description'],
        });
      }
    }

    return availableProperties;
  }

  // Crear nuevo alquiler
  Future<void> createRent(Rent rent) async {
    final String rentId = _firestore.collection('rents').doc().id;
    rent = rent.copyWith(
      id: rentId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: true,
    );
    await _firestore.collection('rents').doc(rentId).set(rent.toFirestore());
  }

  // Obtener un alquiler por su ID
  Future<Rent?> getRentById(String rentId) async {
    try {
      final doc = await _firestore.collection('rents').doc(rentId).get();
      if (doc.exists) {
        return Rent.fromFirestore(doc);
      }
    } catch (e) {
      print('Error al obtener alquiler: $e');
    }
    return null;
  }

  // Actualizar un alquiler
  Future<void> updateRent(Rent rent) async {
    try {
      final rentRef = _firestore.collection('rents').doc(rent.id);
      final rentData = rent.toFirestore();

      // Actualizamos solo los campos modificados
      await rentRef.update(rentData);
    } catch (e) {
      print('Error al actualizar alquiler: $e');
    }
  }

  // Eliminar un alquiler
  Future<void> deleteRent(String rentId) async {
    try {
      final rentRef = _firestore.collection('rents').doc(rentId);
      await rentRef.delete();
    } catch (e) {
      print('Error al eliminar alquiler: $e');
    }
  }

  Future<List<Rent>> getRents(String userId) async {
    final snapshot = await _firestore
        .collection('rents')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => Rent.fromFirestore(doc)).toList();
  }
}
