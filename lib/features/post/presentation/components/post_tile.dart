import 'package:cached_network_image/cached_network_image.dart';
import 'package:coocoo/features/Profile/domain/profile_user.dart';
import 'package:coocoo/features/Profile/presentation/blocs/profile_cubit.dart';
import 'package:coocoo/features/Profile/presentation/components/my_text_field.dart';
import 'package:coocoo/features/Profile/presentation/pages/profile_page.dart';
import 'package:coocoo/features/auth/domain/entities/app_user.dart';
import 'package:coocoo/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:coocoo/features/post/domain/entities/comment.dart';
import 'package:coocoo/features/post/domain/entities/post.dart';
import 'package:coocoo/features/post/presentation/blocs/post_cubit.dart';
import 'package:coocoo/features/post/presentation/blocs/post_states.dart';
import 'package:coocoo/features/post/presentation/components/comment_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? inDeletePressed;

  const PostTile({super.key, required this.post, this.inDeletePressed});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  final commentTextController = TextEditingController();
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false;
  AppUser? currentUser;
  ProfileUser? postUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentuser;
    isOwnPost = widget.post.userId == currentUser!.uid;
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null && mounted) {
      // Check if widget is still mounted
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  void toggleLikePost() {
    final isLiked = widget.post.likes.contains(currentUser!.uid);
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid); // unlike
      } else {
        widget.post.likes.add(currentUser!.uid); // like
      }
    });
    postCubit
        .toggleLikePost(widget.post.id, currentUser!.uid)
        .catchError((error) {
      if (mounted) {
        // Check if widget is still mounted
        setState(() {
          if (isLiked) {
            widget.post.likes.add(currentUser!.uid); // revert unlike
          } else {
            widget.post.likes.remove(currentUser!.uid); // revert like
          }
        });
      }
    });
  }

  void openNewComment() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Add a new comment'),
              content: MyTextField(
                  controller: commentTextController,
                  hintText: 'type a comment',
                  obscureText: false),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      addComment();
                      Navigator.of(context).pop();
                    },
                    child: Text('Add comment'))
              ],
            ));
  }

  void addComment() {
    final newComment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        postId: widget.post.id,
        userId: currentUser!.uid,
        userName: currentUser!.name,
        text: commentTextController.text,
        timeStamp: DateTime.now());

    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    commentTextController.dispose();
    super.dispose();
  }

  void showOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Post?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.inDeletePressed!();
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          GestureDetector(
            onTap:()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage(uid: widget.post.userId))),
            child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                postUser?.profileImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: postUser!.profileImageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                        imageBuilder: (context, ImageProvider) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: ImageProvider, fit: BoxFit.cover),
                          ),
                        ),
                      )
                    : const Icon(Icons.person),
                SizedBox(width: 10),
                Text(
                  widget.post.userName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                if (isOwnPost)
                  GestureDetector(
                    onTap: showOptions,
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
          ),
          GestureDetector(
            onDoubleTap: toggleLikePost,
            child: CachedNetworkImage(
              imageUrl: widget.post.imageUrl,
              height: 430,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => const SizedBox(height: 430),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: Icon(
                          widget.post.likes.contains(currentUser!.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.post.likes.contains(currentUser!.uid)
                              ? Colors.red
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        widget.post.likes.length.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                    onTap: openNewComment,
                    child: Icon(
                      Icons.comment,
                      color: Theme.of(context).colorScheme.primary,
                    )),
                SizedBox(width: 5),
                Text(widget.post.comments.length.toString()),
                Spacer(),
                Text(
                  widget.post.timestamp.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Divider(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Row(
              children: [
                Text(widget.post.userName,style: TextStyle(fontWeight:FontWeight.bold),),
                SizedBox(width: 10,),
                Text(widget.post.text),
            
              ],
            ),
          ),
          BlocBuilder<PostCubit,PostState>(builder: (context,state){
            if(state is PostsLoaded){
              final post = state.posts.firstWhere((post)=>(post.id==widget.post.id));
              if(post.comments.isNotEmpty){
                int showCommentCount = post.comments.length;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: showCommentCount,
                  itemBuilder: (context,index){
                    final comment = post.comments[index];
                  return CommentTile(comment: comment);
                });
              }
            }
            if(state is PostsLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            else if(state is PostsError){
              return Center(child: Text(state.message),);
            }
            else{
              return SizedBox();
            }
          }
          )
        ],
      ),
    );
  }
}
