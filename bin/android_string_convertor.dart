import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart' as args;
import 'package:xml/xml.dart';

final args.ArgParser argumentParser = args.ArgParser()
  ..addOption(
    'prefix',
    abbr: 'p',
    help: 'prefix file name',
    defaultsTo: 'app_',
  )
  ..addFlag(
    'sort',
    abbr: 's',
    help: 'Sort by key name.',
  )
  ..addFlag(
    'directory',
    abbr: 'd',
    help: 'Path is directory',
  );

void printUsage() {
  stdout.writeln('Usage: string converter [options] {files}');
  stdout.writeln();
  stdout.writeln(argumentParser.usage);
  exit(1);
}

void main(List<String> arguments) {
  final files = <File>[];
  final results = argumentParser.parse(arguments);
  final prefix = results['prefix'] as String;
  final sort = results['sort'] as bool;
  final isDirectory = results['directory'] as bool;
  if (isDirectory) {
    final dir = Directory(results.rest.first);
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
    for (final argument in results.rest) {
      final file = File(argument);
      if (file.existsSync()) {
        files.add(file);
      } else {
        stderr.writeln('File not found: $file');
        exit(2);
      }
    }
  }

  if (files.isEmpty) {
    printUsage();
  }
  stdout.writeln("file ${files.length}");

  for (final file in files) {
    var path = file.parent.path +
        Platform.pathSeparator +
        prefix +
        file.uri.pathSegments.last.replaceAll(".xml", ".arb");

    final outfile = File(path);
    final document = XmlDocument.parse(file.readAsStringSync());
    Map<String, String> out = {};
    for (final child in document.rootElement.children) {
      if (child.attributes.isNotEmpty) {
        final n = child.attributes
            .firstWhere((element) => element.name.local == "name");
        var key = '${n.value[0].toLowerCase()}${n.value.substring(1)}';
        out[key] = child.innerText;
      }
    }
    if (sort) {
      out = Map.fromEntries(
          out.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
    }
    stdout.writeln("outfile ${outfile.path}");
    final encoder = JsonEncoder.withIndent("   ");
    final srt = encoder.convert(out);
    outfile.writeAsStringSync(srt);
  }
}
