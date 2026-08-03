// ignore_for_file: avoid_positional_boolean_parameters

import 'package:test/test.dart';
import 'package:glados/glados.dart';

import 'package:confaero_app/features/Events/data/models/invited_event_model.dart';

/// Helper to build a minimal valid JSON map for [InvitedEventModel.fromJson].
Map<String, dynamic> _baseJson({dynamic isregistration = 'pending'}) => {
      '_id': 'event123',
      'title': 'Flutter Conference 2025',
      'location': 'Sydney, Australia',
      'startDate': '2025-08-10T09:00:00.000Z',
      'endDate': '2025-08-12T18:00:00.000Z',
      'bannerImageUrl': 'https://example.com/banner.jpg',
      'isregistration': isregistration,
      'invitationId': 'inv456',
      'role': 'SPEAKER',
    };

/// Minimal [InvitedEventModel] with the given [isregistration] value.
InvitedEventModel _model(dynamic isregistration) => InvitedEventModel(
      id: 'id',
      title: 'title',
      location: 'loc',
      startDate: DateTime(2025),
      endDate: DateTime(2025, 12),
      isregistration: isregistration,
      invitationId: 'inv',
      role: 'SPEAKER',
    );

void main() {
  // ─── fromJson field extraction (subtask 1.1) ────────────────────────────────

  group('InvitedEventModel — fromJson field extraction', () {
    test('parses all fields correctly from JSON', () {
      final model = InvitedEventModel.fromJson(_baseJson());

      expect(model.id, equals('event123'));
      expect(model.title, equals('Flutter Conference 2025'));
      expect(model.location, equals('Sydney, Australia'));
      expect(model.startDate, equals(DateTime.parse('2025-08-10T09:00:00.000Z')));
      expect(model.endDate, equals(DateTime.parse('2025-08-12T18:00:00.000Z')));
      expect(model.bannerImageUrl, equals('https://example.com/banner.jpg'));
      expect(model.invitationId, equals('inv456'));
      expect(model.role, equals('SPEAKER'));
    });

    test('parses injected invitationId and role correctly', () {
      final json = _baseJson()
        ..['invitationId'] = 'myInv'
        ..['role'] = 'VOLUNTEER';
      final model = InvitedEventModel.fromJson(json);

      expect(model.invitationId, equals('myInv'));
      expect(model.role, equals('VOLUNTEER'));
    });

    test('bannerImageUrl is null when absent from JSON', () {
      final json = _baseJson();
      json.remove('bannerImageUrl');
      final model = InvitedEventModel.fromJson(json);

      expect(model.bannerImageUrl, isNull);
    });

    test('preserves raw isregistration without coercion — "pending" string', () {
      final model = InvitedEventModel.fromJson(_baseJson(isregistration: 'pending'));
      expect(model.isregistration, equals('pending'));
      expect(model.isregistration, isA<String>());
    });

    test('preserves raw isregistration without coercion — bool true', () {
      final model = InvitedEventModel.fromJson(_baseJson(isregistration: true));
      expect(model.isregistration, equals(true));
      expect(model.isregistration, isA<bool>());
    });
  });

  // ─── isPending getter (subtask 1.1) ─────────────────────────────────────────

  group('InvitedEventModel — isPending getter', () {
    test('isPending is true when isregistration is "pending" (String)', () {
      expect(
        InvitedEventModel.fromJson(_baseJson(isregistration: 'pending')).isPending,
        isTrue,
      );
    });

    test('isPending is true when isregistration is null', () {
      final json = _baseJson()..['isregistration'] = null;
      expect(InvitedEventModel.fromJson(json).isPending, isTrue);
    });

    test('isPending is true when isregistration is false (bool)', () {
      expect(
        InvitedEventModel.fromJson(_baseJson(isregistration: false)).isPending,
        isTrue,
      );
    });

    test('isPending is true when isregistration is an unrecognised string', () {
      expect(
        InvitedEventModel.fromJson(
          _baseJson(isregistration: 'some_other_string'),
        ).isPending,
        isTrue,
      );
    });

    test('isPending is false when isregistration is true (bool)', () {
      expect(
        InvitedEventModel.fromJson(_baseJson(isregistration: true)).isPending,
        isFalse,
      );
    });
  });

  // ─── isAccepted getter (subtask 1.1) ────────────────────────────────────────

  group('InvitedEventModel — isAccepted getter', () {
    test('isAccepted is false when isregistration is "pending"', () {
      expect(
        InvitedEventModel.fromJson(_baseJson(isregistration: 'pending')).isAccepted,
        isFalse,
      );
    });

    test('isAccepted is true when isregistration is true (bool)', () {
      expect(
        InvitedEventModel.fromJson(_baseJson(isregistration: true)).isAccepted,
        isTrue,
      );
    });

    test('isAccepted is false when isregistration is null', () {
      final json = _baseJson()..['isregistration'] = null;
      expect(InvitedEventModel.fromJson(json).isAccepted, isFalse);
    });

    test('isAccepted is false when isregistration is false (bool)', () {
      expect(
        InvitedEventModel.fromJson(_baseJson(isregistration: false)).isAccepted,
        isFalse,
      );
    });

    test('isAccepted is false when isregistration is an unrecognised string', () {
      expect(
        InvitedEventModel.fromJson(
          _baseJson(isregistration: 'some_other_string'),
        ).isAccepted,
        isFalse,
      );
    });
  });

  // ─── Mutual exclusivity (subtask 1.1) ───────────────────────────────────────

  group('InvitedEventModel — mutual exclusivity (isPending + isAccepted)', () {
    test('isregistration="pending" → isPending=true, isAccepted=false', () {
      final m = InvitedEventModel.fromJson(_baseJson(isregistration: 'pending'));
      expect(m.isPending, isTrue);
      expect(m.isAccepted, isFalse);
    });

    test('isregistration=true → isPending=false, isAccepted=true', () {
      final m = InvitedEventModel.fromJson(_baseJson(isregistration: true));
      expect(m.isPending, isFalse);
      expect(m.isAccepted, isTrue);
    });

    test('isregistration=null → isPending=true, isAccepted=false', () {
      final json = _baseJson()..['isregistration'] = null;
      final m = InvitedEventModel.fromJson(json);
      expect(m.isPending, isTrue);
      expect(m.isAccepted, isFalse);
    });

    test('isregistration=false → isPending=true, isAccepted=false', () {
      final m = InvitedEventModel.fromJson(_baseJson(isregistration: false));
      expect(m.isPending, isTrue);
      expect(m.isAccepted, isFalse);
    });

    test('isregistration="some_other_string" → isPending=true, isAccepted=false', () {
      final m = InvitedEventModel.fromJson(
        _baseJson(isregistration: 'some_other_string'),
      );
      expect(m.isPending, isTrue);
      expect(m.isAccepted, isFalse);
    });
  });

  // ─── formattedDateRange (subtask 1.1) ───────────────────────────────────────

  group('InvitedEventModel — formattedDateRange', () {
    test('same month and year formats as "Mon DD-DD, YYYY"', () {
      // startDate = 2025-08-10, endDate = 2025-08-12
      final model = InvitedEventModel.fromJson(_baseJson());
      expect(model.formattedDateRange, equals('Aug 10-12, 2025'));
    });

    test('different months formats as "Mon DD - Mon DD, YYYY"', () {
      final json = _baseJson()
        ..['startDate'] = '2026-06-22T09:00:00.000Z'
        ..['endDate'] = '2026-07-05T18:00:00.000Z';
      final model = InvitedEventModel.fromJson(json);
      expect(model.formattedDateRange, equals('Jun 22 - Jul 5, 2026'));
    });

    test('different years formats as "Mon DD - Mon DD, YYYY" using endDate year', () {
      final json = _baseJson()
        ..['startDate'] = '2026-12-28T09:00:00.000Z'
        ..['endDate'] = '2027-01-03T18:00:00.000Z';
      final model = InvitedEventModel.fromJson(json);
      expect(model.formattedDateRange, equals('Dec 28 - Jan 3, 2027'));
    });
  });

  // ─── Property 3: isregistration parsing (subtask 1.2) ───────────────────────
  // Feature: invited-events-role-access, Property 3: isregistration parsing — non-pending values default to pending

  group('Property 3: isregistration parsing — non-pending values default to pending', () {
    // Any letterOrDigits String (including "pending") → isPending=true, isAccepted=false
    Glados(any.letterOrDigits).test(
      'any String isregistration → isPending=true, isAccepted=false',
      (s) {
        final model = _model(s);
        expect(
          model.isPending,
          isTrue,
          reason: 'String "$s" should yield isPending=true',
        );
        expect(
          model.isAccepted,
          isFalse,
          reason: 'String "$s" should yield isAccepted=false',
        );
      },
    );

    // null → pending
    test('null isregistration → isPending=true, isAccepted=false', () {
      final model = _model(null);
      expect(model.isPending, isTrue);
      expect(model.isAccepted, isFalse);
    });

    // false (bool) → pending
    test('false (bool) isregistration → isPending=true, isAccepted=false', () {
      final model = _model(false);
      expect(model.isPending, isTrue);
      expect(model.isAccepted, isFalse);
    });

    // true (bool) → accepted (the only non-pending value)
    test('true (bool) isregistration → isPending=false, isAccepted=true', () {
      final model = _model(true);
      expect(model.isPending, isFalse);
      expect(model.isAccepted, isTrue);
    });

    // isPending and isAccepted are always mutually exclusive for any String
    Glados(any.letterOrDigits).test(
      'isPending and isAccepted are never both true for any String',
      (s) {
        final model = _model(s);
        expect(
          model.isPending && model.isAccepted,
          isFalse,
          reason: 'isPending and isAccepted cannot both be true',
        );
      },
    );
  });
}
