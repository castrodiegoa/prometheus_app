import 'package:prometheus_app/models/tenant_model.dart';
import 'package:prometheus_app/services/tenant_service.dart';

class TenantController {
  final TenantService _tenantService = TenantService();

  Future<void> createTenant(Tenant tenant) async {
    await _tenantService.createTenant(tenant);
  }

  Future<void> updateTenant(Tenant tenant) async {
    await _tenantService.updateTenant(tenant);
  }

  Future<void> deleteTenant(String tenantId) async {
    await _tenantService.deleteTenant(tenantId);
  }

  Future<List<Tenant>> getTenants(String userId) async {
    return await _tenantService.getTenants(userId);
  }
}
