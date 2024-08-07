import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../backend.dart';

class StockHistory extends StatelessWidget {
  final ApiResponse? user;

  const StockHistory({
    this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (user == null || user!.stockPriceHistory.isEmpty) {
      return Center(child: Text('No stock price history available'));
    }

    final events = user!.stockPriceHistory
      ..sort((a, b) => a.actualDate.compareTo(b.actualDate));

    final DateTime firstDate = events.first.actualDate;
    final List<FlSpot> spots = events
        .map(
          (e) => FlSpot(
            e.actualDate.difference(firstDate).inDays.toDouble(),
            e.price,
          ),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 40.0),
      child: Column(
        children: [
          Text(
            'Stock Price History',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.5),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.5),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final DateTime date =
                            firstDate.add(Duration(days: value.toInt()));
                        final event = events.firstWhere(
                            (event) => event.actualDate == date,
                            orElse: () => StockPriceHistory(
                                id: 0,
                                title: '',
                                price: 0,
                                displayDate: date,
                                actualDate: date));
                        return Text(event.title.isNotEmpty
                            ? DateFormat('MMM dd yyyy')
                                .format(event.displayDate)
                            : '');
                      },
                      interval: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: true),
                minX: 0,
                maxX: spots.last.x,
                minY: 0,
                maxY:
                    events.map((e) => e.price).reduce((a, b) => a > b ? a : b),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.orange,
                          strokeWidth: 2,
                          strokeColor: Colors.deepOrange,
                        );
                      },
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    // tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((touchedSpot) {
                        final event = events[touchedSpot.spotIndex];
                        return LineTooltipItem(
                          '${event.title}\n${DateFormat('MMM dd yyyy').format(event.displayDate)}\n\$${event.price.toStringAsFixed(2)}',
                          const TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
