import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_practice/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  // creating instance of Firebase database node
  final databaseReference = FirebaseDatabase.instance.ref("Post");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.firebaseOrangeColor,
        title: Text(
          "Post List",
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.whiteColor),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                query: databaseReference,
                defaultChild: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.firebaseOrangeColor,
                    strokeWidth: 3,
                  ),
                ),
                itemBuilder: (context, snapshot, animation, index) {
                  return ListTile(
                    title: Text(
                      snapshot.child("title").value.toString(),
                    ),
                    subtitle: Text(
                      snapshot.child("id").value.toString(),
                    ),
                  );
                },
              ),
            ),

            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: databaseReference.onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.firebaseOrangeColor,
                        strokeWidth: 3,
                      ),
                    );
                  }

                  if (snapshot.data?.snapshot.value == null) {
                    return Text(
                      "No data available...",
                      style: TextStyle(
                        color: AppColors.greyColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }

                  Map<dynamic, dynamic> map =
                      snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

                  List<dynamic> list = map.values.toList();

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          list[index]['title'].toString(),
                        ),
                        subtitle: Text(list[index]['id'].toString()),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}