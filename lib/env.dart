import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env{
  static String get projectId  => dotenv.get('projectId');
  static String get databaseId => dotenv.get('databaseId');
  static String get collectionId => dotenv.get('collectionId');
}
