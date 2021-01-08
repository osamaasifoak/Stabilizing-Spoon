import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseServices {
  FirebaseAuth auth = FirebaseAuth.instance;

  register({@required String email, @required String password}) async {
    try {
      final UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e;
    }
  }

  signIn({@required String email, @required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e;
    }
  }

  forgotPassword({@required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
