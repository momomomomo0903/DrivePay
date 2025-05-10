// ignore_for_file: non_constant_identifier_names, deprecated_member_use, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivepay/UI/auth/auth.dart';
import 'package:drivepay/state/auth_status.dart';
import 'package:drivepay/logic/firebase.dart';
import 'package:drivepay/state/dribeLog_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthLogout {
  static Future<void> LogoutLogic(WidgetRef ref, BuildContext context) async {
    DB.TimeStampWrite(ref, "ログアウト");
    await FirebaseAuth.instance.signOut();
    ref.read(isLoginProvider.notifier).state = false;
    // ref.read(isGoogleLoginProvider.notifier).state = false;
    // ref.read(isMailLoginProvider.notifier).state = false;
    ref.read(userIdProvider.notifier).state = "ログインしてください";
    ref.read(userNameProvider.notifier).state = "ゲスト";
    ref.read(eMailProvider.notifier).state = "ログインしてください";
    ref.read(fuelEfficiencyProvider.notifier).state = "11.3";
    ref.read(historyItemProvider.notifier).state = [];
    AuthUI.logout(context);
  }
}

// class AuthSignin {
//   static Future<String?> SigninLogic(
//     WidgetRef ref,
//     BuildContext context,
//     String password,
//   ) async {
//     final loginEmail = ref.watch(eMailProvider);
//     try {
//       final FirebaseAuth auth = FirebaseAuth.instance;
//       UserCredential userCredential = await auth.createUserWithEmailAndPassword(
//         email: loginEmail,
//         password: password,
//       );
//       ref.read(userIdProvider.notifier).state = userCredential.user!.uid;
//       ref.read(isMailLoginProvider.notifier).state = true;

//       DB.dataBaseSetWrite(ref);

//       DB.TimeStampWrite(ref, 'サインイン');
//       ref.read(isLoginProvider.notifier).state = true;
//     } catch (e) {
//       ref.read(userNameProvider.notifier).state = "ゲスト";
//       ref.read(eMailProvider.notifier).state = "ログインしてください";
//       return e.toString();
//     }
//     return null;
//   }
// }

// class AuthLogin {
//   static Future<String?> LoginLogic(
//     WidgetRef ref,
//     BuildContext context,
//     String password,
//   ) async {
//     final loginEmail = ref.watch(eMailProvider);
//     try {
//       final FirebaseAuth auth = FirebaseAuth.instance;
//       UserCredential userCred = await auth.signInWithEmailAndPassword(
//         email: loginEmail,
//         password: password,
//       );
//       ref.read(userIdProvider.notifier).state = userCred.user!.uid.toString();
//       DB.dataBaseWatch(ref);
//       DB.TimeStampWrite(ref, 'ログイン');
//       ref.read(isLoginProvider.notifier).state = true;
//     } catch (e) {
//       ref.read(eMailProvider.notifier).state = "ログインしてください";
//       return e.toString();
//     }
//     return null;
//   }
// }

class GoogleSignin {
  static Future<void> signInWithGoogle(
    WidgetRef ref,
    BuildContext context,
  ) async {
    try {
      await GoogleSignIn().signOut(); // アカウント選択強制

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final email = googleUser.email;

      try {
        // List<String> methods = await FirebaseAuth.instance
        //     .fetchSignInMethodsForEmail(email);

        // if (methods.contains("password") && !methods.contains("google.com")) {
        //   // メールはあるがGoogle未連携 → リンクさせる流れへ
        //   await AuthUI.popLogin(ref, context, email);
        //   return;
        // }

        // 通常のGoogleログイン処理
        final userCred = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );
        final user = userCred.user!;
        final uid = user.uid;

        ref.read(userIdProvider.notifier).state = uid;
        ref.read(eMailProvider.notifier).state = email;
        // ref.read(isGoogleLoginProvider.notifier).state = true;

        final userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (!userDoc.exists) {
          // 初回 → ユーザー情報登録画面へ遷移
          await AuthUI.getInfo(ref, context);
        } else {
          // 既存ユーザー
          await DB.dataBaseWatch(ref);
          await DB.dataBaseUpdateWrite(ref);
          await DB.TimeStampWrite(ref, 'Googleログイン');
        }

        ref.read(isLoginProvider.notifier).state = true;
        // } on FirebaseAuthException catch (e) {
        //   if (e.code == 'account-exists-with-different-credential') {
        //     // 他の認証方法で登録済み → エラーから認証情報を取得し、後でリンク
        //     final pendingCredential = e.credential;
        //     final email = e.email;
        //     ref.read(eMailProvider.notifier).state = email ?? "";
        //     await AuthUI.popLogin(ref, context, email ?? "");
        //   } else {
        //     debugPrint("Googleログインエラー: ${e.code} - ${e.message}");
        //   }
      } catch (e) {
        debugPrint("$e");
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
      // ref.read(isGoogleLoginProvider.notifier).state = true;
      DB.dataBaseUpdateWrite(ref);
      DB.TimeStampWrite(ref, 'Googleサインイン');
      ref.read(isLoginProvider.notifier).state = true;
    } catch (e) {
      debugPrint("$e");
    }
  }
}

// class AddAuthRoute {
//   static void GoogleToMail(WidgetRef ref, String password) async {
//     // 現在のログインユーザー（Googleログイン済）
//     User? user = FirebaseAuth.instance.currentUser;

//     final loginEmail = ref.watch(eMailProvider);
//     final AuthCredential emailCredential = EmailAuthProvider.credential(
//       email: loginEmail,
//       password: password,
//     );

//     // アカウントをリンク
//     await user!.linkWithCredential(emailCredential);

//     ref.read(isMailLoginProvider.notifier).state = true;
//     DB.dataBaseUpdateWrite(ref);
//     DB.TimeStampWrite(ref, 'メールアドレス認証を追加');
//   }

//   static Future<void> MailToGoogle(WidgetRef ref) async {
//     // 現在のログインユーザー（メール認証済）
//     User? user = FirebaseAuth.instance.currentUser;

//     // Google認証の取得
//     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//     final GoogleSignInAuthentication googleAuth =
//         await googleUser!.authentication;

//     final AuthCredential googleCredential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     // アカウントをリンク
//     await user!.linkWithCredential(googleCredential);

//     ref.read(isGoogleLoginProvider.notifier).state = true;
//     DB.dataBaseUpdateWrite(ref);
//     DB.TimeStampWrite(ref, 'Google認証を追加');
//   }
// }
