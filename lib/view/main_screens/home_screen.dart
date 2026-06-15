import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/constants/app_colors.dart';
import 'package:firebase_practice/view/auth/login.dart';
import 'package:firebase_practice/view/main_screens/add_post_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;

  Future<void> signOut ()async{
    try{
      await auth.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.greenColor,
                closeIconColor: AppColors.whiteColor,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                showCloseIcon: true,
                content: Text("Account logged out...",
              style: TextStyle(color: AppColors.whiteColor,
              fontSize: 12,
              fontWeight: FontWeight.w400),
              ))
            );
            Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context)=>
              Login()
              ));
    }
    on FirebaseAuthException catch(e){
      String errorMessage = "Something went wrong";
      if(e.code == "auth/network-request-failed"){
        errorMessage = "Network request failed...";
      }
      else if(e.code == "auth/internal-error"){
        errorMessage = "Internal server error please try again...";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.redColor,
          clipBehavior: Clip.antiAlias,
          closeIconColor: AppColors.whiteColor,
          showCloseIcon: true,
          content: Text(errorMessage, style: TextStyle(
          color: AppColors.whiteColor,
          fontSize: 12,
          fontWeight: FontWeight.w400
        ),))
      );
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.redColor,
          clipBehavior: Clip.antiAlias,
          closeIconColor: AppColors.whiteColor,
          showCloseIcon: true,
          content: Text("Error: $e", style: TextStyle(
          color: AppColors.whiteColor,
          fontSize: 12,
          fontWeight: FontWeight.w400
        ),))
      );

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.firebaseOrangeColor,
        title: Text("Firebase", style: TextStyle(color: AppColors.whiteColor,
        fontSize: 18,
        fontWeight: FontWeight.w500
        ),),
        //centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){
            showMaterialDialoge(context);
          }, 
          icon: Icon(Icons.logout_outlined, color: AppColors.whiteColor,))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.firebaseOrangeColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(50)),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>
          AddPostScreen()
          ));
        },
        child: Icon(Icons.add, color: AppColors.whiteColor,),
        ),
    );
  }

  // alert dialoge
  void showMaterialDialoge(BuildContext context){
    showDialog(
      context: context,
       builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
          title: Text("Logout Account", 
          style: TextStyle(color: AppColors.firebaseOrangeColor, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          content: Text("Are you sure you want to logout your account?",
          style: TextStyle(color: AppColors.blackColor,
          fontSize: 12,
          fontWeight: FontWeight.w500
          ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text("Cancel",
              style: TextStyle(color: AppColors.blackColor,
              fontSize: 15,
              fontWeight: FontWeight.w500
              ),
              )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.firebaseOrangeColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(5))
                ),
                onPressed: (){
                  signOut();
                }, child: Text("Logout",
              style: TextStyle(color: AppColors.whiteColor,
              fontSize: 15,
              fontWeight: FontWeight.w500),
              ))
          ],
        );
       });
  }
}