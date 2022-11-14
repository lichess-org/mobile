import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.codegen.freezed.dart';
part 'account.codegen.g.dart';

@freezed
class Account with _$Account {
  factory Account({
    required String id,
    required String username,
    String? title,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
}
