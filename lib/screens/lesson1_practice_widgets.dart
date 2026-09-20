part of 'lesson1_practice_screen.dart';

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});
  final _QType type;

  @override
  Widget build(BuildContext context) {
    final (label, icon, color) = switch (type) {
      _QType.identifyDimension => (
          'Identify the Dimension',
          Icons.straighten_rounded,
          const Color(0xFF1565C0),
        ),
      _QType.fillInBlank => (
          'Fill in the Blank — Choose the Unit',
          Icons.tune_rounded,
          const Color(0xFF2E7D32),
        ),
      _QType.metricVsEnglish => (
          'Sort the Units — Drag & Drop',
          Icons.compare_arrows_rounded,
          const Color(0xFF6A1B9A),
        ),
      _QType.whatIsMeasured => (
          'What Is Being Measured?',
          Icons.help_outline_rounded,
          const Color(0xFFE65100),
        ),
      _QType.carpenterDecision => (
          'Carpenter Decision',
          Icons.handyman_rounded,
          const Color(0xFF4E342E),
        ),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.30)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontFamily: _montserrat,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BoardCard extends StatelessWidget {
  const _BoardCard(
      {this.dimensionKey, required this.answered, required this.correct});
  final String? dimensionKey;
  final bool answered;
  final bool correct;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF8EE), Color(0xFFF9F0E0)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4A853).withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4A853).withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _BoardPainter(
          highlight: answered ? dimensionKey : null,
          highlightCorrect: correct,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _BoardPainter extends CustomPainter {
  const _BoardPainter({this.highlight, required this.highlightCorrect});
  final String? highlight;
  final bool highlightCorrect;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final br = Rect.fromLTWH(w * 0.18, h * 0.22, w * 0.50, h * 0.44);
    final brr = RRect.fromRectAndRadius(br, const Radius.circular(6));

    canvas.drawRRect(brr, Paint()..color = const Color(0xFFD4A853));
    final grain = Paint()
      ..color = const Color(0xFFB8893A).withValues(alpha: 0.4)
      ..strokeWidth = 0.8;
    for (var i = 0; i < 6; i++) {
      final y = br.top + 4 + i * br.height / 6.5;
      canvas.drawLine(Offset(br.left + 4, y), Offset(br.right - 4, y), grain);
    }
    canvas.drawRRect(
      brr,
      Paint()
        ..color = const Color(0xFF8B6520)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    final hl = highlight ?? '';
    final hlColor = highlightCorrect ? _green : _red;

    void dblArrow(Offset a, Offset b, Color col) {
      final p = Paint()
        ..color = col
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(a, b, p);
      for (final end in [a, b]) {
        final dir = end == b ? b - a : a - b;
        final len = dir.distance;
        if (len == 0) return;
        final n = dir / len;
        final perp = Offset(-n.dy, n.dx);
        const tl = 5.5;
        canvas.drawLine(end, end - n * tl + perp * tl * 0.5, p);
        canvas.drawLine(end, end - n * tl - perp * tl * 0.5, p);
      }
    }

    void lbl(String text, Offset center, Color col,
        {double fs = 8.5, bool bg = false}) {
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
              color: col, fontSize: fs, fontWeight: FontWeight.w800),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      if (bg) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: center, width: tp.width + 8, height: tp.height + 4),
            const Radius.circular(4),
          ),
          Paint()..color = col.withValues(alpha: 0.15),
        );
      }
      tp.paint(
          canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
    }

    Color dim(String key) =>
        hl == key ? hlColor : _navy.withValues(alpha: 0.55);

    // LENGTH (bottom)
    final ly = br.bottom + 16;
    dblArrow(Offset(br.left, ly), Offset(br.right, ly), dim('length'));
    lbl('LENGTH', Offset(br.center.dx, ly + 10), dim('length'),
        bg: hl == 'length');

    // WIDTH (right)
    final rx = br.right + 20;
    dblArrow(Offset(rx, br.top), Offset(rx, br.bottom), dim('width'));
    canvas.save();
    canvas.translate(rx + 12, br.center.dy);
    canvas.rotate(1.5708);
    lbl('WIDTH', Offset.zero, dim('width'), bg: hl == 'width');
    canvas.restore();

    // THICKNESS (corner)
    final tc = dim('thickness');
    canvas.drawLine(
      Offset(br.left + 10, br.top + 7),
      Offset(br.left - 5, br.top - 6),
      Paint()
        ..color = tc
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round,
    );
    lbl('THICK.', Offset(br.left - 1, br.top - 14), tc,
        fs: 7.5, bg: hl == 'thickness');

    // HEIGHT (left — faint unless highlighted)
    if (hl == 'height') {
      final hx = br.left - 22;
      dblArrow(Offset(hx, br.top), Offset(hx, br.bottom), hlColor);
      canvas.save();
      canvas.translate(hx - 12, br.center.dy);
      canvas.rotate(-1.5708);
      lbl('HEIGHT', Offset.zero, hlColor, bg: true);
      canvas.restore();
    } else {
      final hx = br.left - 14;
      canvas.drawLine(Offset(hx, br.top), Offset(hx, br.bottom),
          Paint()
            ..color = _navy.withValues(alpha: 0.25)
            ..strokeWidth = 1.0);
      lbl('HT.', Offset(hx - 7, br.center.dy), _navy.withValues(alpha: 0.25),
          fs: 7);
    }
  }

  @override
  bool shouldRepaint(_BoardPainter old) =>
      old.highlight != highlight || old.highlightCorrect != highlightCorrect;
}

