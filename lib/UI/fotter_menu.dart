import 'package:drivepay/UI/network.dart';
import 'package:drivepay/state/map_status.dart';
import 'package:flutter/material.dart';
import 'package:drivepay/UI/home.dart';
import 'package:drivepay/UI/map_UI.dart';
import 'package:drivepay/UI/setting.dart';
import 'package:drivepay/UI/driveLog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  late bool isNetwork;
  late bool isNetworkConnected;

  final List<Widget> _pages = const [
    HomePage(),
    DriveLogPage(),
    MapPage(),
    SettingPage(),
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    isNetworkConnected = ref.watch(connectivityCheckProvider);
    return isNetworkConnected
        ? Scaffold(
          appBar: AppBar(
            title: const Text(
              'Drive Pay',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Color(0xff45C4B0),
          ),
          body: IndexedStack(index: _selectedIndex, children: _pages),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color(0xff45C4B0),
            iconSize: 30,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: Icon(Icons.home_outlined),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: Icon(Icons.groups_outlined),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: Icon(Icons.map_outlined),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: Icon(Icons.brightness_low_rounded),
                ),
                label: '',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            onTap: _onItemTapped,
          ),
        )
        : NetworkUI().networkErrorUI(context);
  }
}
