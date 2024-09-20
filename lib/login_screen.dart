import "package:chat_app/providers/auth_provider.dart";
import "package:chat_app/signup_screen.dart";
import "package:chat_app/widgets/auth_text_field.dart";
import "package:chat_app/widgets/password_text_field.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "forget_password.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isRememberMeSelected = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;
    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Opacity(
              opacity: 0.1,
              child: Image.asset(
                "assets/images/chat_app_image.jpg",
                fit: BoxFit.cover,
                width: width,
                height: height,
              ),
            ),
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
                        height: 40,
                      ),
                      const Text(
                        "Login",
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
                        "Login to your account",
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      AuthTextField(
                        hintText: "Email",
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter the valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
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
                          }),
                      const SizedBox(
                        height: 15,
                      ),
                      //const SizedBox(height: 15),
                      Row(
                        children: [
                          Checkbox(
                            value: isRememberMeSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                isRememberMeSelected = !isRememberMeSelected;
                              });
                            },
                          ),
                          const Text("Remember Login",
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 16)),
                          const SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgetPassword(),
                                ),
                              );
                            },
                            child: const Text(
                              "Forget Password?",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            fixedSize: const Size(378, 50),
                          ),
                          child: Consumer<AuthServiceProvider>(
                              builder: (_, provider, __) {
                            return provider.isLoading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    "Login",
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 20,
                                    ),
                                  );
                          }),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontStyle: FontStyle.normal,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Signup",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontStyle: FontStyle.normal,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Or Continue with",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontStyle: FontStyle.normal,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                          Consumer<AuthServiceProvider>(
                              builder: (_, authProvider, __) {
                                return GestureDetector(
                                  onTap: () {
                                    // print("i am here");
                                    authProvider.signInWithGoogle();
                                  },
                                  child: Image.asset(
                                    "assets/images/google_icon.png",
                                    width: 200,
                                    height: 70,
                                  ),
                                );
                              }),
                            const SizedBox(
                              width: 2,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                "assets/images/facebook_icon.png",
                                width: 100,
                                height: 50,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            fixedSize: const Size(400, 50),
                          ),
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "assets/images/face_id_icon.png",
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                              const SizedBox(width: 15),
                              const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Face ID Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      await context.read<AuthServiceProvider>().login(
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }
}