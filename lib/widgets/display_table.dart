import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_app/providers/providers.dart';
import 'package:salah_app/widgets/salah_timer.dart';

class DisplayTable extends StatelessWidget {
  const DisplayTable({super.key});

  static const double _topSpacing = 142.0;
  static const double _timerSpacing = 42.0;
  static const double _bottomSpacing = 32.0;

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: _topSpacing),
        SalahTimer(),
        SizedBox(height: _timerSpacing),
        Expanded(child: _ScrollableSalahTable()),
        SizedBox(height: _bottomSpacing),
      ],
    );
  }
}

class _ScrollableSalahTable extends ConsumerWidget {
  const _ScrollableSalahTable();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scrollbar(
      interactive: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _SalahDataTable(
            dataset: ref.watch(dailySalahProvider).regionSalahTimes,
          ),
        ),
      ),
    );
  }
}

class _SalahDataTable extends StatelessWidget {
  final Map<dynamic, dynamic> dataset;

  const _SalahDataTable({required this.dataset});

  static const int _maxRowCount = 30;
  static const double _borderWidth = 2.0;
  static const double _borderRadius = 12.0;

  static const Map<String, String> _shortWeekdays = {
    'Pazartesi': 'Pzt',
    'Salı': 'Sal',
    'Çarşamba': 'Çar',
    'Perşembe': 'Per',
    'Cuma': 'Cum',
    'Cumartesi': 'Cmt',
    'Pazar': 'Paz',
  };

  String _formatDateToKey(DateTime dateTime) {
    return dateTime.toString().split(' ')[0];
  }

  String _formatDateWithShortWeekday(String date) {
    final dateParts = date.split(' ');
    final day = dateParts[0];
    final month = dateParts[1];

    if (dateParts.length == 4) {
      final shortWeekday = _shortWeekdays[dateParts[3]] ?? dateParts[3];
      return '$day $month $shortWeekday';
    }
    return '$day $month';
  }

  List<TableRow> _buildDataRows() {
    var currentDate = DateTime.now();
    var dateKey = _formatDateToKey(currentDate);
    final rows = <TableRow>[];

    while (dataset[dateKey] != null && rows.length < _maxRowCount) {
      final dayData = dataset[dateKey];
      final isEvenRow = rows.length.isEven;

      rows.add(TableRow(
        decoration: BoxDecoration(
          color: isEvenRow
              ? Colors.grey.shade100.withOpacity(0.5)
              : Colors.transparent,
        ),
        children: <Widget>[
          _DataCell(_formatDateWithShortWeekday(dayData['date']['gregorian'])),
          _DataCell(_formatDateWithShortWeekday(dayData['date']['hijri'])),
          _DataCell(dayData['data']['fajr']),
          _DataCell(dayData['data']['sunrise']),
          _DataCell(dayData['data']['dhuhr']),
          _DataCell(dayData['data']['asr']),
          _DataCell(dayData['data']['maghrib']),
          _DataCell(dayData['data']['isha']),
        ],
      ));

      currentDate = currentDate.add(const Duration(days: 1));
      dateKey = _formatDateToKey(currentDate);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.grey.shade300.withOpacity(0.7);

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(_borderRadius),
          topRight: Radius.circular(_borderRadius),
        ),
        border: Border.fromBorderSide(BorderSide(
          color: borderColor,
          width: _borderWidth,
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
            color: borderColor,
            width: _borderWidth,
          ),
        ),
        children: [
          const _TableHeaderRow(),
          ..._buildDataRows(),
        ],
      ),
    );
  }
}

class _TableHeaderRow extends TableRow {
  const _TableHeaderRow()
      : super(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(251, 219, 132, 0.32),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          children: const [
            _HeaderCell('Miladi'),
            _HeaderCell('Hicri'),
            _HeaderCell('Sabah'),
            _HeaderCell('Güneş'),
            _HeaderCell('Öğle'),
            _HeaderCell('İkindi'),
            _HeaderCell('Akşam'),
            _HeaderCell('Yatsı'),
          ],
        );
}

class _DataCell extends StatelessWidget {
  final String text;

  const _DataCell(this.text);

  static const EdgeInsets _padding =
      EdgeInsets.symmetric(vertical: 10, horizontal: 4);
  static const TextStyle _textStyle =
      TextStyle(fontSize: 12, color: Colors.black87);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Text(
        text,
        style: _textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;

  const _HeaderCell(this.text);

  static const EdgeInsets _padding =
      EdgeInsets.symmetric(vertical: 12, horizontal: 2.9);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
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
