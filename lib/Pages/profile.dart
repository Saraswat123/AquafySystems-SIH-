import 'dart:async';
import 'package:aquafy_systems/Pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'watercondition.dart';
import 'widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late DatabaseReference ref;
  bool isloading = true;
  late double tds;
  late double turbidity;
  late double pH;
  bool isSafe = false;
  bool isNotificationOn = false;
  late String name = '';
  late String email = '';

  @override
  void initState() {
    super.initState();
    ref = FirebaseDatabase.instance.ref().child('waterProject');
    _initDatabaseListener();
    getUserName();
  }

  Future isNotified() async {}

  void _initDatabaseListener() async {
    ref.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        setState(() {
          tds = double.parse(event.snapshot.child('TDS').value.toString());
          turbidity =
              double.parse(event.snapshot.child('Turb').value.toString());
          pH = double.parse(event.snapshot.child('ph').value.toString());
          waterQuality();

          isloading = false;
        });
      }
    }, onError: (Object error) {});
  }

  void waterQuality() {
    if ((tdsState(tds) == 3 || tdsState(tds) == 1 || tdsState(tds) == 4) &&
        turbidityState(turbidity) == 1 &&
        phState(pH) == 1) {
      setState(() {
        isSafe = true;
      });
    } else {
      setState(() {
        isSafe = false;
      });
    }
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
          // Loop through all matching documents (even if there are more than one)
          for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
            Map<String, dynamic> userData =
                documentSnapshot.data() as Map<String, dynamic>;

            // Assuming 'Name' is the field storing the user's name
            String userFName = userData['First Name'] as String;

            String userLName = userData['Last name'] as String;
            String userEmail = userData['Email'] as String;
            // Set the 'name' variable and trigger a UI update using setState
            setState(() {
              name = "$userFName $userLName";
              email = userEmail;
            });
          }
        }
      }
    } catch (e) {
      setState(() {
        name = '';
        email = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    if (isloading && name == '' && email == '') {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 30),
              width: width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/BG.png'), fit: BoxFit.cover),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          size: height * 0.045,
                          color: Colors.white,
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width,
                          height: height * 0.3,
                          child: FittedBox(
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: width * 0.1),
                                  padding: const EdgeInsets.all(50),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                    color: (isSafe)
                                        ? const Color.fromARGB(255, 5, 130, 94)
                                        : const Color.fromARGB(
                                            255, 255, 62, 62),
                                  ),
                                  child: FontText(
                                    text: (isSafe)
                                        ? "Water is\nfit for drinking."
                                        : 'Water is not\nfit for drinking.',
                                    weight: FontWeight.bold,
                                    size: height * 0.05,
                                    maxlines: 2,
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.4,
                                  child: (isSafe)
                                      ? Image.asset('assets/drink.png')
                                      : Image.asset('assets/fever.png'),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: height * 0.09),
                          width: width,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              image: DecorationImage(
                                  image: AssetImage('assets/BG2.png'),
                                  fit: BoxFit.cover)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: width,
                                      child: Icon(
                                        Icons.account_circle,
                                        color: const Color.fromARGB(
                                            255, 124, 117, 117),
                                        size: height * 0.15,
                                      ),
                                    ),
                                    ProfileDetailsTab(
                                        parameter: 'Name:', value: name),
                                    SizedBox(
                                      width: width * 0.8,
                                      child: const Divider(
                                        thickness: 2,
                                      ),
                                    ),
                                    ProfileDetailsTab(
                                        parameter: 'Email:', value: email),
                                    SizedBox(
                                      width: width * 0.8,
                                      child: const Divider(
                                        thickness: 2,
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.04,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        FirebaseAuth.instance.signOut();
                                        Timer(
                                            const Duration(seconds: 2), () {});
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LogIn(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: width * 0.8,
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          color: Color.fromARGB(
                                              255, 103, 177, 198),
                                        ),
                                        child: FontText(
                                          text: "Log out",
                                          align: TextAlign.center,
                                          weight: FontWeight.w100,
                                          size: height * 0.03,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.03,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
