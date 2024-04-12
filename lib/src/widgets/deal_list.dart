import 'package:flutter/material.dart';

import '../data.dart';

class DealList extends StatelessWidget {
  final List<Deal> deals;
  final ValueChanged<Deal>? onTap;

  const DealList({
    required this.deals,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: deals.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(
            deals[index].title,
          ),
          subtitle: Text(
            deals[index].author.name,
          ),
          onTap: onTap != null ? () => onTap!(deals[index]) : null,
        ),
      );
}
