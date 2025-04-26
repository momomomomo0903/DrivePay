import 'package:flutter/material.dart';

class MemberManagement extends ChangeNotifier {
  final List<TextEditingController> _memberControllers = [];
  final String? initialMemberName;

  MemberManagement({this.initialMemberName}) {
    _memberControllers.add(TextEditingController());
    if (initialMemberName != null) {
      _memberControllers[0].text = initialMemberName!;
    }
  }

  List<TextEditingController> get memberControllers => _memberControllers;

  void addMember() {
    _memberControllers.add(TextEditingController());
    notifyListeners();
  }

  void removeMember(int index) {
    if (_memberControllers.length > 1 && index >= 0 && index < _memberControllers.length) {
      _memberControllers[index].dispose();
      _memberControllers.removeAt(index);
      notifyListeners();
    }
  }

  List<String> getMemberNames() {
    return _memberControllers.map((controller) => controller.text.trim()).toList();
  }

  @override
  void dispose() {
    for (var controller in _memberControllers) {
      controller.dispose();
    }
    super.dispose();
  }
} 