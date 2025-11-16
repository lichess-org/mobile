# Publishing a new version to F-Droid

There is a separate `fdroid` branch which uses unified push instead of firebase so that the app can be published on
F-Droid. To publish, merge `main` into that branch, tag it, and then push:

```bash
git checkout fdroid
git merge main
git push
# Any tag that ends with ".fdroid" will be picked up by the f-droid server as a new release
git tag v<new-version>.fdroid
git push --tags
```
