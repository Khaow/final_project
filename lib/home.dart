import 'package:flutter/material.dart';
import 'state.dart';
import 'state_widget.dart';
import 'sign_in.dart';
import 'loading.dart';
import 'package:flutter/cupertino.dart';
import 'addpage.dart';
import 'package:flutter/rendering.dart';
import 'forgot_password.dart';
import 'sign_up.dart';
import 'bottom.dart';
import 'auth.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StateModel appState;
  bool _loadingVisible = false;
  bool _isEmailVerified = false;

  void _checkEmailVerification() async {
    _isEmailVerified = await Auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail() {
    Auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  _showVerifyEmailDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                StateWidget.of(context).logOutUser();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                StateWidget.of(context).logOutUser();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    if (!appState.isLoading &&
        (appState.firebaseUserAuth == null ||
            appState.user == null ||
            appState.settings == null)) {
      return SignInScreen();
    } else {
      if (appState.isLoading) {
        _loadingVisible = true;
      } else {
        _loadingVisible = false;
      }
      _checkEmailVerification();

      final logo = Hero(
        tag: 'hero',
        child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 30.0,
            child: ClipOval(
              child: Image.asset(
                'assets/images/utcc.jpg',
                fit: BoxFit.cover,
                width: 60.0,
                height: 60.0,
              ),
            )),
      );

      final signOutButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {
            StateWidget.of(context).logOutUser();
          },
          padding: EdgeInsets.all(12),
          color: Theme.of(context).primaryColor,
          child: Text('SIGN OUT', style: TextStyle(color: Colors.white)),
        ),
      );

      final forgotLabel = FlatButton(
        child: Text(
          'Forgot password?',
          style: TextStyle(color: Colors.black54),
        ),
        onPressed: () {
          Route route5 =
              MaterialPageRoute(builder: (context) => ForgotPasswordScreen());
          Navigator.push(context, route5);
        },
      );

      final signUpLabel = FlatButton(
        child: Text(
          'Sign Up',
          style: TextStyle(color: Colors.black54),
        ),
        onPressed: () {
          Route route6 =
              MaterialPageRoute(builder: (context) => SignUpScreen());
          Navigator.push(context, route6);
        },
      );

      final signInLabel = FlatButton(
        child: Text(
          'Sign In',
          style: TextStyle(color: Colors.black54),
        ),
        onPressed: () {
          Route route7 =
              MaterialPageRoute(builder: (context) => SignInScreen());
          Navigator.push(context, route7);
        },
      );
//check for null https://stackoverflow.com/questions/49775261/check-null-in-ternary-operation
      final userId = appState?.firebaseUserAuth?.uid ?? '';
      final email = appState?.firebaseUserAuth?.email ?? '';
      final firstName = appState?.user?.firstName ?? '';
      final lastName = appState?.user?.lastName ?? '';
      final address = appState?.user?.address ?? '';
      final telephone = appState?.user?.telephone ?? '';
      final number = appState?.user?.number ?? '';
      final settingsId = appState?.settings?.settingsId ?? '';
      final userIdLabel = Text('App Id: ');
      final emailLabel = Text('อีเมล ',
          style: TextStyle(
            fontSize: 24,
            color: Colors.cyan,
          ));
      final firstNameLabel = Text('ชื่อ: ',
          style: TextStyle(
            fontSize: 26,
            color: Colors.cyan,
          ));
      final lastNameLabel = Text('Last Name');
      final addressLabel = Text('ที่อยู่',
          style: TextStyle(
            fontSize: 20,
            color: Colors.cyan,
          ));
      final telephoneLabel = Text('เบอร์โทรศัพท์',
          style: TextStyle(
            fontSize: 20,
            color: Colors.cyan,
          ));
      final numberLabel = Text('หมายเลขบัตรประชาชน',
          style: TextStyle(
            fontSize: 20,
            color: Colors.cyan,
          ));
      final settingsIdLabel = Text('SetttingsId: ');

      return Scaffold(
        appBar: new AppBar(
          title: new Text(
            'ข้อมูลสมาชิก',
            style: TextStyle(fontSize: 25),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('ออจากระบบ',
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              color: Colors.red,
              onPressed: () {
                StateWidget.of(context).logOutUser();
              },
            )
          ],
        ),
        body: LoadingScreen(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      logo,
                      SizedBox(height: 5.0),
//                      userIdLabel,
//                      Text(userId,
//                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.0),
                      emailLabel,
                      Text(email,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.indigo,
                          )),
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          firstNameLabel,
                          Text(firstName + '   ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: Colors.indigo,
                              )),
                          Text(lastName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: Colors.indigo,
                              )),
                          SizedBox(height: 12.0),
                        ],
                      ),
                      SizedBox(height: 12.0),
                      telephoneLabel,
                      Text(telephone,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.indigo,
                          )),
                      SizedBox(height: 12.0),
                      addressLabel,
                      Text(address,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.indigo,
                          )),
                      SizedBox(height: 12.0),

                      numberLabel,
                      Text(number,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.indigo,
                          )),
                      SizedBox(height: 12.0),

//                      firstNameLabel,
//                      Text(firstName,
//                          style: TextStyle(fontWeight: FontWeight.bold)),

//                      lastNameLabel,
//                      Text(lastName,
//                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 24.0),
                      Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                  builder: (context) => MyAddPage());
                              Navigator.push(context, route);
                            },
                            child: Container(
                              height: 50,
                              width: 250,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(24.0)),
                              child: Center(
                                child: Text(
                                  'เพิ่มห้องพัก',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

//                      settingsIdLabel,
//                      Text(settingsId,
//                          style: TextStyle(fontWeight: FontWeight.bold)),
                      //signOutButton,

//                      signInLabel,
//                      signUpLabel,
//                      forgotLabel
                    ],
                  ),
                ),
              ),
            ),
            inAsyncCall: _loadingVisible),
      );
    }
  }
}
