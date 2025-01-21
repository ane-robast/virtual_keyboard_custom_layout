part of virtual_keyboard_custom_layout;

enum KeyboardState { primary, secondary, tertiary }

/// The default keyboard height. Can we overriden by passing
///  `height` argument to `VirtualKeyboard` widget.
const double _virtualKeyboardDefaultHeight = 300;

/// Virtual Keyboard widget.
class VirtualKeyboard extends StatefulWidget {
  /// Callback for Key press event. Called with pressed `Key` object.
  final Function(VirtualKeyboardKey)? onKeyPress;

  /// Virtual keyboard height. Default is 300
  final double height;

  /// Virtual keyboard height. Default is full screen width
  final double? width;

  /// Color for key texts and icons.
  final Color textColor;

  /// Font size for keyboard keys.
  final double fontSize;

  /// the custom layout for multi or single language
  final VirtualKeyboardLayoutKeys? customLayoutKeys;

  /// the text controller go get the output and send the default input
  final TextEditingController? textController;

  /// The builder function will be called for each Key object.
  final Widget Function(BuildContext context, VirtualKeyboardKey key)? builder;

  /// Set to true if you want only to show Caps letters.
  final bool alwaysCaps;

  /// inverse the layout to fix the issues with right to left languages.
  final bool reverseLayout;

  /// Flex factor of space key
  final int spacebarFlex;

  /// custom keys used if type `Custom` is being used. If `Custom` is selected
  /// and keys is null, the default alphanumeric keyboard will be used.
  /// To order to facilitate the usability, use `BACKSPACE`, `RETURN`, `SHIFT`,
  /// `SPACE` and `SWITCHLANGUAGE` for it's respective values in the keyboard.
  final List<List>? keys;

  /// border of every key in the keyboard.
  final Color? borderColor;

  /// used for multi-languages with default layouts, the default is English only
  /// will be ignored if customLayoutKeys is not null
  final List<VirtualKeyboardDefaultLayouts>? defaultLayouts;

  const VirtualKeyboard(
      {Key? key,
      this.onKeyPress,
      this.builder,
      this.width,
      this.defaultLayouts,
      this.customLayoutKeys,
      this.textController,
      this.reverseLayout = false,
      this.height = _virtualKeyboardDefaultHeight,
      this.textColor = Colors.black,
      this.fontSize = 14,
      this.spacebarFlex = 4,
      this.alwaysCaps = false,
      this.keys,
      this.borderColor})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VirtualKeyboardState();
  }
}

/// Holds the state for Virtual Keyboard class.
class _VirtualKeyboardState extends State<VirtualKeyboard> {
  Function(VirtualKeyboardKey)? onKeyPress;
  late TextEditingController textController;
  // The builder function will be called for each Key object.
  Widget Function(BuildContext context, VirtualKeyboardKey key)? builder;
  late double height;
  double? width;
  late Color textColor;
  late double fontSize;
  late int spacebarFlex;
  late bool alwaysCaps;
  late bool reverseLayout;
  late VirtualKeyboardLayoutKeys customLayoutKeys;
  // Text Style for keys.
  late TextStyle textStyle;
  late List<List> keys;
  // Utilized later to calculate the size of the keys
  bool customKeys = false;
  late Color borderColor;
  bool isShiftEnabled = false;
  KeyboardState _keyboardState = KeyboardState.primary;

  void _updateText(String newCharacters) {
    final currentOffset = textController.selection.baseOffset == -1 ? textController.text.length : textController.selection.baseOffset;
    final newText = textController.text.substring(0, currentOffset) + newCharacters + textController.text.substring(currentOffset);
    final newSelection = TextSelection.collapsed(offset: currentOffset + newCharacters.length);
    textController.value = TextEditingValue(text: newText, selection: newSelection);
  }

  void _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      final String newCharacters;
      if (alwaysCaps || isShiftEnabled) {
        newCharacters = key.capsText ?? '';
        isShiftEnabled = false;
        setState(() {});
      } else {
        newCharacters = key.text ?? '';
      }

