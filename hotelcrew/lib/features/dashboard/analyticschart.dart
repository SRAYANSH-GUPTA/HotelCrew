import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/packages.dart';

class BarChartWidget extends StatelessWidget {
  final List<int> barChartData;
  final List<Map<String, dynamic>> dailyData;

  const BarChartWidget({
    super.key,
    required this.barChartData,
    required this.dailyData,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 50,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final data = dailyData[group.x.toInt()];
                final date = DateFormat('dd/MM').format(data['date']);
                String status = rodIndex == 0 ? 'Present' : 
                              rodIndex == 1 ? 'Absent' : 'Leave';
                return BarTooltipItem(
                  '$status: ${rod.toY.toInt()}\n$date',
                  GoogleFonts.montserrat(
                    color: Pallete.neutral900,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= dailyData.length) {
                    return const Text('');
                  }
                  final date = dailyData[value.toInt()]['date'];
                  return Text(
                    DateFormat('dd/MM').format(date),
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: dailyData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: data['present'].toDouble(),
                  color: Pallete.success400,
                  width: 16,
                ),
                BarChartRodData(
                  toY: data['absent'].toDouble(),
                  color: Pallete.error400,
                  width: 16,
                ),
                BarChartRodData(
                  toY: data['leave'].toDouble(),
                  color: Pallete.warning400,
                  width: 16,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}