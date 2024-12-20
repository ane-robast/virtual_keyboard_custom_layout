import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_keyboard_custom_layout_example/keyboard_provider.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({super.key});

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  final _key = GlobalKey();
  String text = '';
  Timer? indicatorBlinkingTimer;
  bool indicatorBlinkingValue = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("onTap");
        Provider.of<KeyboardProvider>(context, listen: false).key = _key;
        Provider.of<KeyboardProvider>(context, listen: false).text = text;
        Provider.of<KeyboardProvider>(context, listen: false).setTextState = () {
          setState(() {
            text = Provider.of<KeyboardProvider>(context, listen: false).text ?? '';
          });
        };
      },
      child: Container(
        color: Colors.transparent,
        child: Selector<KeyboardProvider, GlobalKey?>(
          selector: (context, provider) => provider.key,
          builder: (context, key, child) {
            final isFocused = key == _key;
            if (isFocused && !(indicatorBlinkingTimer?.isActive ?? false)) {
              indicatorBlinkingTimer = Timer.periodic(const Duration(milliseconds: 750), (timer) {
                setState(() {
                  indicatorBlinkingValue = !indicatorBlinkingValue;
                });
              });
            } else if (!isFocused) {
              indicatorBlinkingTimer?.cancel();
              indicatorBlinkingValue = true;
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Text(
                        text,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 18),
                      ),
                      if (isFocused)
                        Container(
                          margin: const EdgeInsets.only(left: 2),
                          height: 18,
                          width: 1,
                          color: indicatorBlinkingValue ? Colors.black : Colors.blue,
                        )
                    ],
                  ),
                ),
                Container(
                  color: isFocused ? Colors.blue : Colors.grey,
                  width: double.infinity,
                  height: 1,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
