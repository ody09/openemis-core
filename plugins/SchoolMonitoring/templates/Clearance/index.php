<?php
/** @var array $outstanding */
/** @var bool $cleared */
/** @var int $periodId */
/** @var int $personId */
?>
<h1>Textbook / supply clearance</h1>
<form method="get">
    <label>Academic period id <input name="academic_period_id" value="<?= h((string)$periodId) ?>"></label>
    <label>Person id <input name="security_user_id" value="<?= h((string)$personId) ?>"></label>
    <button type="submit">Check</button>
</form>
<?php if ($personId && $periodId): ?>
    <p>Status: <strong><?= $cleared ? 'Cleared' : 'Outstanding items remain' ?></strong></p>
    <p>This report does not block student transfer.</p>
    <?php if ($outstanding !== []): ?>
        <table>
            <thead><tr><th>Copy</th><th>Issued</th></tr></thead>
            <tbody>
            <?php foreach ($outstanding as $row): ?>
                <tr>
                    <td><?= h((string)$row['institution_textbook_id']) ?></td>
                    <td><?= h((string)$row['issued_at']) ?></td>
                </tr>
            <?php endforeach; ?>
            </tbody>
        </table>
    <?php endif; ?>
<?php endif; ?>
