import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_practice/constants/app_colors.dart';
import 'package:firebase_practice/view/auth/login.dart';
import 'package:firebase_practice/view/firebase_realtime_database/add_post_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    // creating instance of Firebase database node
    final databaseReference = FirebaseDatabase.instance.ref("Post");
    final auth = FirebaseAuth.instance;
    final editPostController = TextEditingController();


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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              defaultChild: Center(
                child: CircularProgressIndicator(color: AppColors.firebaseOrangeColor,
                strokeWidth: 3,),
              ),
              query: databaseReference, 
              itemBuilder: (context, snapshot, animation,index){
                String title =snapshot.child("title").value.toString();
                return ListTile(
                  title: Text(title),
                  subtitle: Text(snapshot.child("id").value.toString()),
                  trailing: PopupMenuButton(
                    color: AppColors.whiteColor,
                    icon: Icon(Icons.more_vert, color: AppColors.greyColor,),
                    itemBuilder: (context)=>[
                      // Edit Icon
                      PopupMenuItem(
                        value: 1,
                        onTap: (){
                         editPostDialoge(title, snapshot.child("id").value.toString());
                        },
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text("Edit"),
                        )),
                        PopupMenuItem(
                          value: 2,
                          onTap: () async{
                            try{
                              // the only line to delete data from firebase real time database...
                              await databaseReference.child(snapshot.child("id").value.toString()).remove();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.greenColor,
                                  clipBehavior: Clip.antiAlias,
                                  closeIconColor: AppColors.whiteColor,
                                  showCloseIcon: true,
                                  content: Text("Post deleted successfully...",
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12
                                ),
                                ))
                              );
                            }
                            catch(e){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.redColor,
                                  clipBehavior: Clip.antiAlias,
                                  closeIconColor: AppColors.whiteColor,
                                  showCloseIcon: true,
                                  content: Text("Error: $e",
                                style: TextStyle(color: AppColors.whiteColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400
                                ),
                                ))
                              );
                            }
                          },
                          child: ListTile(
                            leading: Icon(Icons.delete, color: AppColors.redColor,),
                            title: Text("Delete"),
                          ))
                    ])
                );
                
              })),
      ],),
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

  // Logout Dialog Box
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

  // Edit Post Dialoge Box

  Future<void> editPostDialoge(String title, String id) async{
    editPostController.text = title;
    return showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10)
          ),
          title: Text("Edit Post",
          style: TextStyle(color: AppColors.firebaseOrangeColor, 
          fontSize: 18,
          fontWeight: FontWeight.w600
          ),
          ),
          content: Container(
            child: TextFormField(
              controller: editPostController,
              decoration: InputDecoration(
                hint: Text("Edit post...")
              ),
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
                onPressed: () async {
  try {
    await databaseReference.child(id).update({
      "title": editPostController.text.trim(),
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.greenColor,
        content: Text(
          "Post updated successfully",
          style: TextStyle(color: AppColors.whiteColor),
        ),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.redColor,
        content: Text(
          "Failed to update: $e",
          style: TextStyle(color: AppColors.whiteColor),
        ),
      ),
    );
  }
}, 
                child: Text("Save",
              style: TextStyle(color: AppColors.whiteColor,
              fontSize: 15,
              fontWeight: FontWeight.w500),
              ))
          ],
        );
      });
  }

}




// Stream Builder

//  Expanded(
//                 child: StreamBuilder<DatabaseEvent>(
//                   stream: databaseReference.onValue, 
//                   builder: (context, snapshot){
//                     if(!snapshot.hasData){
//                       return Center(
//                         child: CircularProgressIndicator(
//                           color: AppColors.firebaseOrangeColor,
//                           strokeWidth: 3,
//                         ),
//                       );
//                     }
//                     else if(snapshot.data?.snapshot.value == null){
//                       return Center(
//                         child: Text("No data found in database..."),
//                       );
//                     }
//                     else{
//                       Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//                       List<dynamic> list = map.values.toList();
//                       return ListView.builder(
//                         itemCount: list.length,
//                         itemBuilder: (context, index){
//                           return ListTile(
//                             title: Text(list[index]["title"].toString()),
//                           );
//                         });
//                     }
//                   }),
//               ),