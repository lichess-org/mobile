// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Account _$$_AccountFromJson(Map<String, dynamic> json) => _$_Account(
      id: json['id'] as String,
      username: json['username'] as String,
      title: json['title'] as String?,
      patron: json['patron'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      seenAt: DateTime.fromMillisecondsSinceEpoch(json['seenAt'] as int),
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
    );

_$_Profile _$$_ProfileFromJson(Map<String, dynamic> json) => _$_Profile(
      country: json['country'] as String?,
      location: json['location'] as String?,
      bio: json['bio'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      fideRating: json['fideRating'] as int?,
      links: json['links'] as String?,
    );
