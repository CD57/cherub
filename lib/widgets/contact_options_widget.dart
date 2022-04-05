// import 'package:flutter/material.dart';

// import '../models/user_model.dart';

// class ContactOptionsWidget extends StatelessWidget {
//   const ContactOptionsWidget({Key? key, required this.userList}) : super(key: key);
//   final List<UserModel> userList;

//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       padding: const EdgeInsets.all(10),
//       separatorBuilder: (BuildContext context, int index) {
//         return Align(
//           alignment: Alignment.centerRight,
//           child: SizedBox(
//             height: 0.5,
//             width: MediaQuery.of(context).size.width / 1.3,
//             child: const Divider(),
//           ),
//         );
//       },
//       itemCount: userList.length,
//       itemBuilder: (BuildContext context, int index) {
//         UserModel user = userList[index];
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundImage: AssetImage(
//                 user.imageURL,
//               ),
//               radius: 25,
//             ),
//             contentPadding: const EdgeInsets.all(0),
//             title: Text(user.name),
//             subtitle: Text(user.username),
//             trailing: user['isAccept']
//                 ? TextButton(
//                     child: const Text(
//                       "Remove",
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                     onPressed: () {},
//                   )
//                 : TextButton(
//                     child: const Text(
//                       "Add",
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                     onPressed: () {},
//                   ),
//             onTap: () {},
//           ),
//         );
//       },
//     );
//   }
// }
