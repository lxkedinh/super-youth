import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? _user;
  Map<String, dynamic>? _userData;

  User? get user => _user;

  Map<String, dynamic>? get userData => _userData;

  AuthenticationProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        loadUserData();
      } else {
        _userData = null;
      }
      notifyListeners();
    });
  }

  Future<void> loadUserData() async {
    if (_user == null) {
      return;
    }

    try {
      final doc = await _db.collection('users').doc(_user!.uid).get();
      _userData = doc.data();
      if (_userData != null) {
        _userData!['uid'] = _user!.uid;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  bool isAuthenticated() {
    return _user != null;
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _db.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } finally {
      notifyListeners();
    }
  }

  Future<void> logIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } finally {
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> updateProfile({
    String? username,
    String? firstName,
    String? lastName,
  }) async {
    if (_user == null) {
      return;
    }

    Map<String, dynamic> updatedProfile = {};
    if (username != null) {
      updatedProfile['username'] = username;
    }
    if (firstName != null) {
      updatedProfile['firstName'] = firstName;
    }
    if (lastName != null) {
      updatedProfile['lastName'] = lastName;
    }

    try {
      await _db.collection('users').doc(_user!.uid).update(updatedProfile);
      await loadUserData();
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteAccount() async {
    if (_user == null) return;

    try {
      await _db.collection('users').doc(_user!.uid).delete();
      await _user?.delete();
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateProgress({
    required String scenario,
    required String response,
    required Map<String, dynamic> feedback,
  }) async {
    if (_user == null) return;

    try {
      await _db.collection('users').doc(_user!.uid).collection('progress').add({
        'scenario': scenario,
        'response': response,
        'feedback': feedback,
        'score': feedback['score'],
        'timestamp': FieldValue.serverTimestamp(),
      });
    } on Exception catch (e) {
      print("Error updating user progress: $e");
    }
  }
}
