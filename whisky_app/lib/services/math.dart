import 'dart:math';

class Math {
  static double roundHalf(double d) {
    var num = (d * 2);
    var half = num.round()/2;

    return half;
  }

  static String randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index) {
      return rand.nextInt(33) + 89;
    });

    return new String.fromCharCodes(codeUnits);
  }
}