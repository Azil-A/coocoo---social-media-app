import 'package:flutter/material.dart';

class FollowButton extends StatefulWidget {
  final void Function()? onPressed;
  final bool isFollowing;

  const FollowButton({
    Key? key,
    this.onPressed,
    required this.isFollowing,
  }) : super(key: key);

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.only(top: 20,left: 20,right: 20),
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          backgroundColor: widget.isFollowing
              ? Theme.of(context).colorScheme.primary
              : Colors.blue,
          minimumSize: Size(double.infinity, 50), // Set minimum size for the button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
          ),
        ),
        child: Text(
          widget.isFollowing ? 'Unfollow' : 'Follow',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white, // Set text color to white for contrast
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}