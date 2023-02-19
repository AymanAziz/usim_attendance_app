import 'dart:ui';

import 'package:equatable/equatable.dart';

class UserChartModel extends Equatable {
  final String user;
  final int count;
  final Color color;


  const UserChartModel(
      { required this.user,
        required this.count,
        required this.color,
      });

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'count': count,
      'color': color,
    };
  }

//get data from Repository
  static UserChartModel fromJSON(Map<String, Object?> json) => UserChartModel(
      user: json['user'] as String,
      count: json['count'] as int,
    color: json['color'] as Color,
     );

  @override
// TODO: implement props
  List<Object?> get props =>
      [count, user,color];
}