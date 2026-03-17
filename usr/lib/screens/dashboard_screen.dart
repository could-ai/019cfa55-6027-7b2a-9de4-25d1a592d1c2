import 'package:flutter/material.dart';
import '../models/trading_scenario.dart';
import '../services/scenario_flow.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Load our mock data (representing the Excel sheet rows)
  final List<TradingScenario> _scenarios = TradingScenario.getMockData();
  final ScenarioFlowRunner _runner = ScenarioFlowRunner();
  
  // Store logs for the UI
  List<String> _executionLogs = [];
  bool _isRunning = false;

  Future<void> _runScenario(TradingScenario scenario) async {
    setState(() {
      _isRunning = true;
      _executionLogs = ["Starting ${scenario.scenarioName}..."];
    });

    // Execute the 7-step flow
    final logs = await _runner.runScenario(scenario);

    setState(() {
      _executionLogs = logs;
      _isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trading API Tester'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      body: Row(
        children: [
          // Left Side: List of Scenarios (Excel Rows)
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.grey.shade800)),
              ),
              child: ListView.builder(
                itemCount: _scenarios.length,
                itemBuilder: (context, index) {
                  final scenario = _scenarios[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(scenario.scenarioName),
                      subtitle: Text('${scenario.action} ${scenario.qty} ${scenario.symbol}'),
                      trailing: ElevatedButton(
                        onPressed: _isRunning ? null : () => _runScenario(scenario),
                        child: const Text('Run'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Right Side: Execution Logs Console
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black87,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Execution Console',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(color: Colors.greenAccent),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _executionLogs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            _executionLogs[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'monospace',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (_isRunning)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
