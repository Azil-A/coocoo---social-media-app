
import 'package:coocoo/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;
  final List<String> followers;
  final List<String> following;

  ProfileUser(
      {
        required this.followers,
        required this.following,
        required this.bio,
      required this.profileImageUrl,
      required super.uid,
      required super.name,
      required super.email});

  ProfileUser copyWith({String? newBio,
   String? newProfileImageUrl,
   List<String>? newFollowers,
   final List<String>? newFollowing,
   }) {

    return ProfileUser(
        bio: newBio ?? bio,
        profileImageUrl: newProfileImageUrl ?? profileImageUrl,
        uid: uid,
        name: name,
        email: email,
        followers: newFollowers ?? followers,
        following: newFollowing ?? following);
  }

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      bio: json['bio'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      followers:List<String>.from(json['followers'] ?? []),
      following:List<String>.from(json['following'] ?? []),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio ,
      'profileImageUrl': profileImageUrl,
      'uid': uid,
      'name': name,
      'email': email,
      'followers':followers,
      'following':following
    };
  }

}
