(function () {
    var cfg = window.SCHOOL_MONITORING || {};
    var statusEl = document.getElementById('status');
    var lessonEl = document.getElementById('lesson');
    var video = document.getElementById('camera');
    var canvas = document.getElementById('frame');
    var lessons = [];

    function setStatus(text) {
        if (statusEl) {
            statusEl.textContent = text;
        }
    }

    function jsonHeaders() {
        return {
            'X-CSRF-Token': cfg.csrf || '',
            'Accept': 'application/json'
        };
    }

    if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
        navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' }, audio: false })
            .then(function (stream) {
                if (video) {
                    video.srcObject = stream;
                }
            })
            .catch(function () {
                setStatus('Camera permission is required. File uploads are not accepted.');
            });
    } else {
        setStatus('This browser cannot open a live camera.');
    }

    fetch(cfg.todayUrl, { credentials: 'same-origin', headers: jsonHeaders() })
        .then(function (res) { return res.json(); })
        .then(function (data) {
            lessons = data.lessons || [];
            if (!lessonEl) {
                return;
            }
            lessonEl.innerHTML = '';
            if (!lessons.length) {
                setStatus('No published lessons found for today. You can still capture if the form is filled by the timetable.');
                return;
            }
            lessons.forEach(function (lesson, index) {
                var opt = document.createElement('option');
                opt.value = String(index);
                opt.textContent = lesson.lesson_key + ' @ ' + lesson.scheduled_start_at;
                lessonEl.appendChild(opt);
            });
            setStatus('Camera ready. Stay within 150m of the school.');
        })
        .catch(function () {
            setStatus('Could not load today\'s lessons.');
        });

    function currentLesson() {
        if (!lessonEl || !lessons.length) {
            return null;
        }
        return lessons[parseInt(lessonEl.value, 10)] || lessons[0];
    }

    function locate() {
        return new Promise(function (resolve, reject) {
            if (!navigator.geolocation) {
                reject(new Error('geolocation_unavailable'));
                return;
            }
            navigator.geolocation.getCurrentPosition(
                function (pos) { resolve(pos.coords); },
                function () { reject(new Error('geolocation_denied')); },
                { enableHighAccuracy: true, timeout: 15000, maximumAge: 0 }
            );
        });
    }

    document.getElementById('capture').addEventListener('click', function () {
        var lesson = currentLesson();
        if (!lesson) {
            setStatus('No lesson selected.');
            return;
        }
        var phase = parseInt(document.getElementById('phase').value, 10);
        canvas.width = video.videoWidth || 640;
        canvas.height = video.videoHeight || 480;
        canvas.getContext('2d').drawImage(video, 0, 0);
        var dataUrl = canvas.toDataURL('image/jpeg', 0.8);
        setStatus('Requesting capture token…');
        var tokenBody = new FormData();
        tokenBody.append('lesson_key', lesson.lesson_key);
        tokenBody.append('phase', String(phase));
        Promise.all([
            fetch(cfg.tokenUrl, { method: 'POST', credentials: 'same-origin', headers: jsonHeaders(), body: tokenBody }).then(function (r) { return r.json(); }),
            locate()
        ]).then(function (results) {
            var token = results[0].token;
            var coords = results[1];
            var body = new FormData();
            body.append('token', token);
            body.append('lesson_key', lesson.lesson_key);
            body.append('phase', String(phase));
            body.append('scheduled_at', phase === 2 ? lesson.scheduled_end_at : lesson.scheduled_at);
            body.append('school_latitude', lesson.school_latitude || '');
            body.append('school_longitude', lesson.school_longitude || '');
            body.append('latitude', String(coords.latitude));
            body.append('longitude', String(coords.longitude));
            body.append('accuracy', String(coords.accuracy || ''));
            body.append('photo_base64', dataUrl);
            body.append('institution_id', String(lesson.institution_id));
            body.append('academic_period_id', String(lesson.academic_period_id));
            body.append('lesson_detail_id', String(lesson.lesson_detail_id));
            body.append('lesson_date', lesson.lesson_date);
            body.append('timetable_id', String(lesson.timetable_id || ''));
            body.append('class_id', String(lesson.class_id || ''));
            body.append('subject_id', String(lesson.subject_id || ''));
            body.append('timeslot_id', String(lesson.timeslot_id || ''));
            body.append('day_of_week', String(lesson.day_of_week || ''));
            body.append('scheduled_start_at', lesson.scheduled_start_at);
            body.append('scheduled_end_at', lesson.scheduled_end_at);
            body.append('client_reported_at', new Date().toISOString());
            setStatus('Uploading…');
            return fetch(cfg.uploadUrl, { method: 'POST', credentials: 'same-origin', headers: jsonHeaders(), body: body });
        }).then(function (res) {
            return res.json().then(function (payload) {
                if (!res.ok) {
                    throw new Error(payload.error || 'upload_failed');
                }
                setStatus('Saved. Distance ' + (payload.distance == null ? 'n/a' : Math.round(payload.distance) + 'm'));
            });
        }).catch(function (err) {
            setStatus('Capture failed: ' + (err && err.message ? err.message : err));
        });
    });
})();
