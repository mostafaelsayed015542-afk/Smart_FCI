class GeminiMessageModel {
  final String text;
  final String role;
  final bool isSuccess;

  GeminiMessageModel({required this.text,required this.role, required this.isSuccess});

      Map<String , dynamic> toJson(){
        return {
          "role" : role,
          "parts" :[
            {"text" :text},
          ]
        };
      }
    factory GeminiMessageModel.fromJson(Map<String, dynamic> json) {
    try {
      if (json['error'] != null) {
        return GeminiMessageModel(
          text: json['error']['message'] ?? "Unknown error",
          role: "model",
          isSuccess: false,
        );
      }

      final candidates = json['candidates'];

      if (candidates is List && candidates.isNotEmpty) {
        final parts = candidates[0]['content']?['parts'];

        if (parts is List && parts.isNotEmpty) {
          return GeminiMessageModel(
            text: parts[0]['text'] ?? "No response",
            role: "model",
            isSuccess: true,
          );
        }
      }

      return GeminiMessageModel(
        text: "Unexpected format",
        role: "model",
        isSuccess: false,
      );
    } catch (_) {
      return GeminiMessageModel(
        text: "Parse error",
        role: "model",
        isSuccess: false,
      );
    }
  }
}