<?php
declare(strict_types=1);

use App\SchoolMonitoring\LocalizedDateInput;
use PHPUnit\Framework\TestCase;

final class LocalizedDateInputTest extends TestCase
{
    /** @dataProvider dates */
    public function testDatePickerLabelsBecomeUnambiguousServerDates(string $input, ?string $expected): void
    {
        $this->assertTrue(class_exists(LocalizedDateInput::class), 'Localized date normalization is missing.');
        $this->assertSame($expected, LocalizedDateInput::normalize($input));
    }

    public static function dates(): array
    {
        return [
            ['يناير 01, 2025', '2025-01-01'], ['يناير 01, 1990', '1990-01-01'],
            ['نوفمبر 01, 2026', '2026-11-01'], ['January 01, 2025', '2025-01-01'],
            ['2025-01-01', '2025-01-01'], ['01-01-2025', '2025-01-01'],
            ['29-02-2024', '2024-02-29'], ['31-02-2025', null],
            ['يناير 01, 2025 garbage', null], ['', null],
        ];
    }
}
