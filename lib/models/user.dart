class AppUser {
  final int id;
  final String name;
  final String? companyName;
  final String email;
  final String role;
  final String balance;
  final int balancePaise;
  final int rateSms;
  final int rateWhatsapp;
  final int rateIvr;

  AppUser({
    required this.id,
    required this.name,
    this.companyName,
    required this.email,
    required this.role,
    required this.balance,
    required this.balancePaise,
    required this.rateSms,
    required this.rateWhatsapp,
    required this.rateIvr,
  });

  factory AppUser.fromJson(Map<String, dynamic> j) {
    final rates = (j['rates'] ?? {}) as Map<String, dynamic>;
    return AppUser(
      id: j['id'],
      name: j['name'] ?? '',
      companyName: j['company_name'],
      email: j['email'] ?? '',
      role: j['role'] ?? 'client',
      balance: (j['balance'] ?? '0.00').toString(),
      balancePaise: (j['balance_paise'] ?? 0) as int,
      rateSms: (rates['sms'] ?? 25) as int,
      rateWhatsapp: (rates['whatsapp'] ?? 60) as int,
      rateIvr: (rates['ivr'] ?? 100) as int,
    );
  }

  int rateFor(String channel) {
    switch (channel) {
      case 'whatsapp':
        return rateWhatsapp;
      case 'ivr':
        return rateIvr;
      default:
        return rateSms;
    }
  }
}
