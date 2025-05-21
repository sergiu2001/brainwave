String formatDuration(String rawUsage) {
  final parts = rawUsage.split(':');
  if (parts.length < 3) return rawUsage;

  final hours = int.parse(parts[0]);
  final minutes = int.parse(parts[1]);
  final seconds = int.parse(parts[2].split('.').first);

  final output = <String>[];
  if (hours > 0) output.add('${hours}h');
  if (minutes > 0) output.add('${minutes}m');
  if (seconds > 0 || output.isEmpty) output.add('${seconds}s');
  return output.join(' ');
}
