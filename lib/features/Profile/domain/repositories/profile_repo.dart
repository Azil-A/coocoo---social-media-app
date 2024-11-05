import 'package:coocoo/features/Profile/domain/profile_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser?> FetchUserProfile(String uid);
  Future<void> UpdateProfile(ProfileUser UpdateProfile);
  Future<void> toggleFollow(String currentUserId , String targetUserId);
  }
  