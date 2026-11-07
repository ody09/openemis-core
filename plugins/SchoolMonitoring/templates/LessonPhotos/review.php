<?php
/**
 * @var string $date
 * @var int $institutionId
 * @var list<array<string, mixed>> $lessons
 */
use SchoolMonitoring\Domain\LessonDiary;

$imageUrl = function (?string $path): string {
    if ($path === null || $path === '') {
        return '';
    }

    return $this->Url->build([
        'plugin' => 'SchoolMonitoring',
        'controller' => 'LessonPhotos',
        'action' => 'image',
        '?' => ['path' => $path],
    ]);
};
?>
<div dir="rtl">
    <h1>سجل صور الحصص</h1>
    <p>حصص اليوم المنشور جدولها، وصورة بداية كل حصة وصورة نهايتها. حضور الموظف شاشة أخرى ولا تعرض هذه الصور.</p>
    <form method="get">
        <input type="hidden" name="institution_id" value="<?= (int)$institutionId ?>">
        <label>التاريخ
            <input type="date" name="date" value="<?= h($date) ?>">
        </label>
        <button type="submit">عرض</button>
    </form>
    <?php if ($institutionId < 1) : ?>
        <p class="status">افتح المدرسة أولاً ثم ارجع إلى هذه الصفحة.</p>
    <?php elseif ($lessons === []) : ?>
        <p class="status">لا توجد حصص منشورة في هذا اليوم.</p>
    <?php else : ?>
        <div class="sm-review">
        <table>
            <thead>
                <tr>
                    <th>الوقت</th>
                    <th>الحصة</th>
                    <th>الشعبة</th>
                    <th>المعلم</th>
                    <th>صورة البداية</th>
                    <th>صورة النهاية</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($lessons as $lesson) : ?>
                    <tr>
                        <td><span dir="ltr"><?= h(LessonDiary::localTime((string)$lesson['scheduled_start_at'])) ?> – <?= h(LessonDiary::localTime((string)$lesson['scheduled_end_at'])) ?></span></td>
                        <td><?= h((string)$lesson['subject_name']) ?></td>
                        <td><?= h((string)$lesson['class_name']) ?></td>
                        <td><?= h((string)$lesson['staff_name']) ?></td>
                        <td>
                            <?php $start = $imageUrl($lesson['start_photo'] ?? null); ?>
                            <?php if ($start !== '') : ?>
                                <a href="<?= h($start) ?>"><img src="<?= h($start) ?>" alt="صورة البداية" style="max-width:180px"></a>
                            <?php else : ?>
                                لا توجد صورة
                            <?php endif; ?>
                        </td>
                        <td>
                            <?php $end = $imageUrl($lesson['end_photo'] ?? null); ?>
                            <?php if ($end !== '') : ?>
                                <a href="<?= h($end) ?>"><img src="<?= h($end) ?>" alt="صورة النهاية" style="max-width:180px"></a>
                            <?php else : ?>
                                لا توجد صورة
                            <?php endif; ?>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
        </div>
    <?php endif; ?>
</div>
