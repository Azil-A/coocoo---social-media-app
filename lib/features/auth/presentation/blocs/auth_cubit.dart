import 'package:coocoo/features/auth/domain/entities/app_user.dart';
import 'package:coocoo/features/auth/domain/repositories/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthState {

}
class AuthInitial extends AuthState{}

class AuthLoading extends AuthState{}

class AuthAuthenicated extends AuthState{
  final AppUser? user;
  AuthAuthenicated({this.user});
}

class AuthUnAuthenicated extends AuthState{}

class AuthError extends AuthState{
  final String? message;
  AuthError(this.message);
}
//cubit 
class AuthCubit extends Cubit<AuthState>{
  final AuthRepo authRepo;
  AppUser? _currentUser;
  AuthCubit({required this.authRepo}):super(AuthInitial());
  void checkAuth() async{
  final AppUser? user = await authRepo.getCurrentUser();

  if(user !=null){
    _currentUser = user;
    emit(AuthAuthenicated(user: user));
  }
  else{
    emit(AuthUnAuthenicated());
  }

}
AppUser? get currentuser => _currentUser;

Future<void> login(String email,String password) async {
  try{
    emit(AuthLoading());
    final user = await authRepo.loginWithEmailAndPassword(email, password);
    if(user != null){
      _currentUser = user;
      emit(AuthAuthenicated(user: user));
    }
    else{
      emit(AuthUnAuthenicated());
    }
  }
  catch(e){
    emit(AuthError(e.toString()));
    emit(AuthUnAuthenicated());
  }
}
Future<void> register(String name,String email,String password) async {
  try{
    emit(AuthLoading());
    final user = await authRepo.registerWithEmailAndPassword(name ,email, password);
    if(user != null){
      _currentUser = user;
      emit(AuthAuthenicated(user: user));
    }
    else{
      emit(AuthUnAuthenicated());
    }
  }
  catch(e){
    emit(AuthError(e.toString()));
    emit(AuthUnAuthenicated());
  }
}
Future<void> logout() async{
  await authRepo.logout();
  emit(AuthUnAuthenicated());
}
}




