// ignore_for_file: constant_identifier_names

part of virtual_keyboard_custom_layout;

/// Virtual keyboard actions.
enum VirtualKeyboardKeyAction {
  Backspace,
  Return,
  Shift,
  Space,
  SwitchLanguage,
  SwitchToNumbers,
  SwitchToLetters,
  SwitchToSigns,
}

extension VirtualKeyboardKeyActionIcon on VirtualKeyboardKeyAction {
  IconData get icon {
    switch (this) {
      case VirtualKeyboardKeyAction.Backspace:
        return Icons.backspace;
      case VirtualKeyboardKeyAction.Return:
        return Icons.keyboard_return;
      case VirtualKeyboardKeyAction.Shift:
        return Icons.arrow_upward;
      case VirtualKeyboardKeyAction.Space:
        return Icons.space_bar;
      case VirtualKeyboardKeyAction.SwitchLanguage:
        return Icons.language;
      case VirtualKeyboardKeyAction.SwitchToNumbers:
        return Icons.onetwothree;
      case VirtualKeyboardKeyAction.SwitchToLetters:
        return Icons.abc;
      case VirtualKeyboardKeyAction.SwitchToSigns:
        return Icons.emoji_symbols;
      default:
        throw Exception('Unsupported action');
    }
  }
}
