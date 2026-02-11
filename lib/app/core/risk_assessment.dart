/// Risk Assessment Utility
/// Detects high-risk keywords in user content and provides appropriate warnings
class RiskAssessment {
  // Risk levels
  static const String riskLow = 'low';
  static const String riskMedium = 'medium';
  static const String riskHigh = 'high';
  static const String riskCritical = 'critical';

  /// Critical suicide risk keywords
  static const List<String> _suicideKeywords = [
    'bunuh diri',
    'ingin mati',
    'mengakhiri hidup',
    'tidak ingin hidup',
    'lebih baik mati',
    'mau mati',
    'pengen mati',
    'suicide',
    'pengin mati',
    'ingin mengakhiri',
  ];

  /// Moderate risk keywords
  static const List<String> _moderateKeywords = [
    'putus asa',
    'tidak ada harapan',
    'tidak berguna',
    'beban',
    'menyerah',
    'capek hidup',
    'lelah hidup',
    'tidak kuat lagi',
    'sudah tidak sanggup',
  ];

  /// Psychosis indicators
  static const List<String> _psychosisKeywords = [
    'mendengar suara',
    'suara-suara',
    'bisikan',
    'ada yang berbicara',
    'melihat hal',
    'halusinasi',
    'diawasi',
    'diikuti',
    'diintai',
    'konspirasi',
  ];

  /// Trauma indicators
  static const List<String> _traumaKeywords = [
    'diperkosa',
    'perkosaan',
    'dilecehkan',
    'pelecehan seksual',
    'kekerasan',
    'dipukul',
    'dianiaya',
    'disiksa',
    'trauma',
    'flashback',
  ];

  /// Assess risk level from text content
  static Map<String, dynamic> assess(String content) {
    final contentLower = content.toLowerCase();
    final List<String> detectedKeywords = [];
    int criticalCount = 0;
    int moderateCount = 0;
    int otherCount = 0;

    // Check for critical suicide keywords
    for (final keyword in _suicideKeywords) {
      if (contentLower.contains(keyword)) {
        detectedKeywords.add(keyword);
        criticalCount++;
      }
    }

    // Check for moderate keywords
    for (final keyword in _moderateKeywords) {
      if (contentLower.contains(keyword)) {
        if (!detectedKeywords.contains(keyword)) {
          detectedKeywords.add(keyword);
          moderateCount++;
        }
      }
    }

    // Check for psychosis keywords
    for (final keyword in _psychosisKeywords) {
      if (contentLower.contains(keyword)) {
        if (!detectedKeywords.contains(keyword)) {
          detectedKeywords.add(keyword);
          otherCount++;
        }
      }
    }

    // Check for trauma keywords
    for (final keyword in _traumaKeywords) {
      if (contentLower.contains(keyword)) {
        if (!detectedKeywords.contains(keyword)) {
          detectedKeywords.add(keyword);
          otherCount++;
        }
      }
    }

    // Determine risk level
    String riskLevel;
    bool requiresWarning;
    bool requiresEscalation;

    if (criticalCount > 0) {
      riskLevel = riskCritical;
      requiresWarning = true;
      requiresEscalation = true;
    } else if (moderateCount >= 2 || otherCount >= 3) {
      riskLevel = riskHigh;
      requiresWarning = true;
      requiresEscalation = true;
    } else if (moderateCount >= 1 || otherCount >= 2) {
      riskLevel = riskMedium;
      requiresWarning = true;
      requiresEscalation = false;
    } else if (otherCount >= 1) {
      riskLevel = riskLow;
      requiresWarning = false;
      requiresEscalation = false;
    } else {
      riskLevel = riskLow;
      requiresWarning = false;
      requiresEscalation = false;
    }

    return {
      'risk_level': riskLevel,
      'detected_keywords': detectedKeywords,
      'requires_warning': requiresWarning,
      'requires_escalation': requiresEscalation,
      'critical_count': criticalCount,
      'moderate_count': moderateCount,
    };
  }

  /// Get warning message based on risk level
  static String getWarningMessage(String riskLevel) {
    switch (riskLevel) {
      case riskCritical:
        return 'Kami mendeteksi Anda mungkin dalam kondisi darurat. '
            'Silakan hubungi hotline crisis segera di 119 atau klik tombol darurat di bawah. '
            'Tim kami juga akan segera menghubungi Anda.';

      case riskHigh:
        return 'Kami mendeteksi Anda mungkin sedang mengalami kesulitan berat. '
            'Tim kami akan memberikan perhatian khusus untuk kasus Anda. '
            'Jika merasa terdesak, silakan hubungi hotline crisis di 119.';

      case riskMedium:
        return 'Terima kasih telah menceritakan kondisi Anda. '
            'Tim kami akan memberikan pendampingan dengan perhatian khusus.';

      default:
        return '';
    }
  }

  /// Get recommended actions
  static List<String> getRecommendedActions(String riskLevel) {
    switch (riskLevel) {
      case riskCritical:
        return [
          'Hubungi hotline crisis: 119',
          'Tetap tenang dan cari tempat aman',
          'Hubungi keluarga atau teman terdekat',
          'Tim kami akan segera menghubungi Anda',
        ];

      case riskHigh:
        return [
          'Hotline tersedia 24/7: 119',
          'Kami akan prioritaskan kasus Anda',
          'Pertimbangkan berbicara dengan orang terdekat',
        ];

      case riskMedium:
        return [
          'Konsultan kami akan segera merespons',
          'Hotline tersedia jika diperlukan: 119',
        ];

      default:
        return [];
    }
  }

  /// Check if content should trigger immediate warning
  static bool shouldWarnImmediately(String content) {
    final assessment = assess(content);
    return assessment['requires_warning'] == true;
  }

  /// Check if content should trigger crisis escalation
  static bool shouldEscalate(String content) {
    final assessment = assess(content);
    return assessment['requires_escalation'] == true;
  }
}
