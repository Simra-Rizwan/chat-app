// import 'package:chat_app/providers/auth_provider.dart';
// import 'package:chat_app/widgets/cached_image.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'chat_screen.dart';
//
// class FirstScreen extends StatelessWidget {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   FirstScreen({super.key});
//   final List<Map<String, dynamic>> messages = [
//     {
//       'name': 'Ali',
//       'message': 'Sorry I am late',
//       'time': '10:30 AM',
//       'unread': '2'
//     },
//     {
//       'name': 'Uzair',
//       'message': 'Meeting at 5',
//       'time': '9:15 AM',
//       'unread': '3'
//     },
//     {'name': 'Sara', 'message': 'Lunch?', 'time': '11:45 AM', 'unread': '1'},
//   ];
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
//         centerTitle: true,
//         title: const Text(
//           "Message",
//           style: TextStyle(
//               color: Colors.black,
//               fontStyle: FontStyle.normal,
//               fontSize: 26,
//               fontWeight: FontWeight.bold),
//         ), ),
//       drawer: Consumer<AuthProvider>(builder: (_, authProvider, __) {
//         final user = authProvider.user;
//
//         print(user?.avatar);
//         return Drawer(
//             child: Column(children: [
//               UserAccountsDrawerHeader(
//                 // currentAccountPicture: Image.network(user?.avatar ?? ""),
//                 currentAccountPicture: CachedImage(
//                   borderRadius: 8,
//                   imageHeight: 100,
//                   imageWidth: 100,
//                   imageUrl: user?.avatar ?? "",
//                   fit: BoxFit.fill,
//                 ),
//                 accountName: Text(user?.firstName ?? 'Guest'),
//                 accountEmail: Text(user?.email ?? 'guest@example.com'),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.account_circle_rounded),
//                 title: const Text("Personal Information"),
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.chat),
//                 title: const Text("Chat"),
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.logout),
//                 title: const Text("LogOut"),
//                 onTap: () async {
//                   await context.read<AuthProvider>().signOut();
//                 },
//               ),
//             ]));
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
//           // Center(
//           //   child:
//           SingleChildScrollView(
//             padding: const EdgeInsets.only(
//               top: 60,
//               bottom: 40,
//               left: 34,
//               right: 34,
//             ),
//             child: Column(
//               children: [
//                 const SizedBox(height: 50,),
//                 const TextField(
//                   decoration: InputDecoration(
//                       hintText: "Search",
//                       fillColor: Colors.white,
//                       filled: true,
//                       hintStyle: TextStyle(
//                         color: Colors.black,
//                         fontStyle: FontStyle.normal,
//                         fontSize: 20,
//                         fontWeight: FontWeight.normal,
//                       ),
//                       border: OutlineInputBorder(
//                           borderRadius:
//                           const BorderRadius.all(Radius.circular(30)),
//                           borderSide: BorderSide(color: Colors.grey)),
//                       enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(30)),
//                           borderSide: BorderSide(color: Colors.grey)),
//                       suffixIcon: Icon(
//                         Icons.search_rounded,
//                         color: Colors.black,
//                       )),
//                 ),
//                 const SizedBox(height: 20),
//                 ListView.separated(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: messages.length,
//                     padding: EdgeInsets.zero,
//                     separatorBuilder: (_, __) => const SizedBox(
//                       height: 20,
//                     ),
//                     itemBuilder: (context, index) {
//                       final message = messages[index];
//                       return Container(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 5.0, horizontal: 10.0),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(color: Colors.black),
//                         ),
//                         child: ListTile(
//                             leading: Image.asset(
//                               "assets/images/person.png",
//                               width: 30,
//                               height: 20,
//                               fit: BoxFit.fill,
//                             ),
//                             title: Text(
//                               message['name'],
//                               style: const TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                             subtitle: Text(message['message'],
//                                 style:
//                                 const TextStyle(fontWeight: FontWeight.normal)),
//                             trailing: Column(children: [
//                               Text(
//                                 message['time'], // Replace with the actual time
//                                 style: const TextStyle(color: Colors.grey),
//                               ),
//                               const SizedBox(
//                                 height: 10,
//                               ),
//                               Container(
//                                 width: 24, // Adjust the size of the circle
//                                 height: 24,
//                                 decoration: const BoxDecoration(
//                                   color: Colors
//                                       .blue, // Background color of the circle
//                                   shape: BoxShape.circle, // Circular shape
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     message[
//                                     'unread'], // Replace with the actual number
//                                     style: const TextStyle(
//                                       color: Colors.white, // Text color
//                                       fontWeight: FontWeight.bold, // Text style
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ]),
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => ChatScreen(name: message["name"],)),
//                               );
//                             }),
//                       );
//                     }),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
