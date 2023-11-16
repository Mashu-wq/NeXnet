
import 'package:flutter/material.dart';
import 'package:nexnet/pages/authentication/widget/text_field_input.dart';
import 'package:nexnet/services/auth/auth_services.dart';
import 'package:nexnet/services/cloud/cloud_message/cloud_chat.dart';
import 'package:nexnet/services/cloud/cloud_message/cloud_message.dart';
import 'package:nexnet/services/cloud/cloud_message/cloud_message_service.dart';
import 'package:nexnet/services/cloud/cloud_user/cloud_user.dart';
import 'package:nexnet/services/cloud/cloud_user/cloud_user_service.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key, required this.sendToUser});
  final CloudUser sendToUser;

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  late final TextEditingController _messageTextController;

  final currentUser = AuthService.firebase().currentUser!;
  String get userId => currentUser.id;

  final bool sentByMe = true;

  @override
  void initState() {
    _messageTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    super.dispose();
  }

  Future<void> getExistingUser() async {
    await CloudUserService.firebase().getUser(userId: userId);
  }

  Future<void> addMessage() async {
    String messageId = const Uuid().v1();
    final existingUser = await CloudUserService.firebase().getUser(userId: userId);

    CloudMessage cloudMessage = CloudMessage(
      messageId: messageId,
      sendBy: userId,
      messageText: _messageTextController.text,
      sendAt: DateTime.now(),
    );

    CloudChat cloudChatUserSender = CloudChat(
      userId: widget.sendToUser.userId,
      profileUrl: widget.sendToUser.profileUrl!,
      userName: widget.sendToUser.userName,
      fullNmae: widget.sendToUser.fullName,
    );

    CloudMessageService.firebase().createNewMessage(
      existingUser!,
      widget.sendToUser,
      cloudChatUserSender,
      cloudMessage,
    );

    CloudChat cloudChatUserReceiver = CloudChat(
      userId: existingUser.userId,
      profileUrl: existingUser.profileUrl!,
      userName: existingUser.userName,
      fullNmae: existingUser.fullName,
    );

    CloudMessageService.firebase().createNewMessage(
      widget.sendToUser,
      existingUser,
      cloudChatUserReceiver,
      cloudMessage,
    );
    _messageTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color.fromARGB(255, 83, 136, 162),
        centerTitle: false,
        elevation: 0,
        title: Text(widget.sendToUser.fullName),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: CloudUserService.firebase().getUser(userId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.done:
              if (snapshot.hasData) {
                final CloudUser existingUser = snapshot.data as CloudUser;
                return StreamBuilder(
                  stream: CloudMessageService.firebase().userAllMessages(
                    existingUser,
                    widget.sendToUser,
                  ),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final allMessages =
                              snapshot.data as Iterable<CloudMessage>;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 16),
                            child: ListView.separated(
                              itemCount: allMessages.length,
                              reverse: true,
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                height: 12,
                              ),
                              itemBuilder: (context, index) {
                                final message = allMessages.elementAt(index);
                                final sendAt = DateFormat.jm()
                                    .format(message.sendAt)
                                    .toString();
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  alignment: (message.sendBy == userId)
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    margin: (message.sendBy == userId)
                                        ? const EdgeInsets.only(left: 30)
                                        : const EdgeInsets.only(right: 30),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      color: (message.sendBy == userId)
                                          ? Colors.grey.shade100
                                          : Colors.grey.shade300,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message.messageText,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          sendAt,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          // show no post message
                          return const CircularProgressIndicator();
                        }
                      default:
                        return const CircularProgressIndicator();
                    }
                  },
                );
              } else {
                return const Center(
                  child: Text('User Not Found', style: TextStyle(color: Colors.black87),),
                );
              }

            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(33),
          color: Colors.grey.shade100,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: TextFieldInput(
                  textEditingController: _messageTextController,
                  textInputType: TextInputType.text,
                  hintText: 'Message...',
                ),
              ),
              const VerticalDivider(
                color: Colors.transparent,
                width: 10,
              ),
              InkWell(
                onTap: () {
                  addMessage();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(Icons.send),
                  /*Image.asset(
                    'assets/icons/send_msg.png',
                    height: 20,
                    width: 20,
                  ),*/
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
