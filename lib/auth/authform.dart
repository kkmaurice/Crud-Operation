
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({ Key? key }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  final _formKey = GlobalKey<FormState>();
  var email ='';
  var password ='';
  var username ='';
  bool isLoginPage = false;

  @override

  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          // ignore: avoid_unnecessary_containers
          Container(
            padding: const EdgeInsets.only(top: 10,right: 10,left: 10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // username field--------------------------
                  
                  if(!isLoginPage)
                  TextFormField(
                    keyboardType: TextInputType.text,
                    key: const ValueKey('username'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Invalid username!';
                      }
                      return null;
                    },
                    onSaved: (value) => username = value!,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15),
                         ),
                         borderSide: BorderSide(
                           color: Colors.grey,
                           width: 1,
                         ),
                        ),
                        labelText: 'Enter Username',
                      ),
                      ),

                      // email field
                      
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                    onSaved: (value) => email = value!,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15),
                         ),
                         borderSide: BorderSide(
                           color: Colors.grey,
                           width: 1,
                         ),
                        ),
                        labelText: 'Enter Email',
                      ),
                      ),

                      const SizedBox(height: 10,),

                    // password field----------------

                      TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Invalid password!';
                      }
                      return null;
                    },
                    onSaved: (value) => password = value!,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15),
                         ),
                         borderSide: BorderSide(
                           color: Colors.grey,
                           width: 1,
                         ),
                        ),
                        labelText: 'Enter Password',
                      ),
                      ),

                      const SizedBox(height: 10,),

                      // signup button-------------------

                      Container(
                        //color: Colors.purple[200],
                        padding: const EdgeInsets.all(5),
                        width: double.infinity,
                        height: 70,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.purple[200],
                          child: Text(
                            isLoginPage ? 'Login' : 'Sign Up',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () {
                            startauthentication();
                          },
                        ),
                        ), 

                      const SizedBox(height: 10,),

                      // switch button-------------------
                      
                      // ignore: avoid_unnecessary_containers
                      Container(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              isLoginPage = !isLoginPage;
                            });
                          },
                          child: Text(
                            isLoginPage ? 'Create an account' : 'Have an account? Sign in',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      )  
                      ]
                    ),
                  ),
                  
                
              ),
        ]
      ),); 
  }

  //------Functionalities-----------------
  startauthentication(){
    final validity = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(validity){
      _formKey.currentState!.save();

      // calling submit function
      submitForm(email, password, username);
    }
  }

  //------Submitting form-----------------

  submitForm(String email, String password, String username)async{
    final auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    UserCredential credential;
    
    try{
      if(isLoginPage){
        credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      }else{
        credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
        // get user id
        String uid = credential.user!.uid;
        // send the data to firestore
        await firestore.collection('users').doc(uid).set({
          'username': username,
          'email': email,
          'password': password,
        });
      }
  }catch(e){
    // ignore: avoid_print
    print(e.toString());
  }
  }
    
}