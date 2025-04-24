// import 'package:drivepay/UI/auth/auth_signin.dart';
// import 'package:drivepay/UI/fotter_menu.dart';
import 'package:drivepay/logic/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drivepay/state/auth_status.dart';

class AuthLoginPage extends ConsumerStatefulWidget {
  const AuthLoginPage({super.key});

  @override
  ConsumerState<AuthLoginPage> createState() => _AuthLoginPage();
}

class _AuthLoginPage extends ConsumerState<AuthLoginPage> {
  // String infoText = "";
  // final TextEditingController name = TextEditingController();
  // final TextEditingController email = TextEditingController();
  // final TextEditingController password = TextEditingController();
  // bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: Column(
            children: [
              SizedBox(height: 15),
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
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  'ログインすると\nグループを作成できます',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff45c4b0),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Color(0xff45c4b0),
                  shape: const StadiumBorder(),
                  fixedSize: Size(200, double.infinity),
                ),
                onPressed: () {
                  GoogleSignin.signInWithGoogle(ref, context);

                  debugPrint(
                    'loginName:${ref.watch(userNameProvider)},Email:${ref.watch(eMailProvider)},isLogin:${ref.watch(isLoginProvider)}',
                  );
                },
                child: Text(
                  "Googleでログイン",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // SizedBox(height: 15),
              // Text(
              //   "メールアドレス",
              //   style: TextStyle(
              //     fontSize: 20,
              //     color: Color(0xff45c4b0),
              //     fontWeight: FontWeight.bold,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              // TextField(
              //   controller: email,
              //   decoration: InputDecoration(
              //     hintText: 'メールアドレスを入力してください',
              //     hintStyle: const TextStyle(
              //       color: Color(0xff45c4b0),
              //       fontWeight: FontWeight.bold,
              //     ),
              //     contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              //     enabledBorder: const UnderlineInputBorder(
              //       borderSide: BorderSide(color: Color(0xff45c4b0), width: 2),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 20),
              // Text(
              //   "パスワード",
              //   style: TextStyle(
              //     fontSize: 20,
              //     color: Color(0xff45c4b0),
              //     fontWeight: FontWeight.bold,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              // TextField(
              //   controller: password,
              //   decoration: InputDecoration(
              //     hintText: 'パスワードを入力してください',
              //     hintStyle: const TextStyle(
              //       color: Color(0xff45c4b0),
              //       fontWeight: FontWeight.bold,
              //     ),
              //     contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              //     enabledBorder: const UnderlineInputBorder(
              //       borderSide: BorderSide(color: Color(0xff45c4b0), width: 2),
              //     ),
              //     suffixIcon: IconButton(
              //       icon: Icon(
              //         _isObscure ? Icons.visibility_off : Icons.visibility,
              //         size: 15,
              //       ),
              //       onPressed: () {
              //         setState(() {
              //           _isObscure = !_isObscure;
              //         });
              //       },
              //     ),
              //   ),
              //   obscureText: _isObscure,
              // ),
              // SizedBox(height: 10),
              // Center(
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //           elevation: 5,
              //           backgroundColor: Colors.white,
              //           shape: const StadiumBorder(),
              //         ),
              //         onPressed: () {
              //           GoogleSignin.signInWithGoogle(ref, context);

              //           debugPrint(
              //             'loginName:${ref.watch(userNameProvider)},Email:${ref.watch(eMailProvider)},isLogin:${ref.watch(isLoginProvider)},ismailLogin:${ref.watch(isMailLoginProvider)},isGoogleLogin:${ref.watch(isGoogleLoginProvider)}',
              //           );
              //         },
              //         child: Row(
              //           children: [
              //             Text(
              //               "Googleでログイン",
              //               style: TextStyle(
              //                 color: Color(0xFF45C4B0),
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //       SizedBox(width: 10),
              //       ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //           elevation: 5,
              //           backgroundColor: Color(0xFF45C4B0),
              //           shape: const StadiumBorder(),
              //         ),
              //         child: const Text(
              //           'ログイン',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         onPressed: () async {
              //           if (email.text.isNotEmpty || password.text.isNotEmpty) {
              //             ref.read(eMailProvider.notifier).state =
              //                 email.text.trim();
              //             final errorMessage = await AuthLogin.LoginLogic(
              //               ref,
              //               context,
              //               password.text.trim(),
              //             );
              //             debugPrint(
              //               'loginName:${ref.watch(userNameProvider)},Email:${ref.watch(eMailProvider)},isLogin:${ref.watch(isLoginProvider)},ismailLogin:${ref.watch(isMailLoginProvider)},isGoogleLogin:${ref.watch(isGoogleLoginProvider)}',
              //             );
              //             if (errorMessage != null) {
              //               showDialog(
              //                 context: context,
              //                 builder:
              //                     (_) => AlertDialog(
              //                       title: Text('ログインに失敗しました'),
              //                       content: Text(errorMessage),
              //                       actions: [
              //                         TextButton(
              //                           onPressed: () => Navigator.pop(context),
              //                           child: Text('OK'),
              //                         ),
              //                       ],
              //                     ),
              //               );
              //             } else {
              //               Navigator.pop(
              //                 context,
              //                 MaterialPageRoute(
              //                   builder: (context) => const MainScreen(),
              //                 ),
              //               );
              //             }
              //           } else {
              //             if (email.text.isEmpty) {
              //               showDialog(
              //                 context: context,
              //                 builder:
              //                     (_) => AlertDialog(
              //                       title: Text('ログインに失敗しました'),
              //                       content: Text('メールを入力してください'),
              //                       actions: [
              //                         TextButton(
              //                           onPressed: () => Navigator.pop(context),
              //                           child: Text('OK'),
              //                         ),
              //                       ],
              //                     ),
              //               );
              //             }
              //             if (password.text.isEmpty) {
              //               showDialog(
              //                 context: context,
              //                 builder:
              //                     (_) => AlertDialog(
              //                       title: Text('ログインに失敗しました'),
              //                       content: Text('パスワードを入力してください'),
              //                       actions: [
              //                         TextButton(
              //                           onPressed: () => Navigator.pop(context),
              //                           child: Text('OK'),
              //                         ),
              //                       ],
              //                     ),
              //               );
              //             }
              //           }
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 10),
              // TextButton(
              //   onPressed: () {
              //     Navigator.pushReplacement(
              //       // ignore: use_build_context_synchronously
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const AuthSigninPage(),
              //       ),
              //     );
              //   },
              //   child: Text(
              //     "サインインがまだの方はこちら",
              //     style: TextStyle(color: Color(0xff45c4b0)),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
