import 'package:coocoo/features/Profile/presentation/blocs/profile_cubit.dart';
import 'package:coocoo/features/Profile/presentation/components/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> followings;

  const FollowerPage(
      {super.key, required this.followers, required this.followings});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              labelColor: Theme.of(context).colorScheme.inversePrimary,
              unselectedLabelColor: Theme.of(context).colorScheme.primary,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: 'Followers'),
                Tab(
                  text: 'Followings',
                )
              ],
            ),
          ),
          body: TabBarView(children: [
            _buildUserList(followers, 'No Followers', context),
            _buildUserList(followings, 'No Follwings', context)
          ]),
        ));
  }

  Widget _buildUserList(
      List<String> uids, String emptyMessage, BuildContext context) {
    return uids.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
            itemCount: uids.length,
            itemBuilder: (context, index) {
              final uid = uids[index];
              return FutureBuilder(
                future: context.read<ProfileCubit>().getUserProfile(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(title: Text('Waiting...'));
                  } else if (snapshot.hasData) {
                    final user = snapshot.data!;
                    return UserTile(user: user);
                  } else {
                    return ListTile(title: Text('User not found'));
                  }
                },
              );
            },
          );
  }
}
