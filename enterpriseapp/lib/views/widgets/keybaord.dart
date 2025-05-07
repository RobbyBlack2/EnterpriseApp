import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Keyboard extends StatelessWidget {
  final Function(String key) onKeyPress;

  const Keyboard({super.key, required this.onKeyPress});

  static const String spaceKey = 'SPACE';
  static const String backspaceKey = 'BACKSPACE';
  static const String enterKey = 'ENTER';

  // Build a single row of keys
  Widget _buildKeyboardRow(
    BuildContext context,
    List<String> keys, {
    bool isNumberRow = false,
    double horizontalPadding = 0.0,
  }) {
    return Expanded(
      flex: isNumberRow ? 10 : 16,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
              keys.map((key) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(2.w),
                    child: GestureDetector(
                      onPanDown: (details) => onKeyPress(key),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0.r),
                          ),
                          backgroundColor:
                              key == enterKey
                                  ? Colors.green
                                  : (key == backspaceKey
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.primary),
                        ),
                        child:
                            key == backspaceKey
                                ? Icon(
                                  Icons.backspace,
                                  size: 60.sp,
                                  color: Colors.white,
                                )
                                : Text(
                                  key,
                                  style: TextStyle(
                                    fontSize: isNumberRow ? 45.sp : 55.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildKeyboardRow(context, [
          '0',
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
        ], isNumberRow: true),
        _buildKeyboardRow(context, [
          'Q',
          'W',
          'E',
          'R',
          'T',
          'Y',
          'U',
          'I',
          'O',
          'P',
        ]),
        _buildKeyboardRow(context, [
          'A',
          'S',
          'D',
          'F',
          'G',
          'H',
          'J',
          'K',
          'L',
        ], horizontalPadding: 0.05.sw),
        _buildKeyboardRow(context, [
          'Z',
          'X',
          'C',
          'V',
          'B',
          'N',
          'M',
          '-',
        ], horizontalPadding: 0.1.sw),
        _buildKeyboardRow(context, [backspaceKey, spaceKey, enterKey]),
      ],
    );
  }
}
