import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  AuthRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> get authStateChange => _auth.authStateChanges();

  Future<Either<String, bool>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user != null) {
        return const Right(true);
      } else {
        return const Left("Error encountered when signing in user");
      }
      // if (userCredential.user!.emailVerified) {

      // } else {
      //   return const Left("Kindly verify your email address");
      // }
    } on FirebaseAuthException catch (e) {
      return Left(e.message!);
    }
  }

  Future<Either<String, String>> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null && userCredential.user!.uid.isNotEmpty) {
        // final user = userCredential.user;
        // user?.sendEmailVerification();
        return Right(userCredential.user!.uid);
      } else {
        return const Left("Error encountered when signing up");
      }
    } on FirebaseAuthException catch (e) {
      return Left(e.message!);
    }
  }
}
