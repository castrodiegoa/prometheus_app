import 'package:prometheus_app/models/property_model.dart';
import 'package:prometheus_app/services/property_service.dart';

class PropertyController {
  final PropertyService _propertyService = PropertyService();

  Future<void> createProperty(Property property) async {
    await _propertyService.createProperty(property);
  }

  Future<void> updateProperty(Property property) async {
    await _propertyService.updateProperty(property);
  }

  Future<void> deleteProperty(String propertyId) async {
    await _propertyService.deleteProperty(propertyId);
  }

  Future<List<Property>> getProperties(String userId) async {
    return await _propertyService.getProperties(userId);
  }
}