class _FillBlankCard extends StatelessWidget {
  const _FillBlankCard({required this.blankWord, required this.answered});
  final String blankWord;
  final bool answered;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F3260), _navy],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.straighten_rounded,
              color: Colors.white.withValues(alpha: 0.4), size: 32),
          const SizedBox(width: 22),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Measurement Unit',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 9,
                  fontFamily: _montserrat,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                decoration: BoxDecoration(
                  color: answered
                      ? _accent.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: answered ? _accent : Colors.white30,
                      width: answered ? 2 : 1),
                ),
                child: Text(
                  answered ? blankWord : '?',
                  style: TextStyle(
                    color: answered ? _accent : Colors.white60,
                    fontSize: answered ? 28 : 24,
                    fontFamily: _montserrat,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 22),
          Icon(Icons.square_foot_rounded,
              color: Colors.white.withValues(alpha: 0.4), size: 32),
        ],
      ),
    );
  }
}

class _FillBlankPrompt extends StatelessWidget {
  const _FillBlankPrompt(
      {required this.prompt,
      required this.answered,
      required this.selectedWord});
  final String prompt;
  final bool answered;
  final String? selectedWord;

  @override
  Widget build(BuildContext context) {
    final parts = prompt.split('___');
    if (parts.length != 2) return _plain(prompt);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.20)),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: _navy,
            fontSize: 16,
            fontFamily: _montserrat,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
          children: [
            TextSpan(text: parts[0]),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                  color: answered
                      ? _green.withValues(alpha: 0.15)
                      : _accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: answered ? _green : _accent,
                      width: answered ? 2 : 1.5),
                ),
                child: Text(
                  answered && selectedWord != null ? selectedWord! : '  ___  ',
                  style: TextStyle(
                    color: answered ? _green : _navy,
                    fontSize: 16,
                    fontFamily: _montserrat,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            TextSpan(text: parts[1]),
          ],
        ),
      ),
    );
  }

  Widget _plain(String text) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _navy.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: _navy,
            fontSize: 15,
            fontFamily: _montserrat,
            fontWeight: FontWeight.w700,
            height: 1.45,
          ),
        ),
      );
}

class _MetricEnglishInfoCard extends StatelessWidget {
  const _MetricEnglishInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _SysPreview('METRIC / SI', const ['mm', 'cm', 'm'],
              const Color(0xFF64B5F6)),
          Container(width: 1, height: 50, color: Colors.white24),
          _SysPreview(
              'ENGLISH', const ['in', 'ft'], const Color(0xFFFFCC80)),
        ],
      ),
    );
  }
}

class _SysPreview extends StatelessWidget {
  const _SysPreview(this.label, this.units, this.color);
  final String label;
  final List<String> units;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 9,
            fontFamily: _montserrat,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: units
              .map((u) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      u,
                      style: TextStyle(
                        color: color.withValues(alpha: 0.75),
                        fontSize: 13,
                        fontFamily: _montserrat,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _CarpenterCard extends StatelessWidget {
  const _CarpenterCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3E2723), Color(0xFF4E342E)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.handyman_rounded,
              color: Colors.white.withValues(alpha: 0.7), size: 36),
          const SizedBox(width: 20),
          Icon(Icons.straighten_rounded, color: _accent, size: 36),
          const SizedBox(width: 20),
          Icon(Icons.content_cut_rounded,
              color: Colors.white.withValues(alpha: 0.7), size: 36),
        ],
      ),
    );
  }
}

