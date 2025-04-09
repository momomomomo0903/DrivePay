// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivepay/UI/auth/auth_status.dart';
import 'package:drivepay/UI/fotter_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthLogout {
  static Future<void> LogoutLogic(WidgetRef ref, BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    ref.read(isLoginProvider.notifier).state = false;
    ref.read(isGoogleLoginProvider.notifier).state = false;
    ref.read(isMailLoginProvider.notifier).state = false;
    ref.read(userIdProvider.notifier).state = "ログインしてください";
    ref.read(userNameProvider.notifier).state = "ゲスト";
    ref.read(eMailProvider.notifier).state = "ログインしてください";
  }
}

class AuthSignin {
  static Future<String?> SigninLogic(
    WidgetRef ref,
    BuildContext context,
    String loginPassword,
  ) async {
    final loginName = ref.watch(userNameProvider);
    final loginEmail = ref.watch(eMailProvider);
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: loginEmail,
        password: loginPassword,
      );
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final userId = userCredential.user!.uid;
      await firestore.collection('users').doc(userId).set({
        'uid': userId.toString(),
        'username': loginName.toString(),
        'email': loginEmail.toString(),
        'mailLogin': true,
        'GoogleLogin': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
      ref.read(userIdProvider.notifier).state = userId;
      ref.read(isLoginProvider.notifier).state = true;
      ref.read(isMailLoginProvider.notifier).state = true;
      return null;
    } catch (e) {
      ref.read(userNameProvider.notifier).state = "ゲスト";
      ref.read(eMailProvider.notifier).state = "ログインしてください";
      return e.toString();
    }
  }
}

