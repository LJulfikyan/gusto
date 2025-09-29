import 'dart:async';
import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;

class CardBinInfo {
  CardBinInfo({
    required this.bin,
    required this.brand,
    required this.type,
    required this.category,
    required this.issuer,
    required this.issuerPhone,
    required this.issuerUrl,
    required this.countryCode,
    required this.countryName,
  });

  final String bin;
  final String brand;
  final String type;
  final String category;
  final String issuer;
  final String issuerPhone;
  final String issuerUrl;
  final String countryCode;
  final String countryName;

  static CardBinInfo fromRow(List<dynamic> row) {
    return CardBinInfo(
      bin: row[0]?.toString().trim() ?? '',
      brand: row[1]?.toString().trim() ?? '',
      type: row[2]?.toString().trim() ?? '',
      category: row[3]?.toString().trim() ?? '',
      issuer: row[4]?.toString().trim() ?? '',
      issuerPhone: row[5]?.toString().trim() ?? '',
      issuerUrl: row[6]?.toString().trim() ?? '',
      countryCode: row[7]?.toString().trim() ?? '',
      countryName: row[9]?.toString().trim() ?? row[8]?.toString().trim() ?? '',
    );
  }
}

class BinLookupService {
  BinLookupService._();

  static const String _csvUrl =
      'https://raw.githubusercontent.com/venelinkochev/bin-list-data/master/bin-list-data.csv';

  static final BinLookupService instance = BinLookupService._();

  final Map<String, CardBinInfo> _cache = <String, CardBinInfo>{};
  Future<void>? _loadingFuture;

  Future<CardBinInfo?> lookup(String digits) async {
    if (digits.length < 6) return null;
    final prefix = digits.substring(0, 6);
    if (_cache.containsKey(prefix)) {
      return _cache[prefix];
    }
    await _ensureLoaded();
    return _cache[prefix];
  }

  Future<void> _ensureLoaded() {
    return _loadingFuture ??= _loadCsv();
  }

  Future<void> _loadCsv() async {
    try {
      final response = await http.get(Uri.parse(_csvUrl));
      if (response.statusCode != 200 || response.body.isEmpty) {
        return;
      }
      final lines = const LineSplitter().convert(response.body);
      final csv = const CsvToListConverter(shouldParseNumbers: false);
      var isHeader = true;
      for (final line in lines) {
        if (isHeader) {
          isHeader = false;
          continue;
        }
        if (line.trim().isEmpty) continue;
        final parsed = csv.convert(line);
        if (parsed.isEmpty || parsed.first.isEmpty) continue;
        final info = CardBinInfo.fromRow(parsed.first);
        if (info.bin.length >= 6) {
          final key = info.bin.substring(0, 6);
          _cache.putIfAbsent(key, () => info);
        }
      }
    } catch (_) {
      // Ignore load failures; service will simply return null.
    }
  }
}
