import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prometheus_app/models/tenant_model.dart';

class TenantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createTenant(Tenant tenant) async {
    // Agregar el documento sin ID y dejar que Firestore lo genere automáticamente
    final docRef =
        await _firestore.collection('tenants').add(tenant.toFirestore());
    // Crear una nueva instancia de Tenant con el ID generado por Firestore
    final tenantWithId = tenant.copyWith(id: docRef.id.toString());

    await updateTenant(tenantWithId);
  }

  Future<void> updateTenant(Tenant tenant) async {
    await _firestore
        .collection('tenants')
        .doc(tenant.id)
        .update(tenant.toFirestore());
  }

  Future<void> deleteTenant(String tenantId) async {
    await _firestore.collection('tenants').doc(tenantId).delete();
  }

  Future<List<Tenant>> getTenants(String userId) async {
    final snapshot = await _firestore
        .collection('tenants')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => Tenant.fromFirestore(doc)).toList();
  }
}
