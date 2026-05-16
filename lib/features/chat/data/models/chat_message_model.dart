import 'dart:convert'; // required for jsonEncode / jsonDecode

// ============================================================
// ChatMessageModel
// ============================================================
// Represents a single turn in the chat conversation.
//
// ── REQUEST sent to the API ──────────────────────────────────
//   POST https://soaplike-uncalcined-delicia.ngrok-free.dev/api/chat/post/
//   Content-Type: application/json; charset=utf-8
//   Accept: application/json
//
//   { "prompt": "ما هو أفضل مطعم في القاهرة؟" }
//
//   Key MUST be "prompt". Value is always a plain String.
//   Arabic text is supported — Dart strings are UTF-16 internally
//   and jsonEncode() always outputs valid UTF-8 JSON.
//
// ── RESPONSE from the API (HTTP 200) ─────────────────────────
//   The parser tries these response keys in priority order:
//     "response" | "reply" | "answer" | "message" | "text"
//   This makes the model resilient to minor backend key changes.
//
// ── ERROR RESPONSE ────────────────────────────────────────────
//   { "error": "some error message" }
//   { "detail": "some detail" }        (DRF default)
// ============================================================

class ChatMessageModel {
  /// The text content of this message.
  final String text;

  /// "user"  → message typed by the human
  /// "model" → reply received from the AI backend
  final String role;

  /// true  → message is safe to display normally
  /// false → message represents an error / unexpected state
  final bool isSuccess;

  const ChatMessageModel({
    required this.text,
    required this.role,
    required this.isSuccess,
  });

  // ── Convenience getters ───────────────────────────────────────

  bool get isUser => role == 'user';
  bool get isModel => role == 'model';

  // ── Serialisation (Flutter → API) ─────────────────────────────

  /// Builds the JSON body the API expects.
  ///
  /// The key MUST be "prompt" — confirmed by the API spec.
  ///
  /// Example (Arabic prompt):
  ///   jsonEncode(toRequestJson())
  ///   → '{"prompt":"عندنا محاضرات اي يوم الاربعاء؟"}'
  ///
  /// Dart's jsonEncode() always produces valid UTF-8 JSON, so Arabic
  /// characters are transmitted correctly with no extra configuration.
  Map<String, dynamic> toRequestJson() => {
        'prompt': text, // ← MUST be "prompt", not "message"
      };

  // ── Deserialisation (API → Flutter) ───────────────────────────

  /// Parses the raw JSON response from POST /api/chat/post/.
  ///
  /// Tries multiple common response keys for robustness:
  ///   "response" → "reply" → "answer" → "message" → "text"
  ///
  /// Error fields checked first:
  ///   "error" → "detail"  (Django REST Framework default)
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    try {
      // ── 1. Server-side error body ─────────────────────────────
      // e.g. { "error": "invalid request" }
      //      { "detail": "Not found." }  ← DRF default
      final errorText = json['error'] ?? json['detail'];
      if (errorText != null) {
        return ChatMessageModel(
          text: errorText.toString(),
          role: 'model',
          isSuccess: false,
        );
      }

      // ── 2. Successful reply — try keys in priority order ──────
      // "response" is the most common pairing for a "prompt" request.
      // Fallbacks cover common Django/FastAPI naming variants.
      final replyText = json['response'] ??
          json['reply'] ??
          json['answer'] ??
          json['message'] ??
          json['text'];

      if (replyText != null) {
        return ChatMessageModel(
          text: replyText.toString(),
          role: 'model',
          isSuccess: true,
        );
      }

      // ── 3. Unexpected shape ───────────────────────────────────
      // Log the raw json in debug mode so the developer can add
      // the correct key to the priority list above.
      return ChatMessageModel(
        text: 'Unexpected response format. Raw: ${jsonEncode(json)}',
        role: 'model',
        isSuccess: false,
      );
    } catch (_) {
      return const ChatMessageModel(
        text: 'Failed to parse server response.',
        role: 'model',
        isSuccess: false,
      );
    }
  }

  @override
  String toString() =>
      'ChatMessageModel(role: $role, isSuccess: $isSuccess, text: $text)';
}
