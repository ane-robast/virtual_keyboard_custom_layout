import 'package:flutter/material.dart';
import 'package:virtual_keyboard_custom_layout/virtual_keyboard_custom_layout.dart';
import 'package:virtual_keyboard_custom_layout_example/custom_textfield.dart';
import 'package:virtual_keyboard_custom_layout_example/keyboard_aux.dart';
import 'package:virtual_keyboard_custom_layout_example/keyboard_provider.dart';
import 'package:virtual_keyboard_custom_layout_example/types_keyboard.dart';
import 'package:provider/provider.dart';

void main() => runApp(ChangeNotifierProvider(create: (context) => KeyboardProvider(), child: const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Keyboard Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Virtual Keyboard Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Holds the text that user typed.
  String text = '';

  // True if shift enabled.
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  // necessary to maintain the focus and to insert letters in the
  // middle of the string.
  TextEditingController controllerField01 = TextEditingController();
  TextEditingController controllerField02 = TextEditingController();
  TextEditingController controllerField03 = TextEditingController();

  // key variables to utilize the keyboard with the class KeyboardAux
  var isKeyboardVisible = false;
  var controllerKeyboard = TextEditingController();
  late TypeLayout typeLayout;

  @override
  void initState() {
    keyboardListeners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //FocusScope.of(context).unfocus();
        setState(() {
          isKeyboardVisible = false;
        });
        Provider.of<KeyboardProvider>(context, listen: false).key = null;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const CustomTextfield(),
              Expanded(
                child: Container(),
              ),
              if (Provider.of<KeyboardProvider>(context).key != null)
                VirtualKeyboard(
                  borderColor: Colors.red,
                  height: 400,
                  fontSize: 40,
                  textController: TextEditingController(text: Provider.of<KeyboardProvider>(context, listen: false).text),
                  defaultLayouts: const [VirtualKeyboardDefaultLayouts.Numeric],
                  onKeyPress: (key) {
                    print('key:');
                    final provider = Provider.of<KeyboardProvider>(context, listen: false);
                    if (key.keyType == VirtualKeyboardKeyType.Action) {
                      switch (key.action) {
                        case VirtualKeyboardKeyAction.Backspace:
                          print('backspace and ${provider.text}');
                          if (provider.text!.isNotEmpty) {
                            provider.text = provider.text!.substring(0, provider.text!.length - 1);
                          }
                          break;
                        case VirtualKeyboardKeyAction.Return:
                          provider.text = provider.text! + '\n';
                          break;
                        case VirtualKeyboardKeyAction.Space:
                          provider.text = provider.text! + ' ';
                          break;
                        case VirtualKeyboardKeyAction.Shift:
                          shiftEnabled = !shiftEnabled;
                          break;

                        default:
                          print('pressed unsupported action');
                          break;
                      }
                    } else if (key.keyType == VirtualKeyboardKeyType.String) {
                      print(key.text);
                      provider.text = provider.text! + key.text!;
                    }
                    provider.setTextState!();
                  },
                ),
              if (isKeyboardVisible)
                Stack(children: [
                  KeyboardAux(
                    alwaysCaps: true,
                    controller: controllerKeyboard,
                    typeLayout: typeLayout,
                  ),
                ]),
            ],
          ),
        ),
      ),
    );
  }

  keyboardListeners() {
    // Making the return function properly.
    controllerField01.addListener(() {
      if (controllerField01.value.text.endsWith("\n")) {
        controllerField01.text = controllerField01.value.text.replaceAll("\n", "");
        setState(() {
          controllerKeyboard = controllerField02;
          typeLayout = TypeLayout.alphaEmail;
        });
      }
    });
    controllerField02.addListener(() {
      if (controllerField02.value.text.endsWith("\n")) {
        controllerField02.text = controllerField02.value.text.replaceAll("\n", "");
        setState(() {
          controllerKeyboard = controllerField03;
          typeLayout = TypeLayout.numeric;
        });
      }
    });
    controllerField03.addListener(() {
      if (controllerField03.value.text.endsWith("\n")) {
        controllerField03.text = controllerField03.value.text.replaceAll("\n", "");
        setState(() {
          isKeyboardVisible = false;
        });
      }
    });
  }
}
