import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coocoo/features/Profile/domain/profile_user.dart';
import 'package:coocoo/features/Profile/domain/repositories/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> FetchUserProfile(String uid) async {
    try {
      final userDoc = await firebaseFirestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();

        if (userData != null) {
          final followers = List<String>.from(userData['followers'] ?? []);
          final following = List<String>.from(userData['following'] ?? []);

          return ProfileUser(
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl']?.toString() ?? '',
            uid: uid,
            name: userData['name'] ?? '',
            email: userData['email'] ?? '',
            followers: followers,
            following: following,
          );
        }
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  @override
  Future<void> UpdateProfile(ProfileUser UpdateProfile) async {
    try {
      await firebaseFirestore.collection('users').doc(UpdateProfile.uid).update({
        'bio': UpdateProfile.bio,
        'profileImageUrl': UpdateProfile.profileImageUrl,
      });
    } catch (e) {
      print('Error updating profile: $e');
      throw Exception('Failed to update profile');
    }
  }

  @override
  Future<void> toggleFollow(String currentUserId, String targetUserId) async {
    try {
      final currentUserDoc = await firebaseFirestore.collection('users').doc(currentUserId).get();
      final targetUserDoc = await firebaseFirestore.collection('users').doc(targetUserId).get();

      if (currentUserDoc.exists && targetUserDoc.exists) {
        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();

        if (currentUserData != null && targetUserData != null) {
          final List<String> currentFollowing = List<String>.from(currentUserData['following'] ?? []);

          if (currentFollowing.contains(targetUserId)) {
            // Unfollow
            await firebaseFirestore.collection('users').doc(currentUserId).update({
              'following': FieldValue.arrayRemove([targetUserId]),
            });
            await firebaseFirestore.collection('users').doc(targetUserId).update({
              'followers': FieldValue.arrayRemove([currentUserId]),
            });
          } else {
            // Follow
            await firebaseFirestore.collection('users').doc(currentUserId).update({
              'following': FieldValue.arrayUnion([targetUserId]),
            });
            await firebaseFirestore.collection('users').doc(targetUserId).update({
              'followers': FieldValue.arrayUnion([currentUserId]),
            });
          }
        }
      }
    } catch (e) {
      print('Error toggling follow status: $e');
    }
  }
}