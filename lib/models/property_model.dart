import 'package:cloud_firestore/cloud_firestore.dart';

class Property {
  String id;
  String? description;
  String address;
  bool isRented;
  DateTime? createdAt;
  DateTime? updatedAt;
  String userId;

  // Constructor
  Property({
    required this.id,
    this.description,
    required this.address,
    required this.isRented,
    this.createdAt,
    this.updatedAt,
    required this.userId,
  });

  // Factory para crear una propiedad desde Firestore (deserialización)
  factory Property.fromFirestore(DocumentSnapshot data) {
    return Property(
      id: data['id'] ?? '', // Se obtiene el id desde la data de Firestore
      description: data['description'],
      address: data['address'] ?? '',
      isRented: data['isRented'] ?? false, // Asegurarse de que sea un bool
      createdAt: (data['createdAt'] != null)
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: (data['updatedAt'] != null)
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      userId: data['userId'] ?? '',
    );
  }

  // Método para convertir la instancia a un mapa compatible con Firestore (serialización)
  Map<String, dynamic> toFirestore() {
    return {
      'id': id, // El id también se incluye en la serialización
      'description': description,
      'address': address,
      'isRented': isRented, // El bool de si está alquilada
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'userId': userId,
    };
  }

  // Método copyWith para crear una nueva instancia de Tenant con valores actualizados
  Property copyWith({
    String? id,
    String? description,
    String? address,
    bool? isRented,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return Property(
      id: id ?? this.id,
      description: description ?? this.description,
      address: address ?? this.address,
      isRented: isRented ?? this.isRented,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }
}
