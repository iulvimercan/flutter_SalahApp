import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:salah_app/widgets/salah_timer_ramadan.dart';

import '../model/DailySalah.dart';

class DisplayTable extends StatefulWidget {
  const DisplayTable({super.key});

  @override
  State<DisplayTable> createState() => _DisplayTableState();
}

class _DisplayTableState extends State<DisplayTable> {
  List<TableRow> _tableRows() {
    var dataset = Provider.of<DailySalah>(context).regionSalahTimes;
    var dateTime = DateTime.now();
    var date = dateTime.toString().split(' ')[0];
    var rows = <TableRow>[];

    while (dataset[date] != null && rows.length < 30) {
      rows.add(TableRow(
        decoration: BoxDecoration(
            color: rows.length.isEven
                ? Colors.grey.shade100.withOpacity(0.5)
                : Colors.transparent), // todo ULVI - change color
        children: <Widget>[
          _tableCell(_removeYear(dataset[date]['date']['gregorian'])),
          _tableCell(_removeYear(dataset[date]['date']['hijri'])),
          _tableCell(dataset[date]['data']['fajr']),
          _tableCell(dataset[date]['data']['sunrise']),
          _tableCell(dataset[date]['data']['dhuhr']),
          _tableCell(dataset[date]['data']['asr']),
          _tableCell(dataset[date]['data']['maghrib']),
          _tableCell(dataset[date]['data']['isha']),
        ],
      ));
      dateTime = dateTime.add(const Duration(days: 1));
      date = dateTime.toString().split(' ')[0];
    }
    return rows;
  }

  Widget _tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.black87),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _removeYear(String date) {
    var shortWeekdays = {
      'Pazartesi': 'Pzt',
      'Salı': 'Sal',
      'Çarşamba': 'Çar',
      'Perşembe': 'Per',
      'Cuma': 'Cum',
      'Cumartesi': 'Cmt',
      'Pazar': 'Paz',
    };

    var dateParts = date.split(' ');
    var day = dateParts[0];
    var month = dateParts[1];
    if (dateParts.length == 4) {
      return '$day $month ${shortWeekdays[dateParts[3]]}';
    } else {
      return '$day $month';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 142),
        const SalahTimerRamadan(),
        const SizedBox(height: 42),
        Expanded(
          child: Scrollbar(
            interactive: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    border: Border.fromBorderSide(BorderSide(
                      color: Colors.grey.shade300.withOpacity(0.7),
                      width: 2,
                    )),
                  ),
                  child: Table(
                    columnWidths: const {
                      0: IntrinsicColumnWidth(),
                      1: IntrinsicColumnWidth(),
                      2: IntrinsicColumnWidth(),
                      3: IntrinsicColumnWidth(),
                      4: IntrinsicColumnWidth(),
                      5: IntrinsicColumnWidth(),
                      6: IntrinsicColumnWidth(),
                      7: IntrinsicColumnWidth(),
                    },
                    border: TableBorder(
                      horizontalInside: BorderSide(
                        color: Colors.grey.shade300.withOpacity(0.7),
                        width: 2,
                      ),
                    ), // Only horizontal borders
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(251, 219, 132, 0.32),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                        ),
                        children: [
                          _HeaderCell("Miladi"),
                          _HeaderCell("Hicri"),
                          _HeaderCell("Sabah"),
                          _HeaderCell("Güneş"),
                          _HeaderCell("Öğle"),
                          _HeaderCell("İkindi"),
                          _HeaderCell("Akşam"),
                          _HeaderCell("Yatsı"),
                        ],
                      ),
                      ..._tableRows(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;

  const _HeaderCell(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2.9),
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black.withOpacity(0.78),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
