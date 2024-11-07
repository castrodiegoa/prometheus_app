import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prometheus_app/models/property_model.dart';

class PropertyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createProperty(Property property) async {
    final docRef =
        await _firestore.collection('properties').add(property.toFirestore());
    final propertyWithId = property.copyWith(id: docRef.id.toString());

    await updateProperty(propertyWithId);
  }

  Future<void> updateProperty(Property property) async {
    await _firestore
        .collection('properties')
        .doc(property.id)
        .update(property.toFirestore());
  }

  Future<void> deleteProperty(String propertyId) async {
    await _firestore.collection('properties').doc(propertyId).delete();
  }

  Future<List<Property>> getProperties(String userId) async {
    final snapshot = await _firestore
        .collection('properties')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => Property.fromFirestore(doc)).toList();
  }
}