      _updateText(newCharacters);
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (textController.text.isEmpty || textController.selection.baseOffset == 0) return;
          final currentOffset = textController.selection.baseOffset == -1 ? textController.text.length : textController.selection.baseOffset;
          final newText = textController.text.substring(0, currentOffset - 1) + textController.text.substring(currentOffset);
          final newSelection = TextSelection.collapsed(offset: currentOffset - 1);
          textController.value = TextEditingValue(text: newText, selection: newSelection);
          break;
        case VirtualKeyboardKeyAction.Return:
          textController.text += '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          _updateText(' ');
          break;
        case VirtualKeyboardKeyAction.Shift:
          if (!alwaysCaps) {
            setState(() {
              isShiftEnabled = !isShiftEnabled;
            });
          }
          break;
        case VirtualKeyboardKeyAction.SwitchToLetters:
          setState(() {
            _keyboardState = KeyboardState.primary;
          });
          break;
        case VirtualKeyboardKeyAction.SwitchToNumbers:
          setState(() {
            isShiftEnabled = false;
            _keyboardState = KeyboardState.secondary;
          });
          break;
        case VirtualKeyboardKeyAction.SwitchToSigns:
          setState(() {
            isShiftEnabled = false;
            _keyboardState = KeyboardState.tertiary;
          });
          break;
        default:
      }
    }

    onKeyPress?.call(key);
  }

  @override
  dispose() {
    if (widget.textController == null) {
      textController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(VirtualKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      builder = widget.builder;
      onKeyPress = widget.onKeyPress;
      height = widget.height;
      width = widget.width;
      textColor = widget.textColor;
      fontSize = widget.fontSize;
      spacebarFlex = widget.spacebarFlex;
      alwaysCaps = widget.alwaysCaps;
      reverseLayout = widget.reverseLayout;
      textController = widget.textController ?? textController;
      customLayoutKeys = widget.customLayoutKeys ?? customLayoutKeys;
      textStyle = TextStyle(
        fontSize: fontSize,
        color: textColor,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    borderColor = widget.borderColor ?? Colors.transparent;
    textController = widget.textController ?? TextEditingController();
    width = widget.width;
    customLayoutKeys = widget.customLayoutKeys ?? VirtualKeyboardDefaultLayoutKeys(widget.defaultLayouts ?? [VirtualKeyboardDefaultLayouts.English]);
    builder = widget.builder;
    onKeyPress = widget.onKeyPress;
    height = widget.height;
    textColor = widget.textColor;
    fontSize = widget.fontSize;
    spacebarFlex = widget.spacebarFlex;
    alwaysCaps = widget.alwaysCaps;
    reverseLayout = widget.reverseLayout;
    textStyle = TextStyle(
      fontSize: fontSize,
      color: textColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    // because sometimes you may transition between 2 different textfields,
    // you cant initialize the keys in the initState because it would cause the
    // keyboard to assume the first selected controller's row quantity.
    keys = widget.keys ?? [];

    return SizedBox(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _keyboardRows(),
      ),
    );
  }

  /// Returns the rows for keyboard.
  List<Widget> _keyboardRows() {
    List<List<VirtualKeyboardKey>> keyboardRows;
    if (keys.isNotEmpty) {
      keyboardRows = _getKeyboardRows(keys);
    } else if (_keyboardState == KeyboardState.primary) {
      keyboardRows = _getKeyboardRows(customLayoutKeys.activeLayout);
    } else if (_keyboardState == KeyboardState.secondary) {
      keyboardRows = _getKeyboardRows(customLayoutKeys.getDefaultNumbersLayout());
    } else if (_keyboardState == KeyboardState.tertiary) {
      keyboardRows = _getKeyboardRows(customLayoutKeys.getDefaultSignsLayout());
    } else {
      throw Exception('Invalid Keyboard State');
    }

    return keyboardRows
        .map(
          (keyboardRow) => Row(
            children: keyboardRow.map(
              (keyboardKey) {
                if (builder != null) {
                  return builder!(context, keyboardKey);
                } else {
                  return KeyWidget(
                    keyboardKey: keyboardKey,
                    alwaysCaps: alwaysCaps,
                    isShiftEnabled: isShiftEnabled,
                    borderColor: borderColor,
                    textColor: textColor,
                    style: textStyle,
                    fontSize: fontSize,
                    height: height / keyboardRows.length,
                    onKeyPress: _onKeyPress,
                    flex: keyboardKey.action == VirtualKeyboardKeyAction.Space ? spacebarFlex : 1,
                    enableLongpress: keyboardKey.action == VirtualKeyboardKeyAction.Backspace,
                  );
                }
              },
            ).toList(),
          ),
        )
        .toList();
  }
}
