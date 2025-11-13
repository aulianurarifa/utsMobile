import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum _ButtonMood { plain, accent, alert }

class KalkulatorPage extends StatefulWidget {
  const KalkulatorPage({super.key});

  @override
  State<KalkulatorPage> createState() => _KalkulatorPageState();
}

class _KalkulatorPageState extends State<KalkulatorPage> {
  static const String _multiplySymbol = '\u00d7';
  static const String _divideSymbol = '\u00f7';
  static const String _squareSymbol = 'x\u00b2';
  static const String _rootSymbol = '\u221a';
  static const Color _plainTextColor = Color(0xFF3A3251);
  static const Color _accentTextColor = Color(0xFF453A6B);
  static const Color _alertTextColor = Color(0xFF4A2C3F);

  String _output = '0';
  String _currentNumber = '';
  String _operator = '';
  double _num1 = 0;
  double _num2 = 0;

  static const LinearGradient _accentGradient = LinearGradient(
    colors: <Color>[Color(0xFF8EDBFF), Color(0xFFFF9FD3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient _alertGradient = LinearGradient(
    colors: <Color>[Color(0xFFFF8DB6), Color(0xFFFF7BA3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _output = '0';
        _currentNumber = '';
        _operator = '';
        _num1 = 0;
        _num2 = 0;
      } else if (<String>{
        '+',
        '-',
        _multiplySymbol,
        _divideSymbol,
      }.contains(buttonText)) {
        _num1 = double.parse(_output);
        _operator = buttonText;
        _currentNumber = '';
      } else if (buttonText == '=') {
        _num2 = double.parse(_output);
        switch (_operator) {
          case '+':
            _output = (_num1 + _num2).toString();
            break;
          case '-':
            _output = (_num1 - _num2).toString();
            break;
          case _multiplySymbol:
            _output = (_num1 * _num2).toString();
            break;
          case _divideSymbol:
            _output = _num2 != 0 ? (_num1 / _num2).toString() : 'Error';
            break;
        }
        _currentNumber = _output;
        _operator = '';
        _num1 = 0;
        _num2 = 0;
      } else if (buttonText == _squareSymbol) {
        final double numValue = double.parse(_output);
        _output = (numValue * numValue).toString();
        _currentNumber = _output;
      } else if (buttonText == _rootSymbol) {
        final double numValue = double.parse(_output);
        _output = numValue >= 0 ? sqrt(numValue).toString() : 'Error';
        _currentNumber = _output;
      } else if (buttonText == '.') {
        if (!_currentNumber.contains('.')) {
          _currentNumber += buttonText;
          _output = _currentNumber;
        }
      } else {
        if (_output == '0' ||
            (_operator.isNotEmpty && _currentNumber.isEmpty)) {
          _currentNumber = buttonText;
        } else {
          _currentNumber += buttonText;
        }
        _output = _currentNumber;
      }

      if (_output.contains('.') && _output.split('.')[1].length > 8) {
        _output = double.parse(_output).toStringAsFixed(8);
      }
    });
  }

  Widget _buildButton(String label, {_ButtonMood mood = _ButtonMood.plain}) {
    final TextStyle textStyle = GoogleFonts.vt323(
      fontSize: 28,
      letterSpacing: 1.2,
      color: switch (mood) {
        _ButtonMood.alert => _alertTextColor,
        _ButtonMood.accent => _accentTextColor,
        _ => _plainTextColor,
      },
    );

    BoxDecoration decoration;
    switch (mood) {
      case _ButtonMood.accent:
        decoration = BoxDecoration(
          gradient: _accentGradient,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF5E73D4), width: 1.4),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF5E73D4).withValues(alpha: 0.28),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        );
        break;
      case _ButtonMood.alert:
        decoration = BoxDecoration(
          gradient: _alertGradient,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFB34161), width: 1.4),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFFB34161).withValues(alpha: 0.28),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        );
        break;
      case _ButtonMood.plain:
        decoration = BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD4CFF0), width: 1.2),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF8A83C2).withValues(alpha: 0.18),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        );
        break;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _buttonPressed(label),
          child: Ink(
            decoration: decoration,
            child: Center(child: Text(label, style: textStyle)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle headerStyle = GoogleFonts.fredoka(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF574374),
    );
    final TextStyle subtitleStyle = GoogleFonts.vt323(
      fontSize: 18,
      letterSpacing: 1.2,
      color: const Color(0xFF756FA0),
    );
    final TextStyle outputStyle = GoogleFonts.vt323(
      fontSize: 54,
      letterSpacing: 2.2,
      color: const Color(0xFF2F2640),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFCEAFF),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xFFFCEAFF),
                Color(0xFFF9F6FF),
                Color(0xFFFFEFFE),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: CustomPaint(
                  painter: _PixelGridPainter(
                    color: Colors.grey.withValues(alpha: 0.12),
                  ),
                ),
              ),
              const _StickerBadge(
                asset: 'assets/images/stiker1.png',
                top: 12,
                right: 18,
                width: 96,
                opacity: 0.9,
              ),
              const _StickerBadge(
                asset: 'assets/images/stiker2.png',
                bottom: 24,
                left: -6,
                width: 132,
                opacity: 0.8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Kalkulator', style: headerStyle),
                        const SizedBox(height: 6),
                        Text('Hitung cepat ', style: subtitleStyle),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(24, 26, 24, 26),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.82),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: const Color(0xFFB9B4D8),
                          width: 1.4,
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: const Color(
                              0xFF8A83C2,
                            ).withValues(alpha: 0.2),
                            blurRadius: 24,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _output,
                          style: outputStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color(0xFFD7D3EC),
                            width: 1.4,
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: const Color(
                                0xFF8A83C2,
                              ).withValues(alpha: 0.18),
                              blurRadius: 26,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    _buildButton('C', mood: _ButtonMood.alert),
                                    _buildButton(
                                      _rootSymbol,
                                      mood: _ButtonMood.accent,
                                    ),
                                    _buildButton(
                                      _squareSymbol,
                                      mood: _ButtonMood.accent,
                                    ),
                                    _buildButton(
                                      _divideSymbol,
                                      mood: _ButtonMood.accent,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    _buildButton('7'),
                                    _buildButton('8'),
                                    _buildButton('9'),
                                    _buildButton(
                                      _multiplySymbol,
                                      mood: _ButtonMood.accent,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    _buildButton('4'),
                                    _buildButton('5'),
                                    _buildButton('6'),
                                    _buildButton('-', mood: _ButtonMood.accent),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    _buildButton('1'),
                                    _buildButton('2'),
                                    _buildButton('3'),
                                    _buildButton('+', mood: _ButtonMood.accent),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    _buildButton('0'),
                                    _buildButton('.'),
                                    _buildButton('=', mood: _ButtonMood.accent),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StickerBadge extends StatelessWidget {
  const _StickerBadge({
    required this.asset,
    this.top,
    this.left,
    this.right,
    this.bottom,
    this.width,
    this.opacity = 1.0,
  });

  final String asset;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double? width;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: IgnorePointer(
        ignoring: true,
        child: Opacity(
          opacity: opacity,
          child: Image.asset(asset, width: width),
        ),
      ),
    );
  }
}

class _PixelGridPainter extends CustomPainter {
  const _PixelGridPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const double cell = 20;
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    for (double x = 0; x <= size.width; x += cell) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += cell) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PixelGridPainter oldDelegate) =>
      oldDelegate.color != color;
}
