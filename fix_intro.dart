import 'dart:io';

void main() {
  final file = File('lib/screens/lessons_intro_screen.dart');
  var content = file.readAsStringSync();
  
  // Fix widths
  content = content.replaceAll('width: 371', 'width: 340');
  content = content.replaceAll('width: 362', 'width: 340');
  content = content.replaceAll('width: 374', 'width: 340');
  content = content.replaceAll('width: 368', 'width: 340');
  content = content.replaceAll('width: 380', 'width: 340');
  content = content.replaceAll('width: 370', 'width: 340');
  
  // Fix left margins that were shifted
  content = content.replaceAll('left: 27,', 'left: 28,');
  content = content.replaceAll('left: 30,', 'left: 28,');
  content = content.replaceAll('left: 34,', 'left: 28,');
  content = content.replaceAll('left: 36,', 'left: 28,');
  content = content.replaceAll('left: 38,', 'left: 28,');
  
  file.writeAsStringSync(content);
}
