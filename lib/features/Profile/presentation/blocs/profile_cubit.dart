import 'dart:typed_data';

import 'package:coocoo/features/Profile/domain/profile_user.dart';
import 'package:coocoo/features/Profile/domain/repositories/profile_repo.dart';
import 'package:coocoo/features/Profile/presentation/blocs/profile_state.dart';
import 'package:coocoo/features/storage/domain/storage_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({required this.profileRepo, required this.storageRepo})
      : super(ProfileInitial());

  Future<void> FetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.FetchUserProfile(uid);
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError('user not found'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<ProfileUser?> getUserProfile(String uid) async{
    final user =  await profileRepo.FetchUserProfile(uid);
    return user;
  }

  Future<void> UpdatProfile(
      {required String uid,
      String? newBio,
      Uint8List? imageWebBytes,
      String? imageMobilePath}) async {
    emit(ProfileLoading());
    try {
      final currentUser = await profileRepo.FetchUserProfile(uid);
      if (currentUser == null) {
        emit(ProfileError('error to fetch user for profile update'));
        return;
      }

      String? imageDownloadUrl;

      if (imageWebBytes != null || imageMobilePath != null) {
        if (imageMobilePath != null) {
          imageDownloadUrl =
              await storageRepo.uploadProfileImageMobile(imageMobilePath, uid);
        } else if (imageWebBytes != null) {
          imageDownloadUrl =
              await storageRepo.uploadProfileImageWeb(imageWebBytes, uid);
        // ignore: unnecessary_null_comparison
        } else if (imageDownloadUrl == null) {
          emit(ProfileError('failed to upload image'));
          return;
        }
      }

      final UpdatedProfile =
          currentUser.copyWith(newBio: newBio ?? currentUser.bio,newProfileImageUrl:imageDownloadUrl ?? currentUser.profileImageUrl);

      await profileRepo.UpdateProfile(UpdatedProfile);

      await FetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError('Error updating profile:' + e.toString()));
    }
  }
  Future<void> toggleFollow(String currentUserId,String targetUserId)async{
    try{
      await profileRepo.toggleFollow(currentUserId, targetUserId);
      await FetchUserProfile(targetUserId);
    }
    catch(e){
      emit(ProfileError('Error toggling follow: $e'));
    }
  }
}
