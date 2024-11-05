import 'package:coocoo/features/Profile/domain/profile_user.dart';

class ProfileState{

}

class ProfileInitial extends ProfileState{}

class ProfileLoading extends ProfileState{
}

class ProfileLoaded extends ProfileState{
  final ProfileUser profileUser;
  ProfileLoaded(this.profileUser);
}

class ProfileError extends ProfileState{
  final String message;
  ProfileError(this.message);
}
