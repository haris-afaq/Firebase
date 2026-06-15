import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/constants/app_colors.dart';
import 'package:firebase_practice/constants/components/main_button.dart';
import 'package:firebase_practice/view/auth/create_account.dart';
import 'package:firebase_practice/view/main_screens/home_screen.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  // Login Function
  Future<void> loginAccount () async{
    try{
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
         password: passwordController.text.trim());
         if(!mounted) return;
         ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(
            backgroundColor: AppColors.greenColor,
            clipBehavior: Clip.antiAlias,
            closeIconColor: AppColors.whiteColor,
            showCloseIcon: true,
            content: Text("Account logged in successfully...",
           style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          )),
         );
         Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context)=>
          HomeScreen()
          ));
    }
    on FirebaseAuthException catch(e){
      String errorMessage = "Something went wrong...";
      if(e.code == "invalid-email"){
        errorMessage = "Invalid email please enter a valid one...";
      }
      else if(e.code == "user-not-found"){
        errorMessage = "User not found..."; 
      }
      else if(e.code == "invalid-credential"){
        errorMessage = "Invalid credentials...";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.redColor,
          clipBehavior: Clip.antiAlias,
          closeIconColor: AppColors.whiteColor,
          showCloseIcon: true,
          content: Text(errorMessage, 
        style: TextStyle(
          color: AppColors.whiteColor,
          fontSize: 12,
          fontWeight: FontWeight.w400
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
          content: Text("Error $e",
        style: TextStyle(
          color: AppColors.whiteColor,
          fontSize: 12,
          fontWeight: FontWeight.w400
        ),
        ))
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Image(
              
              image: AssetImage("assets/images/login.png")),
            Form(
              key: _formKey,
              child:  Column(
                children: [
                 
                              TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Email"),
                prefixIcon: Icon(Icons.email_outlined)
              ),
              validator: (value){
                if(value!.isEmpty){
                  return "Email is required field";
                }
                else{
                  return null;
                }
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              obscureText: true,
              obscuringCharacter: "*",
              controller: passwordController,
              // keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Password"),
                prefixIcon: Icon(Icons.lock_outline)
              ),
              validator: (value){
                if(value!.isEmpty){
                  return "Password is required field";
                }
                else{
                  return null;
                }
              },
            ),
                ],
              )),
              SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Forgot Password?",
                style: TextStyle(color: AppColors.firebaseOrangeColor,
                fontSize: 15, fontWeight: FontWeight.w500),
                )
              ],
            ),

            SizedBox(height: 30,),
            MainButton(title: "Login", onClick: (){
              if(_formKey.currentState!.validate()){
                loginAccount();
              };

            }),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                  CreateAccount()
                  ));
                }, child: Text("Create Account",
                style: TextStyle(color: AppColors.firebaseOrangeColor,
                fontSize: 15, fontWeight: FontWeight.w500),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}