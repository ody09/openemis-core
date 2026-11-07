<?php
/** @var string $csrfToken */
?>
<h1>Lesson photo capture</h1>
<p>Live camera only. Photos are rejected outside the geofence (150m) or the lesson time window.</p>
<div class="status" id="status">Loading today's lessons…</div>
<label>Lesson
    <select id="lesson"></select>
</label>
<label>Phase
    <select id="phase">
        <option value="1">Start</option>
        <option value="2">End</option>
    </select>
</label>
<video id="camera" autoplay playsinline></video>
<canvas id="frame" hidden></canvas>
<p>
    <button type="button" id="capture">Capture and upload</button>
</p>
<script>
window.SCHOOL_MONITORING = {
    csrf: <?= json_encode((string)$csrfToken) ?>,
    todayUrl: <?= json_encode($this->Url->build(['plugin' => 'SchoolMonitoring', 'controller' => 'LessonPhotos', 'action' => 'today'])) ?>,
    tokenUrl: <?= json_encode($this->Url->build(['plugin' => 'SchoolMonitoring', 'controller' => 'LessonPhotos', 'action' => 'token'])) ?>,
    uploadUrl: <?= json_encode($this->Url->build(['plugin' => 'SchoolMonitoring', 'controller' => 'LessonPhotos', 'action' => 'upload'])) ?>
};
</script>
<script src="<?= $this->Url->webroot('js/school-monitoring-capture.js') ?>"></script>
