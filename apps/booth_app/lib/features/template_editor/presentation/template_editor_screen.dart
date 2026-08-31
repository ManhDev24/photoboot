import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../layout/domain/layout_definition.dart';
import '../../template/domain/template_definition.dart';

class TemplateEditorScreen extends StatefulWidget {
  const TemplateEditorScreen({super.key});

  @override
  State<TemplateEditorScreen> createState() => _TemplateEditorScreenState();
}

class _TemplateEditorScreenState extends State<TemplateEditorScreen> {
  late TemplateDefinition _currentTemplate;
  int? _selectedSlotIndex;

  @override
  void initState() {
    super.initState();
    _currentTemplate = TemplateDefinition.defaultWedding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: Text('TEMPLATE EDITOR — ${_currentTemplate.name}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Template JSON',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Template layout JSON saved successfully!')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          // 1. Left Sidebar — Elements Library
          Container(
            width: 240,
            color: AppTheme.surfaceColor,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ELEMENTS', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold, letterSpacing: 1)),
                const SizedBox(height: 16),
                _buildSidebarButton(Icons.grid_on, 'Add Photo Slot', () {}),
                _buildSidebarButton(Icons.text_fields, 'Add Text Layer', () {}),
                _buildSidebarButton(Icons.image, 'Add Frame Overlay', () {}),
                _buildSidebarButton(Icons.qr_code, 'Add QR Element', () {}),
                const Spacer(),
                const Text('LAYOUT PRESET', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold, letterSpacing: 1)),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: _currentTemplate.layout.id,
                  isExpanded: true,
                  dropdownColor: AppTheme.darkBackground,
                  items: const [
                    DropdownMenuItem(value: 'kho_8_preset', child: Text('Khổ 8 (2x4 Strip)')),
                    DropdownMenuItem(value: 'kho_3_preset', child: Text('Khổ 3 (3 Vertical)')),
                  ],
                  onChanged: (val) {
                    if (val == 'kho_3_preset') {
                      setState(() {
                        _currentTemplate = TemplateDefinition(
                          id: 'template_kho_3',
                          name: 'Khổ 3 Strip Template',
                          layout: LayoutDefinition.kho3(),
                          elements: _currentTemplate.elements,
                        );
                      });
                    } else {
                      setState(() {
                        _currentTemplate = TemplateDefinition.defaultWedding();
                      });
                    }
                  },
                ),
              ],
            ),
          ),

          // 2. Center — Interactive Template Canvas
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: _currentTemplate.layout.aspectRatio,
                child: Container(
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE7F3),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, 10)),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final cw = constraints.maxWidth;
                      final ch = constraints.maxHeight;

                      return Stack(
                        children: [
                          // Photo Slots Render
                          ..._currentTemplate.layout.photoSlots.map((slot) {
                            final isSelected = _selectedSlotIndex == slot.index;
                            return Positioned(
                              left: slot.x * cw,
                              top: slot.y * ch,
                              width: slot.width * cw,
                              height: slot.height * ch,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedSlotIndex = slot.index;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    border: Border.all(
                                      color: isSelected ? AppTheme.secondaryAccent : Colors.white,
                                      width: isSelected ? 4 : 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'SLOT #${slot.index + 1}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: cw * 0.03,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),

                          // Text Layers Render
                          ..._currentTemplate.elements.map((elem) {
                            return Positioned(
                              left: elem.x * cw,
                              top: elem.y * ch,
                              child: Text(
                                elem.content,
                                style: TextStyle(
                                  color: AppTheme.darkBackground,
                                  fontWeight: FontWeight.bold,
                                  fontSize: cw * 0.035,
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // 3. Right Sidebar — Properties Inspector
          Container(
            width: 260,
            color: AppTheme.surfaceColor,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PROPERTIES', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold, letterSpacing: 1)),
                const SizedBox(height: 16),
                if (_selectedSlotIndex != null) ...[
                  Text('Selected Slot: #${_selectedSlotIndex! + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text('X Position: 5.0%', style: TextStyle(color: AppTheme.textSecondary)),
                  const Text('Y Position: 4.0%', style: TextStyle(color: AppTheme.textSecondary)),
                  const Text('Width: 42.0%', style: TextStyle(color: AppTheme.textSecondary)),
                  const Text('Height: 20.0%', style: TextStyle(color: AppTheme.textSecondary)),
                ] else
                  const Text('Click on any canvas slot or element to inspect properties.', style: TextStyle(color: AppTheme.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarButton(IconData icon, String label, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: AppTheme.primaryAccent.withOpacity(0.4)),
          minimumSize: const Size(double.infinity, 44),
          alignment: Alignment.centerLeft,
        ),
        icon: Icon(icon, size: 20),
        label: Text(label),
        onPressed: onTap,
      ),
    );
  }
}
