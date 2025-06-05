# Internationalisation

We're using the official Flutter way of internationalising our app, as desbribed in the
[documentation](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#setting-up).

What is specific to this project is the way the ARB files are generated.

Lichess translations are managed in [Crowdin lichess project](https://crowdin.com/project/lichess).

Crowdin translations (and sources) are located in the `translation/` directory. New
translations (and lila sources) are regularly fetched from crowdin by a github action.

ARB files are generated with a script that processes these translations: `scripts/gen-arb.mjs`.

Then a flutter command is used to generate the dart files from the ARB files.

So, in order to update the dart files we need to run:

```bash
./scripts/gen-arb.mjs
flutter gen-l10n
```

## How to add new translations

[Translations in Crowdin](../translation/sources) are organised by module.

There is one module for the mobile app: [mobile.xml](../translation/source/mobile.xml).

We can edit this file to add new translations that are specific to the mobile
app. It will be automatically synced with Crowdin when changes are pushed to the
file.

All the other modules comes from [lila](https://github.com/lichess-org/lila/tree/master/translation/source) repository. They are pulled from crowdin and should **NOT** be edited.
We are not using all the lila modules, and the list of modules is defined in the
`scripts/gen-arb.mjs` script.

If you need to add a new module, you need to add it to the list of modules in the script.

Note that a module can contain a lot of translations that we don't need in the app. In this case, you can filter the translations by adding the module to the `whitelist` defined in the script.

Once you've added the module to the script, you can run the script to update the translations.

```bash
./scripts/gen-arb.mjs
flutter gen-l10n
```

You should see the new strings in the `lib/l10n/app_*.arb` and `lib/l10n/app_*.dart` files.

### Mobile translations tips

> **Note**
>
> When working on a new feature, you should start with hardcoding English texts first. Once the feature is done,
> released and even used for a while, we can add translations, in order to avoid useless translating work.

There are some strings that appear only in this app, but not on lichess.org.

If you have a new string to be translated, add it to `translations/source/mobile.xml`. Make sure to include a `comment`
attribute, describing the usage of the string and its contents (e.g. placeholders). Some strings also must not exceed a
certain width due to UI constraints, use the `maxLength` attribute for that.

After updating translations as
described above, they can be used like the other translations, however a `mobile` prefix is added in dart. For example,
"foo" in `mobile.xml` turns into `mobileFoo` in dart.

> **Note**
>
> We do not translate error messages that are not critically important, such as "could not load XY" when screen "XY"
> failed to load. Translating work is done by a team of volunteers and we try to focus on quality rather than quantity.
> Such messages are mostly edge cases in the sense they should be rarely seen and people would understand that something
> went wrong and could not load without understanding the actual meaning of the error message.

> **Note**
> Do not translate names such as "Puzzle Storm" and "Puzzle Streak". If such names appear in a translation string,
> add a comment that they should not be translated.

