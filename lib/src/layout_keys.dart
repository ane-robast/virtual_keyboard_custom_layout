part of virtual_keyboard_custom_layout;

abstract class VirtualKeyboardLayoutKeys {
  int activeIndex = 0;

  List<List> get defaultEnglishLayout => _defaultEnglishLayout;
  List<List> get defaultArabicLayout => _defaultArabicLayout;
  List<List> get defaultGermanLayout => _defaultGermanLayout;

  List<List> get activeLayout => getDefaultLayout(activeIndex);
  int getDefaultLayoutsCount();
  List<List> getDefaultLayout(int index);
  List<List> getDefaultNumbersLayout();
  List<List> getDefaultSignsLayout();

  void switchDefaultLayout() {
    activeIndex++;
    if (activeIndex >= getDefaultLayoutsCount()) {
      activeIndex = 0;
    }
  }
}

class VirtualKeyboardDefaultLayoutKeys extends VirtualKeyboardLayoutKeys {
  List<VirtualKeyboardDefaultLayouts> defaultLayouts;
  VirtualKeyboardDefaultLayoutKeys(this.defaultLayouts);

  @override
  int getDefaultLayoutsCount() => defaultLayouts.length;

  @override
  List<List> getDefaultLayout(int index) {
    switch (defaultLayouts[index]) {
      case VirtualKeyboardDefaultLayouts.English:
        return _defaultEnglishLayout;
      case VirtualKeyboardDefaultLayouts.Arabic:
        return _defaultArabicLayout;
      case VirtualKeyboardDefaultLayouts.German:
        return _defaultGermanLayout;
      case VirtualKeyboardDefaultLayouts.Numeric:
        return _defaultNumericLayout;
      default:
        return _defaultEnglishLayout;
    }
  }

  @override
  List<List> getDefaultNumbersLayout() => _defaultNumbersLayout;

  @override
  List<List> getDefaultSignsLayout() => _defaultSignsLayout;
}

const List<List> _defaultEnglishLayout = [
  ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
  ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', VirtualKeyboardKeyAction.Backspace],
  ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', VirtualKeyboardKeyAction.Return],
  [VirtualKeyboardKeyAction.Shift, 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', VirtualKeyboardKeyAction.Shift],
  [VirtualKeyboardKeyAction.SwitchLanguage, '@', VirtualKeyboardKeyAction.Space, '&', '_']
];

const List<List> _defaultArabicLayout = [
  ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
  ['ض', 'ص', 'ث', 'ق', 'ف', 'غ', 'ع', 'ه', 'خ', 'ح', 'ج', 'د', VirtualKeyboardKeyAction.Backspace],
  ['ش', 'س', 'ي', 'ب', 'ل', 'ا', 'ت', 'ن', 'م', 'ك', 'ط', VirtualKeyboardKeyAction.Return],
  ['ذ', 'ئ', 'ء', 'ؤ', 'ر', 'لا', 'ى', 'ة', 'و', 'ز', 'ظ', VirtualKeyboardKeyAction.Shift],
  [VirtualKeyboardKeyAction.SwitchLanguage, '@', VirtualKeyboardKeyAction.Space, '-', '.', '_']
];

const List<List> _defaultGermanLayout = [
  ['q', 'w', 'e', 'r', 't', 'z', 'u', 'i', 'o', 'p', 'ü'],
  ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'ö', 'ä'],
  [VirtualKeyboardKeyAction.Shift, 'y', 'x', 'c', 'v', 'b', 'n', 'm', 'ß', VirtualKeyboardKeyAction.Backspace],
  [VirtualKeyboardKeyAction.SwitchToNumbers, VirtualKeyboardKeyAction.Space, VirtualKeyboardKeyAction.Return]
];

const List<List> _defaultNumbersLayout = [
  ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
  ['-', '/', ':', ';', '(', ')', '€', '&', '@', '"'],
  [VirtualKeyboardKeyAction.SwitchToSigns, '.', ',', '?', '!', "'", VirtualKeyboardKeyAction.Backspace],
  [VirtualKeyboardKeyAction.SwitchToLetters, VirtualKeyboardKeyAction.Space, VirtualKeyboardKeyAction.Return]
];

const List<List> _defaultSignsLayout = [
  ['[', ']', '{', '}', '#', '%', '^', '*', '+', '='],
  ['_', '\\', '|', '~', '<', '>', '\$', '£', '¥', '⋅'],
  [VirtualKeyboardKeyAction.SwitchToNumbers, '.', ',', '?', '!', "'", VirtualKeyboardKeyAction.Backspace],
  [VirtualKeyboardKeyAction.SwitchToLetters, VirtualKeyboardKeyAction.Space, VirtualKeyboardKeyAction.Return]
];

const List<List> _defaultNumericLayout = [
  ['1', '2', '3'],
  ['4', '5', '6'],
  ['7', '8', '9'],
  ['.', '0', VirtualKeyboardKeyAction.Backspace],
];
