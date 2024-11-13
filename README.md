# Android String Converter

A command-line tool to convert Android XML string resources to ARB (Application Resource Bundle) files.

## Usage

```bash
dart run bin/android_string_convertor.dart [options] {files/directory}
```

### Options

- `-p, --prefix <prefix>`: Prefix for output file name (defaults to "app_")
- `-s, --[no-]sort`: Sort the output by key name
- `-d, --[no-]directory`: Input is a directory containing XML files
- `-o, --output-dir <output-dir>`: Output directory for ARB files (default is same as input directory)

### Examples

**Single file**:
```bash
dart run bin/android_string_convertor.dart ./example/en.xml
```

**Multiple files**:
```bash
dart run bin/android_string_convertor.dart ./example/en.xml ./example/es.xml
```

**Directory**:
```bash
dart run bin/android_string_convertor.dart -d ./example
```

**Sort output by key**:
```bash
dart run bin/android_string_convertor.dart -s -d ./example
```

**Use custom output prefix**:
```bash
dart run bin/android_string_convertor.dart -p "test_" -d ./example
```

**Specify output directory**:
```bash
dart run bin/android_string_convertor.dart -d ./example -o ./output
```

## How it Works

The tool reads Android XML string resource files and converts them to ARB (Application Resource Bundle) files, which are used for localization in Flutter applications.

The main steps are:

1. Parse the input XML file(s) or directory using the `xml` package.
2. Extract the string resources and their keys from the XML document.
3. Optionally sort the string resources by key.
4. Write the string resources to an ARB file in the specified output directory (or the same directory as the input, if not specified).

## Requirements

- Dart SDK 2.19.0 or later
- `args` and `xml` packages

## Installation

To use the Android String Converter tool, you can run it directly from the command line using the Dart runtime:

```bash
dart run bin/android_string_convertor.dart [options] {files/directory}
```

Alternatively, you can build the tool as a standalone executable using the `dart compile` command:

```bash
dart compile exe bin/android_string_convertor.dart -o android_string_convertor
```

This will create an `android_string_convertor` executable that you can run directly without the `dart run` prefix.

## Contributing

If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request on the [GitHub repository](https://github.com/OmarMahmoud120/android_string_convertor).