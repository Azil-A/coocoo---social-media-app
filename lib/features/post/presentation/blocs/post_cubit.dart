import 'package:coocoo/features/post/domain/entities/comment.dart';
import 'package:coocoo/features/post/domain/entities/post.dart';
import 'package:coocoo/features/post/domain/repos/pos_repos.dart';
import 'package:coocoo/features/post/presentation/blocs/post_states.dart';
import 'package:coocoo/features/storage/domain/storage_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:typed_data';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit({
    required this.postRepo,
    required this.storageRepo,
  }) : super(PostsInitial());

  // Create a new post
  Future<void> createPost(Post post, {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;

    try {
      // Handle image upload for mobile platforms (using file path)
      if (imagePath != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadProfileImageMobile(imagePath, post.id);
      }
      // Handle image upload for web platforms (using file bytes)
      else if (imageBytes != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadProfileImageWeb(imageBytes, post.id);
      }

      // Give image URL to post
      final newPost = post.copyWith(imageUrl: imageUrl);
      await postRepo.createPost(newPost);

      fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to create post: $e"));
    }
  }

  // Fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError("Failed to fetch posts: $e"));
    }
  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {
      emit(PostsError("Failed to delete post: $e"));
    }
  }
  Future<void> toggleLikePost(String postId ,String userId)async{
    try{
      await postRepo.ToggleLikePost(postId, userId);
    }
    catch(e){
      emit(PostsError('failed to toggle like : $e'));
    }
  }
Future<void> addComment(String postId ,Comment comment)async{
    try{
      await postRepo.addComment(postId, comment);
      await fetchAllPosts();
    }
    catch(e){
      emit(PostsError('failed to add comment : $e'));
    }
  }
  Future<void> delteComment(String postId ,String commentId)async{
    try{
      await postRepo.deleteComment(postId, commentId);
      await fetchAllPosts();
    }
    catch(e){
      emit(PostsError('failed to delete comment : $e'));
    }
  }
  
}