import 'package:flutter/material.dart';
import 'package:drivepay/UI/firstPage.dart';
import 'package:drivepay/UI/component/setting_user.dart';
import 'package:drivepay/UI/component/setting_feature_button.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const UserGroup(),
            const SizedBox(height: 30),
            FeatureButtonGroup(),
          ],
        ),
      ),
    );
  }
}



