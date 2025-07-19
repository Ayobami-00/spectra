// ignore_for_file: unused_field

import 'package:frontend/features/home/data/data_source/home_data_source.dart';

import 'package:frontend/features/home/data/index.dart';
import 'package:frontend/features/home/domain/index.dart';

class HomeRepoImpl extends HomeRepo {
  final HomeDataSource _homeDataSource;
  HomeRepoImpl(
    this._homeDataSource,
  );
}
