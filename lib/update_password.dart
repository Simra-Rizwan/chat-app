import "package:chat_app/verify_email.dart";
import "package:chat_app/widgets/password_text_field.dart";
import "package:flutter/material.dart";

import "login_screen.dart";


class UpdatePassword extends StatelessWidget {

  const UpdatePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _newPasswordController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context)=>const VerifyEmail()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Stack(
        children: [
          Opacity(opacity: 0.1,
          child:Image.asset(
            "assets/images/chat_app_image.jpg", fit: BoxFit.cover,
            width: width,
          height: height,),),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 50,
                left: 40,
                right: 40,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Update Password",
                      style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Enter your new password.",
                      style: TextStyle(color: Colors.black,
                          fontStyle: FontStyle.normal, fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                     PasswordTextField(
                         hintText: "Password",
                         controller: _passwordController,
                         validator: (value) {
                           if (value == null || value.isEmpty) {
                             return 'Please enter password';
                           } else {
                             if (!RegExp(
                                 r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                 .hasMatch(value)) {
                               return 'Enter valid password';
                             } else {
                               return null;
                             }
                           }
                         }
                     ),
                    const SizedBox(height: 20,),
                    PasswordTextField(
                        hintText: "New Password",
                        controller: _newPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter new password';
                          } else {
                            if (_passwordController.text!=_newPasswordController.text){
                              return 'Password does not match';
                            } else {
                              return null;
                            }
                          }
                        }
                    ),
                    const SizedBox(height: 40,),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          fixedSize: const Size(378, 50),
                        ),
                        child: Align( alignment: Alignment.bottomCenter,
                          child: ElevatedButton( onPressed: ()
                          {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            );
                          }
                          },
                            style: ElevatedButton.styleFrom( backgroundColor:Colors.blue,
                              fixedSize: const Size(250, 48), ),
                            child: const
                            Text( "Update Password", style: TextStyle( fontSize: 20, color: Colors.white,
                            ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontStyle: FontStyle.normal,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontStyle: FontStyle.normal,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
