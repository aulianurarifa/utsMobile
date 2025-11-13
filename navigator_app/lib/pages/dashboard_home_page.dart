import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DashboardHomePage extends StatefulWidget {
  const DashboardHomePage({super.key});

  @override
  State<DashboardHomePage> createState() => _DashboardHomePageState();
}

const List<String> _prayerOrder = <String>[
  'imsak',
  'subuh',
  'terbit',
  'dhuha',
  'dzuhur',
  'ashar',
  'maghrib',
  'isya',
];

const Map<String, String> _prayerLabels = <String, String>{
  'imsak': 'Imsak',
  'subuh': 'Subuh',
  'terbit': 'Terbit',
  'dhuha': 'Dhuha',
  'dzuhur': 'Dzuhur',
  'ashar': 'Ashar',
  'maghrib': 'Maghrib',
  'isya': 'Isya',
};

class _DashboardHomePageState extends State<DashboardHomePage> {
  final TextEditingController _todoController = TextEditingController();
  final List<_TodoItem> _todos = <_TodoItem>[
    const _TodoItem(text: 'Stretch dan minum air hangat'),
    const _TodoItem(text: 'Baca 10 halaman buku'),
    const _TodoItem(text: 'Jurnal rasa syukur hari ini'),
  ];

  final int _locationId = 1219; // Bandung
  DateTime _currentDateTime = DateTime.now();
  Timer? _clockTimer;
  PrayerSchedule? _prayerSchedule;
  bool _isLoadingPrayer = false;
  String? _prayerError;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID').then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    _startClock();
    _fetchPrayerSchedule();
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _todoController.dispose();
    super.dispose();
  }

  void _startClock() {
    _clockTimer?.cancel();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _currentDateTime = DateTime.now();
      });
    });
  }

  Future<void> _fetchPrayerSchedule() async {
    setState(() {
      _isLoadingPrayer = true;
      _prayerError = null;
    });

    try {
      final DateTime now = DateTime.now();
      final String year = now.year.toString();
      final String month = now.month.toString().padLeft(2, '0');
      final String day = now.day.toString().padLeft(2, '0');

      final Uri url = Uri.parse(
        'https://api.myquran.com/v2/sholat/jadwal/$_locationId/$year/$month/$day',
      );
      final http.Response response = await http.get(url);

      if (response.statusCode != 200) {
        throw HttpException(
          'Gagal mengambil jadwal sholat (status ${response.statusCode}).',
        );
      }

      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>? ??
          <String, dynamic>{};
      final Map<String, dynamic> result =
          data['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
      final PrayerSchedule schedule = PrayerSchedule.fromJson(result);

      setState(() {
        _prayerSchedule = schedule;
        _isLoadingPrayer = false;
        _prayerError = null;
      });
    } catch (_) {
      setState(() {
        _isLoadingPrayer = false;
        _prayerError = 'Ups, jadwal belum bisa diambil. Coba lagi ya \u2661';
      });
    }
  }

  void _addTodo() {
    final String text = _todoController.text.trim();
    if (text.isEmpty) {
      return;
    }
    setState(() {
      _todos.insert(0, _TodoItem(text: text));
    });
    _todoController.clear();
  }

  void _toggleTodoStatus(int index) {
    setState(() {
      final _TodoItem item = _todos[index];
      _todos[index] = item.copyWith(isDone: !item.isDone);
    });
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  String get _greeting {
    final int hour = _currentDateTime.hour;
    if (hour < 12) {
      return 'Selamat pagi';
    } else if (hour < 15) {
      return 'Selamat siang';
    } else if (hour < 19) {
      return 'Selamat sore';
    }
    return 'Selamat malam';
  }

  String get _formattedDate =>
      DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_currentDateTime);

  String get _formattedTime =>
      DateFormat('HH:mm:ss', 'id_ID').format(_currentDateTime);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFFFCEAFF),
              Color(0xFFF9F6FF),
              Color(0xFFFFEFFE),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(
                painter: _PixelGridPainter(
                  color: Colors.grey.withValues(alpha: 0.12),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: _DashboardHeader(
                          greeting: _greeting,
                          formattedDate: _formattedDate,
                          formattedTime: _formattedTime,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            _PrayerSummaryCard(
                              isLoading: _isLoadingPrayer,
                              schedule: _prayerSchedule,
                              currentDateTime: _currentDateTime,
                              errorMessage: _prayerError,
                              onRetry: _fetchPrayerSchedule,
                            ),
                            const _StickerBadge(
                              asset: 'assets/images/stiker3.png',
                              top: -14,
                              right: 4,
                              width: 68,
                              opacity: 0.42,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.78,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          _TodoCanvasCard(
                            todos: _todos,
                            controller: _todoController,
                            onAdd: _addTodo,
                            onToggle: _toggleTodoStatus,
                            onRemove: _removeTodo,
                          ),
                          const _StickerBadge(
                            asset: 'assets/images/stiker1.png',
                            top: -26,
                            right: -6,
                            width: 92,
                            opacity: 0.40,
                          ),
                          const _StickerBadge(
                            asset: 'assets/images/stiker2.png',
                            bottom: -34,
                            left: 6,
                            width: 124,
                            opacity: 0.40,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.greeting,
    required this.formattedDate,
    required this.formattedTime,
  });

  final String greeting;
  final String formattedDate;
  final String formattedTime;

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = GoogleFonts.fredoka(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF574374),
      letterSpacing: 0.4,
    );
    final TextStyle dateStyle = GoogleFonts.vt323(
      fontSize: 16,
      color: const Color(0xFF756FA0),
      letterSpacing: 1.1,
    );
    final TextStyle timeStyle = GoogleFonts.vt323(
      fontSize: 20,
      color: const Color(0xFF2F2640),
      letterSpacing: 2,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFB9B4D8), width: 1.6),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF8A83C2).withValues(alpha: 0.22),
            blurRadius: 28,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$greeting \u2661', style: titleStyle),
          const SizedBox(height: 6),
          Text(formattedDate, style: dateStyle),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE4E0FA),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF615B92), width: 1.3),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Icon(
                  Icons.access_time_filled,
                  size: 20,
                  color: Color(0xFF5A4D9B),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    formattedTime,
                    style: timeStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerSummaryCard extends StatelessWidget {
  const _PrayerSummaryCard({
    required this.isLoading,
    required this.schedule,
    required this.currentDateTime,
    required this.errorMessage,
    required this.onRetry,
  });

  final bool isLoading;
  final PrayerSchedule? schedule;
  final DateTime currentDateTime;
  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = GoogleFonts.fredoka(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF4E4D88),
    );
    final TextStyle subtitleStyle = GoogleFonts.vt323(
      fontSize: 14,
      letterSpacing: 1.1,
      color: const Color(0xFF5F6AAE),
    );
    final TextStyle nextStyle = GoogleFonts.vt323(
      fontSize: 20,
      letterSpacing: 1.4,
      color: const Color(0xFF2F2640),
    );

    final MapEntry<String, String>? nextPrayer = _findNextPrayer(schedule);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFFFFD8F1), Color(0xFFAED7FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFF9BA7E0), width: 1.3),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF6B7FCF).withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF9BA7E0),
                    width: 1.2,
                  ),
                ),
                child: const Icon(
                  Icons.nightlight_round,
                  color: Color(0xFFFE7FB8),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Jadwal sholat', style: titleStyle),
                    const SizedBox(height: 4),
                    Text(
                      schedule?.prettyLocation ?? 'Bandung dan sekitarnya',
                      style: subtitleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isLoading)
            const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF6FA6F9),
                ),
              ),
            )
          else if (errorMessage != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  errorMessage!,
                  style: GoogleFonts.fredoka(
                    fontSize: 13,
                    color: const Color(0xFF5663A2),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onRetry,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    foregroundColor: const Color(0xFFFF5186),
                    textStyle: GoogleFonts.vt323(fontSize: 16),
                  ),
                  child: const Text('Coba lagi'),
                ),
              ],
            )
          else if (schedule != null && nextPrayer != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Sholat berikutnya',
                        style: GoogleFonts.fredoka(
                          fontSize: 14,
                          color: const Color(0xFF5663A2),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${nextPrayer.key} • ${nextPrayer.value}',
                        style: nextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: onRetry,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    foregroundColor: const Color(0xFF4E4D88),
                    textStyle: GoogleFonts.vt323(fontSize: 16),
                    backgroundColor: Colors.white.withValues(alpha: 0.7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Segarkan'),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Ketuk untuk memuat jadwal sholat hari ini ya \u2661',
                  style: GoogleFonts.fredoka(
                    fontSize: 13,
                    color: const Color(0xFF5663A2),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onRetry,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    foregroundColor: const Color(0xFF4E4D88),
                    textStyle: GoogleFonts.vt323(fontSize: 16),
                    backgroundColor: Colors.white.withValues(alpha: 0.7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Muat jadwal'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  MapEntry<String, String>? _findNextPrayer(PrayerSchedule? schedule) {
    if (schedule == null) {
      return null;
    }

    DateTime? fallbackTime;
    String? fallbackLabel;

    for (final String key in _prayerOrder) {
      final String? timeValue = schedule.times[key];
      if (timeValue == null) {
        continue;
      }
      final DateTime? prayerTime = _parsePrayerTime(timeValue);
      if (prayerTime == null) {
        continue;
      }
      fallbackTime ??= prayerTime;
      fallbackLabel ??= _prayerLabels[key] ?? key;
      if (!prayerTime.isBefore(currentDateTime)) {
        final String label = _prayerLabels[key] ?? key;
        return MapEntry(label, timeValue);
      }
    }

    if (fallbackTime != null && fallbackLabel != null) {
      return MapEntry(fallbackLabel, DateFormat('HH:mm').format(fallbackTime));
    }

    return null;
  }

  DateTime? _parsePrayerTime(String value) {
    final List<String> parts = value.split(':');
    if (parts.length < 2) {
      return null;
    }
    final int? hour = int.tryParse(parts[0]);
    final int? minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }
    return DateTime(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
      hour,
      minute,
    );
  }
}

class _TodoCanvasCard extends StatelessWidget {
  const _TodoCanvasCard({
    required this.todos,
    required this.controller,
    required this.onAdd,
    required this.onToggle,
    required this.onRemove,
  });

  final List<_TodoItem> todos;
  final TextEditingController controller;
  final VoidCallback onAdd;
  final ValueChanged<int> onToggle;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final TextStyle todoTextStyle = GoogleFonts.vt323(
      fontSize: 22,
      height: 1.1,
      letterSpacing: 0.6,
      color: const Color(0xFF3A3251),
    );
    final TextStyle emptyTextStyle = GoogleFonts.fredoka(
      fontSize: 14,
      color: const Color(0xFF6B688F),
    );

    return AspectRatio(
      aspectRatio: 0.72,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF8A83C2).withValues(alpha: 0.2),
              blurRadius: 30,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: <Color>[Color(0xFFFFF6FF), Color(0xFFE5F0FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
              Positioned(
                top: 36,
                left: 40,
                right: 40,
                child: Text(
                  'TO-DO LIST',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.vt323(
                    fontSize: 30,
                    letterSpacing: 2,
                    color: const Color(0xFF2F2640),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(44, 124, 46, 150),
                  child: ScrollConfiguration(
                    behavior: const _NoGlowScrollBehavior(),
                    child: todos.isEmpty
                        ? Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Belum ada tugas manis. Yuk tulis satu!',
                              style: emptyTextStyle,
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            itemCount: todos.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (BuildContext context, int index) {
                              final _TodoItem todo = todos[index];
                              return _PixelTodoTile(
                                text: todo.text,
                                isDone: todo.isDone,
                                onToggle: () => onToggle(index),
                                onRemove: () => onRemove(index),
                                textStyle: todoTextStyle,
                              );
                            },
                          ),
                  ),
                ),
              ),
              Positioned(
                left: 34,
                right: 144,
                bottom: 58,
                child: _PixelTextField(controller: controller, onSubmit: onAdd),
              ),
              Positioned(
                right: 52,
                bottom: 54,
                child: _PixelAddButton(onPressed: onAdd),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoGlowScrollBehavior extends ScrollBehavior {
  const _NoGlowScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

class _PixelTodoTile extends StatelessWidget {
  const _PixelTodoTile({
    required this.text,
    required this.isDone,
    required this.onToggle,
    required this.onRemove,
    required this.textStyle,
  });

  final String text;
  final bool isDone;
  final VoidCallback onToggle;
  final VoidCallback onRemove;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final TextStyle effectiveStyle = textStyle.copyWith(
      decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
      color: isDone ? const Color(0xFF8A86B0) : textStyle.color,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDone
            ? const Color(0xFFE9E6FF).withValues(alpha: 0.92)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDone ? const Color(0xFFBAB5EA) : const Color(0xFFD7D3EC),
          width: 1.2,
        ),
      ),
      child: Row(
        children: <Widget>[
          _PixelCheckbox(isChecked: isDone, onTap: onToggle),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: effectiveStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          _PixelDeleteButton(onPressed: onRemove),
        ],
      ),
    );
  }
}

class _PixelCheckbox extends StatelessWidget {
  const _PixelCheckbox({required this.isChecked, required this.onTap});

  final bool isChecked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: isChecked ? const Color(0xFF8FD7FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF2C243A), width: 2),
        ),
        child: isChecked
            ? const Icon(
                Icons.check_rounded,
                size: 18,
                color: Color(0xFF243141),
              )
            : null,
      ),
    );
  }
}

