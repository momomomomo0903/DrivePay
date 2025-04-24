// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drivepay/state/auth_status.dart';
import 'package:drivepay/logic/group/create_group.dart';
import 'package:drivepay/logic/group/member_management.dart';
import 'package:drivepay/logic/group/error_handler.dart';

final groupCreationControllerProvider = ChangeNotifierProvider.autoDispose((ref) {
  return GroupCreationController(ref);
});

class GroupCreationController extends ChangeNotifier {
  final TextEditingController _groupNameController = TextEditingController();
  late final MemberManagement _memberManagement;
  final CreateGroup _createGroupLogic = CreateGroup();
  bool _isLoading = false;

  GroupCreationController(Ref ref) {
    final name = ref.read(userNameProvider);
    _memberManagement = MemberManagement(initialMemberName: name);
    _memberManagement.addListener(_onMemberChanged);
  }

  TextEditingController get groupNameController => _groupNameController;
  MemberManagement get memberManagement => _memberManagement;
  bool get isLoading => _isLoading;

  void _onMemberChanged() {
    notifyListeners();
  }

  Future<void> createGroup(BuildContext context) async {
    if (_isLoading) return;
    
    try {
      _isLoading = true;
      notifyListeners();
      
      FocusScope.of(context).unfocus();
      
      final groupName = _groupNameController.text.trim();
      final members = _memberManagement.getMemberNames();
      
      await _createGroupLogic.createGroup(
        groupName: groupName,
        members: members,
      );

      ErrorHandler.showSuccessSnackBar(context, 'グループを作成しました');
      Navigator.pop(context);
    } catch (e) {
      ErrorHandler.showErrorDialog(context, e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _memberManagement.removeListener(_onMemberChanged);
    _memberManagement.dispose();
    super.dispose();
  }
} 