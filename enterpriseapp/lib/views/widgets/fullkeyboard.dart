import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FullKeyboard extends StatelessWidget {
  final Function(String key) onKeyPress;

  const FullKeyboard({super.key, required this.onKeyPress});

  Widget _buildKeyboardRow(
    BuildContext context,
    List<String> keys, {
    bool isNumberRow = false,
  }) {
    return Expanded(
      flex: isNumberRow ? 10 : 16, //ratio for number
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            CrossAxisAlignment
                .stretch, // Ensure buttons stretch to fill the available vertical space
        children:
            keys.map((key) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.all(
                    2.w,
                  ), // Reduced padding to minimize the gap
                  child: GestureDetector(
                    onPanDown: (details) => onKeyPress(key),
                    child: ElevatedButton(
                      onPressed: () => {},
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero, // Remove any internal padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
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
                                size: 60.sp,
                                color: Colors.white,
                              )
                              : Text(
                                key,
                                style: TextStyle(
                                  fontSize:
                                      isNumberRow
                                          ? 45.sp
                                          : 55.sp, // Adjust font size for number row
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment
              .stretch, // Ensure the rows stretch to match the container width
      children: [
        _buildKeyboardRow(context, [
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '0',
        ], isNumberRow: true), // Number row
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
          '@',
        ]),
        _buildKeyboardRow(context, [
          'Z',
          'X',
          'C',
          'V',
          'B',
          'N',
          'M',
          '_',
          '.',
          '-',
        ]),
        _buildKeyboardRow(context, ['BACKSPACE', 'SPACE', 'ENTER']),
      ],
    );
  }
}
