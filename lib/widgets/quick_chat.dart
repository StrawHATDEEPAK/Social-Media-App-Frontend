// import 'package:flutter/material.dart';
// import 'package:foxxi/models/story.dart';
// import 'package:dashed_circle/dashed_circle.dart';

// class quickChat extends StatefulWidget {
//   const quickChat({super.key});

//   @override
//   State<quickChat> createState() => _quickChatState();
// }

// class _quickChatState extends State<quickChat> with TickerProviderStateMixin {
//   Animation? gap;
//   Animation<double>? base;
//   Animation<double>? reverse;
//   AnimationController? controller;

//   /// Init
//   @override
//   void initState() {
//     super.initState();
//     controller =
//         AnimationController(vsync: this, duration: Duration(seconds: 6));
//     base = CurvedAnimation(parent: controller!, curve: Curves.easeOut);
//     reverse = Tween<double>(begin: 0.0, end: -1.0).animate(base!);
//     gap = Tween<double>(begin: 3.0, end: 0.0).animate(base!)
//       ..addListener(() {
//         setState(() {});
//       });
//     controller!.forward();
//   }

//   /// Dispose
//   @override
//   void dispose() {
//     controller!.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.2,
//       // color: Colors.grey.withOpacity(0.30),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: stories.length,
//         itemBuilder: (context, index) {
//           return InkWell(
//             onTap: (() {
//               setState(() {
//                 stories[index].isSeen = true;
//               });
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => StoryPage(
//                     profileImage: stories[index].profileImage,
//                     index: index,
//                     storyImage: stories[index].storyImage,
//                     userName: stories[index].userName,
//                   ),
//                 ),
//               );
//             }),
//             child: Container(
//               // decoration: BoxDecoration(border: Border.all()),
//               padding: const EdgeInsets.all(7),
//               alignment: Alignment.center,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     // padding: EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.purpleAccent.shade200.withOpacity(0.7),
//                           Colors.lightBlue.shade200.withOpacity(0.7),
//                         ],
//                         stops: [0, 1],
//                         begin: AlignmentDirectional(1, 0),
//                         end: AlignmentDirectional(-1, 0),
//                         // color: Colors.purpleAccent.shade100.withOpacity(
//                         // 0.3,
//                       ),
//                     ),
//                     child: Card(
//                       elevation: 20,
//                       shape: const CircleBorder(),
//                       // clipBehavior: Clip.antiAlias,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: Container(
//                           padding: EdgeInsets.all(2),
//                           // decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),),
//                           color: Colors.white,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.network(
//                               stories[index].profileImage.toString(),
//                               width: 50,
//                               height: 50,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(stories[index].userName.toString()),
//                   )
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class StoryPage extends StatelessWidget {
//   final int? index;
//   final String? storyImage;
//   final String? profileImage;
//   final String? userName;
//   const StoryPage(
//       {super.key,
//       this.index,
//       this.userName,
//       this.storyImage,
//       this.profileImage});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Row(
//           children: [
//             CircleAvatar(
//               child: ClipOval(
//                 child: Image.network(
//                   profileImage.toString(),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.only(left: 5),
//                   child: Text(
//                     userName.toString(),
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.only(left: 5),
//                   child: const Text(
//                     "2023 Jan 23",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w200,
//                     ),
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//       body: SizedBox(
//         width: double.infinity,
//         height: double.infinity,
//         child: FittedBox(
//           fit: BoxFit.cover,
//           child: Image.network(
//             storyImage.toString(),
//             // fit: BoxFit.fill,
//           ),
//         ),
//       ),
//     );
//   }
// }
