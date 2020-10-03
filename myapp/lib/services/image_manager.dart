import 'package:firebase/firestore.dart';

import '../app_context.dart' as appContext;

class ImageManager {
  Map<String, bool> itemsAtMap = {};
  List<String> items = [];
  DocumentSnapshot lastKey; 

  Future<List<String>> getImageUrls() async {
    print(">call image urls 01 ${items.length}");
    try {
      print(">call image urls 02");
      var response = await appContext.apiClient.listFiles(lastKey: lastKey);
      print(">call image urls 03");

      lastKey = response.lastkey;
      List<String> ret = [];
      print("call image urls 04");
      response.data.forEach((element) {
        print("-el-> ${element}");
        if (putUuid(element)) {
          ret.add(element);
        }
      });
      print("/call image urls ${response.data.length}");

      return ret;
    } catch (e) {
      print("xx ${e}");
      //rethrow;
      return [];
    }
  }

  putUuid(String uuid) {
    if(!itemsAtMap.containsKey(uuid)){
        itemsAtMap[uuid] = true;
        items.add(uuid);
        return true;
    } else {
      return false;
    }
  }
}

class ImageInfo {}
