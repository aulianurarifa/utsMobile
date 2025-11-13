import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class CuacaPage extends StatefulWidget {
  const CuacaPage({super.key});

  @override
  State<CuacaPage> createState() => _CuacaPageState();
}

class _CuacaPageState extends State<CuacaPage>
    with SingleTickerProviderStateMixin {
  static const String _endpoint =
      'https://api.openweathermap.org/data/2.5/weather?q=Bandung&appid=19c806b17f93a3534665336f8a636ac4&units=metric';

  WeatherData? _weather;
  bool _isLoading = true;
  String? _errorMessage;
  late final AnimationController _cloudController;

  @override
  void initState() {
    super.initState();
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat(reverse: true);
    initializeDateFormatting('id_ID', null);
    _fetchWeather();
  }

  @override
  void dispose() {
    _cloudController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final http.Response response = await http.get(Uri.parse(_endpoint));
      if (response.statusCode != 200) {
        throw const HttpException(
          'Gagal memuat cuaca Bandung. Coba lagi sebentar ya.',
        );
      }

      final Map<String, dynamic> body =
          json.decode(response.body) as Map<String, dynamic>;
      final WeatherData data = WeatherData.fromJson(body);

      if (!mounted) {
        return;
      }

      setState(() {
        _weather = data;
        _isLoading = false;
      });
    } on HttpException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = error.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'Cuaca lagi malu-malu muncul. Yuk coba refresh.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final WeatherPalette palette = _paletteFor(_weather);

    return Scaffold(
      backgroundColor: palette.background.first,
      appBar: AppBar(
        backgroundColor: palette.appBar,
        elevation: 0,
        foregroundColor: palette.accent,
        title: Text(
          'Cuaca 🎀',
          style: GoogleFonts.audiowide(
            fontWeight: FontWeight.w700,
            fontSize: 26,
            letterSpacing: 0.8,
          ),
        ),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchWeather),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: palette.background,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            color: palette.accent,
            onRefresh: _fetchWeather,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(22, 26, 22, 32),
              child: _buildBody(palette),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(WeatherPalette palette) {
    if (_isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(color: palette.accent),
            const SizedBox(height: 18),
            const Text(
              'Sedang menyapu awan cantik 🎀',
              style: TextStyle(color: Color(0xFF5F5FA8)),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.cloud_off_rounded, color: palette.accent, size: 54),
            const SizedBox(height: 14),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Color(0xFF5F5FA8)),
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _fetchWeather,
              style: FilledButton.styleFrom(
                backgroundColor: palette.accent.withValues(alpha: 0.18),
                foregroundColor: palette.accent,
              ),
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      );
    }

    final WeatherData data = _weather!;
    final DateFormat dateFormat = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    final String dateLabel = dateFormat.format(DateTime.now());
    final String updatedLabel = DateFormat(
      'HH:mm',
      'id_ID',
    ).format(DateTime.fromMillisecondsSinceEpoch(data.updatedAt * 1000));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.location_on_rounded, color: palette.accent, size: 26),
            const SizedBox(width: 8),
            Text(
              data.city,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: palette.title,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          dateLabel,
          style: const TextStyle(fontSize: 15, color: Color(0xFF5F5FA8)),
        ),
        const SizedBox(height: 4),
        Text(
          'Diperbarui $updatedLabel WIB',
          style: const TextStyle(fontSize: 13, color: Color(0xFF7B8FD6)),
        ),
        const SizedBox(height: 30),
        _AnimatedWeatherOrb(controller: _cloudController, asset: palette.asset),
        const SizedBox(height: 22),
        Text(
          data.description,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
            color: palette.title,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              data.temperature.toStringAsFixed(0),
              style: TextStyle(
                fontSize: 86,
                fontWeight: FontWeight.w700,
                color: palette.temperature,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '°C',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: palette.temperature,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _WeatherDetailCard(palette: palette, data: data),
        const SizedBox(height: 22),
        _SecondaryDetailCard(palette: palette, data: data),
      ],
    );
  }

  WeatherPalette _paletteFor(WeatherData? data) {
    if (data == null) {
      return const WeatherPalette(
        background: <Color>[Color(0xFFFFEAF5), Color(0xFFAED7FF)],
        appBar: Color(0xFFFFEAF5),
        accent: Color(0xFFFF78B5),
        title: Color(0xFF5F5FA8),
        temperature: Color(0xFFFF78B5),
        asset: 'assets/images/berawan.gif',
      );
    }

    switch (data.condition.toLowerCase()) {
      case 'rain':
      case 'drizzle':
        return const WeatherPalette(
          background: <Color>[Color(0xFFBFDFFF), Color(0xFFD8ECFF)],
          appBar: Color(0xFFBFDFFF),
          accent: Color(0xFF4D6CB3),
          title: Color(0xFF2F4C82),
          temperature: Color(0xFFFF78B5),
          asset: 'assets/images/hujan.gif',
        );
      case 'thunderstorm':
        return const WeatherPalette(
          background: <Color>[Color(0xFF6AA1FF), Color(0xFF3C7CFF)],
          appBar: Color(0xFF6AA1FF),
          accent: Color(0xFFFFD6EA),
          title: Color(0xFFECEBFF),
          temperature: Color(0xFFFFE6F4),
          asset: 'assets/images/petir.gif',
        );
      case 'clear':
        return const WeatherPalette(
          background: <Color>[Color(0xFFFFB8D7), Color(0xFFFFD4E8)],
          appBar: Color(0xFFFFB8D7),
          accent: Color(0xFFFF6FAE),
          title: Color(0xFFDA5B9C),
          temperature: Color(0xFFFF6FAE),
          asset: 'assets/images/cerah.gif',
        );
      case 'clouds':
        return const WeatherPalette(
          background: <Color>[Color(0xFFFFC4DD), Color(0xFFFFDEEC)],
          appBar: Color(0xFFFFC4DD),
          accent: Color(0xFF5F5FA8),
          title: Color(0xFF5F5FA8),
          temperature: Color(0xFF5F5FA8),
          asset: 'assets/images/berawan.gif',
        );
      case 'snow':
        return const WeatherPalette(
          background: <Color>[Color(0xFFEAF6FF), Color(0xFFFFEAF5)],
          appBar: Color(0xFFEAF6FF),
          accent: Color(0xFF6F8CCF),
          title: Color(0xFF4B66A3),
          temperature: Color(0xFF5F5FA8),
          asset: 'assets/images/berawan.gif',
        );
      default:
        return const WeatherPalette(
          background: <Color>[Color(0xFFFFEAF5), Color(0xFFAED7FF)],
          appBar: Color(0xFFFFEAF5),
          accent: Color(0xFFFF78B5),
          title: Color(0xFF5F5FA8),
          temperature: Color(0xFFFF78B5),
          asset: 'assets/images/berawan.gif',
        );
    }
  }
}

