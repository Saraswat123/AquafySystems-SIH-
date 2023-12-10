import 'package:flutter/material.dart';
import 'package:water_resources/Pages/widgets.dart';

class HomePage extends StatefulWidget {
  final String name;
  final double tds;
  final double turbidity;
  final double temperature;
  final double dO;
  final double pH;
  final double pressure;
  final double depth;
  final double flowDischarge;
  const HomePage(
      {Key? key,
      this.name = '',
      required this.tds,
      required this.turbidity,
      required this.temperature,
      required this.dO,
      required this.pH,
      required this.pressure,
      required this.depth,
      required this.flowDischarge})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.refresh),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/Resources/BG.png'), fit: BoxFit.cover)),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 0, bottom: height * 0.02, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FontText(
                          text: 'Testing Water',
                          weight: FontWeight.bold,
                          size: height * 0.04),
                      FontText(
                        text: getGreeting(),
                        weight: FontWeight.w100,
                        size: height * 0.025,
                      ),
                      FontText(
                        text: widget.name,
                        weight: FontWeight.w100,
                        size: height * 0.025,
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.account_circle,
                      size: height * 0.06,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  image: DecorationImage(
                      image: AssetImage('lib/Resources/BG2.png'),
                      fit: BoxFit.cover)),
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FontText(
                      text: "Water Quality Index",
                      weight: FontWeight.w100,
                      size: height * 0.03,
                      color: const Color.fromRGBO(1, 133, 183, 1),
                    ),
                    SizedBox(height: height * 0.02),
                    ParameterBox(
                      parameter: 'TDS',
                      value: widget.tds,
                      unit: 'units',
                    ),
                    ParameterBox(
                      parameter: 'Turbidity',
                      value: widget.turbidity,
                      unit: 'units',
                    ),
                    ParameterBox(
                      parameter: 'Temperature',
                      value: widget.temperature,
                      unit: 'units',
                    ),
                    ParameterBox(
                      parameter: 'D.O.',
                      value: widget.dO,
                      unit: 'units',
                    ),
                    ParameterBox(
                      parameter: 'pH',
                      value: widget.pH,
                      unit: 'units',
                    ),
                    FontText(
                      text: "Water Quantity Index",
                      weight: FontWeight.w100,
                      size: height * 0.03,
                      color: const Color.fromRGBO(1, 133, 183, 1),
                    ),
                    SizedBox(height: height * 0.02),
                    ParameterBox(
                      parameter: 'Pressure',
                      value: widget.pressure,
                      unit: 'units',
                    ),
                    ParameterBox(
                      parameter: 'Depth',
                      value: widget.depth,
                      unit: 'units',
                    ),
                    ParameterBox(
                      parameter: 'Flow Discharge',
                      value: widget.flowDischarge,
                      unit: 'units',
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
