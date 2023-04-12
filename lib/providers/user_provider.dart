import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/user.dart';
import 'package:news_app/repositories/user_repository.dart';

final userRepositoryProvider = Provider((ref) => UserRepository(ref));

final userProvider =
    FutureProvider<User>((ref) => ref.watch(userRepositoryProvider).getUser());
