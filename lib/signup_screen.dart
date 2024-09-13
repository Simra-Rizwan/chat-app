import "package:chat_app/providers/auth_provider.dart";
import "package:chat_app/widgets/auth_text_field.dart";
import "package:chat_app/widgets/password_text_field.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "email_verification_screen.dart";
import "login_screen.dart";

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isRememberMeSelected = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
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
                      const SizedBox(height: 10),
                      const Text(
                        "SignUp",
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Create an Account, It's free.",
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AuthTextField(
                          hintText: "First Name",
                          obscureText: false,
                          controller: _firstNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),
                      AuthTextField(
                          hintText: "Last Name",
                          obscureText: false,
                          controller: _lastNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),
                      AuthTextField(
                          hintText: "Email",
                          obscureText: false,
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter the valid email address';
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 05),
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
                          const Text(
                            "I agree Terms and conditions",
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: _signup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            fixedSize: const Size(378, 50),
                          ),
                          child: Consumer<AuthServiceProvider>(
                              builder: (_, provider, __) {
                            return provider.isLoading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    "Sign Up",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
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
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontStyle: FontStyle.normal,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                            const SizedBox(width: 2),
                            Image.asset(
                              "assets/images/facebook_icon.png",
                              width: 100,
                              height: 50,
                            ),
                          ],
                        ),
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

  void _signup() async {
    if (_formKey.currentState?.validate() ?? false) {
      await context.read<AuthServiceProvider>().signUp(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }
}