class _PixelDeleteButton extends StatelessWidget {
  const _PixelDeleteButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE4EB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFFF83A7), width: 1.2),
        ),
        child: const Icon(
          Icons.close_rounded,
          size: 16,
          color: Color(0xFFD94A6F),
        ),
      ),
    );
  }
}

class _PixelTextField extends StatelessWidget {
  const _PixelTextField({required this.controller, required this.onSubmit});

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final TextStyle fieldStyle = GoogleFonts.vt323(
      fontSize: 18,
      color: const Color(0xFF3A3251),
    );

    return TextField(
      controller: controller,
      style: fieldStyle,
      decoration: InputDecoration(
        hintText: 'tulis agenda baru...',
        hintStyle: GoogleFonts.vt323(
          fontSize: 18,
          color: const Color(0xFF9895BB),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: _pixelBorder(const Color(0xFFD1CCE6)),
        enabledBorder: _pixelBorder(const Color(0xFFD1CCE6)),
        focusedBorder: _pixelBorder(const Color(0xFF8F8BD9)),
      ),
      onSubmitted: (_) => onSubmit(),
    );
  }

  OutlineInputBorder _pixelBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: 1.3),
    );
  }
}

class _PixelAddButton extends StatelessWidget {
  const _PixelAddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[Color(0xFF8EDBFF), Color(0xFFFF9FD3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF5E73D4), width: 1.4),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF5E73D4).withValues(alpha: 0.3),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
      ),
    );
  }
}

