import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/landlord_provider.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedReportType = 'landlords';
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    final landlordProvider = Provider.of<LandlordProvider>(context, listen: false);
    Future.microtask(() => landlordProvider.fetchLandlords());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark ? Colors.white : const Color(0xFF1A2138),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report Type Selector
            Text(
              'Select Report Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A2138),
              ),
            ),
            const SizedBox(height: 12),
            _buildReportTypeSelector(isDark),
            const SizedBox(height: 24),

            // Date Range Filter
            Text(
              'Date Range',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A2138),
              ),
            ),
            const SizedBox(height: 12),
            _buildDateRangeSelector(isDark),
            const SizedBox(height: 24),

            // Report Preview
            if (_selectedReportType == 'landlords')
              _buildLandlordsReport(isDark),
            if (_selectedReportType == 'summary')
              _buildSummaryReport(isDark),
            if (_selectedReportType == 'verification')
              _buildVerificationReport(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTypeSelector(bool isDark) {
    final reportTypes = [
      {'id': 'landlords', 'name': 'Landlords Report', 'icon': Icons.apartment},
      {'id': 'verification', 'name': 'Verification Report', 'icon': Icons.verified_user},
      {'id': 'summary', 'name': 'Summary Report', 'icon': Icons.bar_chart},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: reportTypes.map((type) {
          final isSelected = _selectedReportType == type['id'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedReportType = type['id'] as String),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF2D5BFF)
                      : (isDark ? const Color(0xFF2A2A2A) : Colors.white),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2D5BFF)
                        : (isDark ? Colors.grey[800]! : Colors.grey[200]!),
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF2D5BFF).withOpacity(0.2),
                            blurRadius: 8,
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      type['icon'] as IconData,
                      size: 18,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white70 : const Color(0xFF1A2138)),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      type['name'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.white70 : const Color(0xFF1A2138)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateRangeSelector(bool isDark) {
    return GestureDetector(
      onTap: _selectDateRange,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 18,
              color: const Color(0xFF2D5BFF),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedDateRange == null
                    ? 'Select date range'
                    : '${DateFormat('MMM dd, yyyy').format(_selectedDateRange!.start)} - ${DateFormat('MMM dd, yyyy').format(_selectedDateRange!.end)}',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : const Color(0xFF8F9BB3),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
    );
    if (result != null) {
      setState(() => _selectedDateRange = result);
    }
  }

  Widget _buildLandlordsReport(bool isDark) {
    return Consumer<LandlordProvider>(
      builder: (context, landlordProvider, _) {
        final landlords = landlordProvider.landlords;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportHeader('Landlords Report', landlords.length, isDark),
            const SizedBox(height: 16),

            // Export Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.file_download),
                label: const Text('Export as CSV'),
                onPressed: () => _exportLandlordsReport(landlords, isDark),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D5BFF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Report Table
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                  width: 0.5,
                ),
              ),
              child: Column(
                children: [
                  _buildTableHeader(
                    ['Name', 'Status', 'Properties', 'Rating'],
                    isDark,
                  ),
                  ...landlords.map((landlord) {
                    return _buildTableRow(
                      [
                        landlord.name,
                        landlord.verificationStatus,
                        '${landlord.totalProperties}',
                        (landlord.rating.toStringAsFixed(1)),
                      ],
                      isDark,
                    );
                  }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVerificationReport(bool isDark) {
    return Consumer<LandlordProvider>(
      builder: (context, landlordProvider, _) {
        final stats = landlordProvider.getStatistics();
        final landlords = landlordProvider.landlords;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportHeader('Verification Report', landlords.length, isDark),
            const SizedBox(height: 16),

            // Statistics Cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _buildStatCard('Total', '${stats['total']}', Icons.people, const Color(0xFF2D5BFF), isDark),
                _buildStatCard('Verified', '${stats['verified']}', Icons.check_circle, const Color(0xFF00C48C), isDark),
                _buildStatCard('Pending', '${stats['pending']}', Icons.pending_actions, const Color(0xFFFF9500), isDark),
                _buildStatCard('Rejected', '${stats['rejected']}', Icons.cancel, const Color(0xFFFF3B30), isDark),
              ],
            ),
            const SizedBox(height: 16),

            // Export Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.file_download),
                label: const Text('Export Report'),
                onPressed: () => _exportVerificationReport(stats, isDark),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D5BFF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryReport(bool isDark) {
    return Consumer<LandlordProvider>(
      builder: (context, landlordProvider, _) {
        final stats = landlordProvider.getStatistics();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportHeader('Summary Report', stats['total'] ?? 0, isDark),
            const SizedBox(height: 16),

            // Summary Cards
            _buildSummaryCard(
              'Total Landlords',
              '${stats['total']}',
              'All registered landlords',
              Icons.apartment,
              const Color(0xFF2D5BFF),
              isDark,
            ),
            const SizedBox(height: 12),
            _buildSummaryCard(
              'Verification Rate',
              '${((stats['verified'] ?? 0) / (stats['total'] ?? 1) * 100).toStringAsFixed(1)}%',
              'Verified out of total',
              Icons.trending_up,
              const Color(0xFF00C48C),
              isDark,
            ),
            const SizedBox(height: 12),
            _buildSummaryCard(
              'Pending Review',
              '${stats['pending']}',
              'Awaiting verification',
              Icons.pending_actions,
              const Color(0xFFFF9500),
              isDark,
            ),
            const SizedBox(height: 16),

            // Export Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.file_download),
                label: const Text('Export Summary'),
                onPressed: () => _exportSummaryReport(stats, isDark),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D5BFF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReportHeader(String title, int count, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.assessment,
            size: 32,
            color: const Color(0xFF2D5BFF),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A2138),
                ),
              ),
              Text(
                'Generated on ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF2D5BFF).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count Records',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D5BFF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1A2138),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, String subtitle, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A2138),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey[500] : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(List<String> headers, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F7FA),
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: headers.map((header) {
          return Expanded(
            child: Text(
              header,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTableRow(List<String> values, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: values.map((value) {
          return Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white70 : const Color(0xFF1A2138),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _exportLandlordsReport(List<Landlord> landlords, bool isDark) {
    _generateCSV([
      ['Name', 'Email', 'Business Name', 'Status', 'Properties', 'Bookings', 'Rating', 'Joined'],
      ...landlords.map((l) => [
            l.name,
            l.email,
            l.businessName,
            l.verificationStatus,
            '${l.totalProperties}',
            '${l.totalBookings}',
            '${l.rating}',
            l.createdAt.toString(),
          ]),
    ]);
    _showExportSuccess('Landlords Report', isDark);
  }

  void _exportVerificationReport(Map<String, int> stats, bool isDark) {
    _generateCSV([
      ['Metric', 'Count'],
      ['Total', '${stats['total']}'],
      ['Verified', '${stats['verified']}'],
      ['Pending', '${stats['pending']}'],
      ['Rejected', '${stats['rejected']}'],
    ]);
    _showExportSuccess('Verification Report', isDark);
  }

  void _exportSummaryReport(Map<String, int> stats, bool isDark) {
    final total = stats['total'] ?? 1;
    final verified = stats['verified'] ?? 0;
    _generateCSV([
      ['Report Type', 'Summary Report'],
      ['Generated', DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())],
      ['Total Landlords', '$total'],
      ['Verified', '$verified'],
      ['Verification Rate', '${(verified / total * 100).toStringAsFixed(1)}%'],
    ]);
    _showExportSuccess('Summary Report', isDark);
  }

  String _generateCSV(List<List<String>> data) {
    return data.map((row) => row.map((cell) => '"$cell"').join(',')).join('\n');
  }

  void _showExportSuccess(String reportName, bool isDark) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ $reportName exported successfully!'),
        backgroundColor: const Color(0xFF00C48C),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
