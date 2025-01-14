part of virtual_keyboard_custom_layout;

/// Virtual Keyboard key
class VirtualKeyboardKey {
  VirtualKeyboardKey({this.text, this.capsText, required this.keyType, this.action});

  final VirtualKeyboardKeyType keyType;
  final VirtualKeyboardKeyAction? action;
  late final String? text;
  late final String? capsText;
}
