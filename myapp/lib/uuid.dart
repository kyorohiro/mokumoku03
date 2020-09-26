import 'dart:math' as math;
import 'package:uuid/uuid.dart' as uuid;
import 'dart:convert' as conv;


class Uuid 
{
  static math.Random _random = new math.Random();
  static String  createV1() { 
    return uuid.Uuid().v1();//options: {"node":List<int>.generate(6, (index) => _random.nextInt(0xFFFF))});
  }
  static String createUUID() {
    return s4()+s4()+"-"+s4()+"-"+s4()+"-"+s4()+"-"+s4()+s4()+s4();
  }
  static String s4() {
    return (_random.nextInt(0xFFFF)+0x10000).toRadixString(16).substring(0,4);
  }
}