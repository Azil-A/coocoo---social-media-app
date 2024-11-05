   import 'package:coocoo/features/search/domain/search_repo.dart';
import 'package:coocoo/features/search/presentation/cubits/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchState>{

  final SearchRepo searchRepo;
  
  SearchCubit({required this.searchRepo}) : super(SearchInitial());

  Future<void> SearchUsers(String query) async {
    if(query.isEmpty){
      emit(SearchInitial());
      return;
    }
    try{
      emit(SearchLoading());
      final users = await searchRepo.searchUser(query);
      emit(SearchLoaded(users));
    }
    catch(e){
      emit(SearchError('error loading search results'));
    }
  }

   }    