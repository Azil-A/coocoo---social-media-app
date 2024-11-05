import 'dart:io';
import 'dart:typed_data';
import 'package:coocoo/features/Profile/presentation/components/my_text_field.dart';
import 'package:coocoo/features/auth/domain/entities/app_user.dart';
import 'package:coocoo/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:coocoo/features/post/domain/entities/post.dart';
import 'package:coocoo/features/post/presentation/blocs/post_cubit.dart';
import 'package:coocoo/features/post/presentation/blocs/post_states.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  PlatformFile? imagePickedFile;
  Uint8List? webImage;
  final textController = TextEditingController();
  AppUser? currentUser; 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentUser();
    
  }

  void getCurrentUser(){
    final authCubit =context.read<AuthCubit>();
    currentUser = authCubit.currentuser;
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: kIsWeb);

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }
  void uploadPost(){
    if(imagePickedFile == null || textController.text.isEmpty){
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(const SnackBar(content: Text('Both image and caption are required')));
    }
    final newPost = Post(id: DateTime.now().millisecond.toString(), 
    userId: currentUser!.uid,
     userName: currentUser!.name,
      text: textController.text,
       imageUrl: '',
        timestamp:DateTime.now(),
        likes: [],
        comments: []);
        
        print('current user name :'+currentUser!.email);


  final postCubit = context.read<PostCubit>();
  if(kIsWeb){
    postCubit.createPost(newPost,imageBytes: imagePickedFile?.bytes);
  }      
  else{
    postCubit.createPost(newPost,imagePath: imagePickedFile?.path);
  }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textController.dispose();
    super.dispose();

  }



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder:(context, state) {
        if(state is PostsLoading || state is PostUploading){
          return Scaffold(
            body: Center(child: CircularProgressIndicator(),),
          );
        }
        return BuildUploadPage();
      },
      listener: (context,state){
        if(state is PostsLoaded){
          Navigator.pop(context);
        }
      },
    );
  }
  Widget BuildUploadPage(){
    return Scaffold(
      appBar: AppBar(title:const Text('Creat post'),
      foregroundColor: Theme.of(context).colorScheme.primary,
      actions: [
        IconButton(onPressed: uploadPost, icon: Icon(Icons.upload)),
        IconButton(onPressed: (){
          print('current init :'+currentUser!.name);
        }, icon: Icon(Icons.textsms))
      ],),
      body: Center(child: Column(
        children: [
          if(kIsWeb && webImage != null)
          Image.memory(webImage!),
          if(!kIsWeb && imagePickedFile != null)
          Image.file(File(imagePickedFile!.path!)),

          MaterialButton(onPressed: pickImage,child: Text('Pick Image'),color:Colors.blue,),
          MyTextField(controller: textController, hintText: 'captions', obscureText: false)
        ],
      ),),
    );
  }
}