import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );


  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign in with Email and Password
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Save user to Firestore if not already present
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));


      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Failed to sign in with email and password.");
    }
  }

  // Sign up with Email and Password
  Future<UserCredential> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Save new user to Firestore
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Failed to sign up with email and password.");
    }
  }

  // Google Sign-In
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Force the account selection prompt
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception("Google Sign-In was cancelled by the user.");
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Save user to Firestore
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': userCredential.user!.email,
      }, SetOptions(merge: true));

      return userCredential;
    } catch (e) {
      throw Exception("Google Sign-In failed: ${e.toString()}");
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      // Sign out from both Firebase and Google
      await _auth.signOut();
      await _googleSignIn.signOut();

    } catch (e) {
      throw Exception("Failed to sign out: ${e.toString()}");
    }
  }


}
