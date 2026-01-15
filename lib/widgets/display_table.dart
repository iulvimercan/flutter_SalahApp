import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_app/providers/providers.dart';
import 'package:salah_app/utils/responsive_utils.dart';
import 'package:salah_app/widgets/salah_timer.dart';

class DisplayTable extends StatelessWidget {
  final bool isLandscape;

  const DisplayTable({super.key, this.isLandscape = false});

  @override
  Widget build(BuildContext context) {
    return isLandscape
      ? _buildLandscapeLayout(context)
      : _buildPortraitLayout(context);
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Responsive.verticalSpace(130, context),
        const SalahTimer(),
        Responsive.verticalSpace(35, context),
        const Expanded(child: _ScrollableSalahTable()),
        Responsive.verticalSpace(25, context),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Row(
      children: [
        // Timer on the left
        Padding(
          padding: Responsive.only(context: context, left: 16),
          child: const SalahTimer(),
        ),
        Responsive.horizontalSpace(16, context),
        // Table on the right
        Expanded(
          child: Padding(
            padding: Responsive.symmetric(context: context, vertical: 8),
            child: const _ScrollableSalahTable(),
          ),
        ),
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
    var isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    var containerWidth = isLandscape ? 500.0 : 400.0;

    return Container(
      width: Responsive.w(containerWidth, context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Responsive.r(12, context)),
          topRight: Radius.circular(Responsive.r(12, context)),
        ),
        border: Border.fromBorderSide(BorderSide(
          color: borderColor,
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
            color: borderColor,
            width: 2,
          ),
        ),
        children: [
          _TableHeaderRow(context),
          ..._buildDataRows(),
        ],
      ),
    );
  }
}

class _TableHeaderRow extends TableRow {
  _TableHeaderRow(BuildContext context)
      : super(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(251, 219, 132, 0.32),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Responsive.r(12, context)),
              topRight: Radius.circular(Responsive.r(12, context)),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Responsive.symmetric(context: context, vertical: 10, horizontal: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: Responsive.sp(11, context), color: Colors.black87),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;

  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Responsive.symmetric(context: context, vertical: 12, horizontal: 3),
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontSize: Responsive.sp(11, context),
          fontWeight: FontWeight.bold,
          color: Colors.black.withOpacity(0.78),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
