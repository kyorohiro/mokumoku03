import 'package:firebase/firestore.dart';

import '../app_context.dart' as appContext;

class ImageManager {
  Map<String, bool> itemsAtMap = {};
  List<String> items = [];
  DocumentSnapshot lastKey; 

  Future<List<String>> getImageUrls() async {
    print(">call image urls 01");
    try {
      var response = await appContext.apiClient.listFiles(lastKey: lastKey);
      lastKey = response.lastkey;
      List<String> ret = [];
      print("call image urls 02");
      response.data.forEach((element) {
        print("-el-> ${element}");
        if (!itemsAtMap.containsKey(element)) {
          itemsAtMap[element] = true;
          items.add(element);
          ret.add(element);
        }
      });
      print("/call image urls ${response.data.length}");

      return ret;
    } catch (e) {
      print("xx ${e}");
      rethrow;
    }
  }
}

class ImageInfo {}