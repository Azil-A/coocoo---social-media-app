import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coocoo/features/Profile/domain/profile_user.dart';
import 'package:coocoo/features/search/domain/search_repo.dart';

class FirebaseSearchRepo implements SearchRepo{
  @override
  Future<List<ProfileUser>> searchUser(String query) async{
    // TODO: implement searchUser
    try{
      final result = await FirebaseFirestore.instance.collection('users').
      where('name',isGreaterThanOrEqualTo: query).
      where('name',isLessThanOrEqualTo: '$query\uf8ff').get();
      return result.docs.map((doc)=>  ProfileUser.fromJson(doc.data())).toList();
    }
    catch(e){
      throw Exception('error on searching users:$e');
    }
  }
}