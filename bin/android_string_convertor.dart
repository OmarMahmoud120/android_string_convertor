import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart' as args;
import 'package:xml/xml.dart';

final args.ArgParser argumentParser = args.ArgParser()
  ..addOption(
    'prefix',
    abbr: 'p',
    help: 'Prefix for output file name',
    defaultsTo: 'app_',
  )
  ..addFlag(
    'sort',
    abbr: 's',
    help: 'Sort the output by key name',
  )
  ..addFlag(
    'directory',
    abbr: 'd',
    help: 'Input is a directory containing XML files',
  )
  ..addOption(
    'output-dir',
    abbr: 'o',
    help: 'Output directory for ARB files (default is same as input directory)',
    defaultsTo: '',
  );

void printUsage() {
  stdout.writeln('Usage: android-string-converter [options] {files|directory}');
  stdout.writeln();
  stdout.writeln(argumentParser.usage);
  exit(1);
}

void main(List<String> arguments) {
  final results = argumentParser.parse(arguments);
  final prefix = results['prefix'] as String;
  final sort = results['sort'] as bool;
  final isDirectory = results['directory'] as bool;
  final outputDir = results['output-dir'] as String;

  final files = getInputFiles(results.rest, isDirectory);
  if (files.isEmpty) {
    printUsage();
  }

  for (final file in files) {
    final outfile = getOutputFile(file, prefix, outputDir);
    final document = XmlDocument.parse(file.readAsStringSync());
    final out = extractStringsFromXml(document, sort);
    stdout.writeln("Writing to $outfile");
    outfile.writeAsStringSync(JsonEncoder.withIndent("   ").convert(out));
  }
}

List<File> getInputFiles(List<String> paths, bool isDirectory) {
  final files = <File>[];
  if (isDirectory) {
    final dir = Directory(paths.first);
    if (!dir.existsSync()) {
      stderr.writeln('Directory not found: $dir');
      exit(2);
    }
    dir
        .listSync(recursive: false)
        .where((element) => element.path.endsWith(".xml"))
        .forEach((element) {
      files.add(File(element.path));
    });
  } else {
    for (final path in paths) {
      final file = File(path);
      if (file.existsSync()) {
        files.add(file);
      } else {
        stderr.writeln('File not found: $file');
        exit(2);
      }
    }
  }
  return files;
}

File getOutputFile(File inputFile, String prefix, String outputDir) {
  if (outputDir.isNotEmpty) {
    final dir = Directory(outputDir);
    if (!dir.existsSync()) {
      dir.createSync();
    }
  }
  final outputPath = outputDir.isNotEmpty
      ? '${outputDir.replaceAll('\\', '/')}/$prefix${inputFile.uri.pathSegments.last.replaceAll(".xml", ".arb")}'
      : '${inputFile.parent.path}/$prefix${inputFile.uri.pathSegments.last.replaceAll(".xml", ".arb")}';
  return File(outputPath);
}

Map<String, String> extractStringsFromXml(XmlDocument document, bool sort) {
  final out = <String, String>{};
  for (final child in document.rootElement.children) {
    if (child.attributes.isNotEmpty) {
      final n = child.attributes
          .firstWhere((element) => element.name.local == "name");
      var key = '${n.value[0].toLowerCase()}${n.value.substring(1)}';
      out[key] = child.innerText;
    }
  }
  if (sort) {
    return Map.fromEntries(
        out.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
  }
  return out;
}
