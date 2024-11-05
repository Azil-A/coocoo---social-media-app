import 'package:coocoo/features/post/domain/entities/comment.dart';
import 'package:coocoo/features/post/domain/entities/post.dart';

/// Abstract class representing a repository for managing posts.
abstract class PostRepo {
  /// Fetches all posts.
  Future<List<Post>> fetchAllPosts();

  /// Creates a new post.
  Future<void> createPost(Post post);

  /// Deletes a post by its ID.
  Future<void> deletePost(String postId);

  /// Fetches posts created by a specific user.
  Future<List<Post>> fetchPostsByUserId(String userId);

  Future<void> ToggleLikePost(String postId , String userId);

  Future<void> addComment(String postId , Comment comment);

  Future<void> deleteComment(String postId , String commentId);


}