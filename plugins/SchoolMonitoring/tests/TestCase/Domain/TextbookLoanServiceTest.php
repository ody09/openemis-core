<?php
declare(strict_types=1);

namespace SchoolMonitoring\Test\TestCase\Domain;

use PHPUnit\Framework\TestCase;
use SchoolMonitoring\Domain\TextbookLoanService;

final class TextbookLoanServiceTest extends TestCase
{
    public function testOpenAndClearance(): void
    {
        $pdo = SqliteFactory::pdo();
        $loans = new TextbookLoanService($pdo);
        $id = $loans->openLoan(10, 1, 50, 2);
        $this->assertGreaterThan(0, $id);
        $this->assertFalse($loans->isCleared(50, 1));
        $this->assertCount(1, $loans->outstandingForPerson(50, 1));
        $loans->closeLoan(10, 1, 2, TextbookLoanService::RETURNED);
        $this->assertTrue($loans->isCleared(50, 1));
    }

    public function testCannotDoubleIssueSameCopy(): void
    {
        $pdo = SqliteFactory::pdo();
        $loans = new TextbookLoanService($pdo);
        $loans->openLoan(10, 1, 50, 2);
        $this->expectException(\RuntimeException::class);
        $loans->openLoan(10, 1, 51, 2);
    }

    public function testRolloverCopiesOpenLoans(): void
    {
        $pdo = SqliteFactory::pdo();
        $loans = new TextbookLoanService($pdo);
        $loans->openLoan(10, 1, 50, 2);
        $copied = $loans->rolloverOpenLoans(1, 2, 2);
        $this->assertSame(1, $copied);
        $this->assertCount(1, $loans->outstandingForPeriod(2));
        $this->assertCount(1, $loans->outstandingForPeriod(1));
    }

    public function testInvalidOutcomeRejected(): void
    {
        $pdo = SqliteFactory::pdo();
        $loans = new TextbookLoanService($pdo);
        $loans->openLoan(10, 1, 50, 2);
        $this->expectException(\InvalidArgumentException::class);
        $loans->closeLoan(10, 1, 2, 'SOLD');
    }
}
