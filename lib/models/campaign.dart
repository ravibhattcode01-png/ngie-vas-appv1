class Campaign {
  final int id;
  final String title;
  final String channel;
  final int totalRecipients;
  final int sentCount;
  final int deliveredCount;
  final int failedCount;
  final String status;
  final String totalCost;

  Campaign({
    required this.id,
    required this.title,
    required this.channel,
    required this.totalRecipients,
    required this.sentCount,
    required this.deliveredCount,
    required this.failedCount,
    required this.status,
    required this.totalCost,
  });

  factory Campaign.fromJson(Map<String, dynamic> j) => Campaign(
        id: j['id'],
        title: j['title'] ?? '',
        channel: j['channel'] ?? 'sms',
        totalRecipients: (j['total_recipients'] ?? 0) as int,
        sentCount: (j['sent_count'] ?? 0) as int,
        deliveredCount: (j['delivered_count'] ?? 0) as int,
        failedCount: (j['failed_count'] ?? 0) as int,
        status: j['status'] ?? 'queued',
        totalCost: (j['total_cost'] ?? '0.00').toString(),
      );
}

class CampaignMessage {
  final String recipient;
  final String status;
  final String? failureReason;
  CampaignMessage({required this.recipient, required this.status, this.failureReason});

  factory CampaignMessage.fromJson(Map<String, dynamic> j) => CampaignMessage(
        recipient: j['recipient'] ?? '',
        status: j['status'] ?? 'pending',
        failureReason: j['failure_reason'],
      );
}
