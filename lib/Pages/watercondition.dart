import 'package:flutter/material.dart';

List<String> conditionString = [
  'Poor',
  'Good',
  'Unacceptable',
  'Excellent ',
  'Fair'
];
List<Color> conditionColor = [
  const Color.fromARGB(255, 198, 79, 28),
  const Color.fromARGB(255, 39, 179, 3),
  const Color.fromARGB(255, 235, 5, 5),
  const Color.fromARGB(255, 8, 155, 37),
  const Color.fromARGB(255, 234, 255, 0),
];

int tdsState(double data) {
  if (data < 50) {
    return 2;
  } else if (data > 50 && data <= 150) {
    return 3;
  } else if (data > 150 && data <= 250) {
    return 1;
  } else if (data > 250 && data <= 300) {
    return 4;
  } else if (data > 300 && data <= 500) {
    return 0;
  } else {
    return 2;
  }
}

int turbidityState(double data) {
  if (data < 5) {
    return 1;
  } else {
    return 0;
  }
}

int phState(double data) {
  if (data < 6.5) {
    return 0;
  } else if (data >= 6.5 && data <= 8.5) {
    return 1;
  } else {
    return 0;
  }
}
