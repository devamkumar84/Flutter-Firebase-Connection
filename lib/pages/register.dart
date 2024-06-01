import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:may_two/blocs/authentication.dart';
import 'package:may_two/pages/home.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState()=> RegisterScreenState();
}
class RegisterScreenState extends State<RegisterScreen>{
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController checkEmail = TextEditingController();
  TextEditingController checkPassword = TextEditingController();
  bool obscurePass = true;
  bool checkObscurePass = true;
  bool registerPage = true;
  FaIcon eyePass = const FaIcon(FontAwesomeIcons.solidEye,size: 18,);
  FaIcon checkEyePass = const FaIcon(FontAwesomeIcons.solidEye,size: 18,);
  bool isEmailValid(String email){
    final RegExp emailRegex = RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
  Future handleSignUpWithEmail()async {
    showDialog(
      context: context,
      builder: (context){
        return const Center(child: CircularProgressIndicator());
      }
    );
    final Authentication au = Provider.of<Authentication>(context, listen: false);
    await au.checkInternet().then((hasInternet){
      if(hasInternet == false){
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Container(
                height: 60,
                alignment: Alignment.centerLeft,
                child: const Text('No Internet'),
              ),
              action: SnackBarAction(
                onPressed: (){},
                textColor: Colors.blueAccent,
                label: 'OK',
              ),
            ),
        );
      }else {
        au.signUpWithEmailPassword(username.text.toString(), email.text.toString(), password.text.toString()).then((_){
          if(au.hasError == false){
            Navigator.pop(context);
            au.getTimeStamp()
                .then((value)=> au.saveToFireStore()
                .then((value)=> au.saveDataToSp()
                .then((value)=> au.setSignIn()
                .then((value){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
            })
            )));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: const Text('Account Created Successfully'),
                ),
                action: SnackBarAction(
                  onPressed: (){},
                  textColor: Colors.blueAccent,
                  label: 'OK',
                ),
              ),
            );
          }else {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: const Text('Error'),
                    content: Text(au.errorCode.toString()),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: const Text('OK'))
                    ],
                  );
                }
            );
          }
        });
      }
    });
  }
  Future handleSignIn()async {
    showDialog(
        context: context,
        builder: (context){
          return const Center(child: CircularProgressIndicator(),);
        }
    );
    final Authentication au = Provider.of<Authentication>(context, listen: false);
    await au.checkInternet().then((hasInternet){
      if(hasInternet == false){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Container(
                height: 60,
                alignment: Alignment.centerLeft,
                child: const Text('No Internet'),
              ),
            action: SnackBarAction(
              onPressed: (){},
              label: 'OK',
              textColor: Colors.blueAccent,
            ),
          )
        );
      }else {
        au.signInWithEmailPassword(checkEmail.text.toString(), checkPassword.text.toString()).then((_){
          if(au.hasCheckError == false){
            Navigator.pop(context);
            au.getUserDataFromFireStore(au.uid)
            .then((value)=> au.saveDataToSp()
            .then((value)=> au.setSignIn()
            .then((value){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
            })
            ));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: const Text('Login Successfully'),
                ),
                action: SnackBarAction(
                  onPressed: (){},
                  textColor: Colors.blueAccent,
                  label: 'OK',
                ),
              ),
            );
          }else {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: const Text('Error'),
                    content: const Text('Invalid Credentials'),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: const Text('OK'))
                    ],
                  );
                }
            );
          }
        });
      }
    });
  }
  Future handleFacebookSignIn()async {
    final Authentication au = Provider.of<Authentication>(context, listen: false);
    await au.checkInternet().then((hasInternet){
      if(hasInternet == false){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Container(
                height: 60,
                alignment: Alignment.centerLeft,
                child: const Text('No Internet'),
              ),
              action: SnackBarAction(
                onPressed: (){},
                label: 'OK',
                textColor: Colors.blueAccent,
              ),
            )
        );
      }else {
        au.signInWithFb().then((value){
          if(au.hasFbError == true){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: const Text('Something is wrong. please try again.'),
                ),
                action: SnackBarAction(
                  onPressed: (){},
                  textColor: Colors.blueAccent,
                  label: 'OK',
                ),
              ),
            );
          }else {
            au.checkUserExists().then((value){
              if(value == true){
                au.getUserDataFromFireStore(au.uid)
                    .then((value)=> au.saveDataToSp()
                    .then((value)=> au.setSignIn()
                    .then((value){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                })
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Container(
                      height: 60,
                      alignment: Alignment.centerLeft,
                      child: const Text('Login Successfully'),
                    ),
                    action: SnackBarAction(
                      onPressed: (){},
                      textColor: Colors.blueAccent,
                      label: 'OK',
                    ),
                  ),
                );
              }else {
                au.getTimeStamp()
                    .then((value)=> au.saveToFireStore()
                    .then((value)=> au.saveDataToSp()
                    .then((value)=> au.setSignIn()
                    .then((value){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                })
                )));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Container(
                      height: 60,
                      alignment: Alignment.centerLeft,
                      child: const Text('Login Successfully with Store Data'),
                    ),
                    action: SnackBarAction(
                      onPressed: (){},
                      textColor: Colors.blueAccent,
                      label: 'OK',
                    ),
                  ),
                );
              }
            });
          }
        });
      }
    });
  }
  Future handleGoogleSignIn()async {
    final Authentication au = Provider.of<Authentication>(context, listen: false);
    await au.checkInternet().then((hasInternet){
      if(hasInternet == false){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Container(
                height: 60,
                alignment: Alignment.centerLeft,
                child: const Text('No Internet'),
              ),
              action: SnackBarAction(
                onPressed: (){},
                label: 'OK',
                textColor: Colors.blueAccent,
              ),
            )
        );
      }else {
        au.signInWithGoogle().then((value){
          if(au.hasGoogleError == true){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: const Text('Something is wrong. please try again.'),
                ),
                action: SnackBarAction(
                  onPressed: (){},
                  textColor: Colors.blueAccent,
                  label: 'OK',
                ),
              ),
            );
          }else {
            au.checkUserExists().then((value){
              if(value == true){
                au.getUserDataFromFireStore(au.uid)
                    .then((value)=> au.saveDataToSp()
                    .then((value)=> au.setSignIn()
                    .then((value){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                })
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Container(
                      height: 60,
                      alignment: Alignment.centerLeft,
                      child: const Text('Login Successfully'),
                    ),
                    action: SnackBarAction(
                      onPressed: (){},
                      textColor: Colors.blueAccent,
                      label: 'OK',
                    ),
                  ),
                );
              }else {
                au.getTimeStamp()
                    .then((value)=>au.saveToFireStore()
                    .then((value)=> au.saveDataToSp()
                    .then((value)=> au.setSignIn()
                    .then((value){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                })
              )));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Container(
                      height: 60,
                      alignment: Alignment.centerLeft,
                      child: const Text('Login Successfully With Store Data'),
                    ),
                    action: SnackBarAction(
                      onPressed: (){},
                      textColor: Colors.blueAccent,
                      label: 'OK',
                    ),
                  ),
                );
              }
            });
          }
        });
      }
    });
  }
  @override
  Widget build(BuildContext context){
    final au = context.read<Authentication>();
    final auShow = context.watch<Authentication>();
    return Scaffold(
      appBar: AppBar(
        title: au.isLogin ? const Text('Profile') : registerPage == true ? const Text('Register') : const Text('Login'),
      ),
      body: Container(
        padding: const EdgeInsets.all(14),
        child: au.isLogin ? Column(
          children: [
            Text(auShow.name ?? 'No name available'),
            Text(auShow.email ?? 'No email available'),
            Text(auShow.uid ?? 'No UID available'),
            Text(auShow.signInProvider ?? 'No provider available'),
            TextButton(
                onPressed: () async {
                  await au.checkInternet().then((hasInternet){
                    if(hasInternet == false){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Container(
                              alignment: Alignment.centerLeft,
                              child: const Text('No Internet'),
                            ),
                            action: SnackBarAction(
                              onPressed: (){},
                              label: 'OK',
                              textColor: Colors.blueAccent,
                            ),
                          )
                      );
                    }else {
                      if(au.isLogin){
                        au.signOut().then((value){
                          au.afterUserSignOut();
                        }).then((value){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Container(
                                height: 60,
                                alignment: Alignment.centerLeft,
                                child: const Text('Logout Successfully'),
                              ),
                              action: SnackBarAction(
                                onPressed: (){},
                                textColor: Colors.blueAccent,
                                label: 'OK',
                              ),
                            ),
                          );
                        });
                      }
                    }
                  });
                },
                child: const Text('Sign Out')
            )
          ],
        ) :
        registerPage == true ?
        Column(
          children: [
            TextField(
              controller: username,
              decoration: const InputDecoration(
                label: Text('Username'),
                hintText: 'Enter Username',
              ),
            ),
            const SizedBox(height: 15,),
            TextField(
              controller: email,
              decoration: const InputDecoration(
                label: Text('Email'),
                hintText: 'example@gmail.com'
              ),
            ),
            const SizedBox(height: 15,),
            TextField(
              controller: password,
              obscureText: obscurePass,
              decoration: InputDecoration(
                label: const Text('Password'),
                hintText: 'Enter Password',
                suffixIcon: IconButton(
                    onPressed: (){
                      setState(() {
                        if(obscurePass == true){
                          obscurePass = false;
                          eyePass = const FaIcon(FontAwesomeIcons.solidEyeSlash,size: 18,);
                        }else {
                          obscurePass = true;
                          eyePass = const FaIcon(FontAwesomeIcons.solidEye,size: 18,);
                        }
                      });
                    },
                    icon: eyePass,
                )
              ),
            ),
            const SizedBox(height: 15,),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  onPressed:(){
                    if(username.text.isNotEmpty && email.text.isNotEmpty && password.text.isNotEmpty){
                      if(isEmailValid(email.text.toString())){
                        handleSignUpWithEmail();
                      }else {
                        showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text('Please enter a valid email address.'),
                                  actions:[
                                    TextButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK')
                                    )
                                  ]
                              );
                            }
                        );
                      }
                    }else {
                      showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text('Please fill all fields'),
                              actions:[
                                TextButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK')
                                )
                              ]
                            );
                          }
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    alignment: Alignment.center,
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 12)
                  ),
                child: const Text('Sign Up', style: TextStyle(color: Colors.white))
              ),
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already Account?'),
                TextButton(
                  onPressed:(){
                    setState(() {
                      registerPage = false;
                    });
                  },
                  child:const Text('Sign In')
                ),
              ],
            )
          ]
        ) :
        Column(
          children: [
            TextField(
              controller: checkEmail,
              decoration: const InputDecoration(
                label: Text('Email'),
                hintText: 'example@gmail.com',
              ),
            ),
            const SizedBox(height: 15,),
            TextField(
              controller: checkPassword,
              obscureText: checkObscurePass,
              decoration: InputDecoration(
                label: const Text('Password'),
                hintText: 'Enter Password',
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      if(checkObscurePass == true){
                        checkObscurePass = false;
                        checkEyePass = const FaIcon(FontAwesomeIcons.solidEyeSlash,size: 18,);
                      }else {
                        checkObscurePass = true;
                        checkEyePass = const FaIcon(FontAwesomeIcons.solidEye,size: 18,);
                      }
                    });
                  },
                  icon: checkEyePass,
                )
              ),
            ),
            const SizedBox(height: 15,),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed:(){
                  if(checkEmail.text.isNotEmpty && checkPassword.text.isNotEmpty){
                    if(isEmailValid(checkEmail.text.toString())){
                      handleSignIn();
                    }else {
                      showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text('Please enter a valid email address.'),
                              actions: [
                                TextButton(onPressed: (){
                                  Navigator.pop(context);
                                }, child: const Text('OK'))
                              ],
                            );
                          }
                      );
                    }
                  }else {
                    showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Please fill all fields'),
                            actions: [
                              TextButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: const Text('OK')
                              )
                            ],
                          );
                        }
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Sign In'),
              ),
            ),
            const SizedBox(height: 15,),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed:(){
                  handleGoogleSignIn();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.google, size: 20,),
                    SizedBox(width: 8,),
                    Text('Sign In With Google'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15,),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed:(){
                  handleFacebookSignIn();
                  // signInWithFacebook();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.facebookF, size: 20,),
                    SizedBox(width: 8,),
                    Text('Sign In With Facebook'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                const Text('New User?'),
                TextButton(
                  onPressed:(){
                    setState(() {
                      registerPage = true;
                    });
                  },
                  child: const Text('Register now'),
                )
              ]
            )
          ]
        ),
      ),
    );
  }
}