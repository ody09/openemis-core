<?php
declare(strict_types=1);

namespace SchoolMonitoring\Domain;

use PDO;

final class TextbookLoanService
{
    public const RETURNED = 'RETURNED';
    public const DAMAGED = 'DAMAGED';
    public const LOST = 'LOST';

    public function __construct(private PDO $pdo)
    {
    }

    public function openLoan(int $copyId, int $periodId, int $userId, int $issuedBy, ?string $dueDate = null): int
    {
        $open = $this->pdo->prepare(
            'SELECT id FROM sm_textbook_loans WHERE institution_textbook_id = ? AND academic_period_id = ? AND returned_at IS NULL'
        );
        $open->execute([$copyId, $periodId]);
        if ($open->fetchColumn()) {
            throw new \RuntimeException('copy_already_on_loan');
        }
        $stmt = $this->pdo->prepare(
            'INSERT INTO sm_textbook_loans (institution_textbook_id, academic_period_id, security_user_id, issued_at, issued_by, due_date)
             VALUES (?, ?, ?, ?, ?, ?)'
        );
        $stmt->execute([$copyId, $periodId, $userId, gmdate('Y-m-d H:i:s'), $issuedBy, $dueDate]);

        return (int)$this->pdo->lastInsertId();
    }

    public function closeLoan(int $copyId, int $periodId, int $receivedBy, string $outcome, ?int $conditionId = null, ?string $notes = null): void
    {
        if (!in_array($outcome, [self::RETURNED, self::DAMAGED, self::LOST], true)) {
            throw new \InvalidArgumentException('invalid_outcome');
        }
        $stmt = $this->pdo->prepare(
            'UPDATE sm_textbook_loans SET returned_at = ?, received_by = ?, return_outcome = ?, return_condition_id = ?, notes = ?
             WHERE institution_textbook_id = ? AND academic_period_id = ? AND returned_at IS NULL'
        );
        $stmt->execute([gmdate('Y-m-d H:i:s'), $receivedBy, $outcome, $conditionId, $notes, $copyId, $periodId]);
        if ($stmt->rowCount() === 0) {
            throw new \RuntimeException('no_open_loan');
        }
    }

    /** @return list<array<string, mixed>> */
    public function outstandingForPerson(int $userId, int $periodId): array
    {
        $stmt = $this->pdo->prepare(
            'SELECT * FROM sm_textbook_loans WHERE security_user_id = ? AND academic_period_id = ? AND returned_at IS NULL'
        );
        $stmt->execute([$userId, $periodId]);

        return $stmt->fetchAll(PDO::FETCH_ASSOC) ?: [];
    }

    public function isCleared(int $userId, int $periodId): bool
    {
        return $this->outstandingForPerson($userId, $periodId) === [];
    }

    /** @return list<array<string, mixed>> */
    public function outstandingForPeriod(int $periodId): array
    {
        $stmt = $this->pdo->prepare(
            'SELECT * FROM sm_textbook_loans WHERE academic_period_id = ? AND returned_at IS NULL'
        );
        $stmt->execute([$periodId]);

        return $stmt->fetchAll(PDO::FETCH_ASSOC) ?: [];
    }

    public function rolloverOpenLoans(int $fromPeriod, int $toPeriod, int $actorId): int
    {
        $copied = 0;
        foreach ($this->outstandingForPeriod($fromPeriod) as $loan) {
            try {
                $this->openLoan(
                    (int)$loan['institution_textbook_id'],
                    $toPeriod,
                    (int)$loan['security_user_id'],
                    $actorId,
                    $loan['due_date'] ?? null
                );
                $copied++;
            } catch (\RuntimeException $e) {
                // Already open in the destination period.
            }
        }

        return $copied;
    }
}
