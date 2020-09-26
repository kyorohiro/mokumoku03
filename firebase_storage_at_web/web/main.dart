import 'dart:html' as html;
import 'package:firebase/firebase.dart' as fb;
void main() {
  html.querySelector('#output').text = 'Your Dart app is running.';
  try {
    fb.initializeApp(
      apiKey: "AIzaSyBiMJJy4UT5wXDmuGAuIpH3LDf9xfJN-KM ",
      authDomain: "mokumoku00003.firebaseapp.com",
      projectId: "mokumoku00003",
      storageBucket: "mokumoku00003.appspot.com",
      appId: "1:1011491025362:web:bbee4b2beb78920450980b"         
    );

    xx();
  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }
}
  
  xx() async {
    fb.StorageReference ref = fb.storage().ref('pkg_firebase/examples/storage');
    var file = html.Blob(["Hello,World!!"]);
    var uploadTask = ref.child("test.txt").put(file);
    try {
      await uploadTask.future;
    } catch(e) {
      print(e);
    }
  }