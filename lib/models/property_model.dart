import 'package:cloud_firestore/cloud_firestore.dart';

class Property {
  String id;
  String name;
  String? description;
  String address;
  bool isRented;
  DateTime? createdAt;

  // Constructor
  Property({
    required this.id,
    required this.name,
    this.description,
    required this.address,
    required this.isRented,
    this.createdAt,
  });

  // Factory para crear una propiedad desde Firestore (deserialización)
  factory Property.fromFirestore(DocumentSnapshot data) {
    return Property(
      id: data['id'] ?? '', // Se obtiene el id desde la data de Firestore
      name: data['name'] ?? '',
      description: data['description'],
      address: data['address'] ?? '',
      isRented: data['isRented'] ?? false, // Asegurarse de que sea un bool
      createdAt: (data['createdAt'] != null)
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Método para convertir la instancia a un mapa compatible con Firestore (serialización)
  Map<String, dynamic> toFirestore() {
    return {
      'id': id, // El id también se incluye en la serialización
      'name': name,
      'description': description,
      'address': address,
      'isRented': isRented, // El bool de si está alquilada
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}
