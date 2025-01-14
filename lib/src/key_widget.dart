import 'dart:async';

import 'package:flutter/material.dart';
import 'package:virtual_keyboard_custom_layout/virtual_keyboard_custom_layout.dart';

class KeyWidget extends StatelessWidget {
  const KeyWidget({
    super.key,
    required this.keyboardKey,
    required this.alwaysCaps,
    required this.isShiftEnabled,
    required this.borderColor,
    required this.style,
    required this.textColor,
    required this.fontSize,
    required this.height,
    required this.onKeyPress,
    this.flex = 1,
    this.enableLongpress = false,
  });

  final longPressEventPeriod = const Duration(milliseconds: 250);

  final VirtualKeyboardKey keyboardKey;
  final bool alwaysCaps;
  final bool isShiftEnabled;
  final Color borderColor;
  final Color textColor;
  final TextStyle style;
  final double fontSize;
  final double height;
  final Function(VirtualKeyboardKey) onKeyPress;
  final int flex;
  final bool enableLongpress;

  @override
  Widget build(BuildContext context) {
    if (keyboardKey.keyType == VirtualKeyboardKeyType.Action) {
      return _keyboardActionKey(keyboardKey);
    } else {
      return _keyboardTextKey(keyboardKey);
    }
  }

  /// Creates default UI element for keyboard Key.
  Widget _keyboardTextKey(VirtualKeyboardKey key) {
    return _keyboardKey(
      key: key,
      child: Text(
        alwaysCaps ? key.capsText ?? '' : (isShiftEnabled ? key.capsText : key.text) ?? '',
        style: TextStyle(color: textColor, fontSize: fontSize),
      ),
    );
  }

  /// Creates default UI element for keyboard Action Key.
  Widget _keyboardActionKey(VirtualKeyboardKey key) {
    Widget actionKeyWidget = _keyboardKey(
      key: key,
      child: Icon(
        key.action!.icon,
        color: textColor,
        size: fontSize,
      ),
    );

    return actionKeyWidget;
  }

  Widget _keyboardKey({required VirtualKeyboardKey key, required Widget child}) {
    final keyInkwell = InkWell(
      onTap: () {
        onKeyPress(key);
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: borderColor, width: 0)),
        height: height,
        child: Center(child: child),
      ),
    );

    return Expanded(
      flex: flex,
      child: enableLongpress ? _longpressDetector(child: keyInkwell, key: key) : keyInkwell,
    );
  }

  Widget _longpressDetector({required Widget child, required VirtualKeyboardKey key}) {
    bool longPress = false;
    return GestureDetector(
      onLongPress: () {
        longPress = true;
        // Start sending key events while longPress is true
        Timer.periodic(longPressEventPeriod, (timer) {
          if (longPress) {
            onKeyPress(key);
          } else {
            timer.cancel();
          }
        });
      },
      onLongPressUp: () {
        // Cancel event loop
        longPress = false;
      },
      child: child,
    );
  }
}
