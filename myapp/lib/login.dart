
import 'package:firebase/firebase.dart' as fb;

        
fb.App gfirebaseApp;


//
// Firebase
//
setupFirebase() {
  try {
    print("fb init");
    gfirebaseApp = fb.initializeApp(
      apiKey: "AIzaSyBiMJJy4UT5wXDmuGAuIpH3LDf9xfJN-KM ",
      authDomain: "mokumoku00003.firebaseapp.com",
      projectId: "mokumoku00003",
      appId: "1:1011491025362:web:bbee4b2beb78920450980b"
    );
  } catch(e) {
    print("fb error ${e}");
  } finally {
    print("fn fini");
  }
}

loginAtFirebase(String email, String password) async {
  try {
    print("fn slog");
    var userCredential = await fb.auth().signInWithEmailAndPassword(email, password);
    print(userCredential.additionalUserInfo.username);
  } catch(e) {
    print("fb error ${e}");
    throw LoginErrorMessage()..message="${e}";
  } finally {
     print("fn elog");
  }
}

registAtFirebase(String email, String password) async {
  try {
    print("fn slog");
    var userCredential = await fb.auth().createUserWithEmailAndPassword(email, password);
    //signInWithEmailAndPassword(email, password);
    print(userCredential.additionalUserInfo.username);
  } catch(e) {
    print("fb error ${e}");
    throw LoginErrorMessage()..message="${e}";
  } finally {
     print("fn elog");
  }
}

class LoginErrorMessage {
  String message;
}