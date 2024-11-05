
import 'package:coocoo/features/Profile/presentation/components/user_tile.dart';
import 'package:coocoo/features/search/presentation/cubits/search_cubit.dart';
import 'package:coocoo/features/search/presentation/cubits/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();
  void onSearchChanged(){
    final query = searchController.text;
    searchCubit.SearchUsers(query);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.addListener(onSearchChanged);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search users...',
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary)
      ),
        
      ),),
      body: BlocBuilder<SearchCubit,SearchState>(builder: (context,state){
        if(state is SearchLoaded){
          if(state.user.isEmpty){
            return Center(child: Text('No users found'),);
          }
          return ListView.builder(
            itemCount: state.user.length,
            itemBuilder: (context,index){
              final user = state.user[index];
              return UserTile(user: user);
            });
        }
        else if(state is SearchLoading){
          return CircularProgressIndicator();
        }
        else if(state is SearchError){
          return Center(child: Text(state.message),);
        }
        return Center(child: Text('Start Search for Users'),);
      }),
    );
  }
}