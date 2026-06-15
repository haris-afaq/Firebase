import 'package:firebase_practice/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.firebaseOrangeColor,
        title: Text("Post List", style: TextStyle(color: AppColors.whiteColor,
        fontSize: 18,
        fontWeight: FontWeight.w500
        ),),
        //centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.whiteColor),
        automaticallyImplyLeading: true,
      ),
    );
  }
}