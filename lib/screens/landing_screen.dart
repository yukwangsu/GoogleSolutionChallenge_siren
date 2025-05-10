import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_siren/screens/home_screen.dart';
import 'package:flutter_siren/screens/friends_screen.dart';
import 'package:flutter_siren/variables/variables.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({
    super.key,
  });

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const FriendsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: SizedBox(
          height: 76.0,
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(green),
                  width: 1,
                ),
              ),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashFactory: NoSplash.splashFactory,
              ),
              child: BottomNavigationBarTheme(
                data: const BottomNavigationBarThemeData(
                  backgroundColor: Colors.white,
                  selectedItemColor: Color(0xFF687D94),
                  unselectedItemColor: Color(0xFF9FA9B3),
                  selectedLabelStyle:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  unselectedLabelStyle:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                child: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  items: [
                    BottomNavigationBarItem(
                      icon: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/home_icon.svg',
                            color: _selectedIndex == 0
                                ? const Color(0xFF687D94)
                                : const Color(0xFF9FA9B3),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/friends_icon.svg',
                            color: _selectedIndex == 1
                                ? const Color(0xFF687D94)
                                : const Color(0xFF9FA9B3),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                      label: 'Friends',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
