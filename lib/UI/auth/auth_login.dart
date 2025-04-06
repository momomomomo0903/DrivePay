import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivepay/UI/auth/auth_signin.dart';
import 'package:drivepay/UI/fotter_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drivepay/UI/auth/auth_status.dart';

class AuthLoginPage extends ConsumerStatefulWidget {
  const AuthLoginPage({super.key});

  @override
  ConsumerState<AuthLoginPage> createState() => _AuthLoginPage();
}

class _AuthLoginPage extends ConsumerState<AuthLoginPage> {
  String infoText = "";
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Drive Pay',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xff45c4b0),
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        decoration: const BoxDecoration(color: Color(0xFFDCFFF9)),
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/first-page.png',
                  width: 280,
                  height: 280,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                'ログインすると\nグループを作成できます',
                style: TextStyle(fontSize: 20, color: Color(0xff45c4b0)),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "メールアドレス",
              style: TextStyle(fontSize: 20, color: Color(0xff45c4b0)),
              textAlign: TextAlign.center,
            ),
            TextField(
              controller: email,
              decoration: const InputDecoration(hintText: 'ユーザー名を入力してください'),
            ),
            SizedBox(height: 20),
            Text(
              "パスワード",
              style: TextStyle(fontSize: 20, color: Color(0xff45c4b0)),
              textAlign: TextAlign.center,
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(
                hintText: 'パスワードを入力してください',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
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
            SizedBox(height: 10),
            ElevatedButton(
              child: const Text('ログイン'),
              onPressed: () async {
                final loginEmail = email.text.trim();
                final loginPassword = password.text.trim();
                try {
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  await auth.signInWithEmailAndPassword(
                    email: loginEmail,
                    password: loginPassword,
                  );
                  String? userId = auth.currentUser?.uid;
                  final loginUserSnapshot =
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .get();
                  final loginUser =
                      loginUserSnapshot.data()?['username'] ?? 'ゲスト';
                  ref.read(userNameProvider.notifier).state = loginUser;
                  ref.read(eMailProvider.notifier).state = loginEmail;
                  ref.read(isLoginProvider.notifier).state = true;
                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                } catch (e) {
                  setState(() {
                    (() {
                      infoText = "ログインに失敗しました。:${e.toString()}";
                    });
                  });
                }
              },
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(builder: (context) => const AuthSigninPage()),
                );
              },
              child: Text(
                "サインインがまだの方はこちら",
                style: TextStyle(color: Color(0xff45c4b0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
