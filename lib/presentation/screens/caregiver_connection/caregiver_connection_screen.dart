import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:gentle_dose/core/services/connection_service.dart';
import 'package:gentle_dose/core/models/connection_model.dart';

class CaregiverConnectionScreen extends StatefulWidget {
  const CaregiverConnectionScreen({super.key});

  @override
  State<CaregiverConnectionScreen> createState() =>
      _CaregiverConnectionScreenState();
}

class _CaregiverConnectionScreenState extends State<CaregiverConnectionScreen> {
  final ConnectionService _connectionService = ConnectionService();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isLoading = false;
  List<PatientCaregiverConnection> _connections = [];
  List<PatientCaregiverConnection> _pendingRequests = [];

  @override
  void initState() {
    super.initState();
    _loadConnections();
    _loadPendingRequests();
  }

  Future<void> _loadConnections() async {
    try {
      List<PatientCaregiverConnection> connections = await _connectionService
          .getActiveConnections();
      setState(() {
        _connections = connections;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading connections: $e')));
    }
  }

  Future<void> _loadPendingRequests() async {
    try {
      List<PatientCaregiverConnection> requests = await _connectionService
          .getPendingRequests();
      setState(() {
        _pendingRequests = requests;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading pending requests: $e')),
      );
    }
  }

  Future<void> _connectViaPhone() async {
    if (_phoneController.text.isEmpty || _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? connectionId = await _connectionService.connectViaPhone(
        caregiverPhoneNumber: _phoneController.text,
        patientName: _nameController.text,
      );

      if (connectionId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Connection request sent! The caregiver will receive a verification code.',
            ),
            backgroundColor: Colors.green,
          ),
        );
        _phoneController.clear();
        _nameController.clear();
        await _loadConnections();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmConnection(String connectionId) async {
    if (_codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter verification code')),
      );
      return;
    }

    try {
      bool success = await _connectionService.confirmConnection(
        connectionId: connectionId,
        verificationCode: _codeController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connection confirmed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _codeController.clear();
        await _loadConnections();
        await _loadPendingRequests();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caregiver Connections'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Add Caregiver Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Caregiver',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Your Name',
                        hintText: 'Enter your full name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    IntlPhoneField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: "Caregiver's Phone Number",
                        border: OutlineInputBorder(),
                      ),
                      initialCountryCode: 'US',
                      onChanged: (phone) {
                        _phoneController.text = phone.completeNumber;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _connectViaPhone,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Send Connection Request'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Pending Requests Section (for caregivers)
            if (_pendingRequests.isNotEmpty) ...[
              Text(
                'Pending Connection Requests',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              ...(_pendingRequests.map(
                (request) => Card(
                  child: ListTile(
                    title: Text('Connection Request'),
                    subtitle: Text(
                      'From: ${request.metadata?['patientName'] ?? 'Unknown Patient'}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _codeController,
                            decoration: const InputDecoration(
                              labelText: 'Code',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: request.id == null
                              ? null
                              : () => _confirmConnection(request.id!),
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
              const SizedBox(height: 20),
            ],

            // Active Connections Section
            Text(
              'Active Connections',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _connections.isEmpty
                  ? const Center(
                      child: Text(
                        'No active connections yet.\nAdd a caregiver to get started!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _connections.length,
                      itemBuilder: (context, index) {
                        PatientCaregiverConnection connection =
                            _connections[index];
                        return Card(
                          child: ListTile(
                            title: Text('Connected'),
                            subtitle: Text(
                              'Status: ${connection.status.toString().split('.').last}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                bool? confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Disconnect'),
                                    content: const Text(
                                      'Are you sure you want to disconnect this caregiver?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text('Disconnect'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  if (connection.id != null) {
                                    await _connectionService
                                        .disconnectConnection(connection.id!);
                                  }
                                  await _loadConnections();
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
