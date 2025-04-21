// import 'package:drivepay/UI/fotter_menu.dart';
// import 'package:drivepay/logic/auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:drivepay/UI/auth/auth_status.dart';

// class AuthSigninPage extends ConsumerStatefulWidget {
//   const AuthSigninPage({super.key});

//   @override
//   ConsumerState<AuthSigninPage> createState() => _AuthSigninPage();
// }

// class _AuthSigninPage extends ConsumerState<AuthSigninPage> {
//   String infoText = "";
//   final TextEditingController name = TextEditingController();
//   final TextEditingController email = TextEditingController();
//   final TextEditingController password = TextEditingController();
//   bool _isObscure = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'Drive Pay',
//           style: TextStyle(
//             fontSize: 24.0,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Color(0xff45c4b0),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           width: double.infinity,
//           margin: EdgeInsets.zero,
//           padding: const EdgeInsets.only(top: 10, bottom: 20),
//           child: Column(
//             children: [
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Image.asset(
//                     'assets/images/first-page.png',
//                     width: 280,
//                     height: 280,
//                     fit: BoxFit.contain,
//                   ),
//                 ],
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 child: Text(
//                   'サインインすると\nグループを作成できます',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Color(0xff45c4b0),
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(height: 15),
//               Text(
//                 "メールアドレス",
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Color(0xff45c4b0),
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               TextField(
//                 controller: email,
//                 decoration: InputDecoration(
//                   hintText: 'メールアドレスを入力してください',
//                   hintStyle: const TextStyle(
//                     color: Color(0xff45c4b0),
//                     fontWeight: FontWeight.bold,
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   enabledBorder: const UnderlineInputBorder(
//                     borderSide: BorderSide(color: Color(0xff45c4b0), width: 2),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 15),
//               Text(
//                 "名前",
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Color(0xff45c4b0),
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               TextField(
//                 controller: name,
//                 decoration: InputDecoration(
//                   hintText: '名前を入力してください',
//                   hintStyle: const TextStyle(
//                     color: Color(0xff45c4b0),
//                     fontWeight: FontWeight.bold,
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   enabledBorder: const UnderlineInputBorder(
//                     borderSide: BorderSide(color: Color(0xff45c4b0), width: 2),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 "パスワード",
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Color(0xff45c4b0),
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               TextField(
//                 controller: password,
//                 decoration: InputDecoration(
//                   hintText: 'パスワードを入力してください',
//                   hintStyle: const TextStyle(
//                     color: Color(0xff45c4b0),
//                     fontWeight: FontWeight.bold,
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   enabledBorder: const UnderlineInputBorder(
//                     borderSide: BorderSide(color: Color(0xff45c4b0), width: 2),
//                   ),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _isObscure ? Icons.visibility_off : Icons.visibility,
//                       size: 15,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _isObscure = !_isObscure;
//                       });
//                     },
//                   ),
//                 ),
//                 obscureText: _isObscure,
//               ),
//               SizedBox(height: 10),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   elevation: 5,
//                   backgroundColor: Color(0xFF45C4B0),
//                   shape: const StadiumBorder(),
//                 ),
//                 child: const Text(
//                   'サインイン',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 onPressed: () async {
//                   if (name.text.isNotEmpty ||
//                       email.text.isNotEmpty ||
//                       password.text.isNotEmpty) {
//                     ref.read(userNameProvider.notifier).state =
//                         name.text.trim();
//                     ref.read(eMailProvider.notifier).state = email.text.trim();
//                     final errorMessage = await AuthSignin.SigninLogic(
//                       ref,
//                       context,
//                       password.text.trim(),
//                     );
//                     if (errorMessage != null) {
//                       showDialog(
//                         context: context,
//                         builder:
//                             (_) => AlertDialog(
//                               title: Text('登録に失敗しました'),
//                               content: Text(errorMessage),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(context),
//                                   child: Text('OK'),
//                                 ),
//                               ],
//                             ),
//                       );
//                     } else {
//                       Navigator.pop(
//                         // ignore: use_build_context_synchronously
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const MainScreen(),
//                         ),
//                       );
//                     }
//                     debugPrint(
//                       'loginName:${ref.watch(userNameProvider)},Email:${ref.watch(eMailProvider)},isLogin:${ref.watch(isLoginProvider)},ismailLogin:${ref.watch(isMailLoginProvider)},isGoogleLogin:${ref.watch(isGoogleLoginProvider)}',
//                     );
//                   } else if (name.text.isEmpty) {
//                     showDialog(
//                       context: context,
//                       builder:
//                           (_) => AlertDialog(
//                             title: Text('ログインに失敗しました'),
//                             content: Text('名前を入力してください'),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context),
//                                 child: Text('OK'),
//                               ),
//                             ],
//                           ),
//                     );
//                   } else if (email.text.isEmpty) {
//                     showDialog(
//                       context: context,
//                       builder:
//                           (_) => AlertDialog(
//                             title: Text('ログインに失敗しました'),
//                             content: Text('メールアドレスを入力してください'),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context),
//                                 child: Text('OK'),
//                               ),
//                             ],
//                           ),
//                     );
//                   } else if (password.text.isEmpty) {
//                     showDialog(
//                       context: context,
//                       builder:
//                           (_) => AlertDialog(
//                             title: Text('ログインに失敗しました'),
//                             content: Text('パスワードを入力してください'),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context),
//                                 child: Text('OK'),
//                               ),
//                             ],
//                           ),
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
