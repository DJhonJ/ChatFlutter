import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import 'package:f_chat_template/domain/message.dart';
import '../controllers/authentication_controller.dart';
import '../controllers/chat_controller.dart';
import '../themes/app_theme.dart';
import '../widgets/message_widget.dart';

// Widget con la interfaz del chat
class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // controlador para el text input
  late TextEditingController _controller;

  // controlador para el sistema de scroll de la lista
  late ScrollController _scrollController;
  late String remoteUserUid;
  late String remoteEmail;

  // obtenemos los parámetros del sistema de navegación
  dynamic argumentData = Get.arguments;

  // obtenemos las instancias de los controladores
  ChatController chatController = Get.find();
  AuthenticationController authenticationController = Get.find();

  @override
  void initState() {
    super.initState();
    // obtenemos los datos del usuario con el cual se va a iniciar el chat de los argumentos
    remoteUserUid = argumentData[0];
    remoteEmail = argumentData[1];

    // instanciamos los controladores
    _controller = TextEditingController();
    _scrollController = ScrollController();

    // Le pedimos al chatController que se suscriba los chats entre los dos usuarios
    chatController.subscribeToUpdated(remoteUserUid);
  }

  @override
  void dispose() {
    // proceso de limpieza
    _controller.dispose();
    _scrollController.dispose();
    chatController.unsubscribe();
    super.dispose();
  }

  Widget _item(Message element, int posicion, String uid) {
    bool isSentMessage = uid == element.senderUid;
    return MessageWidget(message: element, isSentMessage: isSentMessage);
  }

  Widget _list() {
    String uid = authenticationController.getUid();
    logInfo('Current user $uid');

    // Escuchamos la lista de mensajes entre los dos usuarios usando el ChatController
    return GetX<ChatController>(builder: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
      return ListView.builder(
        itemCount: chatController.messages.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          var element = chatController.messages[index];
          return _item(element, index, uid);
        },
      );
    });
  }

  Future<void> _sendMsg(String text) async {
    // enviamos un nuevo mensaje usando el ChatController
    if (text.isNotEmpty && text.trim().isNotEmpty) {
      logInfo("Calling _sendMsg with $text");
      await chatController.sendChat(remoteUserUid, text);
    }
  }

  Widget _textInput() {
    const OutlineInputBorder borderInput = OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black26, width: 1.3),
        borderRadius: BorderRadius.all(Radius.circular(50))
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          flex: 6,
          child: Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: TextField(
              style: TextStyle(height: 1.4, color: AppTheme.colorBlack),
              key: const Key('MsgTextField'),
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:  const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                focusedBorder: borderInput,
                enabledBorder: borderInput,
                border: borderInput,
                hintText: "Escribe algo para $remoteEmail",
              ),
              // onSubmitted: (value) {
              //   _sendMsg(_controller.text);
              //   _controller.clear();
              // },
              controller: _controller,
            ),
          ),
        ),
        Transform.scale(
          scale: 1.3,
          child: IconButton(
              color: AppTheme.colorPrimary,
              icon: const Icon(Icons.send_rounded),
              onPressed: () {
                _sendMsg(_controller.text);
                _controller.clear();
              }),
        ),
      ],
    );
  }

  _scrollToEnd() async {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());

    return Scaffold(
        appBar: AppBar(title: Text("Chat with $remoteEmail")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [Expanded(flex: 1, child: _list()), _textInput()],
          ),
        ));
  }
}
