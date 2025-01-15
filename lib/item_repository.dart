import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hm_web_flutter/item_data.dart';
import 'package:http/http.dart' as http;

import 'env.dart';

class ItemRepository {
  final Ref ref;

  ItemRepository({required this.ref});

  Future<List<ItemData>> getItems() async {
    final result = <ItemData>[];

    const String baseUrl = 'https://cloud.appwrite.io/v1';
    final String projectId = Env.projectId;
    final String databaseId = Env.databaseId;
    final String collectionId = Env.collectionId;

    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/databases/$databaseId/collections/$collectionId/documents'),
        headers: {
          'Content-Type': 'application/json',
          'X-Appwrite-Project': projectId,
        },
      );

      if (response.statusCode == 200) {
        final responseBody = await compute((m) => json.decode(m), response.body);

        for (final i in responseBody['documents'] as List) {
          result.add(ItemData.fromJson(i));
        }

        return result;
      } else {
        throw Exception('Failed to load documents: ${response.body}');
      }
    } catch (e,st) {
      if (kDebugMode) {
        print('Error fetching documents: $e $st');
      }
      return [];
    }
  }
}

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  return ItemRepository(ref: ref);
});

final getItemsProvider = FutureProvider<List<ItemData>>((ref) async {
  return ref.watch(itemRepositoryProvider).getItems();
});

final getItemDetailProvider =
    FutureProvider.family.autoDispose<ItemData, String>((ref, arg) async {
  final list = await ref.watch(getItemsProvider.future);
  return list.where((e) => e.id == arg).first;
});
