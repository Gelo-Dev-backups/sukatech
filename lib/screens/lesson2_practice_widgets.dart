part of 'lesson2_practice_screen.dart';

// ---------------------------------------------------------
// REUSABLE TOOL ICONS (Procedurally drawn for simplicity)
// ---------------------------------------------------------

class _ToolIcon extends StatelessWidget {
  const _ToolIcon({required this.toolName, this.size = 64});
  final String toolName;
  final double size;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (toolName) {
      case 'Tape Measure':
        icon = Icons.straighten_rounded;
        color = const Color(0xFFFDD835); // Yellow tape
        break;
      case 'Steel Rule':
        icon = Icons.linear_scale_rounded;
        color = const Color(0xFF9E9E9E); // Silver/grey
        break;
      case 'Try Square':
        icon = Icons.architecture_rounded;
        color = const Color(0xFF8D6E63); // Wood handle
        break;
      case 'Straight Edge':
        icon = Icons.horizontal_rule_rounded;
        color = const Color(0xFFB0BEC5); // Metal edge
        break;
      case 'Vernier Caliper':
        icon = Icons.tune_rounded;
        color = const Color(0xFF78909C); // Metal caliper
        break;
      case 'Folding Rule':
        icon = Icons.timeline_rounded;
        color = const Color(0xFFFFCC80); // Wooden sections
        break;
      default:
        icon = Icons.build_rounded;
        color = PracticeStyles.navy;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
      ),
      child: Center(
        child: Icon(icon, color: color, size: size * 0.5),
      ),
    );
  }
}

// ---------------------------------------------------------
// CONNECT DOTS ACTIVITY (Activities 1, 6, 7)
// ---------------------------------------------------------

class _ConnectDotsActivity extends StatefulWidget {
  const _ConnectDotsActivity({
    required this.pairs,
    required this.onAllMatched,
  });

  final Map<String, String> pairs;
  final VoidCallback onAllMatched;

  @override
  State<_ConnectDotsActivity> createState() => _ConnectDotsActivityState();
}

class _ConnectDotsActivityState extends State<_ConnectDotsActivity> {
  late List<String> leftItems;
  late List<String> rightItems;

  String? selectedLeft;
  String? errorPair;
  final Map<String, String> matches = {};

  @override
  void initState() {
    super.initState();
    leftItems = widget.pairs.keys.toList()..shuffle();
    rightItems = widget.pairs.values.toList()..shuffle();
  }

  void _onTapLeft(String left) {
    if (matches.containsKey(left)) return;
    setState(() {
      selectedLeft = selectedLeft == left ? null : left;
      errorPair = null;
    });
  }

