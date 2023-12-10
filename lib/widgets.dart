import 'package:flutter/material.dart';

class FontText extends StatelessWidget {
  final String text;
  final FontWeight weight;
  final double size;
  final Color color;

  const FontText(
      {super.key,
      this.color = const Color.fromRGBO(254, 255, 255, 1),
      required this.text,
      required this.weight,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      "$text",
      style: TextStyle(
          fontSize: size,
          fontFamily: "MavenPro",
          fontWeight: weight,
          color: color,
          overflow: TextOverflow.ellipsis),
    );
  }
}

class ParameterBox extends StatelessWidget {
  final String parameter;
  final double value;
  final String unit;
  ParameterBox(
      {super.key,
      required this.parameter,
      required this.value,
      required this.unit});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          height: height * 0.13,
          decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                Color.fromRGBO(36, 215, 254, 1),
                Color.fromRGBO(149, 253, 255, 1)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FontText(
                    text: parameter,
                    weight: FontWeight.w100,
                    size: height * 0.026),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FontText(
                        text: value.toStringAsFixed(2),
                        weight: FontWeight.w300,
                        size: height * 0.03),
                    FontText(
                        text: unit,
                        weight: FontWeight.w300,
                        size: height * 0.02)
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: height * 0.02,
        )
      ],
    );
  }
}

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

class InBox extends StatelessWidget {
  final String name;
  final bool obscure;
  final TextEditingController controller;
  const InBox(
      {super.key,
      required this.name,
      required this.obscure,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FontText(
            text: "  " + name, weight: FontWeight.w100, size: height * 0.03),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 6),
          height: height * 0.05,
          width: width * 0.8,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          child: TextField(
            style: TextStyle(
                fontSize: height * 0.018,
                fontFamily: "MavenPro",
                fontWeight: FontWeight.w100,
                color: Colors.black,
                overflow: TextOverflow.ellipsis),
            controller: controller,
            obscureText: obscure,
            obscuringCharacter: "*",
            decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none),
          ),
        )
      ],
    );
  }
}
