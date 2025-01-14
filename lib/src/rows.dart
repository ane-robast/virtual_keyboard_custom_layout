part of virtual_keyboard_custom_layout;

/// Returns a list of VirtualKeyboard rows with `VirtualKeyboardKey` objects.
List<List<VirtualKeyboardKey>> _getKeyboardRows(List<List<dynamic>> keyLayout) {
  return keyLayout.map((keyboardRow) => keyboardRow.map((keyValue) => _createKey(keyValue)).toList()).toList();
}

VirtualKeyboardKey _createKey(dynamic keyValue) {
  if (keyValue is String && keyValue.length == 1) {
    return VirtualKeyboardKey(
      text: keyValue,
      capsText: toShift(keyValue),
      keyType: VirtualKeyboardKeyType.String,
    );
  } else if (keyValue is String && keyValue.length > 1) {
    final action = toAction(keyValue);
    return VirtualKeyboardKey(
      text: keyValue,
      capsText: toShift(keyValue),
      action: action,
      keyType: action != null ? VirtualKeyboardKeyType.Action : VirtualKeyboardKeyType.String,
    );
  } else if (keyValue is VirtualKeyboardKeyAction) {
    return VirtualKeyboardKey(
      keyType: VirtualKeyboardKeyType.Action,
      action: keyValue,
    );
  } else {
    throw Exception('Invalid key value: $keyValue');
  }
}

String toShift(String input) {
  const Map<String, String> shiftMapping = {
    // Letters
    'a': 'A', 'b': 'B', 'c': 'C', 'd': 'D', 'e': 'E', 'f': 'F',
    'g': 'G', 'h': 'H', 'i': 'I', 'j': 'J', 'k': 'K', 'l': 'L',
    'm': 'M', 'n': 'N', 'o': 'O', 'p': 'P', 'q': 'Q', 'r': 'R',
    's': 'S', 't': 'T', 'u': 'U', 'v': 'V', 'w': 'W', 'x': 'X',
    'y': 'Y', 'z': 'Z', 'ü': 'Ü', 'ö': 'Ö', 'ä': 'Ä', 'ß': 'ẞ',
  };

  // Use the mapping to transform the input
  return input.split('').map((char) {
    // If the character exists in the map, replace it; otherwise, keep it as is
    return shiftMapping[char] ?? char;
  }).join('');
}

VirtualKeyboardKeyAction? toAction(String input) {
  switch (input) {
    case 'BACKSPACE':
      return VirtualKeyboardKeyAction.Backspace;
    case 'RETURN':
      return VirtualKeyboardKeyAction.Return;
    case 'SHIFT':
      return VirtualKeyboardKeyAction.Shift;
    case 'SPACE':
      return VirtualKeyboardKeyAction.Space;
    case 'SWITCHTOLETTERS':
      return VirtualKeyboardKeyAction.SwitchToLetters;
    case 'SWITCHTONUMBERS':
      return VirtualKeyboardKeyAction.SwitchToNumbers;
    case 'SWITCHTOSIGNS':
      return VirtualKeyboardKeyAction.SwitchToSigns;
    default:
      return null;
  }
}
