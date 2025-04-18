// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers
import 'package:drivepay/UI/auth/auth_status.dart';
// import 'package:drivepay/logic/auth.dart';
import 'package:drivepay/logic/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthUI {
  static Future<void> getInfo(WidgetRef ref, BuildContext context) async {
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

                    if (loginName.isEmpty) {
                      // ユーザー名未入力チェック
                      showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: Text('ユーザー名が未入力です'),
                              content: Text('ユーザー名を入力してください'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                      );
                      return;
                    }

                    ref.read(userNameProvider.notifier).state = loginName;
                    await DB.dataBaseSetWrite(ref);

                    await DB.TimeStampWrite(ref, 'Googleサインイン');
                    Navigator.pop(context);
                    Navigator.pop(context);
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

  // static Future<void> popLogin(
  //   WidgetRef ref,
  //   BuildContext context,
  //   String mail,
  // ) async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       final TextEditingController password = TextEditingController();
  //       bool _isObscure = true;

  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return Dialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             child: DecoratedBox(
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(vertical: 24),
  //                     child: Text(
  //                       'メールアドレスが登録されています。\nGoogleアカウントとリンクするためログインしてください。',
  //                       style: const TextStyle(
  //                         color: Color(0xFF45C4B0),
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(vertical: 24),
  //                     child: Text(
  //                       'メールアドレス : $mail',
  //                       style: const TextStyle(
  //                         color: Color(0xFF45C4B0),
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                   Text(
  //                     "パスワード",
  //                     style: TextStyle(
  //                       fontSize: 20,
  //                       color: Color(0xff45c4b0),
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   TextField(
  //                     controller: password,
  //                     decoration: InputDecoration(
  //                       hintText: 'パスワードを入力してください',
  //                       hintStyle: const TextStyle(
  //                         color: Color(0xff45c4b0),
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                       contentPadding: const EdgeInsets.symmetric(
  //                         horizontal: 16.0,
  //                       ),
  //                       enabledBorder: const UnderlineInputBorder(
  //                         borderSide: BorderSide(
  //                           color: Color(0xff45c4b0),
  //                           width: 2,
  //                         ),
  //                       ),
  //                       suffixIcon: IconButton(
  //                         icon: Icon(
  //                           _isObscure
  //                               ? Icons.visibility_off
  //                               : Icons.visibility,
  //                           size: 15,
  //                         ),
  //                         onPressed: () {
  //                           setState(() {
  //                             _isObscure = !_isObscure;
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                     obscureText: _isObscure,
  //                   ),
  //                   const SizedBox(height: 24),
  //                   ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                       elevation: 5,
  //                       backgroundColor: Color(0xFF45C4B0),
  //                       shape: const StadiumBorder(),
  //                     ),
  //                     child: const Text(
  //                       'ログイン',
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     onPressed: () async {
  //                       if (password.text.isNotEmpty) {
  //                         final loginPassword = password.text.trim();
  //                         final errorMessage = await AuthLogin.LoginLogic(
  //                           ref,
  //                           context,
  //                           loginPassword,
  //                         );
  //                         debugPrint(
  //                           'loginName:${ref.watch(userNameProvider)},Email:${ref.watch(eMailProvider)},isLogin:${ref.watch(isLoginProvider)},ismailLogin:${ref.watch(isMailLoginProvider)},isGoogleLogin:${ref.watch(isGoogleLoginProvider)}',
  //                         );
  //                         if (errorMessage != null) {
  //                           showDialog(
  //                             context: context,
  //                             builder:
  //                                 (_) => AlertDialog(
  //                                   title: Text('ログインに失敗しました'),
  //                                   content: Text(errorMessage),
  //                                   actions: [
  //                                     TextButton(
  //                                       onPressed: () => Navigator.pop(context),
  //                                       child: Text('OK'),
  //                                     ),
  //                                   ],
  //                                 ),
  //                           );
  //                         } else {
  //                           await AddAuthRoute.MailToGoogle(ref);
  //                           Navigator.pop(context); // popLoginのダイアログを閉じる
  //                         }
  //                       } else {
  //                         if (password.text.isNotEmpty) {
  //                           showDialog(
  //                             context: context,
  //                             builder:
  //                                 (_) => AlertDialog(
  //                                   title: Text('ログインに失敗しました'),
  //                                   content: Text('パスワードを入力してください'),
  //                                   actions: [
  //                                     TextButton(
  //                                       onPressed: () => Navigator.pop(context),
  //                                       child: Text('OK'),
  //                                     ),
  //                                   ],
  //                                 ),
  //                           );
  //                         }
  //                       }
  //                     },
  //                   ),
  //                   const SizedBox(height: 24),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  static void logout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
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
                    'ログアウトしました',
                    style: const TextStyle(
                      color: Color(0xFF45C4B0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'OK',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 7),
              ],
            ),
          ),
        );
      },
    );
  }
}
