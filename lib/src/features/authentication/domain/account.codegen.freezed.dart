// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'account.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Account _$AccountFromJson(Map<String, dynamic> json) {
  return _Account.fromJson(json);
}

/// @nodoc
mixin _$Account {
  String get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  bool get patron => throw _privateConstructorUsedError;
  @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch)
  DateTime get seenAt => throw _privateConstructorUsedError;
  Profile get profile => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountCopyWith<Account> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountCopyWith<$Res> {
  factory $AccountCopyWith(Account value, $Res Function(Account) then) =
      _$AccountCopyWithImpl<$Res, Account>;
  @useResult
  $Res call(
      {String id,
      String username,
      String? title,
      bool patron,
      @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch)
          DateTime createdAt,
      @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch)
          DateTime seenAt,
      Profile profile});

  $ProfileCopyWith<$Res> get profile;
}

/// @nodoc
class _$AccountCopyWithImpl<$Res, $Val extends Account>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? title = freezed,
    Object? patron = null,
    Object? createdAt = null,
    Object? seenAt = null,
    Object? profile = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      patron: null == patron
          ? _value.patron
          : patron // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      seenAt: null == seenAt
          ? _value.seenAt
          : seenAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res> get profile {
    return $ProfileCopyWith<$Res>(_value.profile, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_AccountCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$$_AccountCopyWith(
          _$_Account value, $Res Function(_$_Account) then) =
      __$$_AccountCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String username,
      String? title,
      bool patron,
      @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch)
          DateTime createdAt,
      @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch)
          DateTime seenAt,
      Profile profile});

  @override
  $ProfileCopyWith<$Res> get profile;
}

/// @nodoc
class __$$_AccountCopyWithImpl<$Res>
    extends _$AccountCopyWithImpl<$Res, _$_Account>
    implements _$$_AccountCopyWith<$Res> {
  __$$_AccountCopyWithImpl(_$_Account _value, $Res Function(_$_Account) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? title = freezed,
    Object? patron = null,
    Object? createdAt = null,
    Object? seenAt = null,
    Object? profile = null,
  }) {
    return _then(_$_Account(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      patron: null == patron
          ? _value.patron
          : patron // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      seenAt: null == seenAt
          ? _value.seenAt
          : seenAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$_Account implements _Account {
  _$_Account(
      {required this.id,
      required this.username,
      this.title,
      required this.patron,
      @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch)
          required this.createdAt,
      @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch)
          required this.seenAt,
      required this.profile});

  factory _$_Account.fromJson(Map<String, dynamic> json) =>
      _$$_AccountFromJson(json);

  @override
  final String id;
  @override
  final String username;
  @override
  final String? title;
  @override
  final bool patron;
  @override
  @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch)
  final DateTime createdAt;
  @override
  @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch)
  final DateTime seenAt;
  @override
  final Profile profile;

  @override
  String toString() {
    return 'Account(id: $id, username: $username, title: $title, patron: $patron, createdAt: $createdAt, seenAt: $seenAt, profile: $profile)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Account &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.patron, patron) || other.patron == patron) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.seenAt, seenAt) || other.seenAt == seenAt) &&
            (identical(other.profile, profile) || other.profile == profile));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, username, title, patron, createdAt, seenAt, profile);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AccountCopyWith<_$_Account> get copyWith =>
      __$$_AccountCopyWithImpl<_$_Account>(this, _$identity);
}

abstract class _Account implements Account {
  factory _Account(
      {required final String id,
      required final String username,
      final String? title,
      required final bool patron,
      @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch)
          required final DateTime createdAt,
      @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch)
          required final DateTime seenAt,
      required final Profile profile}) = _$_Account;

  factory _Account.fromJson(Map<String, dynamic> json) = _$_Account.fromJson;

  @override
  String get id;
  @override
  String get username;
  @override
  String? get title;
  @override
  bool get patron;
  @override
  @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch)
  DateTime get createdAt;
  @override
  @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch)
  DateTime get seenAt;
  @override
  Profile get profile;
  @override
  @JsonKey(ignore: true)
  _$$_AccountCopyWith<_$_Account> get copyWith =>
      throw _privateConstructorUsedError;
}

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return _Profile.fromJson(json);
}

/// @nodoc
mixin _$Profile {
  String? get country => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  int? get fideRating => throw _privateConstructorUsedError;
  String? get links => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProfileCopyWith<Profile> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileCopyWith<$Res> {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) then) =
      _$ProfileCopyWithImpl<$Res, Profile>;
  @useResult
  $Res call(
      {String? country,
      String? location,
      String? bio,
      String? firstName,
      String? lastName,
      int? fideRating,
      String? links});
}

/// @nodoc
class _$ProfileCopyWithImpl<$Res, $Val extends Profile>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? country = freezed,
    Object? location = freezed,
    Object? bio = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? fideRating = freezed,
    Object? links = freezed,
  }) {
    return _then(_value.copyWith(
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      fideRating: freezed == fideRating
          ? _value.fideRating
          : fideRating // ignore: cast_nullable_to_non_nullable
              as int?,
      links: freezed == links
          ? _value.links
          : links // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$$_ProfileCopyWith(
          _$_Profile value, $Res Function(_$_Profile) then) =
      __$$_ProfileCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? country,
      String? location,
      String? bio,
      String? firstName,
      String? lastName,
      int? fideRating,
      String? links});
}

/// @nodoc
class __$$_ProfileCopyWithImpl<$Res>
    extends _$ProfileCopyWithImpl<$Res, _$_Profile>
    implements _$$_ProfileCopyWith<$Res> {
  __$$_ProfileCopyWithImpl(_$_Profile _value, $Res Function(_$_Profile) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? country = freezed,
    Object? location = freezed,
    Object? bio = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? fideRating = freezed,
    Object? links = freezed,
  }) {
    return _then(_$_Profile(
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      fideRating: freezed == fideRating
          ? _value.fideRating
          : fideRating // ignore: cast_nullable_to_non_nullable
              as int?,
      links: freezed == links
          ? _value.links
          : links // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$_Profile implements _Profile {
  _$_Profile(
      {this.country,
      this.location,
      this.bio,
      this.firstName,
      this.lastName,
      this.fideRating,
      this.links});

  factory _$_Profile.fromJson(Map<String, dynamic> json) =>
      _$$_ProfileFromJson(json);

  @override
  final String? country;
  @override
  final String? location;
  @override
  final String? bio;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final int? fideRating;
  @override
  final String? links;

  @override
  String toString() {
    return 'Profile(country: $country, location: $location, bio: $bio, firstName: $firstName, lastName: $lastName, fideRating: $fideRating, links: $links)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Profile &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.fideRating, fideRating) ||
                other.fideRating == fideRating) &&
            (identical(other.links, links) || other.links == links));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, country, location, bio,
      firstName, lastName, fideRating, links);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ProfileCopyWith<_$_Profile> get copyWith =>
      __$$_ProfileCopyWithImpl<_$_Profile>(this, _$identity);
}

abstract class _Profile implements Profile {
  factory _Profile(
      {final String? country,
      final String? location,
      final String? bio,
      final String? firstName,
      final String? lastName,
      final int? fideRating,
      final String? links}) = _$_Profile;

  factory _Profile.fromJson(Map<String, dynamic> json) = _$_Profile.fromJson;

  @override
  String? get country;
  @override
  String? get location;
  @override
  String? get bio;
  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  int? get fideRating;
  @override
  String? get links;
  @override
  @JsonKey(ignore: true)
  _$$_ProfileCopyWith<_$_Profile> get copyWith =>
      throw _privateConstructorUsedError;
}
