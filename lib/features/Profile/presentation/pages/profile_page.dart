import 'package:cached_network_image/cached_network_image.dart';
import 'package:coocoo/features/Profile/presentation/blocs/profile_cubit.dart';
import 'package:coocoo/features/Profile/presentation/blocs/profile_state.dart';
import 'package:coocoo/features/Profile/presentation/components/bio_box.dart';
import 'package:coocoo/features/Profile/presentation/components/follow_button.dart';
import 'package:coocoo/features/Profile/presentation/components/profile_stats.dart';
import 'package:coocoo/features/Profile/presentation/pages/edit_profile.dart';
import 'package:coocoo/features/Profile/presentation/pages/follower_page.dart';
import 'package:coocoo/features/auth/domain/entities/app_user.dart';
import 'package:coocoo/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:coocoo/features/post/presentation/blocs/post_cubit.dart';
import 'package:coocoo/features/post/presentation/blocs/post_states.dart';
import 'package:coocoo/features/post/presentation/components/post_tile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final authcubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  late AppUser? currentUser = authcubit.currentuser;

  int postCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileCubit.FetchUserProfile(widget.uid);
    
  }

  void followButtonPressed(){
    final profileState = profileCubit.state;
    if(profileState is! ProfileLoaded){
      return;
    }
    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(currentUser!.uid);

    setState(() {
      //unfollow
      if(isFollowing){
        profileUser.followers.remove(currentUser!.uid);
      }
      //follow
      else{
        profileUser.followers.add(currentUser!.uid);
      }
    });
    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error){
      setState(() {
      //unfollow
      if(isFollowing){
        profileUser.followers.add(currentUser!.uid);
      }
      //follow
      else{
        profileUser.followers.remove(currentUser!.uid);
      }
    });

    }); 
  
  }
  @override
  Widget build(BuildContext context) {
    bool isOwnPost = (widget.uid == currentUser!.uid);
    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      if (state is ProfileLoaded) {
        // context.read<PostCubit>().(uid);
        final user = state.profileUser;
        return Scaffold(
          appBar: AppBar(
            title: Text(user.name),
            foregroundColor: Theme.of(context).colorScheme.primary,
            actions: [
              if(isOwnPost)
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfile(user: user)));
                  },
                  icon: Icon(Icons.settings))
            ],
          ),
          body: ListView(
            children: [
              Center(
                child: Text(
                  user.email,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              CachedNetworkImage(
                  imageUrl: user.profileImageUrl,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, Error) => Icon(
                        Icons.person,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  imageBuilder: (context, imageProvider) => Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover)),
                      )),
                      SizedBox(height: 15,),
              ProfileStats(postCount: postCount, followersCount: user.followers.length, followingCount: user.following.length
              
              ,onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FollowerPage(
                followers: user.followers,
                followings: user.following
              ))); },),

                      if(!isOwnPost)
                    FollowButton(isFollowing: user.followers.contains(currentUser!.uid) ,onPressed: followButtonPressed,),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    Text(
                      'Bio',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              BioBox(text: user.bio),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    Text('Posts',style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),),     
                  ],
                ),
              ),
              SizedBox(height: 10,),
              BlocBuilder<PostCubit,PostState>(builder: (context , state){
                              if(state is PostsLoaded){
                                final userPost = state.posts.where((post)=>(post.userId == widget.uid)).toList();
                                postCount = userPost.length;
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: postCount,
                                  itemBuilder: (context,index){
                                    final post = userPost[index];
                                    return PostTile(post: userPost[index],inDeletePressed: ()=>context.read<PostCubit>().deletePost(post.id),);
                                  });
                              }
                              else if(state is PostsLoading){
                                return Center(child: CircularProgressIndicator(),);
                              }
                              else{
                                return Center(child: Text('No posts..'),);
                              }
                            },) 
            ],
          ),
        );
      } else if (state is ProfileLoading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return const Center(
          child: Text('no profile found'),
        );
      }
    });
  }
}