class _DragDropActivity extends StatelessWidget {
  const _DragDropActivity({
    required this.sortState,
    required this.submitted,
    required this.onAssign,
  });

  final _SortState sortState;
  final bool submitted;
  final void Function(String unit, String group) onAssign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          submitted
              ? (sortState.isAllCorrect
                  ? '✓ All units correctly sorted!'
                  : '✗ Some units are in the wrong group.')
              : 'Drag each card to the correct system box below.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: submitted
                ? (sortState.isAllCorrect ? _green : _red)
                : _navy.withValues(alpha: 0.6),
            fontSize: 12,
            fontFamily: _montserrat,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        if (sortState.unassigned.isNotEmpty) ...[
          Text(
            'UNIT CARDS — Drag to sort',
            style: TextStyle(
              color: _navy.withValues(alpha: 0.45),
              fontSize: 10,
              fontFamily: _montserrat,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sortState.unassigned
                .map(
                  (u) => submitted
                      ? _UnitCard(unit: u, color: _uColor(u))
                      : _DraggableUnit(unit: u, color: const Color(0xFF5C6B80)),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _DropZone(
                label: 'METRIC / SI',
                color: const Color(0xFF1565C0),
                units: sortState.groupUnits('metric'),
                submitted: submitted,
                correctUnits: _metricUnits,
                onAccept: submitted ? null : (u) => onAssign(u, 'metric'),
                onRemove: submitted ? null : (u) => onAssign(u, 'unassign'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _DropZone(
                label: 'ENGLISH',
                color: const Color(0xFFE65100),
                units: sortState.groupUnits('english'),
                submitted: submitted,
                correctUnits: _englishUnits,
                onAccept: submitted ? null : (u) => onAssign(u, 'english'),
                onRemove: submitted ? null : (u) => onAssign(u, 'unassign'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _uColor(String u) =>
      _metricUnits.contains(u) ? const Color(0xFF1565C0) : const Color(0xFFE65100);
}

class _DraggableUnit extends StatelessWidget {
  const _DraggableUnit({required this.unit, required this.color});
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final card = _UnitCard(unit: unit, color: color);
    return Draggable<String>(
      data: unit,
      feedback: Material(
        color: Colors.transparent,
        child: _UnitCard(unit: unit, color: color, elevated: true),
      ),
      childWhenDragging: Opacity(opacity: 0.25, child: card),
      child: card,
    );
  }
}

class _UnitCard extends StatelessWidget {
  const _UnitCard(
      {required this.unit, required this.color, this.elevated = false});
  final String unit;
  final Color color;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: elevated ? 2 : 1.5),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: color.withValues(alpha: 0.18),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Text(
        unit,
        style: TextStyle(
          color: color,
          fontSize: 18,
          fontFamily: _montserrat,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _DropZone extends StatelessWidget {
  const _DropZone({
    required this.label,
    required this.color,
    required this.units,
    required this.submitted,
    required this.correctUnits,
    this.onAccept,
    this.onRemove,
  });

  final String label;
  final Color color;
  final List<String> units;
  final bool submitted;
  final Set<String> correctUnits;
  final void Function(String)? onAccept;
  final void Function(String)? onRemove;

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (d) => !submitted,
      onAcceptWithDetails: (d) => onAccept?.call(d.data),
      builder: (context, candidateData, rejectedData) {
        final hovering = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          constraints: const BoxConstraints(minHeight: 120),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: hovering
                ? color.withValues(alpha: 0.16)
                : color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hovering ? color : color.withValues(alpha: 0.35),
              width: hovering ? 2.0 : 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontFamily: _montserrat,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: units.map((u) {
                  final ok = correctUnits.contains(u);
                  final c = submitted ? (ok ? _green : _red) : color;
                  return GestureDetector(
                    onTap: submitted ? null : () => onRemove?.call(u),
                    child: _UnitCard(unit: u, color: c),
                  );
                }).toList(),
              ),
              if (units.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    hovering ? 'Release to drop!' : 'Drop here',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: hovering ? color : color.withValues(alpha: 0.38),
                      fontSize: 11,
                      fontFamily: _montserrat,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

