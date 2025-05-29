/*import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Message Model
class Message {
  final String id;
  final String content;
  final bool isMe;
  final DateTime timestamp;
  final MessageType type;
  final String? fileName;
  final String? filePath;

  Message({
    required this.id,
    required this.content,
    required this.isMe,
    required this.timestamp,
    this.type = MessageType.text,
    this.fileName,
    this.filePath,
  });
}

enum MessageType { text, audio, image, file }

// Chat Controller
class IndividualChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
   final ImagePicker _picker = ImagePicker();

  var messages = <Message>[
    Message(
      id: '1',
      content: 'Hey! Ready for tomorrow\'s study session?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Message(
      id: '2',
      content: 'Yes! I\'ve prepared all the notes we discussed.',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
    ),
    Message(
      id: '3',
      content: 'Perfect! Should we meet at the library?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
  ].obs;

  var isRecording = false.obs;
  var recordingDuration = 0.obs;

  void sendMessage(String content, {MessageType type = MessageType.text, String? fileName, String? filePath}) {
    if (content.trim().isEmpty && type == MessageType.text) return;

    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isMe: true,
      timestamp: DateTime.now(),
      type: type,
      fileName: fileName,
      filePath: filePath,
    );

    messages.add(message);
    messageController.clear();

    // Auto scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void startRecording() {
    isRecording.value = true;
    recordingDuration.value = 0;
    // Start recording timer
    _startRecordingTimer();
  }

  void stopRecording() {
    isRecording.value = false;
    sendMessage(
      'Audio message (${_formatDuration(recordingDuration.value)})',
      type: MessageType.audio,
    );
    recordingDuration.value = 0;
  }

  void _startRecordingTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (isRecording.value) {
        recordingDuration.value++;
        _startRecordingTimer();
      }
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> pickImage(source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        sendMessage(
          'Photo',
          type: MessageType.image,
          fileName: image.name,
          filePath: image.path,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        PlatformFile file = result.files.first;
        sendMessage(
          file.name,
          type: MessageType.file,
          fileName: file.name,
          filePath: file.path,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick file');
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}

// Individual Chat Page
class IndividualChatPage extends StatelessWidget {
  final String chatId;
  final String chatName;
  final bool isOnline;

  const IndividualChatPage({
    Key? key,
    required this.chatId,
    required this.chatName,
    required this.isOnline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(IndividualChatController(), tag: chatId);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessagesList(controller)),
          _buildMessageInput(controller, context),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Get.back(),
      ),
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  chatName.split(' ').map((e) => e[0]).take(2).join(),
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  isOnline ? 'Online' : 'Last seen recently',
                  style: TextStyle(
                    fontSize: 12,
                    color: isOnline ? Colors.green : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.videocam, color: Colors.black87),
          onPressed: () => Get.snackbar('Video Call', 'Starting video call...'),
        ),
        IconButton(
          icon: const Icon(Icons.call, color: Colors.black87),
          onPressed: () => Get.snackbar('Voice Call', 'Starting voice call...'),
        ),
        PopupMenuButton(
          icon: const Icon(Icons.more_vert, color: Colors.black87),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'view_profile', child: Text('View Profile')),
            const PopupMenuItem(value: 'media', child: Text('Media, Links, and Docs')),
            const PopupMenuItem(value: 'search', child: Text('Search')),
            const PopupMenuItem(value: 'mute', child: Text('Mute Notifications')),
            const PopupMenuItem(value: 'wallpaper', child: Text('Wallpaper')),
          ],
        ),
      ],
    );
  }

  Widget _buildMessagesList(IndividualChatController controller) {
    return Obx(() => ListView.builder(
      controller: controller.scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: controller.messages.length,
      itemBuilder: (context, index) {
        final message = controller.messages[index];
        return _buildMessageBubble(message);
      },
    ));
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: message.isMe ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: message.isMe ? const Radius.circular(4) : const Radius.circular(20),
            bottomLeft: !message.isMe ? const Radius.circular(4) : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMessageContent(message),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    fontSize: 11,
                    color: message.isMe ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
                if (message.isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.done_all,
                    size: 14,
                    color: Colors.white70,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(Message message) {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content,
          style: TextStyle(
            fontSize: 15,
            color: message.isMe ? Colors.white : Colors.black87,
          ),
        );
      case MessageType.audio:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_arrow,
              color: message.isMe ? Colors.white : Colors.blue,
            ),
            const SizedBox(width: 8),
            Text(
              message.content,
              style: TextStyle(
                fontSize: 15,
                color: message.isMe ? Colors.white : Colors.black87,
              ),
            ),
          ],
        );
      case MessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image, size: 50, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              message.fileName ?? 'Image',
              style: TextStyle(
                fontSize: 13,
                color: message.isMe ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
          ],
        );
      case MessageType.file:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.insert_drive_file,
              color: message.isMe ? Colors.white : Colors.blue,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message.fileName ?? 'File',
                style: TextStyle(
                  fontSize: 15,
                  color: message.isMe ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        );
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${dateTime.day}/${dateTime.month}';
    } else {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  Widget _buildMessageInput(IndividualChatController controller, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(() => controller.isRecording.value
          ? _buildRecordingWidget(controller)
          : _buildNormalInput(controller, context)),
    );
  }

  Widget _buildNormalInput(IndividualChatController controller, BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.add, color: Colors.blue),
          onPressed: () => _showAttachmentOptions(context, controller),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              controller: controller.messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => controller.messageController.text.isNotEmpty
              ? controller.sendMessage(controller.messageController.text)
              : controller.startRecording(),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              controller.messageController.text.isNotEmpty ? Icons.send : Icons.mic,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingWidget(IndividualChatController controller) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Recording...', style: TextStyle(color: Colors.red)),
                const Spacer(),
                Obx(() => Text(
                  controller._formatDuration(controller.recordingDuration.value),
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                )),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: controller.stopRecording,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.stop,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  void _showAttachmentOptions(BuildContext context, IndividualChatController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  color: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickImage(ImageSource.camera);
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickImage(ImageSource.gallery);
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.insert_drive_file,
                  label: 'File',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickFile();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} */