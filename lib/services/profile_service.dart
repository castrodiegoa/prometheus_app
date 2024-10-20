import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          return {
            'document': userDoc['document'] ?? '',
            'email': user.email ?? '',
            'phoneNumber': userDoc['phoneNumber'] ?? '',
            'firstName': userDoc['firstName'] ?? '',
            'lastName': userDoc['lastName'] ?? '',
          };
        }
      } catch (e) {
        print('Error loading user data: $e');
        throw e;
      }
    }
    return {};
  }

  Future<void> updateUserData(Map<String, dynamic> userData) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Verificar si el documento ya está registrado con otro usuario
        QuerySnapshot documentSnapshot = await _firestore
            .collection('users')
            .where('document', isEqualTo: userData['document'])
            .where(FieldPath.documentId, isNotEqualTo: user.uid)
            .get();

        if (documentSnapshot.docs.isNotEmpty) {
          throw Exception(
              'El número de documento ya está registrado con otro usuario.');
        }

        // Verificar si el correo ya está registrado con otro usuario
        if (userData['email'] != user.email) {
          QuerySnapshot emailSnapshot = await _firestore
              .collection('users')
              .where('email', isEqualTo: userData['email'])
              .where(FieldPath.documentId, isNotEqualTo: user.uid)
              .get();

          if (emailSnapshot.docs.isNotEmpty) {
            throw Exception(
                'El correo electrónico ya está registrado con otro usuario.');
          }

          // Usar verifyBeforeUpdateEmail en lugar de updateEmail
          await user.verifyBeforeUpdateEmail(userData['email']);
        }

        // Actualizar otros datos en Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'document': userData['document'],
          'phoneNumber': userData['phoneNumber'],
          'firstName': userData['firstName'],
          'lastName': userData['lastName'],
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print('Error updating user data: $e');
        throw e;
      }
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
      } catch (e) {
        print('Error cambiando la contraseña: $e');
        throw e;
      }
    }
  }

  Future<String> getFullName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          String firstName = userDoc['firstName'] ?? '';
          String lastName = userDoc['lastName'] ?? '';
          return '$firstName $lastName'; // Devolver nombre completo
        }
      } catch (e) {
        print('Error obteniendo el nombre completo: $e');
        throw e;
      }
    }
    return '';
  }
}
