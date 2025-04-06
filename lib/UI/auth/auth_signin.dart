import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivepay/UI/fotter_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drivepay/UI/auth/auth_status.dart';

class AuthSigninPage extends ConsumerStatefulWidget {
  const AuthSigninPage({super.key});

  @override
  ConsumerState<AuthSigninPage> createState() => _AuthSigninPage();
}

class _AuthSigninPage extends ConsumerState<AuthSigninPage> {
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
                'サインインすると\nグループを作成できます',
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
              decoration: const InputDecoration(hintText: 'メールアドレスを入力してください'),
            ),
            SizedBox(height: 15),
            Text(
              "ユーザー名",
              style: TextStyle(fontSize: 20, color: Color(0xff45c4b0)),
              textAlign: TextAlign.center,
            ),
            TextField(
              controller: name,
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
            ElevatedButton(
              child: const Text('サインイン'),
              onPressed: () async {
                final loginName = name.text.trim();
                final loginEmail = email.text.trim();
                final loginPassword = password.text.trim();
                try {
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  UserCredential userCredential = await auth
                      .createUserWithEmailAndPassword(
                        email: loginEmail,
                        password: loginPassword,
                      );
                  final FirebaseFirestore firestore =
                      FirebaseFirestore.instance;
                  final userId = userCredential.user!.uid;
                  await firestore
                      .collection('users')
                      .doc(userCredential.user!.uid)
                      .set({
                        'uid': userId.toString(), // FirestoreにUIDを保存
                        'username': loginName.toString(),
                        'email': loginEmail.toString(),
                        'createdAt': FieldValue.serverTimestamp(),
                      });
                  ref.read(userNameProvider.notifier).state = loginName;
                  ref.read(userIdProvider.notifier).state = userId;
                  ref.read(eMailProvider.notifier).state = loginEmail;
                  ref.read(isLoginProvider.notifier).state = true;
                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                } catch (e) {
                  setState(() {
                    infoText = "ユーザー登録に失敗しました。:${e.toString()}";
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
