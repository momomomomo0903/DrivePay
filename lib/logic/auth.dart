// ignore_for_file: non_constant_identifier_names, deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivepay/UI/auth/auth.dart';
import 'package:drivepay/UI/auth/auth_status.dart';
import 'package:drivepay/UI/fotter_menu.dart';
import 'package:drivepay/logic/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthLogout {
  static Future<void> LogoutLogic(WidgetRef ref, BuildContext context) async {
    DB.TimeStampWrite(ref, "ログアウト");
    await FirebaseAuth.instance.signOut();
    ref.read(isLoginProvider.notifier).state = false;
    ref.read(isGoogleLoginProvider.notifier).state = false;
    ref.read(isMailLoginProvider.notifier).state = false;
    ref.read(userIdProvider.notifier).state = "ログインしてください";
    ref.read(userNameProvider.notifier).state = "ゲスト";
    ref.read(eMailProvider.notifier).state = "ログインしてください";
    AuthUI.logout(context);
  }
}

class AuthSignin {
  static Future<String?> SigninLogic(
    WidgetRef ref,
    BuildContext context,
    String password,
  ) async {
    final loginEmail = ref.watch(eMailProvider);
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: loginEmail,
        password: password,
      );
      ref.read(userIdProvider.notifier).state = userCredential.user!.uid;
      ref.read(isMailLoginProvider.notifier).state = true;

      // firestoreに書き込み
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'username': ref.watch(userNameProvider),
        'email': loginEmail,
        'mailLogin': true,
        'GoogleLogin': false,
        'updateDate': FieldValue.serverTimestamp(),
      });

      DB.TimeStampWrite(ref, 'サインイン');
      ref.read(isLoginProvider.notifier).state = true;
    } catch (e) {
      ref.read(userNameProvider.notifier).state = "ゲスト";
      ref.read(eMailProvider.notifier).state = "ログインしてください";
      return e.toString();
    }
    return null;
  }
}

class AuthLogin {
  static Future<String?> LoginLogic(
    WidgetRef ref,
    BuildContext context,
    String password,
  ) async {
    final loginEmail = ref.watch(eMailProvider);
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCred = await auth.signInWithEmailAndPassword(
        email: loginEmail,
        password: password,
      );
      ref.read(userIdProvider.notifier).state = userCred.user!.uid.toString();
      DB.dataBaseWatch(ref);
      DB.TimeStampWrite(ref, 'ログイン');
      ref.read(isLoginProvider.notifier).state = true;
    } catch (e) {
      ref.read(eMailProvider.notifier).state = "ログインしてください";
      return e.toString();
    }
    return null;
  }
}

class GoogleSignin {
  static Future<void> signInWithGoogle(
    WidgetRef ref,
    BuildContext context,
  ) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        forceCodeForRefreshToken: true,
      );
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      // メールアドレスに紐づくサインイン方法を取得
      final String email = googleUser.email;
      final signInMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(email);

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final loginUser = FirebaseAuth.instance.currentUser;

      // TODO:Google認証とメール+パスワード認証のリンク
      if (signInMethods.contains('password')) {
        // すでにメール+パスワードで登録済みのユーザー
        if (loginUser == null) {
          // ユーザーにログインを促すダイアログを表示し、その後Googleとリンク
          ref.read(eMailProvider.notifier).state = email;
          AuthUI.popLogin(ref, context, email);
          return;
        } else {
          // すでにログインしていればそのままリンク（想定外だが保険）
          try {
            AddAuthRoute.MailToGoogle(ref);
            Navigator.pop(context);
          } catch (e) {
            debugPrint("リンクエラー:$e");
          }
          ref.read(isLoginProvider.notifier).state = true;
          return;
        }
      } else if (signInMethods.contains('google.com')) {
        // Googleでログイン
        final UserCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );

        ref.read(userIdProvider.notifier).state =
            UserCredential.user.toString();
        await DB.dataBaseWatch(ref);
        ref.read(isLoginProvider.notifier).state = true;
        debugPrint('Googleでログイン');
        Navigator.pop(context);
        return;
      } else {
        // 新規登録
        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);
        final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
        ref.read(isGoogleLoginProvider.notifier).state = true;
        if (isNewUser) {
          await AuthUI.getInfo(ref, context, credential);
        }

        await DB.dataBaseWrite(ref);
        ref.read(isLoginProvider.notifier).state = true;
        debugPrint('Google認証登録');
        Navigator.pop(context);
        return;
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  static Future<void> writeInfo(WidgetRef ref, credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      final FirebaseAuth auth = FirebaseAuth.instance;
      String? userId = auth.currentUser?.uid;
      ref.read(userIdProvider.notifier).state = userId.toString();
      ref.read(isGoogleLoginProvider.notifier).state = true;
      DB.dataBaseWrite(ref);
      DB.TimeStampWrite(ref, 'Googleサインイン');
      ref.read(isLoginProvider.notifier).state = true;
    } catch (e) {
      debugPrint("$e");
    }
  }
}

class AddAuthRoute {
  static void GoogleToMail(WidgetRef ref, String password) async {
    // 現在のログインユーザー（Googleログイン済）
    User? user = FirebaseAuth.instance.currentUser;

    final loginEmail = ref.watch(eMailProvider);
    final AuthCredential emailCredential = EmailAuthProvider.credential(
      email: loginEmail,
      password: password,
    );

    // アカウントをリンク
    await user!.linkWithCredential(emailCredential);

    ref.read(isMailLoginProvider.notifier).state = true;
    DB.dataBaseWrite(ref);
    DB.TimeStampWrite(ref, 'メールアドレス認証を追加');
  }

  static Future<void> MailToGoogle(WidgetRef ref) async {
    // 現在のログインユーザー（メール認証済）
    User? user = FirebaseAuth.instance.currentUser;

    // Google認証の取得
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final AuthCredential googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // アカウントをリンク
    await user!.linkWithCredential(googleCredential);

    ref.read(isGoogleLoginProvider.notifier).state = true;
    DB.dataBaseWrite(ref);
    DB.TimeStampWrite(ref, 'Google認証を追加');
  }
}
