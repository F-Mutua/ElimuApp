import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/resource_model.dart';

class FirebaseService {
  // Lazy initialization to avoid Firebase access before initialization
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser {
    try {
      return _auth.currentUser;
    } catch (e) {
      debugPrint('Firebase not initialized: $e');
      return null;
    }
  }

  // Auth state stream
  Stream<User?> get authStateChanges {
    try {
      return _auth.authStateChanges();
    } catch (e) {
      debugPrint('Firebase not initialized: $e');
      return Stream.value(null);
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('Error signing in: $e');
      rethrow;
    }
  }

  // Create account with email and password
  Future<UserCredential?> createAccountWithEmail(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('Error creating account: $e');
      rethrow;
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }

  // Save user data to Firestore
  Future<void> saveUserData(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
    } catch (e) {
      debugPrint('Error saving user data: $e');
      rethrow;
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user data: $e');
      return null;
    }
  }

  // Update user data
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      debugPrint('Error updating user data: $e');
      rethrow;
    }
  }

  // Get resources by grade
  Future<List<ResourceModel>> getResourcesByGrade(String grade) async {
    try {
      final querySnapshot = await _firestore
          .collection('resources')
          .where('grade', isEqualTo: grade)
          .orderBy('subject')
          .get();

      return querySnapshot.docs
          .map((doc) => ResourceModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      debugPrint('Error getting resources: $e');
      return [];
    }
  }

  // Stream resources by grade (real-time updates)
  Stream<List<ResourceModel>> streamResourcesByGrade(String grade) {
    try {
      return _firestore
          .collection('resources')
          .where('grade', isEqualTo: grade)
          .orderBy('subject')
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map(
                  (doc) =>
                      ResourceModel.fromJson({...doc.data(), 'id': doc.id}),
                )
                .toList(),
          );
    } catch (e) {
      debugPrint('Error streaming resources: $e');
      return Stream.value([]);
    }
  }

  // Get resources by grade and type
  Future<List<ResourceModel>> getResourcesByGradeAndType(
    String grade,
    String type,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('resources')
          .where('grade', isEqualTo: grade)
          .where('type', isEqualTo: type)
          .orderBy('subject')
          .get();

      return querySnapshot.docs
          .map((doc) => ResourceModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      debugPrint('Error getting resources by type: $e');
      return [];
    }
  }

  // Get resources by grade and subject
  Future<List<ResourceModel>> getResourcesByGradeAndSubject(
    String grade,
    String subject,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('resources')
          .where('grade', isEqualTo: grade)
          .where('subject', isEqualTo: subject)
          .get();

      return querySnapshot.docs
          .map((doc) => ResourceModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      debugPrint('Error getting resources by subject: $e');
      return [];
    }
  }

  // Search resources
  Future<List<ResourceModel>> searchResources(
    String query, {
    String? grade,
  }) async {
    try {
      Query resourceQuery = _firestore.collection('resources');

      if (grade != null) {
        resourceQuery = resourceQuery.where('grade', isEqualTo: grade);
      }

      final querySnapshot = await resourceQuery.get();

      // Filter results by title or subject containing query
      final results = querySnapshot.docs
          .map(
            (doc) => ResourceModel.fromJson({
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            }),
          )
          .where(
            (resource) =>
                resource.title.toLowerCase().contains(query.toLowerCase()) ||
                resource.subject.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      return results;
    } catch (e) {
      debugPrint('Error searching resources: $e');
      return [];
    }
  }

  // Add a resource (for admin/upload purposes)
  Future<String> addResource(ResourceModel resource) async {
    try {
      final docRef = await _firestore
          .collection('resources')
          .add(resource.toJson());
      return docRef.id;
    } catch (e) {
      debugPrint('Error adding resource: $e');
      rethrow;
    }
  }

  // Update a resource
  Future<void> updateResource(
    String resourceId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection('resources').doc(resourceId).update(data);
    } catch (e) {
      debugPrint('Error updating resource: $e');
      rethrow;
    }
  }

  // Delete a resource
  Future<void> deleteResource(String resourceId) async {
    try {
      await _firestore.collection('resources').doc(resourceId).delete();
    } catch (e) {
      debugPrint('Error deleting resource: $e');
      rethrow;
    }
  }

  // Batch upload resources from JSON (for initial setup)
  Future<void> batchUploadResources(List<ResourceModel> resources) async {
    try {
      final batch = _firestore.batch();

      for (var resource in resources) {
        final docRef = _firestore.collection('resources').doc();
        batch.set(docRef, resource.toJson());
      }

      await batch.commit();
      debugPrint('Successfully uploaded ${resources.length} resources');
    } catch (e) {
      debugPrint('Error batch uploading resources: $e');
      rethrow;
    }
  }

  // Track user progress
  Future<void> saveUserProgress(
    String userId,
    String resourceId,
    double progress,
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc(resourceId)
          .set({
            'resourceId': resourceId,
            'progress': progress,
            'lastAccessed': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving user progress: $e');
      rethrow;
    }
  }

  // Get user progress
  Future<Map<String, double>> getUserProgress(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .get();

      final progressMap = <String, double>{};
      for (var doc in querySnapshot.docs) {
        progressMap[doc.data()['resourceId']] = doc.data()['progress'] ?? 0.0;
      }

      return progressMap;
    } catch (e) {
      debugPrint('Error getting user progress: $e');
      return {};
    }
  }

  // Save user download
  Future<void> saveUserDownload(String userId, String resourceId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('downloads')
          .doc(resourceId)
          .set({
            'resourceId': resourceId,
            'downloadedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      debugPrint('Error saving user download: $e');
      rethrow;
    }
  }

  // Get user downloads
  Future<List<String>> getUserDownloads(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('downloads')
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data()['resourceId'] as String)
          .toList();
    } catch (e) {
      debugPrint('Error getting user downloads: $e');
      return [];
    }
  }
}
