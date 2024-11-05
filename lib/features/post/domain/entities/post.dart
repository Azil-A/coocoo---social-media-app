import 'package:coocoo/features/post/domain/entities/comment.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timestamp;
  final List<String>likes;
  final List<Comment>comments;

  // Constructor
  Post({
    required this.likes,
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.imageUrl,
    required this.timestamp,
    required this.comments
  });

  // CopyWith method
  Post copyWith({String? imageUrl}) {
    return Post(
      id: id,
      userId: userId,
      userName: userName,
      text: text,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp,
      likes: likes,
      comments: comments
    );
  }

  // Convert post to JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(), // Convert DateTime to String
      'likes':likes,
      'comments':comments.map((comment)=>comment.toJson()).toList(),
    };
  }




  // Optional: Factory method to create a Post from JSON
  factory Post.fromJson(Map<String, dynamic> json) {

    //prepare the comments
    List<Comment> comments = (json['comments'] as List<dynamic>?)
    ?.map((commentJson) => Comment.fromJson(commentJson))
    .toList() ?? []; // Default to an empty list if null
    //    
    return Post(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      text: json['text'],
      imageUrl: json['imageUrl'],
      timestamp: DateTime.parse(json['timestamp']), // Convert String back to DateTime
      likes :List<String>.from(json['likes'] ?? []),
      comments: comments
    );
  }
}