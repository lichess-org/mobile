import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> setupIntl() async {
  // we need call this because it is not setup automatically
  final systemLocale = await findSystemLocale();
  Intl.defaultLocale = systemLocale;

  // we need to setup timeago locale manually
  final currentLocale = Intl.getCurrentLocale();
  final longLocale = Intl.canonicalizedLocale(currentLocale);
  final messages = _timeagoLocales[longLocale];
  if (messages != null) {
    timeago.setLocaleMessages(longLocale, messages);
    timeago.setDefaultLocale(longLocale);
  } else {
    final shortLocale = Intl.shortLocale(currentLocale);
    final messages = _timeagoLocales[shortLocale];
    if (messages != null) {
      timeago.setLocaleMessages(shortLocale, messages);
      timeago.setDefaultLocale(shortLocale);
    }
  }
}

final Map<String, timeago.LookupMessages> _timeagoLocales = {
  'am': timeago.AmMessages(),
  'ar': timeago.ArMessages(),
  'az': timeago.AzMessages(),
  'be': timeago.BeMessages(),
  'bs': timeago.BsMessages(),
  'ca': timeago.CaMessages(),
  'cs': timeago.CsMessages(),
  'da': timeago.DaMessages(),
  'de': timeago.DeMessages(),
  'dv': timeago.DvMessages(),
  'en': timeago.EnMessages(),
  'es': timeago.EsMessages(),
  'et': timeago.EtMessages(),
  'fa': timeago.FaMessages(),
  'fi': timeago.FiMessages(),
  'fr': timeago.FrMessages(),
  'gr': timeago.GrMessages(),
  'he': timeago.HeMessages(),
  'hi': timeago.HiMessages(),
  'hr': timeago.HrMessages(),
  'hu': timeago.HuMessages(),
  'id': timeago.IdMessages(),
  'it': timeago.ItMessages(),
  'ja': timeago.JaMessages(),
  'km': timeago.KmMessages(),
  'ko': timeago.KoMessages(),
  'ku': timeago.KuMessages(),
  'lv': timeago.LvMessages(),
  'mn': timeago.MnMessages(),
  'ms_MY': timeago.MsMyMessages(),
  'nb_NO': timeago.NbNoMessages(),
  'nl': timeago.NlMessages(),
  'nn_NO': timeago.NnNoMessages(),
  'pl': timeago.PlMessages(),
  'pt_BR': timeago.PtBrMessages(),
  'ro': timeago.RoMessages(),
  'ru': timeago.RuMessages(),
  'sr': timeago.SrMessages(),
  'sv': timeago.SvMessages(),
  'ta': timeago.TaMessages(),
  'th': timeago.ThMessages(),
  'tk': timeago.TkMessages(),
  'tr': timeago.TrMessages(),
  'uk': timeago.UkMessages(),
  'ur': timeago.UrMessages(),
  'vi': timeago.ViMessages(),
  'zh_CN': timeago.ZhCnMessages(),
  'zh': timeago.ZhMessages(),
};
