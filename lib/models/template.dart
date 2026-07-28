class MessageTemplate {
  final int id;
  final String name;
  final String channel;
  final String body;

  MessageTemplate({required this.id, required this.name, required this.channel, required this.body});

  factory MessageTemplate.fromJson(Map<String, dynamic> j) => MessageTemplate(
        id: j['id'],
        name: j['name'] ?? '',
        channel: j['channel'] ?? 'sms',
        body: j['body'] ?? '',
      );
}
