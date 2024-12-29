import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signup(String name, String regNumber, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: "$regNumber@example.com", // Using regNumber as email
        password: password,
      );
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        'name': name,
        'registrationNumber': regNumber,
        'password': password, // Not recommended for production
      });
      return 'success'; // Return success message
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  Future<String> login(String regNumber, String password) async {
    try {
      // Perform login using Firebase or other authentication method
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: "$regNumber@example.com", // Using registration number as email
        password: password,
      );

      // Check if the user is authenticated
      if (userCredential.user != null) {
        return 'success'; // Return success message
      } else {
        return 'Invalid credentials';
      }
    } catch (e) {
      return e.toString(); // Return error message
    }
  }
}
