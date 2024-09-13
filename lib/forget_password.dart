import "package:chat_app/providers/auth_provider.dart";
import "package:chat_app/verify_email.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "login_screen.dart";
import "widgets/auth_text_field.dart";

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
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
                        height: 20,
                      ),
                      const Text(
                        "Forgot Password?",
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
                        "Enter your email ",
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
                        hintText: "Enter Email Address",
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
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            fixedSize: const Size(378, 50),
                          ),
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Consumer<AuthServiceProvider>(
                                  builder: (_, authProvider, __) {
                                return ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           const VerifyEmail()),
                                      // );

                                      authProvider.resetPassword(
                                          email: _emailController.text,
                                          context: context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    fixedSize: const Size(250, 48),
                                  ),
                                  child: const Text(
                                    "Verify Email",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              })),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Forgot username?",
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontStyle: FontStyle.normal,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Let us Help",
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