class _AnimatedWeatherOrb extends StatelessWidget {
  const _AnimatedWeatherOrb({required this.controller, required this.asset});

  final AnimationController controller;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          final double offset = (controller.value - 0.5) * 32;
          final double scale = 0.95 + (controller.value * 0.1);
          return Transform.translate(
            offset: Offset(offset, 0),
            child: Transform.scale(scale: scale, child: child),
          );
        },
        child: Image.asset(asset, fit: BoxFit.contain),
      ),
    );
  }
}

class _WeatherDetailCard extends StatelessWidget {
  const _WeatherDetailCard({required this.palette, required this.data});

  final WeatherPalette palette;
  final WeatherData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.accent.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              _MetricChip(
                icon: Icons.thermostat,
                label: 'Terasa',
                value: '${data.feelsLike.toStringAsFixed(1)}°C',
                color: palette.accent,
              ),
              _MetricChip(
                icon: Icons.cloud_outlined,
                label: 'Awan',
                value: '${data.cloudiness}%',
                color: palette.accent,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _DetailRow(
            icon: Icons.water_drop_rounded,
            label: 'Kelembapan',
            value: '${data.humidity}%',
          ),
          const Divider(height: 24, color: Color(0xFFFFC5E3)),
          _DetailRow(
            icon: Icons.air_rounded,
            label: 'Angin',
            value:
                '${data.windSpeedKmH.toStringAsFixed(1)} km/j • ${data.windDirection}',
          ),
          const Divider(height: 24, color: Color(0xFFFFC5E3)),
          _DetailRow(
            icon: Icons.speed_rounded,
            label: 'Tekanan',
            value: '${data.pressure} hPa',
          ),
          const Divider(height: 24, color: Color(0xFFFFC5E3)),
          _DetailRow(
            icon: Icons.visibility_rounded,
            label: 'Visibilitas',
            value: '${data.visibilityKm.toStringAsFixed(1)} km',
          ),
        ],
      ),
    );
  }
}

