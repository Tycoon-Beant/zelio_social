
class UnitData{
  String? unit;
  String? value;

  UnitData({this.unit, this.value});

  UnitData.fromJson(Map<String, dynamic> json) {
    unit = json["unit"] ;
    value =  json["value"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["unit"] = this.unit;
    data["value"] = this.value;
    return data;
  }
}




// class BuildChatBubble extends StatelessWidget {
//   final List<MessageModel> chat;
//   const BuildChatBubble({super.key, required this.chat});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ListView.separated(
//         itemCount: chat.length,
//         reverse: true,
//         itemBuilder: (BuildContext context, int index) {
//           final String user = chat[index].["user"]};
//           final String message = chat[index]["message"] as String;
//           return Row(
//             mainAxisAlignment: user == "sender"
//                 ? MainAxisAlignment.end
//                 : MainAxisAlignment.start,
//             children: [
//               Column(
//                 crossAxisAlignment: user == "sender"
//                     ? CrossAxisAlignment.end
//                     : CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "$user: ",
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodySmall!
//                         .copyWith(color: Colors.grey),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: user == "sender"
//                             ? Colors.blue
//                             : const Color.fromARGB(255, 213, 212, 212),
//                         borderRadius: user == "sender"
//                             ? BorderRadius.only(
//                                 topLeft: Radius.circular(20),
//                                 bottomLeft: Radius.circular(20),
//                                 bottomRight: Radius.circular(20))
//                             : BorderRadius.only(
//                                 topRight: Radius.circular(20),
//                                 bottomLeft: Radius.circular(20),
//                                 bottomRight: Radius.circular(20))),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Text(
//                         message,
//                         style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                             color:
//                                 user == "sender" ? Colors.white : Colors.black),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           );
//         },
//         separatorBuilder: (BuildContext context, int index) {
//           return const SizedBox(height: 8);
//         },
//       ),
//     );
//   }
// }
