import 'package:calculator_app/view/calculator_theme_view.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final List<String> buttonValues = [
    "*",
    "C",
    "<-",
    "/",
    "1",
    "2",
    "3",
    "+",
    "4",
    "5",
    "6",
    "-",
    "7",
    "8",
    "9",
    "*",
    "%",
    "0",
    ".",
    "=",
  ];

  final TextEditingController _textController = TextEditingController();
  String _displayText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CalculatorTheme.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Calculator",
          style: TextStyle(
            fontSize: 50,
            color: CalculatorTheme.titleTextColor,
          ),
        ),
        backgroundColor: CalculatorTheme.appBarColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CalculatorDisplay(textController: _textController),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CalculatorKeypad(
              buttonValues: buttonValues,
              onPressed: _handleButtonPress,
            ),
          ),
        ],
      ),
    );
  }

  void _handleButtonPress(String value) {
    setState(() {
      if (value == "C") {
        _displayText = '';
      } else if (value == "<-") {
        if (_displayText.isNotEmpty) {
          _displayText = _displayText.substring(0, _displayText.length - 1);
        }
      } else if (value == "=") {
        _displayText = _calculateResult(_displayText);
      } else {
        _displayText += value;
      }

      _textController.text = _displayText;
    });
  }

  String _calculateResult(String expression) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (e) {
      return "Error";
    }
  }
}

class CalculatorDisplay extends StatelessWidget {
  final TextEditingController textController;

  const CalculatorDisplay({Key? key, required this.textController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      readOnly: true,
      textAlign: TextAlign.right,
      style: const TextStyle(fontSize: 24),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(18),
      ),
    );
  }
}

class CalculatorKeypad extends StatelessWidget {
  final List<String> buttonValues;
  final Function(String) onPressed;

  const CalculatorKeypad(
      {Key? key, required this.buttonValues, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: buttonValues.length,
      itemBuilder: (context, index) {
        return CalculatorButton(
          label: buttonValues[index],
          onPressed: () => onPressed(buttonValues[index]),
        );
      },
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CalculatorButton(
      {Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: CalculatorTheme.buttonBackgroundColor,
        foregroundColor: CalculatorTheme.buttonTextColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 25),
      ),
    );
  }
}
