<?php
declare(strict_types=1);

namespace SchoolMonitoring\Test\TestCase\Domain;

use PHPUnit\Framework\TestCase;
use SchoolMonitoring\Domain\SupplyService;

final class SupplyServiceTest extends TestCase
{
    public function testIssueAndReturn(): void
    {
        $pdo = SqliteFactory::pdo();
        $pdo->exec("INSERT INTO sm_supply_items (code, name) VALUES ('NB', 'Notebook')");
        $itemId = (int)$pdo->lastInsertId();
        $supplies = new SupplyService($pdo);
        $supplies->addStock(3, $itemId, 10);
        $issueId = $supplies->issue(3, 1, $itemId, 50, 2, 9);
        $this->assertGreaterThan(0, $issueId);
        $qty = (int)$pdo->query('SELECT quantity FROM sm_supply_stock WHERE item_id = ' . $itemId)->fetchColumn();
        $this->assertSame(8, $qty);
        $supplies->returnItem($issueId, 2);
        $qty = (int)$pdo->query('SELECT quantity FROM sm_supply_stock WHERE item_id = ' . $itemId)->fetchColumn();
        $this->assertSame(10, $qty);
    }

    public function testInsufficientStock(): void
    {
        $pdo = SqliteFactory::pdo();
        $pdo->exec("INSERT INTO sm_supply_items (code, name) VALUES ('NB', 'Notebook')");
        $itemId = (int)$pdo->lastInsertId();
        $this->expectException(\RuntimeException::class);
        (new SupplyService($pdo))->issue(3, 1, $itemId, 50, 1, 9);
    }
}
