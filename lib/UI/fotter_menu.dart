import 'dart:async';
import 'package:drivepay/UI/network.dart';
import 'package:drivepay/logic/network.dart';
import 'package:drivepay/state/map_status.dart';
import 'package:flutter/material.dart';
import 'package:drivepay/UI/home.dart';
import 'package:drivepay/UI/map.dart';
import 'package:drivepay/UI/setting.dart';
import 'package:drivepay/UI/result.dart';
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
    ResultPage(perPersonAmount: 1200, peopleCount: 5, distance: 10.0),
    MapPage(),
    SettingPage(),
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   isNetwork = ref.read(connectivityCheckProvider);
  //   isNetworkConnected = ref.read(connectivityCheckProvider);

  //   Timer.periodic(const Duration(seconds: 4), (timer) async {
  //     isNetwork = await NetworkLogic().networkCheck();
  //     setState(() {
  //       isNetworkConnected = isNetwork;
  //       ref.read(connectivityCheckProvider.notifier).state = isNetworkConnected;
  //     });
  //   });
  // }

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
            backgroundColor: Color(0xff45c4b0),
          ),
          body: IndexedStack(index: _selectedIndex, children: _pages),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calculate_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.brightness_low_rounded),
                label: '',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xFF45C4B0),
            unselectedItemColor: Color(0xFF45C4B0),
            onTap: _onItemTapped,
          ),
        )
        : NetworkUI().networkErrorUI();
  }
}
