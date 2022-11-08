import 'package:flutter/material.dart';
import 'package:thinking_capp/colors/palette.dart';

class MyTabBar extends StatefulWidget {
  final List<String> tabs;
  final Function(String) onChanged;

  const MyTabBar({
    Key? key,
    required this.tabs,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<MyTabBar> createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  String _currentTab = '';

  @override
  void initState() {
    super.initState();
    _currentTab = widget.tabs.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.black1,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.tabs
            .map((tab) => GestureDetector(
                  onTap: () {
                    setState(() => _currentTab = tab);
                    widget.onChanged(tab);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      tab,
                      style: TextStyle(
                        color:
                            tab == _currentTab ? Palette.primary : Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
