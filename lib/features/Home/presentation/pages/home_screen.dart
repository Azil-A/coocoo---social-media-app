
import 'package:coocoo/features/Home/presentation/components/my_drawer.dart';
import 'package:coocoo/features/post/presentation/components/post_tile.dart';
import 'package:coocoo/features/post/presentation/blocs/post_cubit.dart';
import 'package:coocoo/features/post/presentation/blocs/post_states.dart';
import 'package:coocoo/features/post/presentation/pages/upload_post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final postCubit = context.read<PostCubit>();
  final textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllPost();

  }

  void fetchAllPost() {
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Explore'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UploadPostPage()));
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: BlocBuilder<PostCubit, PostState>(builder: (context, state) {
        if (state is PostsLoading && state is PostUploading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PostsLoaded) {
          final allposts = state.posts;
          if (allposts.isEmpty) {
            return Center(
              child: Text('No posts available'),
            );
          }
          return ListView.builder(
              itemCount: allposts.length,
              itemBuilder: (context, index) {
                final post = allposts[index];
                return PostTile(post: post,inDeletePressed: (){deletePost(post.id);},);
              });
        }
        else if(state is PostsError){
          return Center(child: Text(state.message),);
        }
        else{
          return SizedBox(
          );
        }
      }),
    );
  }
}
