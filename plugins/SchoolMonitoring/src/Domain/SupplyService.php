<?php
declare(strict_types=1);

namespace SchoolMonitoring\Domain;

use PDO;

final class SupplyService
{
    public function __construct(private PDO $pdo)
    {
    }

    public function addStock(int $institutionId, int $itemId, int $quantity): void
    {
        $find = $this->pdo->prepare('SELECT id, quantity FROM sm_supply_stock WHERE institution_id = ? AND item_id = ?');
        $find->execute([$institutionId, $itemId]);
        $row = $find->fetch(PDO::FETCH_ASSOC);
        if ($row) {
            $this->pdo->prepare('UPDATE sm_supply_stock SET quantity = ? WHERE id = ?')
                ->execute([(int)$row['quantity'] + $quantity, $row['id']]);
            return;
        }
        $this->pdo->prepare('INSERT INTO sm_supply_stock (institution_id, item_id, quantity) VALUES (?, ?, ?)')
            ->execute([$institutionId, $itemId, $quantity]);
    }

    public function issue(int $institutionId, int $periodId, int $itemId, int $userId, int $quantity, int $issuedBy): int
    {
        $stock = $this->pdo->prepare('SELECT id, quantity FROM sm_supply_stock WHERE institution_id = ? AND item_id = ?');
        $stock->execute([$institutionId, $itemId]);
        $row = $stock->fetch(PDO::FETCH_ASSOC);
        if (!$row || (int)$row['quantity'] < $quantity) {
            throw new \RuntimeException('insufficient_stock');
        }
        $this->pdo->prepare('UPDATE sm_supply_stock SET quantity = quantity - ? WHERE id = ?')->execute([$quantity, $row['id']]);
        $this->pdo->prepare(
            'INSERT INTO sm_supply_issues (institution_id, academic_period_id, item_id, security_user_id, quantity_issued, issued_at, issued_by)
             VALUES (?, ?, ?, ?, ?, ?, ?)'
        )->execute([$institutionId, $periodId, $itemId, $userId, $quantity, gmdate('Y-m-d H:i:s'), $issuedBy]);

        return (int)$this->pdo->lastInsertId();
    }

    public function returnItem(int $issueId, int $quantity, string $outcome = 'RETURNED'): void
    {
        $stmt = $this->pdo->prepare('SELECT * FROM sm_supply_issues WHERE id = ?');
        $stmt->execute([$issueId]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$row) {
            throw new \RuntimeException('issue_not_found');
        }
        $remaining = (int)$row['quantity_issued'] - (int)$row['quantity_returned'];
        if ($quantity > $remaining) {
            throw new \RuntimeException('return_exceeds_issued');
        }
        $this->pdo->prepare('UPDATE sm_supply_issues SET quantity_returned = quantity_returned + ?, returned_at = ?, return_outcome = ? WHERE id = ?')
            ->execute([$quantity, gmdate('Y-m-d H:i:s'), $outcome, $issueId]);
        $this->addStock((int)$row['institution_id'], (int)$row['item_id'], $quantity);
    }
}
