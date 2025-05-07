import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Keypad extends StatelessWidget {
  final Function(String key) onKeyPress;

  const Keypad({super.key, required this.onKeyPress});

  //takes out - and last character if - is present
  Widget _buildKeypadRow(
    BuildContext context,
    List<String> keys, {
    bool isNumberRow = false,
    double horizontalPadding = 0.0,
  }) {
    return Expanded(
      flex: 13, // Adjust flex for uniform height across all rows
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
        ), // Apply horizontal padding for indentation
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Stretch buttons vertically
          children:
              keys.map((key) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(2.w), // Responsive padding
                    child: GestureDetector(
                      onPanDown: (details) => onKeyPress(key),
                      child: ElevatedButton(
                        onPressed: () => {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero, // Remove internal padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20.0.r,
                            ), // Responsive border radius
                          ),
                          backgroundColor:
                              key == 'ENTER'
                                  ? Colors.green
                                  : Theme.of(context)
                                      .colorScheme
                                      .primary, // Use primary color for other keys
                        ),
                        child:
                            key == 'BACKSPACE'
                                ? Icon(
                                  Icons.backspace,
                                  size: 65.sp,
                                  color: Colors.white,
                                )
                                : Text(
                                  key,
                                  style: TextStyle(
                                    fontSize:
                                        isNumberRow
                                            ? 50.sp
                                            : 60.sp, // Adjust font size for number row
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
        _buildKeypadRow(context, ['1', '2', '3'], isNumberRow: true),
        _buildKeypadRow(context, ['4', '5', '6'], isNumberRow: true),
        _buildKeypadRow(context, ['7', '8', '9'], isNumberRow: true),
        _buildKeypadRow(
          context,
          ['0'],
          isNumberRow: true,
          horizontalPadding: 0.19.sw,
        ),
        _buildKeypadRow(context, ['BACKSPACE', 'ENTER']),
      ],
    );
  }
}
