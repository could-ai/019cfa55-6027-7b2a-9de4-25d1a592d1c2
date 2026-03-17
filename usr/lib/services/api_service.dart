import '../models/trading_scenario.dart';

/// This service handles all the API configurations and requests.
/// In your original JS, `Excell_run?.headers` was used globally which causes errors.
/// Here, we pass the token explicitly to the methods that need it.
class ApiService {
  final String baseUrl = 'https://sandboxcoreapiv3.millionero.io/api';

  /// Generates the headers needed for the API request using the token from the Excel row.
  Map<String, String> _getHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // --- Mocked API Calls ---
  // In a real app, you would use the 'http' package here.

  Future<double> getBalance(String token) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return 10000.0; // Mock balance
  }

  Future<bool> placeOrder(TradingScenario scenario) async {
    final headers = _getHeaders(scenario.authenticationToken);
    // Simulate placing order
    await Future.delayed(const Duration(milliseconds: 800));
    return true; // Success
  }

  Future<List<Map<String, dynamic>>> getRecentTrades(String token) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {'tradeId': '123', 'pnl': 50.0, 'margin': 100.0}
    ];
  }

  Future<bool> closePosition(String token, String positionId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }
}
