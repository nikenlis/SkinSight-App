import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:skinsight/core/ui/shared_method.dart';

import '../../../../core/theme/app_color.dart';
import '../../../explore/presentation/bloc/news/news_bloc.dart';
import '../bloc/chatbot_bloc.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: '0', firstName: "User");
  ChatUser chatbotUser = ChatUser(
      id: '1',
      firstName: "SkinSight ChatBot",
      profileImage:
          'https://www.shutterstock.com/image-vector/chat-bot-icon-design-robot-600nw-2476207303.jpg');

  @override
  void initState() {
    super.initState();

    messages.add(
      ChatMessage(
        text:
            "Hi there! I’m your digital cosmetologist. Having concerns about skin? I’m always here to give you prompt advice and help you choose safe skincare...",
        createdAt: DateTime.now(),
        user: chatbotUser,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sizuka ChatBot'),
      ),
      body: _buildUi(),
    );
  }

  _buildUi() {
    return BlocConsumer<ChatbotBloc, ChatbotState>(
      listener: (context, state) {
        if (state is ChatbotLoaded) {
          // Tambahkan balasan chatbot
          final botReply = ChatMessage(
            text: state.data,
            user: chatbotUser,
            createdAt: DateTime.now(),
          );
          setState(() {
            messages = [botReply, ...messages];
          });
        } else if (state is ChatbotFailed) {
          showCustomSnackbar(context, state.message);
        }
      },
      builder: (context, state) {
        return DashChat(
          currentUser: currentUser,
          onSend: _sendMessage,
          messages: messages,
          typingUsers: state is ChatbotLoading ? [chatbotUser] : [],
          
          inputOptions: InputOptions(
            alwaysShowSend: true,
            sendButtonBuilder: (onSend) {
              return IconButton(
                icon: Icon(
                  Icons.send_rounded,
                  color: mainColor,
                ),
                onPressed: onSend,
              );
            },
            cursorStyle: CursorStyle(
              color: mainColor, // ⬅️ warna cursor
            ),
            inputDecoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Type your question here",
              hintStyle: TextStyle(color: kSecondaryTextColor),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: kOutlineColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: kOutlineColor),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: kOutlineColor),
              ),
            ),
            inputToolbarStyle: BoxDecoration(
              color: lightBackgroundColor,
            ),
            inputToolbarPadding: EdgeInsets.all(8),
            inputToolbarMargin: EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
          ),
          messageOptions: MessageOptions(
            showOtherUsersName: true,
            showTime: true,
            containerColor: Colors.white,
            currentUserContainerColor: mainColor,
            messageTextBuilder: (message, _, __) {
              final isCurrentUser = message.user.id == currentUser.id;
              return MarkdownBody(
                data: message.text,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    fontSize: 16,
                    color: isCurrentUser
                        ? Colors.white
                        : kMainTextColor, // ⬅️ penting!
                  ),
                  strong: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCurrentUser ? Colors.white : kMainTextColor,
                  ),
                  a: const TextStyle(
                    color: mainColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              );
            },
            avatarBuilder: (user, onTapAvatar, isUser) {
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundImage: user.id == chatbotUser.id
                        ? AssetImage('assets/img_bot.png')
                        : null,
                    child: user.id != chatbotUser.id
                        ? Text(user.firstName?[0] ?? '')
                        : null,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    String question = chatMessage.text;
    context.read<ChatbotBloc>().add(GetOutputChatbotEvent(message: question));
  }
}
