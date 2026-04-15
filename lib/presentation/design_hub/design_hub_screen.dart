import 'package:flutter/material.dart';

import 'design_registry.dart';

class DesignHubScreen extends StatefulWidget {
  const DesignHubScreen({super.key});

  @override
  State<DesignHubScreen> createState() => _DesignHubScreenState();
}

class _DesignHubScreenState extends State<DesignHubScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DesignRegistry.titles[_selected]),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_list_numbered),
            onPressed: () => _showDesignPicker(context),
          ),
        ],
      ),
      body: DesignRegistry.buildScreen(_selected),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showDesignPicker(context),
        icon: const Icon(Icons.dashboard_customize),
        label: const Text('15 Designs'),
      ),
    );
  }

  void _showDesignPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: DesignRegistry.titles.length,
            itemBuilder: (_, index) {
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(DesignRegistry.titles[index]),
                selected: _selected == index,
                onTap: () {
                  setState(() => _selected = index);
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }
}
