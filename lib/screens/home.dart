import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_app/providers/providers.dart';
import 'package:salah_app/widgets/current_info.dart';

import '../widgets/display_daily.dart';
import '../widgets/display_table.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  var _displayType = 'daily';

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: isLandscape ? Alignment.topCenter : Alignment.topLeft,
            end: isLandscape ? Alignment.bottomCenter : Alignment.bottomRight,
            colors: const [
              Color.fromARGB(255, 255, 254, 233),
              Color.fromARGB(255, 253, 252, 227),
              Color.fromARGB(255, 237, 213, 255),
            ],
          ),
        ),
        child: SafeArea(
          child: isLandscape
              ? _buildLandscapeLayout()
              : _buildPortraitLayout(),
        ),
      ),
      floatingActionButton: _buildFloatingButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildPortraitLayout() {
    return Stack(
      children: [
        const Positioned(left: 0, right: 0, child: CurrentInfo()),
        Positioned.fill(
          child: _displayType == 'daily'
              ? const DisplayDaily()
              : const DisplayTable(),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      children: [
        // Left side - Current Info
        const SizedBox(
          width: 200,
          child: CurrentInfo(isLandscape: true),
        ),
        // Right side - Main content
        Expanded(
          child: _displayType == 'daily'
              ? const DisplayDaily(isLandscape: true)
              : const DisplayTable(isLandscape: true),
        ),
      ],
    );
  }

  Widget _buildFloatingButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _IftarToggleButton(),
        const SizedBox(width: 12),
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _displayType = _displayType == 'daily' ? 'table' : 'daily';
            });
          },
          child: _displayType == 'daily'
              ? const Icon(Icons.calendar_month)
              : const Icon(Icons.looks_one_outlined),
        ),
      ],
    );
  }
}

class _IftarToggleButton extends ConsumerWidget {
  const _IftarToggleButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showIftar = ref.watch(showIftarProvider);

    return FloatingActionButton(
      onPressed: ref.read(showIftarProvider.notifier).toggle,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.restaurant),
          if (showIftar)
            Transform.rotate(
              angle: 0.785398, // 45 degrees in radians
              child: Container(
                width: 32,
                height: 3,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

