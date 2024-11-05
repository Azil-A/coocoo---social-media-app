import 'package:coocoo/features/Home/presentation/components/drawer_tile.dart';
import 'package:coocoo/features/Profile/presentation/pages/profile_page.dart';
import 'package:coocoo/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:coocoo/features/search/presentation/pages/search_page.dart';
import 'package:coocoo/features/settings/pages/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
            DrawerTile(
              icon: Icons.home,
              title: 'H O M E',
              ontap: () {
                Navigator.of(context).pop();
              },
            ),
            DrawerTile(
              icon: Icons.person,
              title: 'P R O F I L E',
              ontap: () async{
                Navigator.of(context).pop();
                // Navigator.of(context).popAndPushNamed('/profile');
                final user = context.read<AuthCubit>().currentuser;
                String? uid = user!.uid;
                Navigator.push(context,MaterialPageRoute(builder: (context)=>ProfilePage(uid: uid)));
              },
            ),
            DrawerTile(
              icon: Icons.search,
              title: 'S E A R C H',
              ontap: (){
                Navigator.of(context).pop();
                Navigator.push(context,MaterialPageRoute(builder: (context)=>SearchPage()));
              }),
            
            DrawerTile(
              icon: Icons.settings,
              title: 'S E T T I N G S',
              ontap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>SettingPage()),)
            ),
            Spacer(),
            DrawerTile(
              icon: Icons.logout,
              title: 'L O G O U T',
              ontap: () {
                context.read<AuthCubit>().logout();
              },
            ),
          ],
        ),
      )),
    );
  }
}