class _StickerBadge extends StatelessWidget {
  const _StickerBadge({
    required this.asset,
    this.top,
    this.left,
    this.right,
    this.bottom,
    this.width,
    this.opacity = 1.0,
  });

  final String asset;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double? width;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: IgnorePointer(
        ignoring: true,
        child: Opacity(
          opacity: opacity,
          child: Image.asset(asset, width: width),
        ),
      ),
    );
  }
}

class _PixelGridPainter extends CustomPainter {
  const _PixelGridPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const double cell = 20;
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    for (double x = 0; x <= size.width; x += cell) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += cell) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PixelGridPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _TodoItem {
  const _TodoItem({required this.text, this.isDone = false});

  final String text;
  final bool isDone;

  _TodoItem copyWith({String? text, bool? isDone}) {
    return _TodoItem(text: text ?? this.text, isDone: isDone ?? this.isDone);
  }
}

class PrayerSchedule {
  const PrayerSchedule({
    required this.location,
    required this.region,
    required this.dateLabel,
    required this.times,
  });

  final String location;
  final String region;
  final String dateLabel;
  final Map<String, String> times;

  String get prettyLocation =>
      region.isEmpty ? location : '$location \u00B7 $region';
  String get prettyDate => dateLabel;

  factory PrayerSchedule.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> scheduleJson =
        (json['jadwal'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final String dateLabel =
        scheduleJson['tanggal']?.toString() ??
        scheduleJson['date']?.toString() ??
        '';
    final Map<String, String> times = <String, String>{};
    for (final MapEntry<String, dynamic> entry in scheduleJson.entries) {
      final String key = entry.key;
      if (key == 'tanggal' || key == 'date') {
        continue;
      }
      times[key] = entry.value.toString();
    }

    return PrayerSchedule(
      location: _beautifyLabel(json['lokasi']?.toString() ?? 'Lokasi'),
      region: _beautifyLabel(json['daerah']?.toString() ?? ''),
      dateLabel: _formatDateLabel(dateLabel),
      times: times,
    );
  }

  static String _beautifyLabel(String raw) {
    if (raw.isEmpty) {
      return raw;
    }
    final Iterable<String> words = raw
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((String word) => word.isNotEmpty)
        .map((String word) {
          final String first = word[0].toUpperCase();
          return word.length == 1 ? first : '$first${word.substring(1)}';
        });
    return words.join(' ');
  }

  static String _formatDateLabel(String raw) {
    if (raw.isEmpty || !raw.contains(',')) {
      return raw;
    }
    final List<String> parts = raw.split(',');
    if (parts.length < 2) {
      return raw;
    }
    final String dayName = parts[0].trim();
    final List<String> dateParts = parts[1].trim().split('/');
    if (dateParts.length != 3) {
      return raw;
    }
    final int day = int.tryParse(dateParts[0]) ?? 0;
    final int month = int.tryParse(dateParts[1]) ?? 0;
    final int year = int.tryParse(dateParts[2]) ?? 0;
    if (day <= 0 || month <= 0) {
      return raw;
    }

    const List<String> monthNames = <String>[
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    final String monthName = month >= 1 && month <= monthNames.length
        ? monthNames[month - 1]
        : '';
    if (monthName.isEmpty) {
      return raw;
    }

    return '$dayName, $day $monthName $year';
  }
}

class HttpException implements Exception {
  const HttpException(this.message);
  final String message;

  @override
  String toString() => message;
}
