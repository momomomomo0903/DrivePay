import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drivepay/UI/auth/auth_status.dart';
import 'package:drivepay/UI/component/input_text.dart';
import 'package:drivepay/UI/fotter_menu.dart';
import 'package:drivepay/UI/group.dart';  // GroupPageのインポート
// import 'package:firebase_storage/firebase_storage.dart';

class CreateGroupPage extends ConsumerStatefulWidget {
  const CreateGroupPage({super.key});
  @override
  ConsumerState<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends ConsumerState<CreateGroupPage> {
  //状態関数と初期化処理
  final TextEditingController _groupNameController = TextEditingController();
  List<TextEditingController> _memberControllers = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  
  @override
  void initState() {
    //自分の名前をグループの一番上に入れておく
    super.initState();
    // 初期値として空のコントローラーを追加
    _memberControllers.add(TextEditingController());
    // didChangeDependenciesでユーザー名を設定
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final name = ref.read(userNameProvider) ?? '';
        _memberControllers[0].text = name;
      }
    });
  }

  @override
    //メモリリーク防止
  void dispose() {
    _groupNameController.dispose();
    for (var controller in _memberControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  //メンバー追加
  void _addMember() {
    setState(() {
      _memberControllers.add(TextEditingController());
    });
  }

  //メンバー削除
  void _removeMember(int index) {
    if (_memberControllers.length > 1 && index >= 0 && index < _memberControllers.length) {
      setState(() {
        _memberControllers[index].dispose();
        _memberControllers.removeAt(index);
      });
    }
  }

  //グループ作成
  Future<void> _createGroup() async {
    if (_isLoading) return;
    
    try {
      setState(() {
        _isLoading = true;
      });
      
      FocusScope.of(context).unfocus();
      
      final groupName = _groupNameController.text.trim();
      final members = _memberControllers.map((controller) => controller.text.trim()).toList();
      
      if (groupName.isEmpty) {
        _showErrorDialog('グループ名を入力してください');
        return;
      }

      if (members.any((member) => member.isEmpty)) {
        _showErrorDialog('メンバー名を全て入力してください');
        return;
      }

      final user = _auth.currentUser;
      if (user == null) {
        _showErrorDialog('ログインしていません');
        return;
      }

      final firestore = FirebaseFirestore.instance;
      final groupId = DateTime.now().millisecondsSinceEpoch.toString();
      
      // グループデータを保存
      final groupRef = firestore
          .collection('groups')
          .doc(groupId);

      await groupRef.set({
        'groupId': groupId,
        'groupName': groupName,
        'members': members,  // 単純な名前のリストとして保存
        'ownerId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        // 成功メッセージを表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('グループを作成しました'),
            backgroundColor: Color(0xff45c4b0),
            duration: Duration(seconds: 2),
          ),
        );
        
        // 前の画面に戻る（スライドアニメーション）
        Navigator.pop(context);
      }
    } catch (e) {
      _showErrorDialog('グループの作成に失敗しました: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('エラー'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '新規グループ作成',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xff45c4b0),
      ),
      backgroundColor: Color(0xffDCFFF9),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'グループ名',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                InputText(
                  controller: _groupNameController,
                  hintText: 'グループ名を入力',
                  width: double.infinity,
                  icon: Icons.group,
                ),
                const SizedBox(height: 24),
                const Text(
                  'メンバー',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ..._memberControllers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final controller = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InputText(
                            controller: controller,
                            hintText: 'メンバー名を入力',
                            width: double.infinity,
                            icon: Icons.person,
                          ),
                        ),
                        if (_memberControllers.length > 1 && index > 0)
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFdf5656)),
                            onPressed: () => _removeMember(index),
                          ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: _addMember,
                  icon: const Icon(Icons.add_circle_outline, color: Color(0xFF45C4B0), size: 24),
                  label: const Text('メンバーを追加', style: TextStyle(color: Color(0xFF45C4B0))),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _createGroup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff45c4b0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'グループを作成',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
