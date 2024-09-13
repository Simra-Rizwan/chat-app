// import 'package:chat_app/login_screen.dart';
// import 'package:chat_app/providers/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class FirstScreen extends StatelessWidget {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     double height = size.height;
//     double width = size.width;
//     return Scaffold(
//       key: _scaffoldKey,
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         leading: IconButton(
//           icon: const Icon(Icons.menu),
//           onPressed: () {
//             _scaffoldKey.currentState?.openDrawer();
//           },
//         ),
//       ),
//       drawer: Consumer<AuthProvider>(builder: (_, authProvider, __) {
//         final user = authProvider.user;
//         return Drawer(
//           child: Column(
//             children: [
//               Stack(
//                 children: [
//                   UserAccountsDrawerHeader(
//                     currentAccountPicture: user?.avatar != null
//                         ? CircleAvatar(
//                       backgroundImage: NetworkImage(user!.avatar!),
//                     )
//                         : CircleAvatar(
//                       child: Icon(Icons.person),
//                     ),
//                     accountName: Text(user?.firstName ?? 'Guest'),
//                     accountEmail: Text(user?.email ?? 'guest@example.com'),
//                   ),
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: IconButton(
//                       icon: const Icon(Icons.close_rounded),
//                       color: Colors.white,
//                       onPressed: () {
//                         Navigator.pop(context); // Close the drawer
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               ListTile(
//                 leading: const Icon(Icons.account_circle_rounded),
//                 title: const Text("Personal Information"),
//                 onTap: () {
//                   Navigator.pop(context); // Close the drawer
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.chat),
//                 title: const Text("Chat"),
//                 onTap: () {
//                   Navigator.pop(context); // Close the drawer
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.logout),
//                 title: const Text("Log Out"),
//                 onTap: () async {
//                   await context.read<AuthProvider>().signOut();
//                 },
//               ),
//             ],
//           ),
//         );
//       }),
//       body: Stack(
//         children: [
//           Opacity(
//             opacity: 0.1,
//             child: Image.asset(
//               "assets/images/chat_app_image.jpg",
//               fit: BoxFit.cover,
//               width: width,
//               height: height,
//             ),
//           ),
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.only(
//                 top: 100,
//                 bottom: 40,
//                 left: 34,
//                 right: 34,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Chat app",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 60),
//                   Align(
//                     alignment: Alignment.center,
//                     child: ElevatedButton(
//                       onPressed: () => _signOut(context),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blueAccent,
//                         fixedSize: const Size(378, 50),
//                       ),
//                       child: Consumer<AuthProvider>(
//                         builder: (_, provider, __) {
//                           return provider.isLoading
//                               ? const CircularProgressIndicator()
//                               : const Text(
//                             "Sign Out",
//                             textDirection: TextDirection.ltr,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontStyle: FontStyle.normal,
//                               fontSize: 20,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _signOut(BuildContext context) async {
//     await context.read<AuthProvider>().signOut();
//   }
// }
