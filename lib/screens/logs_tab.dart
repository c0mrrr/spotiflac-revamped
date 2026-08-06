import 'dart:ui' as dart_ui;
import 'package:flutter/material.dart';
import 'package:spotiflac_android/widgets/frosted_glass_background.dart';
import 'package:spotiflac_android/utils/logger.dart';
import 'package:spotiflac_android/l10n/l10n.dart';

class LogsTab extends StatefulWidget {
  const LogsTab({super.key});

  @override
  State<LogsTab> createState() => _LogsTabState();
}

class _LogsTabState extends State<LogsTab> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    LogBuffer.loggingEnabled = true;
    LogBuffer().addListener(_scrollToBottom);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    LogBuffer().removeListener(_scrollToBottom);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  Color _getColorForLevel(String level, ColorScheme colorScheme) {
    switch (level) {
      case 'ERROR':
      case 'FATAL':
        return colorScheme.error;
      case 'WARN':
        return Colors.orange;
      case 'DEBUG':
        return Colors.grey;
      case 'INFO':
      default:
        return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
flexibleSpace: const FrostedGlassBackground(),
backgroundColor: Colors.transparent,
elevation: 0,

        title: Text(l10n.navLogs),
        scrolledUnderElevation: 0,
      ),
      body: Container(
        color: colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.all(8.0),
        child: AnimatedBuilder(
          animation: LogBuffer(),
          builder: (context, _) {
            final entries = LogBuffer().entries;
            return ListView.builder(
              controller: _scrollController,
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12.0,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      children: [
                        TextSpan(
                          text: '[${entry.formattedTime}] ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: '[${entry.level}] ',
                          style: TextStyle(
                            color: _getColorForLevel(entry.level, colorScheme),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '[${entry.tag}] ',
                          style: TextStyle(color: colorScheme.tertiary),
                        ),
                        TextSpan(text: entry.message),
                        if (entry.error != null) ...[
                          TextSpan(text: ' | '),
                          TextSpan(
                            text: entry.error,
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
