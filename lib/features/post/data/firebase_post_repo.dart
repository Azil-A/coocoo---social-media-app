import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coocoo/features/post/domain/entities/comment.dart';
import 'package:coocoo/features/post/domain/entities/post.dart';
import 'package:coocoo/features/post/domain/repos/pos_repos.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // Store the posts in a collection called 'posts'
  final CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');

  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error creating post: $e");
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await postsCollection.doc(postId).delete();
    } catch (e) {
      throw Exception("Error deleting post: $e");
    }
  }

  Future<List<Post>> fetchAllPosts() async {
    try {
      // Get all posts with the most recent posts at the top
      final postsSnapshot = await postsCollection.orderBy('timestamp', descending: true).get();
      
      // Convert each Firestore document from JSON -> list of posts
      final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      
      return allPosts;
    } catch (e) {
      throw Exception("Error fetching posts: $e");
    }
  }

  Future<List<Post>> fetchPostsByUserId(String userId) async {
    try {
      // Fetch posts snapshot with this user ID
      final postsSnapshot = await postsCollection.where('userId', isEqualTo: userId).get();

      // Convert Firestore documents to list of Posts
      final List<Post> userPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return userPosts;
    } catch (e) {
      throw Exception("Error fetching posts by user: $e");
    }
  }
  @override
  Future<void> ToggleLikePost(String postId, String userId) async{
    // TODO: implement ToggleLikePost
    try{
      final postDoc = await postsCollection.doc(postId).get();
      if(postDoc.exists){
        final post = Post.fromJson(postDoc.data() as Map<String,dynamic>);
        final hasLiked = post.likes.contains(userId);

        if(hasLiked){
          post.likes.remove(userId);

        }
        else{
          post.likes.add(userId);

        }
        await postsCollection.doc(postId).update({'likes':post.likes});
      }
      else{
        throw Exception('post not found');
      }
    }
    catch(e){
      throw Exception('error toggling like : $e');
    }
  }
  @override
  Future<void> addComment(String postId, Comment comment) async{
    try{
      final postDoc = await postsCollection.doc(postId).get();
      if(postDoc.exists){
        final post = Post.fromJson(postDoc.data() as Map<String , dynamic>);
        post.comments.add(comment);
        await postsCollection.doc(postId).update({
          "comments":post.comments.map((comment)=>comment.toJson()).toList(),

        });
      }
      else {
        throw Exception('post not found');
      }

    }
    catch(e){
      throw Exception('errror on adding comment :'+e.toString() );
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async{
    // TODO: implement deleteComment
    try{
      final postDoc = await postsCollection.doc(postId).get();
      if(postDoc.exists){
        final post = Post.fromJson(postDoc.data() as Map<String , dynamic>);
        post.comments.removeWhere((comment)=>comment.id == commentId);
        await postsCollection.doc(postId).update({
          "comments":post.comments.map((comment)=>comment.toJson()).toList(),

        });
      }
      else {
        throw Exception('post not found');
      }

    }
    catch(e){
      throw Exception('errror on deleting comment :'+e.toString() );
    }
  }
}

