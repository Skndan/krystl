import 'package:flutter/material.dart';

/// Created by Balaji Malathi on 5/27/2024 at 21:39.
class Keypad extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const Keypad({super.key, required this.onChanged});

  @override
  State<Keypad> createState() => _KeypadState();
}

class _KeypadState extends State<Keypad> {
  String _input = '';

  void _onKeyPress(String key) {
    setState(() {
      if (key == 'C') {
        _input = '';
      } else if (key == 'DEL') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else {
        _input += key;
      }
      widget.onChanged(_input);
    });
  }

  Widget _buildKey(String key) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _onKeyPress(key),
          child: Text(key, style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(_input, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        _buildKeypad(),
      ],
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        Row(
          children: <Widget>[
            _buildKey('1'),
            _buildKey('2'),
            _buildKey('3'),
          ],
        ),
        Row(
          children: <Widget>[
            _buildKey('4'),
            _buildKey('5'),
            _buildKey('6'),
          ],
        ),
        Row(
          children: <Widget>[
            _buildKey('7'),
            _buildKey('8'),
            _buildKey('9'),
          ],
        ),
        Row(
          children: <Widget>[
            _buildKey('C'), // Clear button
            _buildKey('0'),
            _buildKey('DEL'), // Delete button
          ],
        ),
      ],
    );
  }
}
