sealed class AppLink {
  const AppLink();
}

final class UrlLink extends AppLink {
  const UrlLink(this.uri);

  final Uri uri;
}

final class MentionLink extends AppLink {
  const MentionLink(this.username);

  final String username;
}
