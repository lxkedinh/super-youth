import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/unit.dart';

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
    required int unitNumber,
    required String response,
    required Map<String, dynamic> feedback,
  }) async {
    if (_user == null) return;

    try {
      await _db.collection('users').doc(_user!.uid).collection('progress').add({
        'scenario': scenario,
        'unitNumber': unitNumber,
        'response': response,
        'feedback': feedback,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } on Exception catch (e) {
      print("Error updating user progress: $e");
    }
  }

  Future<List<double>> getAverageScores() async {
    if (_user == null) {
      throw Exception("User not authenticated. Please log in");
    }

    try {
      List<double> unitAvgScores = List.generate(units.length, (i) => 0);
      List<double> completedUnitScenarios = List.generate(
        units.length,
        (i) => 0,
      );

      final progressCollection =
          await _db
              .collection('users')
              .doc(_user!.uid)
              .collection('progress')
              .get();
      for (final doc in progressCollection.docs) {
        Map<String, dynamic> docData = doc.data();
        int unitNumber = docData['unitNumber'];
        int score = docData['feedback']['score'];
        completedUnitScenarios[unitNumber - 1]++;
        unitAvgScores[unitNumber - 1] += score;
      }

      for (int i = 0; i < unitAvgScores.length; i++) {
        if (completedUnitScenarios[i] != 0) {
          unitAvgScores[i] /= completedUnitScenarios[i];
        }
      }

      return unitAvgScores;
    } catch (e) {
      print("Could not get user progress: $e");
      throw Exception("Could not get user progress. Try again.");
    }
  }
}