class AuthLogin {
  static Future<String?> LoginLogic(
    WidgetRef ref,
    BuildContext context,
    String loginPassword,
  ) async {
    final loginEmail = ref.watch(eMailProvider);
    try {
      // ref.watch(isMailLoginProvider);
      // ref.watch(isGoogleLoginProvider);
      final FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCred = await auth.signInWithEmailAndPassword(
        email: loginEmail,
        password: loginPassword,
      );

      String? userId = userCred.user?.uid;
      final loginUserSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
      final loginUser = loginUserSnapshot.data()?['username'] ?? 'ゲスト';

      // firestoreに書き込み
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc(userId).update({
        'createdAt': FieldValue.serverTimestamp(),
      });
      ref.read(userNameProvider.notifier).state = loginUser;
      ref.read(isLoginProvider.notifier).state = true;
    } on FirebaseAuthException catch (e) {
      ref.read(eMailProvider.notifier).state = "ログインしてください";
      ref.read(isMailLoginProvider.notifier).state = false;
      ref.read(isGoogleLoginProvider.notifier).state = false;
      if (e.code == 'user-not-found') {
        return 'ユーザーが見つかりません。';
      } else if (e.code == 'wrong-password') {
        return 'パスワードが間違っています。';
      } else if (e.code == 'invalid-email') {
        return 'メールアドレスの形式が正しくありません。';
      } else {
        return e.toString();
      }
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
      final List<String> signInMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(email);

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final loginName = ref.watch(userNameProvider);

      if (signInMethods.contains('password')) {
        // メール＋パスワードで登録
        final loginUser = FirebaseAuth.instance.currentUser;
        if (!(loginUser != null && loginUser.email == email)) {
          // ログインしていない場合のログインロジック
          _login(ref, context, email);
        } else {
          AddAuthRoute.MailToGoogle(ref);
        }
      } else if (signInMethods.contains('google.com')) {
        // Firebaseでログイン
        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);

        final User? user = userCredential.user;

        ref.read(eMailProvider.notifier).state = user!.email ?? "";
        ref.read(userNameProvider.notifier).state = loginName;
        ref.read(userIdProvider.notifier).state = user.uid;
        ref.read(isLoginProvider.notifier).state = true;
        ref.read(isGoogleLoginProvider.notifier).state = true;
        Navigator.pop(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else if (signInMethods.isEmpty) {
        // 新規登録
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Firebaseでログイン
        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);

        final User? user = userCredential.user;
        ref.read(eMailProvider.notifier).state = user!.email ?? "";
        ref.read(userNameProvider.notifier).state = loginName;
        ref.read(userIdProvider.notifier).state = user.uid;
        ref.read(isLoginProvider.notifier).state = true;
        ref.read(isGoogleLoginProvider.notifier).state = true;

        if (userCredential.additionalUserInfo?.isNewUser == true) {
          _getInfo(ref, context, credential);
        } else {
          Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        }
        Navigator.pop(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  static void _getInfo(WidgetRef ref, BuildContext context, credential) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final TextEditingController name = TextEditingController();
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'ユーザー名',
                    style: const TextStyle(
                      color: Color(0xFF45C4B0),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextField(
                  controller: name,
                  decoration: InputDecoration(
                    hintText: 'ユーザー名を入力してください',
                    hintStyle: const TextStyle(
                      color: Color(0xff45c4b0),
                      fontWeight: FontWeight.bold,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff45c4b0),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Color(0xFF45C4B0),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () async {
                    final loginName = name.text.trim();
                    ref.read(userNameProvider.notifier).state = loginName;
                    await writeInfo(ref, credential);
                    Navigator.pop(context);
                    Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );
                  },
                  child: Text(
                    'ログイン',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _login(WidgetRef ref, BuildContext context, String mail) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final TextEditingController password = TextEditingController();
        bool _isObscure = true;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'メールアドレスが登録されています。\nGoogleアカウントとリンクするためログインしてください。',
                        style: const TextStyle(
                          color: Color(0xFF45C4B0),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'メールアドレス : $mail',
                        style: const TextStyle(
                          color: Color(0xFF45C4B0),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "パスワード",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff45c4b0),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextField(
                      controller: password,
                      decoration: InputDecoration(
                        hintText: 'パスワードを入力してください',
                        hintStyle: const TextStyle(
                          color: Color(0xff45c4b0),
                          fontWeight: FontWeight.bold,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff45c4b0),
                            width: 2,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 15,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                      obscureText: _isObscure,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Color(0xFF45C4B0),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        'ログイン',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        if (password.text.isNotEmpty) {
                          final loginPassword = password.text.trim();
                          final errorMessage = await AuthLogin.LoginLogic(
                            ref,
                            context,
                            loginPassword,
                          );
                          debugPrint(
                            'loginName:${ref.watch(userNameProvider)},Email:${ref.watch(eMailProvider)},isLogin:${ref.watch(isLoginProvider)},ismailLogin:${ref.watch(isMailLoginProvider)},isGoogleLogin:${ref.watch(isGoogleLoginProvider)}',
                          );
                          if (errorMessage != null) {
                            showDialog(
                              context: context,
                              builder:
                                  (_) => AlertDialog(
                                    title: Text('ログインに失敗しました'),
                                    content: Text(errorMessage),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        } else {
                          if (password.text.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder:
                                  (_) => AlertDialog(
                                    title: Text('ログインに失敗しました'),
                                    content: Text('パスワードを入力してください'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Future<void> writeInfo(WidgetRef ref, credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      final FirebaseAuth auth = FirebaseAuth.instance;
      String? userId = auth.currentUser?.uid;
      final loginName = ref.watch(userNameProvider);
      // firestoreに書き込み
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final loginEmail = ref.watch(eMailProvider);
      await firestore.collection('users').doc(userId).set({
        'uid': userId.toString(),
        'username': loginName.toString(),
        'email': loginEmail.toString(),
        'mailLogin': false,
        'GoogleLogin': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
      ref.read(userIdProvider.notifier).state = userId.toString();
      ref.read(eMailProvider.notifier).state = loginEmail.toString();
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

    // firestoreに書き込み
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(user.uid).update({
      'mailLogin': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static void MailToGoogle(WidgetRef ref) async {
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

    // firestoreに書き込み
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(user.uid).update({
      'GoogleLogin': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
