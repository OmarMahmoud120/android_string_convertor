
# Android String Convertor

command-line tool to convert android xml string to arb.

## Usage

```bash
dart run bin/android_string_convertor.dart [options] {files/directory}

-p, --prefix prefix file name
(defaults to "app_")
-s, --[no-]sort Sort by key name.
-d, --[no-]directory Path is directory
```

### Example

This example reads XML string file and convert it to arb file:

- Single file

```bash
dart run bin/android_string_convertor.dart  ./example/en.xml
```

- Multible files

```bash
dart run bin/android_string_convertor.dart  ./example/en.xml ./example/es.xml
```

- Directory

```bash
dart run bin/android_string_convertor.dart -d ./example 
```

- With srot the output by key

```bash
dart run bin/android_string_convertor.dart -s -d ./example
```

- With outout prefix filename defaults to app_

```bash
dart run bin/android_string_convertor.dart -p "test_" -d ./example
```
