import 'package:aft/ATESTS/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {


   Future<User?> googleLogin() async {
    // String res = "Some error occured";
    // String res1 = "Some error occured";

     final checkUser= FirebaseAuth.instance.currentUser;
print("here");

    final GoogleSignIn googleSignIn = GoogleSignIn();
     if(checkUser !=null)
     {
       googleSignIn.signOut();


     }




    //User? _user;
    final GoogleSignInAccount? googleUser =
    await googleSignIn.signIn();

    if (googleUser == null) return null;
   // _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =   await FirebaseAuth.instance.signInWithCredential(credential);


    notifyListeners();
    return userCredential.user!;


  }
}
