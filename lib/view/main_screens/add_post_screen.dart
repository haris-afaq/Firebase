import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_practice/constants/app_colors.dart';
import 'package:firebase_practice/constants/components/main_button.dart';
import 'package:firebase_practice/view/main_screens/home_screen.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final textController = TextEditingController();

  // Creating Node/Table in Firebase Realtime database
  final databaseReference = FirebaseDatabase.instance.ref("Post");

  Future<void> addingPost()async{
    try{
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      
      await databaseReference.child(id).set({
                "title": textController.text.toString(),
                "id": id,
              });
              if(!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  clipBehavior: Clip.antiAlias,
                  closeIconColor: AppColors.whiteColor,
                  showCloseIcon: true,
                  backgroundColor: AppColors.greenColor,
                  content: Text("Post added successfully...",
                style: TextStyle(color: AppColors.whiteColor,
                fontSize: 12,
                fontWeight: FontWeight.w400),
                ))
              );
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
              HomeScreen()
              ));
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.redColor,
          clipBehavior: Clip.antiAlias,
          closeIconColor: AppColors.redColor,
          showCloseIcon: true,
          content: Text("Error: $e",
        style: TextStyle(color: AppColors.whiteColor,
        fontSize: 12,
        fontWeight: FontWeight.w400),
        ))
      );

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
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.firebaseOrangeColor,
        title: Text("Add Post", style: TextStyle(color: AppColors.whiteColor,
        fontSize: 18,
        fontWeight: FontWeight.w500
        ),),
        //centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.whiteColor),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30,),
            TextFormField(
              maxLines: 5,
              controller: textController,
              decoration: InputDecoration(
                hint: Text("Type here..."),
                // hintStyle: TextStyle(
                //   color: AppColors.greyColor
                // ),
                border: OutlineInputBorder(),
                
              ),
            ),
            SizedBox(height: 30,),
            MainButton(title: "Add Post", onClick: (){
              addingPost();
            }),
          ],
        ),
      ),
    );
  }
}