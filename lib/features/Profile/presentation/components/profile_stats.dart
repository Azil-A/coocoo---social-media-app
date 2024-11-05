import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int postCount;
  final int followersCount;
  final int followingCount;
  final void Function()? onTap;

  const ProfileStats(
      {super.key,
      required this.postCount,
      required this.followersCount,
      required this.followingCount,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Column(
              children: [Text(postCount.toString()), Text('post')],
            ),
          ),
          SizedBox(
            width: 100,
            child: Column(
              children: [Text(followersCount.toString()), Text('follower')],
            ),
          ),
          SizedBox(
            width: 100,
            child: Column(
              children: [Text(followingCount.toString()), Text('following')],
            ),
          )
        ],
      ),
    );
  }
}
