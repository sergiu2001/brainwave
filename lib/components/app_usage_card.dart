import 'package:flutter/material.dart';
import 'package:brainwave/models/report_models.dart';
import 'attributes_choices.dart';
import 'package:brainwave/utils/usage_formatter.dart';

class AppUsageCard extends StatelessWidget {
  final AppUsageWithIcon appItem;
  final Function(String, bool) onAttributeSelected;

  const AppUsageCard({
    super.key,
    required this.appItem,
    required this.onAttributeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 10),
                  child: appItem.iconBytes != null
                      ? Image.memory(
                          appItem.iconBytes!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 48),
                        )
                      : const Icon(Icons.apps, size: 48),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appItem.appModel.appName,
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Usage: ${formatDuration(appItem.appModel.appUsage)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 58, top: 8),
              child: AttributesChoices(
                selectedAttributes: appItem.attributes,
                onAttributeSelected: onAttributeSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
