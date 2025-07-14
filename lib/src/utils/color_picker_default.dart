import 'dart:async';
import 'dart:math';

import 'package:flex_color_picker/flex_color_picker.dart' as color;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quill_html_editor/src/widgets/webviewx/src/utils/utils.dart';

/// Function for select color
Future<Color> colorPickerDefault(
  BuildContext context, {
  required Color color,
  TapDownDetails? tap,
}) async {
  var dx = tap!.globalPosition.dx - (tap.localPosition.dx + 140);
  var dy = tap.globalPosition.dy - (tap.localPosition.dy - 30);

  final cor = await showMenu<Color>(
    context: context,
    position: RelativeRect.fromLTRB(dx, dy, dx, dy),
    color: Colors.transparent,
    elevation: 0,
    items: [
      PopupMenuItem(
        enabled: false,
        child: WebViewAware(
          child: Card(
            child: Column(
              children: [
                // TextButton(
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                //   child: Text(
                //     'X',
                //     style: TextStyle(color: Color.fromRGBO(42, 96, 232, 1)),
                //   ),
                // ),
                _MultiColorPicker(colorSelect: color),
                InkWell(
                  onTap: () async {
                    final colorPicked = await colorPickerSquare(context, color);

                    Navigator.of(context).pop(colorPicked);
                  },
                  child: const Text(
                    'Escolher nova cor',
                    style: TextStyle(
                      color: Color.fromRGBO(42, 96, 232, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  return cor ?? color;
}

/// Function for select color
Future<Color?> colorPickerSquare(BuildContext context, Color color) async {
  return showDialog<Color>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return ChangeNotifierProvider<_NewColorPickerState>(
        create: (context) => _NewColorPickerState(color: color),
        child: Consumer<_NewColorPickerState>(
          builder: (_, state, __) {
            return WebViewAware(
              child: Center(
                child: SizedBox(
                  width: 450,
                  height: 500,
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: Text(
                                'Selecione uma cor',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const _ColorPicker(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                style: const ButtonStyle(
                                  foregroundColor:
                                      WidgetStatePropertyAll<Color?>(
                                    Color.fromRGBO(42, 96, 232, 1),
                                  ),
                                  textStyle: WidgetStatePropertyAll<TextStyle?>(
                                    TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                child: const Text('Cancelar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                style: const ButtonStyle(
                                  foregroundColor:
                                      WidgetStatePropertyAll<Color?>(
                                    Color.fromRGBO(42, 96, 232, 1),
                                  ),
                                  textStyle: WidgetStatePropertyAll<TextStyle?>(
                                    TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                child: const Text('Confirmar'),
                                onPressed: () {
                                  Navigator.of(context).pop(state.color);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<_NewColorPickerState>(context);

    final textStyle = validateTextStyle(state.color);

    return Material(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: color.ColorPicker(
                width: 32,
                height: 32,
                spacing: 8,
                enableOpacity: false,
                wheelDiameter: 280,
                color: state.color,
                pickersEnabled: const <color.ColorPickerType, bool>{
                  color.ColorPickerType.both: false,
                  color.ColorPickerType.primary: false,
                  color.ColorPickerType.accent: false,
                  color.ColorPickerType.bw: false,
                  color.ColorPickerType.custom: false,
                  color.ColorPickerType.wheel: true,
                },
                tonalColorSameSize: true,
                wheelSquarePadding: 2,
                onColorChanged: state.selectColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: state.color,
                borderRadius: BorderRadius.circular(
                  8,
                ),
              ),
              child: Text(
                state.color.hexAlpha,
                style: textStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MultiColorPicker extends StatelessWidget {
  const _MultiColorPicker({required this.colorSelect});

  final Color colorSelect;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: color.ColorPicker(
                enableShadesSelection: false,
                width: 24,
                height: 24,
                spacing: 8,
                color: colorSelect,
                pickersEnabled: const <color.ColorPickerType, bool>{
                  color.ColorPickerType.both: true,
                  color.ColorPickerType.primary: false,
                  color.ColorPickerType.accent: false,
                  color.ColorPickerType.bw: false,
                  color.ColorPickerType.custom: false,
                  color.ColorPickerType.wheel: false,
                },
                onColorChanged: (value) {
                  Navigator.of(context).pop(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Button select color
class ButtonSelectColor extends StatelessWidget {
  /// Default constructor
  const ButtonSelectColor({
    super.key,
    required this.color,
    required this.onTap,
    required this.title,
    this.buttonPadding,
    this.isBackground = false,
  });

  /// Color of change and select
  final Color color;

  /// Method for onTap in inkWell
  final Future<void> Function(TapDownDetails tap) onTap;

  /// Title in the center container with a [color]
  final String title;

  /// Button padding [EdgeInsetsGeometry]
  final EdgeInsetsGeometry? buttonPadding;

  /// Boolean to background color
  final bool isBackground;

  @override
  Widget build(BuildContext context) {
    final greyscale = validateTextStyle(
      color,
    );

    return Material(
      color: isBackground ? color : Colors.transparent,
      child: InkWell(
        onHover: (value) {},
        onTapDown: (details) async {
          await onTap(details);
        },
        child: Center(
          child: isBackground
              ? Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color,
                  ),
                  height: 20,
                  width: 20,
                  child: Center(
                    child: Text(
                      'A',
                      style: greyscale.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    const Text(
                      'A',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    Container(
                      height: 4,
                      decoration: BoxDecoration(color: color),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

class _NewColorPickerState extends ChangeNotifier {
  _NewColorPickerState({required this.color}) {
    _init();
  }

  Color color;

  void _init() {
    if (color.a < 0.1) {
      color = generateRandomPastelColor();
    }
  }

  void selectColor(Color value) {
    color = value;
    notifyListeners();
  }
}

/// Method for validate text style
TextStyle validateTextStyle(Color color) {
  return TextStyle(color: isLight(color) ? Colors.black : Colors.white);
}

/// Validate if color selected is light or dark based in RGB
bool isLight(Color color) {
  final red = color.r;
  final green = color.g;
  final blue = color.b;
  final opacity = color.a;

  final grayscale = (0.299 * red) + (0.587 * green) + (0.114 * blue);
  return grayscale > 0.5 || opacity < 0.4;
}

/// Method to generate random colors
Color generateRandomPastelColor() {
  final random = Random();

  final hue = random.nextInt(360);
  final saturation = random.nextDouble() * 0.3 + 0.3;
  final lightness = random.nextDouble() * 0.3 + 0.6;

  final color = HSLColor.fromAHSL(
    1.0,
    hue.toDouble(),
    saturation,
    lightness,
  );
  return color.toColor();
}
