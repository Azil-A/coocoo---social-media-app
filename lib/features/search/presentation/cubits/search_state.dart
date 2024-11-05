import 'package:coocoo/features/Profile/domain/profile_user.dart';

abstract class SearchState {}

class SearchInitial extends SearchState{}

class SearchLoading extends SearchState{}

class SearchLoaded extends SearchState{
  final List<ProfileUser> user;

  SearchLoaded(this.user);
}

class SearchError extends SearchState{
  final String message;
  SearchError(this.message);
}
