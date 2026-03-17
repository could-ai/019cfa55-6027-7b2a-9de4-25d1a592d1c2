import '../models/trading_scenario.dart';
import 'api_service.dart';

/// This class contains the exact 7-step flow from your Scenario_flow.js.
/// It is organized sequentially so a beginner can easily read top-to-bottom.
class ScenarioFlowRunner {
  final ApiService _apiService = ApiService();

  /// Runs the full 7-step trading scenario for a specific row from the Excel sheet.
  /// Returns a list of log messages to display in the UI.
  Future<List<String>> runScenario(TradingScenario scenario) async {
    List<String> logs = [];
    
    void log(String message) {
      logs.add(message);
      print(message); // Also print to console
    }

    log("\n===============================");
    log("🚀 Starting Scenario: ${scenario.scenarioName}");
    log("===============================\n");

    try {
      final token = scenario.authenticationToken;

      // ===============================
      // Step 1 — Get Balance Before
      // ===============================
      log("--- Step 1: Get Balance Before Order ---");
      final balanceBefore = await _apiService.getBalance(token);
      log("Balance Before: \$${balanceBefore}");

      // ===============================
      // Step 2 — Place Order
      // ===============================
      log("\n--- Step 2: Place Order ---");
      final orderSuccess = await _apiService.placeOrder(scenario);
      if (!orderSuccess) {
        log("❌ Order Not Placed. Stopping scenario.");
        return logs;
      }
      log("✅ Order placed successfully (${scenario.action} ${scenario.qty} ${scenario.symbol})");

      await Future.delayed(const Duration(seconds: 1));

      // ===============================
      // Step 3 — Trade History
      // ===============================
      log("\n--- Step 3: Trade History ---");
      final recentTrades = await _apiService.getRecentTrades(token);
      log("Found ${recentTrades.length} recent trades.");

      // ===============================
      // Step 4 — Get Balance After Order
      // ===============================
      log("\n--- Step 4: Get Balance After Order ---");
      final balanceAfter = await _apiService.getBalance(token);
      log("Balance After: \$${balanceAfter}");

      // ===============================
      // Step 5 — Locked Balance Calculation
      // ===============================
      log("\n--- Step 5: Calculate Order Cost ---");
      final lockedBalance = balanceBefore - balanceAfter;
      log("Locked Balance (Cost): \$${lockedBalance}");

      // ===============================
      // Step 6 — Manual Calculations
      // ===============================
      log("\n--- Step 6: Manual Calculations ---");
      if (recentTrades.isNotEmpty) {
        final trade = recentTrades[0];
        log("Manual Margin: \$${trade['margin']}");
        log("Manual PNL: \$${trade['pnl']}");
      } else {
        log("⚠ No trade history found.");
      }

      // ===============================
      // Step 7 — Close Position (Optional)
      // ===============================
      if (scenario.action == "CLOSE") {
        log("\n--- Step 7: Close Position ---");
        final closed = await _apiService.closePosition(token, "mock_pos_id");
        if (closed) {
          log("✅ Position closed successfully.");
        }
      }

      log("\n✅ Scenario Completed Successfully\n");

    } catch (e) {
      log("❌ Scenario Error: ${e.toString()}");
    }

    return logs;
  }
}
