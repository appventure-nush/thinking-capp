import 'package:flutter/material.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/utils/animation.dart';

class MySwitch extends StatefulWidget {
  final bool defaultValue;
  final Function(bool) onChanged;

  const MySwitch({
    Key? key,
    required this.defaultValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<MySwitch> createState() => _MySwitchState();
}

class _MySwitchState extends State<MySwitch> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _value = !_value);
        widget.onChanged(_value);
      },
      child: Stack(
        children: [
          AnimatedContainer(
            duration: mediumAnimationDuration,
            width: 48,
            height: 24,
            decoration: BoxDecoration(
              color: _value ? Palette.primary : Color(0xFF606060),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          AnimatedPositioned(
            duration: mediumAnimationDuration,
            left: _value ? 26 : 2,
            top: 2,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Palette.black1,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
