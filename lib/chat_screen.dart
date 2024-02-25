import 'package:ask_gemini/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  bool _loading = false;
  late final GenerativeModel _model;
  late final ChatSession _chat;

  @override
  void initState() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: const String.fromEnvironment('API_KEY'), // your API KEY here
    );
    _chat = _model.startChat();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ask Gemini ✨',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: _chat.history.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/chat.png'),
                          const SizedBox(height: 20),
                          Text(
                            'Start a conversation',
                            style: GoogleFonts.fredoka(fontSize: 16),
                          )
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _chat.history.length,
                      itemBuilder: (ctx, idx) {
                        var content = _chat.history.toList()[idx];
                        var text = content.parts
                            .whereType<TextPart>()
                            .map<String>((e) => e.text)
                            .join('');
                        return Column(
                          crossAxisAlignment: content.role == 'user'
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: content.role == 'user' ? 12 : 0,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: content.role == 'user'
                                      ? green
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  text,
                                  style: GoogleFonts.fredoka(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 24, bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: GoogleFonts.fredoka(),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Ask gemini...',
                        hintStyle: GoogleFonts.fredoka(color: greenDark),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: greenDark,
                          ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: greenDark,
                          ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: const BorderSide(
                            color: greenDark,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () async {
                      _sendChatMessage(_messageController.text);
                    },
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: greenAncent,
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                            ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _sendChatMessage(String message) async {
    setState(() {
      _loading = true;
    });
    try {
      var response = await _chat.sendMessage(Content.text(message));
      var text = response.text;
      if (text == null) {
        _showError('No response from API');
        return;
      } else {
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _messageController.clear();
      setState(() {
        _loading = false;
      });
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message, style: GoogleFonts.fredoka()),
        );
      },
    );
  }
}
