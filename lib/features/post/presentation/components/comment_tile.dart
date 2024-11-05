import 'package:coocoo/features/auth/domain/entities/app_user.dart';
import 'package:coocoo/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:coocoo/features/post/domain/entities/comment.dart';
import 'package:coocoo/features/post/presentation/blocs/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();

  
}

class _CommentTileState extends State<CommentTile> {
  AppUser? currentUser;
  bool isOwnPost = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser(){
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentuser;
    isOwnPost = widget.comment.userId == currentUser?.uid;
  }
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Comment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<PostCubit>().delteComment(widget.comment.postId, widget.comment.id);
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
    return Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Text(widget.comment.userName,style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(width: 5,),
                        Text(widget.comment.text),
                        Spacer(),
                        if(isOwnPost) GestureDetector(
                          onTap:showOptions ,
                          child: Icon(Icons.more_horiz,color: Theme.of(context).colorScheme.primary,))

                        
                      ],
                    ),
                  );
  }
}