import 'package:flutter/material.dart';
import 'package:krystl/core/extensions/string_extension.dart';
import 'package:krystl/core/extensions/widget_extension.dart';
import 'package:solar_icons/solar_icons.dart';

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
      if (key == 'DEL') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else {
        if (_input.isEmpty) {
          if (key.startsWith('0')) {
            return;
          }
        }
        _input += key;
      }
      widget.onChanged(_input);
    });
  }

  Widget _buildKey(String key) {
    return Expanded(
      child: FilledButton(
        onPressed: () => _onKeyPress(key),
        style: FilledButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
          minimumSize: const Size(100, 56), //////// HERE
        ),
        child: Text(key,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildIcon(String key) {
    return Expanded(
      child: FilledButton(
        onPressed: () => _onKeyPress(key),
        style: FilledButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
          minimumSize: const Size(100, 56), //////// HERE
        ),
        child: const Icon(
          SolarIconsBold.backspace,
          size: 24,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 20),
        _buildKeypad(),
      ],
    );
  }
  // secondary
  // secondaryContainer
  Widget _buildKeypad() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(36)
      ),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              _buildKey('1'),
              _buildKey('2'),
              _buildKey('3'),
            ].divide(const SizedBox(
              width: 4,
            )),
          ),
          Row(
            children: <Widget>[
              _buildKey('4'),
              _buildKey('5'),
              _buildKey('6'),
            ].divide(const SizedBox(
              width: 4,
            )),
          ),
          Row(
            children: <Widget>[
              _buildKey('7'),
              _buildKey('8'),
              _buildKey('9'),
            ].divide(const SizedBox(
              width: 4,
            )),
          ),
          Row(
            children: <Widget>[
              _buildKey('00'), // Clear button
              _buildKey('0'),
              _buildIcon('DEL'), // Delete button
            ].divide(const SizedBox(
              width: 4,
            )),
          ),
        ].divide(const SizedBox(
          height: 4,
        )),
      ),
    );
  }
}
