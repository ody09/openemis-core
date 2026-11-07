<?php
/** @var array $rows */
/** @var int $periodId */
/** @var int $personId */
?>
<h1>Textbook loans</h1>
<form method="get">
    <label>Academic period id <input name="academic_period_id" value="<?= h((string)$periodId) ?>"></label>
    <label>Person id <input name="security_user_id" value="<?= h((string)$personId) ?>"></label>
    <button type="submit">Show</button>
</form>
<?php if ($rows === []): ?>
    <p>No outstanding loans.</p>
<?php else: ?>
<table>
    <thead><tr><th>Copy</th><th>Issued</th><th>Due</th><th></th></tr></thead>
    <tbody>
    <?php foreach ($rows as $row): ?>
        <tr>
            <td><?= h((string)$row['institution_textbook_id']) ?></td>
            <td><?= h((string)$row['issued_at']) ?></td>
            <td><?= h((string)$row['due_date']) ?></td>
            <td>
                <?= $this->Form->create(null, ['url' => ['plugin' => 'SchoolMonitoring', 'controller' => 'TextbookLoans', 'action' => 'returnCopy']]) ?>
                <input type="hidden" name="institution_textbook_id" value="<?= h((string)$row['institution_textbook_id']) ?>">
                <input type="hidden" name="academic_period_id" value="<?= h((string)$row['academic_period_id']) ?>">
                <select name="outcome">
                    <option value="RETURNED">Returned</option>
                    <option value="DAMAGED">Damaged</option>
                    <option value="LOST">Lost</option>
                </select>
                <button type="submit">Close loan</button>
                <?= $this->Form->end() ?>
            </td>
        </tr>
    <?php endforeach; ?>
    </tbody>
</table>
<?php endif; ?>
<p>Student transfer is not blocked by outstanding items.</p>
