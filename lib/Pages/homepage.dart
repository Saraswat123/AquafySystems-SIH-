import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:water_resources/Pages/profile.dart';
import 'package:water_resources/Pages/watercondition.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:water_resources/Pages/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseReference ref;
  late FirebaseFirestore db;
  String name = '';
  bool isloading = true;
  bool isflowtapped = false;
  late double tds;
  late double turbidity;
  late double temperature;
  late double dO;
  late double pH;
  late double depth;
  late double flowDischarge;
  late double inflow;
  late double outflow;
  @override
  void initState() {
    super.initState();
    ref = FirebaseDatabase.instance.ref().child('waterProject');

    _initDatabaseListener();
    getUserName();
  }

  void _initDatabaseListener() async {
    ref.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        setState(() {
          tds = double.parse(event.snapshot.child('TDS').value.toString());
          turbidity =
              double.parse(event.snapshot.child('Turb').value.toString());
          temperature =
              double.parse(event.snapshot.child('Temp').value.toString());
          dO = double.parse(event.snapshot.child('DO').value.toString());
          pH = double.parse(event.snapshot.child('ph').value.toString());
          depth = double.parse(event.snapshot.child('depth').value.toString());
          flowDischarge =
              double.parse(event.snapshot.child('flow').value.toString());
          inflow =
              double.parse(event.snapshot.child('inflow').value.toString());
          outflow =
              double.parse(event.snapshot.child('outflow').value.toString());
          isloading = false;
        });
      }
    }, onError: (Object error) {});
  }

  void getUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('Email', isEqualTo: user.email)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
            Map<String, dynamic> userData =
                documentSnapshot.data() as Map<String, dynamic>;

            // Assuming 'Name' is the field storing the user's name
            String userName = userData['First Name'] as String;

            // Set the 'name' variable and trigger a UI update using setState
            setState(() {
              name = userName;
            });
          }
        } else {
          // If no matching documents are found, set 'name' to an empty string
        }
      } else {
        // If no user is currently logged in, set 'name' to an empty string
      }
    } catch (e) {
      // Handle errors and set 'name' to an empty string
      setState(() {
        name = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    if (isloading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(top: 30),
            width: width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('lib/Resources/BG.png'),
                    fit: BoxFit.cover)),
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
                            text: name,
                            weight: FontWeight.w100,
                            size: height * 0.025,
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfilePage()),
                          );
                        },
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
                  width: width,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      image: DecorationImage(
                          image: AssetImage('lib/Resources/BG2.png'),
                          fit: BoxFit.cover)),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                          value: tds,
                          unit: 'mg/L',
                          condition: conditionString[tdsState(tds)],
                          color: conditionColor[tdsState(tds)],
                        ),
                        ParameterBox(
                            parameter: 'Turbidity',
                            value: turbidity,
                            unit: 'NTU',
                            condition:
                                conditionString[turbidityState(turbidity)],
                            color: conditionColor[turbidityState(turbidity)]),
                        ParameterBox(
                          parameter: 'Temperature',
                          value: temperature,
                          unit: '°C',
                        ),
                        ParameterBox(
                          parameter: 'D.O.',
                          value: dO,
                          unit: 'mg/L',
                        ),
                        ParameterBox(
                            parameter: 'pH',
                            value: pH,
                            unit: '     ',
                            condition: conditionString[phState(pH)],
                            color: conditionColor[phState(pH)]),
                        FontText(
                          text: "Water Quantity Index",
                          weight: FontWeight.w100,
                          size: height * 0.03,
                          color: const Color.fromRGBO(1, 133, 183, 1),
                        ),
                        SizedBox(height: height * 0.02),
                        ParameterBox(
                          parameter: 'Depth',
                          value: depth,
                          unit: 'm',
                        ),
                        if (!isflowtapped)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isflowtapped = !isflowtapped;
                              });
                            },
                            child: ParameterBox(
                              parameter: 'Flow Discharge',
                              value: flowDischarge,
                              unit: 'L/min',
                            ),
                          ),
                        if (isflowtapped)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isflowtapped = !isflowtapped;
                              });
                            },
                            child: SizedBox(
                              width: width,
                              child: FlowBox(
                                  parameter1: "Inflow",
                                  value1: inflow,
                                  parameter2: "Outflow",
                                  value2: outflow,
                                  unit: 'L/min'),
                            ),
                          ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