class _SecondaryDetailCard extends StatelessWidget {
  const _SecondaryDetailCard({required this.palette, required this.data});

  final WeatherPalette palette;
  final WeatherData data;

  @override
  Widget build(BuildContext context) {
    final DateFormat timeFormat = DateFormat('HH:mm', 'id_ID');
    final String sunrise = timeFormat.format(
      DateTime.fromMillisecondsSinceEpoch(data.sunrise * 1000),
    );
    final String sunset = timeFormat.format(
      DateTime.fromMillisecondsSinceEpoch(data.sunset * 1000),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Sunrise',
                  style: TextStyle(fontSize: 13, color: Color(0xFF7B8FD6)),
                ),
                const SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    Icon(Icons.wb_twilight, color: palette.accent, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '$sunrise WIB',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5F5FA8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Sunset',
                  style: TextStyle(fontSize: 13, color: Color(0xFF7B8FD6)),
                ),
                const SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.nightlight_round,
                      color: palette.accent,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$sunset WIB',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5F5FA8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 13, color: color)),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(icon, color: const Color(0xFF6F8CCF), size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5F5FA8),
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFF78B5),
          ),
        ),
      ],
    );
  }
}

class WeatherData {
  const WeatherData({
    required this.city,
    required this.condition,
    required this.description,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.visibility,
    required this.windSpeed,
    required this.windDegree,
    required this.cloudiness,
    required this.sunrise,
    required this.sunset,
    required this.updatedAt,
  });

  final String city;
  final String condition;
  final String description;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final int pressure;
  final int visibility;
  final double windSpeed;
  final int windDegree;
  final int cloudiness;
  final int sunrise;
  final int sunset;
  final int updatedAt;

  double get visibilityKm => visibility / 1000.0;
  double get windSpeedKmH => windSpeed * 3.6;
  String get windDirection => _directionFromDegrees(windDegree);

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> main = json['main'] as Map<String, dynamic>;
    final Map<String, dynamic> wind = json['wind'] as Map<String, dynamic>;
    final Map<String, dynamic> clouds = json['clouds'] as Map<String, dynamic>;
    final Map<String, dynamic> sys = json['sys'] as Map<String, dynamic>;
    final List<dynamic> weather = json['weather'] as List<dynamic>;
    final Map<String, dynamic> weatherItem = weather.isNotEmpty
        ? weather.first as Map<String, dynamic>
        : <String, dynamic>{};

    return WeatherData(
      city: json['name']?.toString() ?? 'Bandung',
      condition: weatherItem['main']?.toString() ?? 'Clouds',
      description: _beautifyDescription(
        weatherItem['description']?.toString() ?? 'awan syahdu',
      ),
      temperature: (main['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (main['feels_like'] as num?)?.toDouble() ?? 0.0,
      humidity: (main['humidity'] as num?)?.toInt() ?? 0,
      pressure: (main['pressure'] as num?)?.toInt() ?? 0,
      visibility: (json['visibility'] as num?)?.toInt() ?? 0,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0.0,
      windDegree: (wind['deg'] as num?)?.toInt() ?? 0,
      cloudiness: (clouds['all'] as num?)?.toInt() ?? 0,
      sunrise: (sys['sunrise'] as num?)?.toInt() ?? 0,
      sunset: (sys['sunset'] as num?)?.toInt() ?? 0,
      updatedAt:
          (json['dt'] as num?)?.toInt() ??
          DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
  }

  static String _beautifyDescription(String raw) {
    if (raw.isEmpty) {
      return 'Cuaca cerah';
    }
    return raw
        .split(' ')
        .map(
          (String word) =>
              word.isEmpty ? word : word[0].toUpperCase() + word.substring(1),
        )
        .join(' ');
  }

  static String _directionFromDegrees(int degree) {
    const List<String> directions = <String>[
      'Utara',
      'Timur Laut',
      'Timur',
      'Tenggara',
      'Selatan',
      'Barat Daya',
      'Barat',
      'Barat Laut',
    ];
    final int index = ((degree % 360) / 45).round() % directions.length;
    return directions[index];
  }
}

class WeatherPalette {
  const WeatherPalette({
    required this.background,
    required this.appBar,
    required this.accent,
    required this.title,
    required this.temperature,
    required this.asset,
  });

  final List<Color> background;
  final Color appBar;
  final Color accent;
  final Color title;
  final Color temperature;
  final String asset;
}

class HttpException implements Exception {
  const HttpException(this.message);
  final String message;

  @override
  String toString() => message;
}
