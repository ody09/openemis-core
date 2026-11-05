<?php
declare(strict_types=1);

namespace App\SchoolMonitoring;

use DateTimeImmutable;
use IntlDateFormatter;

final class LocalizedDateInput
{
    public static function normalize(string $input): ?string
    {
        $input = trim($input);
        foreach (['!Y-m-d', '!d-m-Y', '!d/m/Y'] as $format) {
            $date = DateTimeImmutable::createFromFormat($format, $input);
            $errors = DateTimeImmutable::getLastErrors();
            if ($date && (!$errors || (!$errors['warning_count'] && !$errors['error_count']))) {
                return $date->format('Y-m-d');
            }
        }
        // The datepicker renders month names in the user's selected UI language.
        foreach (['ar', 'en', 'fr', 'es', 'ru', 'zh'] as $locale) {
            $parser = new IntlDateFormatter($locale, IntlDateFormatter::NONE, IntlDateFormatter::NONE, 'UTC', IntlDateFormatter::GREGORIAN, 'MMMM dd, yyyy');
            $parser->setLenient(false);
            $position = 0;
            $timestamp = $parser->parse($input, $position);
            if ($timestamp !== false && $position === mb_strlen($input, 'UTF-8')) {
                return gmdate('Y-m-d', $timestamp);
            }
        }
        return null;
    }
}
