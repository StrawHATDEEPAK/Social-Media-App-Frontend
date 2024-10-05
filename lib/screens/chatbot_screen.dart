import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:foxxi/env.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../widgets/chatbot_message.dart';
import '../widgets/threedot_loader.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  late OpenAI? chatGPT;
  bool _isImageSearch = false;

  bool _isTyping = false;

  @override
  void initState() {
    chatGPT = OpenAI.instance.build(
        token: openAIKey,
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)));
    super.initState();
  }

  @override
  void dispose() {
    chatGPT?.close();
    chatGPT?.genImgClose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: _controller.text,
      sender: "You",
      isImage: false,
    );

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    _controller.clear();

    if (_isImageSearch) {
      final request = GenerateImage(message.text, 1, size: ImageSize.size512);

      final response = await chatGPT!.generateImage(request);
      insertNewData(response!.data!.last!.url!, isImage: true);
    } else {
      final request = ChatCompleteText(messages: [
        Map.of({"role": "user", "content": message.text})
      ], maxToken: 200, model: kChatGptTurboModel);

      final response = await OpenAI.instance.onChatCompletion(request: request);

      insertNewData(response!.choices[0].message.content, isImage: false);
    }
  }

  void insertNewData(String response, {bool isImage = false}) {
    ChatMessage botMessage = ChatMessage(
      text: response,
      sender: "Foxxi AI",
      isImage: isImage,
    );
    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.insert(0, botMessage);
      });
    }
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (value) => _sendMessage(),
              decoration: const InputDecoration.collapsed(
                  hintText: "Question/description"),
            ),
          ),
          ButtonBar(
            children: [
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  _isImageSearch = false;
                  _sendMessage();
                },
              ),
              TextButton(
                  onPressed: () {
                    _isImageSearch = true;
                    _sendMessage();
                  },
                  child: const Text("Generate Image"))
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
        backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(5),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages[index];
                },
              )),
              if (_isTyping) const ThreeDots(),
              const Divider(
                height: 1.0,
              ),
              Container(
                child: _buildTextComposer(),
              )
            ],
          ),
        ));
  }
}
