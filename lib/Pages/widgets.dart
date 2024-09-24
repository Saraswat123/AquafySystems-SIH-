import 'package:flutter/material.dart';

//Text with Maven Pro font
class FontText extends StatelessWidget {
  final String text;
  final FontWeight weight;
  final double size;
  final Color color;
  final TextOverflow overflow;
  final TextAlign align;
  final int maxlines;
  const FontText(
      {super.key,
      this.color = const Color.fromRGBO(254, 255, 255, 1),
      required this.text,
      required this.weight,
      required this.size,
      this.maxlines = 1,
      this.overflow = TextOverflow.ellipsis,
      this.align = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontFamily: "MavenPro",
        fontWeight: weight,
        color: color,
        overflow: overflow,
      ),
      textAlign: align,
      maxLines: maxlines,
    );
  }
}

//Homepage Parametrers Box
class ParameterBox extends StatelessWidget {
  final String parameter;
  final double value;
  final String unit;
  final String condition;
  final Color color;
  final bool overflow;
  const ParameterBox({
    super.key,
    required this.parameter,
    required this.value,
    required this.unit,
    this.condition = '',
    this.color = Colors.red,
    this.overflow = false,
  });

  @override
  Widget build(BuildContext context) {
    String superscript(int exponent) {
      const Map<int, String> superscripts = {
        0: '\u2070',
        1: '\u00B9',
        2: '\u00B2',
        3: '\u00B3',
        4: '\u2074',
        5: '\u2075',
        6: '\u2076',
        7: '\u2077',
        8: '\u2078',
        9: '\u2079',
      };

      String result = '';
      for (var digit in exponent.toString().runes) {
        result += superscripts[int.parse(String.fromCharCode(digit))]!;
      }

      return result;
    }

    String power(double n) {
      if (n > 100000) {
        int exponent = 0;
        double coefficient = n.abs();

        while (coefficient >= 10.0) {
          coefficient /= 10.0;
          exponent++;
        }

        if (n < 0) {
          coefficient = -coefficient;
        }

        if (coefficient == 1) {
          return '10${superscript(exponent)}';
        } else {
          return '${coefficient.toStringAsFixed(2)}x10${superscript(exponent)}';
        }
      } else {
        return n.toStringAsFixed(2);
      }
    }

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.02),
      height: height * 0.13,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color(0xFF1E185F),
            Color(0xFF3E32C5),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FontText(
                  text: parameter,
                  weight: FontWeight.w100,
                  size: height * 0.026),
              if (condition != '')
                Row(
                  children: [
                    FontText(
                        text: "State: ",
                        weight: FontWeight.w100,
                        size: height * 0.02),
                    FontText(
                        text: condition,
                        weight: FontWeight.bold,
                        size: height * 0.02,
                        color: color),
                  ],
                ),
            ],
          ),
          SizedBox(
            child: FontText(
              text: (overflow) ? "${power(value)}\n$unit" : power(value) + unit,
              weight: FontWeight.w300,
              size: height * 0.022,
              align: TextAlign.end,
              overflow: (overflow) ? TextOverflow.visible : TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }
}

//Get good morning, good afternoon and good evening messages
String getGreeting() {
  var now = DateTime.now();
  var hour = now.hour;
  if (hour < 12) {
    return 'Good morning,';
  } else if (hour < 17) {
    return 'Good afternoon,';
  } else {
    return 'Good evening,';
  }
}

//sign in and log in text input field
class InBox extends StatelessWidget {
  final String name;
  final bool obscure;
  final TextEditingController controller;
  const InBox({
    super.key,
    required this.name,
    this.obscure = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FontText(text: " $name", weight: FontWeight.w100, size: height * 0.02),
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 6),
          height: height * 0.05,
          width: width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            style: TextStyle(
              fontSize: height * 0.018,
              fontFamily: "MavenPro",
              fontWeight: FontWeight.w200,
              color: Colors.black,
              overflow: TextOverflow.ellipsis,
            ),
            controller: controller,
            obscureText: obscure,
            obscuringCharacter: "*",
            decoration: const InputDecoration(
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }
}

//in the profile tab to display the name and email
class ProfileDetailsTab extends StatelessWidget {
  final String parameter;
  final String value;

  const ProfileDetailsTab(
      {super.key, required this.parameter, required this.value});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FontText(
            text: parameter,
            weight: FontWeight.w300,
            size: height * 0.015,
            color: const Color.fromARGB(255, 122, 113, 113),
          ),
          FontText(
            text: value,
            weight: FontWeight.w300,
            size: height * 0.022,
            color: const Color.fromARGB(255, 21, 20, 20),
          ),
        ],
      ),
    );
  }
}

//to show the inflow and outflow
class FlowBox extends StatelessWidget {
  final String parameter1;
  final double value1;
  final String parameter2;
  final double value2;
  final String unit;

  const FlowBox({
    super.key,
    required this.unit,
    required this.parameter1,
    required this.value1,
    required this.parameter2,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    String superscript(int exponent) {
      const Map<int, String> superscripts = {
        0: '\u2070',
        1: '\u00B9',
        2: '\u00B2',
        3: '\u00B3',
        4: '\u2074',
        5: '\u2075',
        6: '\u2076',
        7: '\u2077',
        8: '\u2078',
        9: '\u2079',
      };

      String result = '';
      for (var digit in exponent.toString().runes) {
        result += superscripts[int.parse(String.fromCharCode(digit))]!;
      }

      return result;
    }

    String power(double n) {
      if (n > 100000) {
        int exponent = 0;
        double coefficient = n.abs();

        while (coefficient >= 10.0) {
          coefficient /= 10.0;
          exponent++;
        }

        if (n < 0) {
          coefficient = -coefficient;
        }

        if (coefficient == 1) {
          return '10${superscript(exponent)}';
        } else {
          return '${coefficient.toStringAsFixed(2)}x10${superscript(exponent)}';
        }
      } else {
        return n.toStringAsFixed(2);
      }
    }

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.02),
      height: height * 0.13,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color.fromRGBO(36, 156, 254, 1),
            Color.fromRGBO(108, 215, 250, 1),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FontText(
                  text: parameter1,
                  weight: FontWeight.w100,
                  size: height * 0.026),
              SizedBox(
                width: width * 0.4,
                child: FontText(
                  text: power(value1) + unit,
                  weight: FontWeight.w300,
                  size: height * 0.022,
                  align: TextAlign.end,
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.001,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FontText(
                  text: parameter2,
                  weight: FontWeight.w100,
                  size: height * 0.026),
              SizedBox(
                width: width * 0.4,
                child: FontText(
                  text: power(value2) + unit,
                  weight: FontWeight.w300,
                  size: height * 0.022,
                  align: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
