/// This class represents a single row from your Excel sheet.
/// By creating a "Model" class, we make the data structured and easy to understand for beginners.
class TradingScenario {
  final String sNo;
  final String scenarioName;
  final String orderType;
  final String symbol;
  final double price;
  final double qty;
  final String side;
  final String action;
  final String authenticationToken;

  TradingScenario({
    required this.sNo,
    required this.scenarioName,
    required this.orderType,
    required this.symbol,
    required this.price,
    required this.qty,
    required this.side,
    required this.action,
    required this.authenticationToken,
  });

  /// A helper method to create a mock scenario for testing without needing the actual Excel sheet.
  static List<TradingScenario> getMockData() {
    return [
      TradingScenario(
        sNo: "1",
        scenarioName: "Open Long Position",
        orderType: "LIMIT",
        symbol: "BTCUSDT",
        price: 45000.0,
        qty: 0.1,
        side: "BUY",
        action: "OPEN",
        authenticationToken: "mock_token_123",
      ),
      TradingScenario(
        sNo: "2",
        scenarioName: "Close Long Position",
        orderType: "MARKET",
        symbol: "BTCUSDT",
        price: 46000.0,
        qty: 0.1,
        side: "SELL",
        action: "CLOSE",
        authenticationToken: "mock_token_123",
      ),
    ];
  }
}
