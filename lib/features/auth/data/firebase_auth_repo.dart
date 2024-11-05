import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coocoo/features/auth/domain/entities/app_user.dart';
import 'package:coocoo/features/auth/domain/repositories/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance; 

  @override
  Future<AppUser?> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await firebaseFirestore.collection('users').doc(userCredential.user!.uid).get();

      if (!userDoc.exists) {
        return null; // User document does not exist
      }

      String userName = userDoc['name'] ?? ''; // Handle potential null value
      AppUser user = AppUser(uid: userCredential.user!.uid, email: email, name: userName);
      return user;
    } catch (e) {
      print("Login failed: $e"); // Log the error for debugging
      throw Exception("Login failed: ${e.toString()}");
    }
  }

  @override
  Future<AppUser?> registerWithEmailAndPassword(String name, String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      AppUser user = AppUser(uid: userCredential.user!.uid, email: email, name: name);
      await firebaseFirestore.collection('users').doc(user.uid).set(user.toJson());
      
      return user;
    } catch (e) {
      print("Registration failed: $e"); // Log the error for debugging
      throw Exception("Registration failed: ${e.toString()}");
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut(); // Await signOut to ensure it completes
    } catch (e) {
      print("Logout failed: $e"); // Log the error for debugging
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final fireUser = firebaseAuth.currentUser;
    if (fireUser == null) {
      return null; // No current user
    }

    // Fetch additional details from Firestore if necessary
    DocumentSnapshot userDoc = await firebaseFirestore.collection('users').doc(fireUser.uid).get();
    String userName = userDoc['name'] ?? ''; // Handle potential null value

    return AppUser(uid: fireUser.uid, email: fireUser.email!, name: userName);
  }
}