  void _onTapRight(String right) {
    if (selectedLeft == null) return;
    if (matches.containsValue(right)) return;

    if (widget.pairs[selectedLeft] == right) {
      // Correct Match
      setState(() {
        matches[selectedLeft!] = right;
        selectedLeft = null;
        errorPair = null;
      });
      if (matches.length == widget.pairs.length) {
        widget.onAllMatched();
      }
    } else {
      // Incorrect Match
      setState(() {
        errorPair = '$selectedLeft-$right';
      });
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            errorPair = null;
            selectedLeft = null;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (matches.length == widget.pairs.length)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Great! You matched all the items!',
              style: TextStyle(
                color: PracticeStyles.green,
                fontSize: 14,
                fontFamily: PracticeStyles.montserrat,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // LEFT COLUMN
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: leftItems.map((l) {
                  final matched = matches.containsKey(l);
                  final selected = selectedLeft == l;
                  final isError = errorPair?.startsWith('$l-') ?? false;

                  Color bg = Colors.white;
                  Color border = const Color(0xFFDDE0E8);
                  Color text = PracticeStyles.navy;

                  if (matched) {
                    bg = PracticeStyles.green.withValues(alpha: 0.1);
                    border = PracticeStyles.green;
                    text = PracticeStyles.green;
                  } else if (isError) {
                    bg = PracticeStyles.red.withValues(alpha: 0.1);
                    border = PracticeStyles.red;
                  } else if (selected) {
                    bg = PracticeStyles.accent.withValues(alpha: 0.15);
                    border = PracticeStyles.accent;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () => _onTapLeft(l),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: border, width: matched || selected ? 2 : 1),
                        ),
                        child: Text(
                          l,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: text,
                            fontSize: 12,
                            fontFamily: PracticeStyles.montserrat,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 16),
            // RIGHT COLUMN
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: rightItems.map((r) {
                  final matched = matches.containsValue(r);
                  final isError = errorPair?.endsWith('-$r') ?? false;

                  Color bg = Colors.white;
                  Color border = const Color(0xFFDDE0E8);
                  Color text = PracticeStyles.navy;

                  if (matched) {
                    bg = PracticeStyles.green.withValues(alpha: 0.1);
                    border = PracticeStyles.green;
                    text = PracticeStyles.green;
                  } else if (isError) {
                    bg = PracticeStyles.red.withValues(alpha: 0.1);
                    border = PracticeStyles.red;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () => _onTapRight(r),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: border, width: matched ? 2 : 1),
                        ),
                        child: Text(
                          r,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: text,
                            fontSize: 12,
                            fontFamily: PracticeStyles.montserrat,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------
// DRAG TO TASK (Activity 2)
// ---------------------------------------------------------

class _DragToTaskActivity extends StatelessWidget {
  const _DragToTaskActivity({
    required this.task,
    required this.toolChoices,
    required this.correctTool,
    required this.submitted,
    required this.droppedTool,
    required this.onDrop,
  });

  final String task;
  final List<String> toolChoices;
  final String correctTool;
  final bool submitted;
  final String? droppedTool;
  final void Function(String?) onDrop;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: PracticeStyles.navy.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              const Text(
                'TASK',
                style: TextStyle(
                  color: PracticeStyles.navy,
                  fontSize: 10,
                  fontFamily: PracticeStyles.montserrat,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                task,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: PracticeStyles.navy,
                  fontSize: 15,
                  fontFamily: PracticeStyles.montserrat,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              DragTarget<String>(
                onWillAcceptWithDetails: (d) => !submitted,
                onAcceptWithDetails: (d) => onDrop(d.data),
                builder: (context, candidateData, rejectedData) {
                  final hovering = candidateData.isNotEmpty;
                  Color borderColor = const Color(0xFFDDE0E8);
                  if (hovering) borderColor = PracticeStyles.accent;
                  if (submitted) {
                    borderColor = droppedTool == correctTool ? PracticeStyles.green : PracticeStyles.red;
                  }

                  return Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: hovering ? PracticeStyles.accent.withValues(alpha: 0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: droppedTool != null
                        ? GestureDetector(
                            onTap: submitted ? null : () => onDrop(null),
                            child: Center(
                              child: _DraggableToolCard(toolName: droppedTool!, isDragging: false, active: true),
                            ),
                          )
                        : Center(
                            child: Text(
                              'Drop correct tool here',
                              style: TextStyle(
                                color: PracticeStyles.navy.withValues(alpha: 0.4),
                                fontSize: 13,
                                fontFamily: PracticeStyles.montserrat,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (droppedTool == null)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: toolChoices.map((t) {
              return Draggable<String>(
                data: t,
                feedback: Material(
                  color: Colors.transparent,
                  child: _DraggableToolCard(toolName: t, isDragging: true, active: true),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: _DraggableToolCard(toolName: t, isDragging: false, active: false),
                ),
                child: _DraggableToolCard(toolName: t, isDragging: false, active: true),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class _DraggableToolCard extends StatelessWidget {
  const _DraggableToolCard({required this.toolName, required this.isDragging, required this.active});
  final String toolName;
  final bool isDragging;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? PracticeStyles.navy : PracticeStyles.navy.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDragging
            ? [BoxShadow(color: PracticeStyles.navy.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.handyman_rounded, color: Colors.white.withValues(alpha: 0.8), size: 14),
          const SizedBox(width: 6),
          Text(
            toolName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontFamily: PracticeStyles.montserrat,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// SORTING ACTIVITY (Activities 4 and 9)
// ---------------------------------------------------------

class _GenericSortActivity extends StatelessWidget {
  const _GenericSortActivity({
    required this.categories,
    required this.unassignedItems,
    required this.assignments,
    required this.submitted,
    required this.onAssign,
  });

  final List<({String name, Color color, List<String> correctItems})> categories;
  final List<String> unassignedItems;
  final Map<String, String?> assignments;
  final bool submitted;
  final void Function(String item, String? category) onAssign;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (unassignedItems.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: unassignedItems.map((item) {
              final card = _SortItemCard(text: item);
              if (submitted) return card;
              return Draggable<String>(
                data: item,
                feedback: Material(color: Colors.transparent, child: _SortItemCard(text: item, elevated: true)),
                childWhenDragging: Opacity(opacity: 0.3, child: card),
                child: card,
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categories.map((cat) {
            final itemsInCat = assignments.entries.where((e) => e.value == cat.name).map((e) => e.key).toList();
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: cat == categories.last ? 0 : 8),
                child: DragTarget<String>(
                  onWillAcceptWithDetails: (d) => !submitted,
                  onAcceptWithDetails: (d) => onAssign(d.data, cat.name),
                  builder: (context, candidateData, rejectedData) {
                    final hovering = candidateData.isNotEmpty;
                    return Container(
                      constraints: const BoxConstraints(minHeight: 120),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: hovering ? cat.color.withValues(alpha: 0.15) : cat.color.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: hovering ? cat.color : cat.color.withValues(alpha: 0.3),
                          width: hovering ? 2 : 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            cat.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: cat.color,
                              fontSize: 10,
                              fontFamily: PracticeStyles.montserrat,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...itemsInCat.map((item) {
                            final isCorrect = cat.correctItems.contains(item);
                            final color = submitted ? (isCorrect ? PracticeStyles.green : PracticeStyles.red) : PracticeStyles.navy;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: GestureDetector(
                                onTap: submitted ? null : () => onAssign(item, null),
                                child: _SortItemCard(text: item, overrideColor: color),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SortItemCard extends StatelessWidget {
  const _SortItemCard({required this.text, this.elevated = false, this.overrideColor});
  final String text;
  final bool elevated;
  final Color? overrideColor;

  @override
  Widget build(BuildContext context) {
    final color = overrideColor ?? const Color(0xFF5C6B80);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1.5),
        boxShadow: elevated
            ? [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 6, offset: const Offset(0, 3))]
            : null,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontFamily: PracticeStyles.montserrat,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
