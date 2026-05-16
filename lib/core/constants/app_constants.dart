class AppConstants {
  // ─── New API base URL (ngrok tunnel → Django/FastAPI backend) ───
  static const String baseUrl =
      'https://soaplike-uncalcined-delicia.ngrok-free.dev';

  // Full chat endpoint path (used by ChatApiService)
  static const String chatEndpoint = '/api/chat/post/';
}
