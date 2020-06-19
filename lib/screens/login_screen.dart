import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:primeiro_app/models/user_model.dart';
import 'package:primeiro_app/screens/home_screen.dart';
import 'package:primeiro_app/screens/signup_screen.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Text(
                "CRIAR CONTA",
                style: TextStyle(fontSize: 15.0),
              ),
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
            )
          ],
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            Future<void> _googleSignUp() async {
              //Google
              try {
                GoogleSignIn _googleSignIn = GoogleSignIn(
                  scopes: <String>[
                    'email',
                  ],
                );
                final FirebaseAuth _auth = FirebaseAuth.instance;

                final GoogleSignInAccount googleUser =
                    await _googleSignIn.signIn();
                final GoogleSignInAuthentication googleAuth =
                    await googleUser.authentication;

                final AuthCredential credential =
                    GoogleAuthProvider.getCredential(
                  accessToken: googleAuth.accessToken,
                  idToken: googleAuth.idToken,
                );

                final FirebaseUser user =
                    (await _auth.signInWithCredential(credential).then((user) {
                  model.signUpGoogle(user);
                }));
                _onSuccess();

                return user;
              } catch (e) {
                _onFail();
              }
            }

            if (model.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );

            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "E-mail"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text.isEmpty || !text.contains("@"))
                        return "E-mail inválido!";
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(hintText: "Senha"),
                    obscureText: true,
                    validator: (text) {
                      if (text.isEmpty || text.length < 6)
                        return "Senha inválida!";
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () {
                        if (_emailController.text.isEmpty)
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content:
                                Text("Insira seu e-mail para recuperação!"),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 2),
                          ));
                        else {
                          model.recoverPass(_emailController.text);
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Confira seu e-mail!"),
                            backgroundColor: Theme.of(context).primaryColor,
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                      child: Text(
                        "Esqueci minha senha",
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {}
                        model.signIn(
                            email: _emailController.text,
                            pass: _passController.text,
                            onSuccess: _onSuccess,
                            onFail: _onFail);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    // BOTAO LOGIN GOOGLE
                    height: 44.0,
                    child: GoogleSignInButton(onPressed: () {
                      _googleSignUp();
                      model.signInWithGoogle(user: user);
                    }),
                  ), // FIM BOTAO LOGIN GOOGLE
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    // BOTAO LOGIN FACEBOOK
                    height: 44.0,
                    child: FacebookSignInButton(onPressed: () {
                      null;
                    }),
                  ), // FIM BOTAO LOGIN FACEBOOK
                ],
              ),
            );
          },
        ));
  }

  void _onSuccess() {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao Entrar!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
