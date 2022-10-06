import 'package:flutter/material.dart';

import '../../../domain/message.dart';
import '../themes/app_theme.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget(
      {Key? key, required this.message, required this.isSentMessage})
      : super(key: key);

  final Message message;
  final bool isSentMessage;

  @override
  Widget build(BuildContext context) {
    double left = 0.0;
    double right = 0.0;

    if (isSentMessage) {
      left = 40;
    } else {
      right = 40;
    }

    return Padding(
      padding: EdgeInsets.only(right: right, left: left, top: 2, bottom: 2),
      child: Row(
        mainAxisAlignment:
            isSentMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          //SizedBox(height: 30),
          Flexible(
              child: Container(
            constraints: const BoxConstraints(
              minWidth: 150,
            ),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSentMessage
                  ? AppTheme.colorPrimaryMedium
                  : AppTheme.colorGrey,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
                bottomLeft: Radius.circular(13),
                bottomRight: Radius.circular(13),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.msg,
                  style: TextStyle(color: AppTheme.colorBlack, fontSize: 16),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
