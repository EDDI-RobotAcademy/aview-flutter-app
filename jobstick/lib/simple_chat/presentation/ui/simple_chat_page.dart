import 'package:jobstick/common_ui/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/simple_chat_provider.dart';

class SimpleChatPage extends StatefulWidget {

  @override
  _SimpleChatPageState createState() => _SimpleChatPageState();
}

class _SimpleChatPageState extends State<SimpleChatPage> {
  final TextEditingController messageController = TextEditingController();
  String? response;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SimpleChatProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          body: Container(),
          title: 'Simple Chat',
          showBackButton: false, // ✅ 이 한 줄 추가하면 뒤로가기 안 보임
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: messageController,
              decoration: const InputDecoration(
                labelText: '메시지를 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final message = messageController.text.trim();
                if (message.isNotEmpty) {
                  try {
                    final result = await provider.sendMessageToLLM(message);
                    setState(() {
                      response = result;
                    });
                  } catch (e) {
                    setState(() {
                      response = 'Error: $e';
                    });
                  }
                }
              },
              child: const Text('전송'),
            ),
            const SizedBox(height: 24),
            if (response != null) ...[
              const Text(
                'LLM 응답:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(response!),
            ]
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}