import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shopping_app/api_connection/api_connect.dart';
import 'package:shopping_app/users/authentication/signup_page.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/users/fragments/dashboard_fragments.dart';
import 'package:shopping_app/users/model/user.dart';
import 'package:shopping_app/users/userePreferences.dart/user_preferences.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  loginUserNow() async
  {
    try
    {
      var res = await http.post(
        Uri.parse(API.login),
        body: {
          "user_email": emailController.text.trim(),
          "user_password": passwordController.text.trim(),
        },
      );

      if(res.statusCode == 200)
      {
        var resBodyOfLogin = jsonDecode(res.body);
        if(resBodyOfLogin['success'] == true)
        {
          Fluttertoast.showToast(msg: "Login Successfully! ");

          User userInfo = User.fromJson(resBodyOfLogin["userData"]);

          await RememberUserPrefs.saveRememberUser(userInfo); //save userInfo to the Local storage using shared pref

          Future.delayed(Duration(milliseconds: 2000), ()
          {
            Get.to(DashboardOfFragments());
          });
        }
        else
        {
          Fluttertoast.showToast(msg: "Incorrect Email or Password. ");
        }
      }
    }
    catch(e)
    {
      print("Error :: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, cons)
        {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: cons.maxHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [


                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 285,
                    child: Image.asset(
                      "images/login.jpg",
                    ),
                  ),
                  //sign in form
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.all(
                          Radius.circular(60),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, -3),
                          )
                        ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                        child: Column(
                          children: [

                            //Email-Password-Login_button
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  //getting email from users
                                  TextFormField(
                                    controller: emailController,
                                    validator: (val) => val == "" ? "This field is required" : null,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ),
                                      hintText: "Email",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6,
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                  ),

                                  const SizedBox(height: 18,),

                                  //password
                                  Obx(
                                          () => TextFormField(
                                            controller: passwordController,
                                            obscureText: isObsecure.value,
                                            validator: (val) => val == "" ? "This field is required" : null,
                                            decoration: InputDecoration(
                                              prefixIcon: const Icon(
                                                Icons.vpn_key_sharp,
                                                color: Colors.black,
                                              ),
                                              suffixIcon: Obx(
                                                    ()=> GestureDetector(
                                                  onTap: ()
                                                  {
                                                    isObsecure.value = !isObsecure.value;
                                                  },
                                                  child: Icon(
                                                    isObsecure.value ? Icons.visibility_off : Icons.visibility,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              hintText: "Password",
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: const BorderSide(
                                                  color: Colors.white60,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: const BorderSide(
                                                  color: Colors.white60,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: const BorderSide(
                                                  color: Colors.white60,
                                                ),
                                              ),
                                              disabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: const BorderSide(
                                                  color: Colors.white60,
                                                ),
                                              ),
                                              contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 14,
                                                vertical: 6,
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                            ),
                                          ),
                                  ),

                                  const SizedBox(height: 18,),

                                  //button
                                  Material(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      onTap: ()
                                      {
                                        if(formKey.currentState!.validate())
                                        {
                                          loginUserNow();
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(30),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 28,
                                        ),
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            //Don't have an Account
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an Account?"
                                ),
                                TextButton(
                                  onPressed: ()
                                  {
                                    Get.to(SignupScreen());

                                  },
                                  child: const Text(
                                    "Signup Here",
                                    style: TextStyle(
                                      color: Colors.blueAccent
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Text(
                              "or",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            //Admin
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                    "Are you an Admin?"
                                ),
                                TextButton(
                                  onPressed: ()
                                  {

                                  },
                                  child: const Text(
                                    "Click Here",
                                    style: TextStyle(
                                        color: Colors.blueAccent
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
