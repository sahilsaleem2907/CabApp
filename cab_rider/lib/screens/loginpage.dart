import 'package:cab_rider/brand_colors.dart';
import 'package:cab_rider/screens/mainpage.dart';
import 'package:cab_rider/screens/registrationpage.dart';
import 'package:cab_rider/widgets/ProgressDialog.dart';
import 'package:cab_rider/widgets/TaxiButton.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential userCredential ;

  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }




  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  Future<void> login ()
  async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Logging you in',),
    );
    try {
      userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        showSnackBar('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showSnackBar('Wrong password provided for that user.');
      }
    }


    if(userCredential != null){
      // verify login
      DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users/${userCredential.user.uid}');
      userRef.once().then((DataSnapshot snapshot) {

        if(snapshot.value != null){
          Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
        }
      });

    }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 70,),
                Image(
                  alignment: Alignment.center,
                  height: 150.0,
                  width: 2000.0,
                  image: AssetImage('images/logo.png'),
                ),
                SizedBox(height: 40,),
                Text('Login In as a Rider',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email address',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 10,),

                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 40,),

                      TaxiButton(
                        title: 'Login',
                        color: Colors.black,
                        onPressed: ()async{

                          var connectivityResult = await Connectivity().checkConnectivity();
                          if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
                            showSnackBar('No internet connectivity');
                            return;
                          }




                          if(!emailController.text.contains('@')){


                            showSnackBar('Please provide a valid email address');

                            return;
                          }

                          if(passwordController.text.length < 8){


                            showSnackBar('password must be at least 8 characters');
                            return;
                          }

                          login();
                          showSnackBar('Login Successful');
                          Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
                        },
                      ),

                    ],
                  ),
                ),

                FlatButton(
                    onPressed: (){
                      Navigator.pushNamedAndRemoveUntil(context, RegistrationPage.id, (route) => false);
                    },
                    child: Text('Need an account ? sign up here')
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}

