# Publishing a new version to F-Droid

There is a separate `fdroid` branch which uses unified push instead of firebase so that the app can be published on
F-Droid. 
To publish, first merge the new version tag into that branch.
Then, ensure that the `flutter-version` file contains the exact version that the new Play Store release was built
against (this is required for f-droid builds being reproducible).
Finally, tag the release and push, this will automatically trigger a new version to be built by the F-Droid server.

```bash
git checkout fdroid
git merge v<new-version>

# If neccessary, update the flutter-version file

# Any tag that ends with ".fdroid" will be picked up by the f-droid server as a new release
git push
git tag v<new-version>.fdroid
git push --tags
```
