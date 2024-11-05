import 'package:coocoo/features/Profile/domain/profile_user.dart';

abstract class SearchRepo {
  Future<List<ProfileUser>> searchUser(String query); 
}