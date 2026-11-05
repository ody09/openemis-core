/* shortcut: presentation prototype; browser-only storage and simulated roles. Replace with authenticated server workflows before deployment. */
(() => {
    'use strict';
    const MAX_SIZE = 5 * 1024 * 1024;
    function validateFile(file) {
        if (!file || !['image/jpeg', 'image/png', 'image/webp'].includes(file.type)) throw new Error('اختر صورة بصيغة JPG أو PNG أو WEBP.');
        if (!file.size || file.size > MAX_SIZE) throw new Error('حجم الصورة يجب أن يكون أكبر من صفر وأقل من أو يساوي 5 ميجابايت.');
    }
    function statusOf(lesson) {
        if (!lesson?.start) return 'draft';
        if (!lesson.end) return 'started';
        return ['approved', 'returned'].includes(lesson.review?.decision) ? lesson.review.decision : 'pending';
    }
    function withPhoto(lesson, phase, data, now) {
        if (!['start', 'end'].includes(phase)) throw new Error('نوع التوثيق غير صحيح.');
        if (phase === 'end' && !lesson.start) throw new Error('أضف صورة البداية أولًا.');
        if (phase === 'start' && lesson.end) throw new Error('الحصة مكتملة؛ لا يمكن تغيير صورة البداية.');
        if (lesson[phase]) throw new Error('صورة هذه المرحلة محفوظة بالفعل.');
        return { ...lesson, [phase]: { data, at: now }, review: null };
    }
    function withReview(lesson, decision, note, now) {
        if (!lesson.start || !lesson.end) throw new Error('لا يمكن اعتماد حصة دون صورتي البداية والنهاية.');
        if (!['approved', 'returned'].includes(decision)) throw new Error('قرار المراجعة غير صحيح.');
        if (decision === 'returned' && !note.trim()) throw new Error('اكتب سبب إعادة الحصة للمعلم.');
        return { ...lesson, review: { decision, note: note.trim(), at: now } };
    }
    if (typeof module !== 'undefined' && module.exports) module.exports = { validateFile, statusOf, withPhoto, withReview };
    if (typeof document === 'undefined') return;

    const $ = id => document.getElementById(id);
    const labels = { draft: 'لم تبدأ', started: 'بدأت — بانتظار النهاية', pending: 'بانتظار مراجعة المؤسسة', approved: 'معتمدة تجريبيًا', returned: 'معادة للمعلم' };
    let db, busy = false, lessons = [];
    const local = new Date();
    $('lesson-date').value = `${local.getFullYear()}-${String(local.getMonth() + 1).padStart(2, '0')}-${String(local.getDate()).padStart(2, '0')}`;
    const stamp = value => new Intl.DateTimeFormat('ar-YE', { dateStyle: 'medium', timeStyle: 'medium', timeZone: 'Asia/Aden' }).format(new Date(value));
    function announce(text, error = false) {
        $('message').textContent = text;
        $('message').classList.toggle('error', error);
        $('message').hidden = false;
    }
    function key() {
        if (!$('lesson-date').value || !$('lesson-date').validity.valid) throw new Error('اختر تاريخًا صحيحًا للحصة.');
        return `${$('lesson-date').value}:1:${$('lesson-period').value}`;
    }
    function current() {
        return lessons.find(l => l.id === key()) || { id: key(), date: $('lesson-date').value, period: $('lesson-period').value, className: 'تمهيدي أول — أ', teacher: 'معلم تجريبي المتابعة', subject: $('lesson-subject').value.trim(), note: '' };
    }
    function transaction(mode, action) {
        return new Promise((resolve, reject) => {
            const tx = db.transaction('lessons', mode);
            const request = action(tx.objectStore('lessons'));
            tx.oncomplete = () => resolve(request.result);
            tx.onerror = () => reject(tx.error || new Error('تعذر حفظ بيانات التجربة.'));
            tx.onabort = () => reject(tx.error || new Error('أُلغي الحفظ؛ أعد المحاولة.'));
        });
    }
    async function refresh() {
        lessons = await transaction('readonly', store => store.getAll());
        renderTeacher(); renderReview();
        $('pending-count').textContent = lessons.filter(l => statusOf(l) === 'pending').length;
    }
    async function save(lesson) {
        await transaction('readwrite', store => store.put(lesson));
        await refresh();
    }
    async function run(work) {
        if (busy || !db) return;
        busy = true;
        document.querySelectorAll('button, input, select, textarea').forEach(e => e.disabled = true);
        try { await work(); } catch (error) { announce(error.message || 'تعذر الحفظ. أعد المحاولة.', true); }
        finally {
            busy = false;
            document.querySelectorAll('button, input, select, textarea').forEach(e => e.disabled = false);
            try { renderTeacher(); } catch (_) { /* Invalid date remains available for correction. */ }
        }
    }
    function renderTeacher() {
        const lesson = current();
        $('lesson-subject').value = lesson.subject || '';
        $('lesson-note').value = lesson.note || '';
        $('lesson-status').textContent = labels[statusOf(lesson)];
        $('duration').textContent = lesson.review ? `آخر مراجعة: ${stamp(lesson.review.at)}` : lesson.end ? 'الصورتان محفوظتان — جاهزة للمراجعة' : lesson.start ? 'أضف صورة النهاية عند انتهاء الحصة' : 'لم تُرفع صور بعد';
        $('review-feedback').hidden = !lesson.review?.note;
        $('review-feedback').textContent = lesson.review?.note ? `ملاحظة المؤسسة: ${lesson.review.note}` : '';
        for (const phase of ['start', 'end']) {
            const preview = $(`${phase}-preview`);
            preview.replaceChildren();
            preview.classList.toggle('has-photo', !!lesson[phase]);
            if (lesson[phase]) {
                const img = document.createElement('img');
                img.src = lesson[phase].data; img.alt = phase === 'start' ? 'صورة بداية الحصة' : 'صورة نهاية الحصة';
                preview.append(img);
            } else {
                const hint = document.createElement('span');
                hint.textContent = phase === 'start' ? 'المعلم والطلاب داخل الفصل' : lesson.start ? 'المعلم والطلاب عند نهاية الحصة' : 'أكمل توثيق البداية أولًا';
                preview.append(hint);
            }
            $(`${phase}-time`).textContent = lesson[phase] ? `وقت الرفع التجريبي: ${stamp(lesson[phase].at)}` : `بانتظار صورة ${phase === 'start' ? 'البداية' : 'النهاية'}`;
            const locked = busy || !!lesson[phase] || (phase === 'end' && !lesson.start);
            $(`${phase}-file`).disabled = locked;
            $(`${phase}-label`).classList.toggle('disabled', locked);
            $(`${phase}-label`).textContent = lesson[phase] ? 'تم حفظ الصورة' : `إضافة صورة ${phase === 'start' ? 'البداية' : 'النهاية'}`;
        }
    }
    function element(tag, text, className) {
        const el = document.createElement(tag);
        if (text !== undefined) el.textContent = text;
        if (className) el.className = className;
        return el;
    }
    function renderReview() {
        const list = $('review-list'); list.replaceChildren();
        const filter = $('review-filter').value;
        const entries = lessons.filter(l => l.start && (filter === 'all' || statusOf(l) === filter)).sort((a, b) => b.start.at.localeCompare(a.start.at));
        if (!entries.length) {
            const box = element('div', undefined, 'empty');
            box.append(element('h2', 'لا توجد حصص في هذه القائمة'), element('p', 'أضف صور الحصة من واجهة المعلم، ثم ارجع للمراجعة.'));
            list.append(box); return;
        }
        for (const lesson of entries) {
            const card = element('article', undefined, 'card review-card');
            const head = element('div', undefined, 'review-heading'), title = element('div');
            title.append(element('h2', lesson.subject || 'حصة تجريبية'), element('p', `${lesson.teacher} · ${lesson.className} · ${lesson.date} · الحصة ${lesson.period}`, 'muted'));
            head.append(title, element('span', labels[statusOf(lesson)], `badge ${statusOf(lesson)}`)); card.append(head);
            const photos = element('div', undefined, 'review-photos');
            for (const phase of ['start', 'end']) {
                const panel = element('div'); panel.append(element('h3', phase === 'start' ? 'بداية الحصة' : 'نهاية الحصة'));
                if (lesson[phase]) {
                    const img = element('img'); img.src = lesson[phase].data; img.alt = phase === 'start' ? 'صورة بداية الحصة للمراجعة' : 'صورة نهاية الحصة للمراجعة';
                    panel.append(img, element('p', `وقت الرفع: ${stamp(lesson[phase].at)}`));
                } else panel.append(element('div', 'بانتظار توثيق نهاية الحصة', 'preview'));
                photos.append(panel);
            }
            card.append(photos);
            if (lesson.note) card.append(element('p', `ملاحظة المعلم: ${lesson.note}`, 'note-text'));
            if (lesson.review) card.append(element('p', `مراجعة تجريبية: ${lesson.review.note || 'تمت مراجعة الصورتين.'} — ${stamp(lesson.review.at)}`, 'note-text'));
            if (lesson.start && lesson.end) {
                const id = `review-${lesson.id.replaceAll(':', '-')}`;
                const label = element('label', 'ملاحظة المراجع'); label.htmlFor = id;
                const note = element('textarea'); note.id = id; note.maxLength = 600; note.rows = 2; note.placeholder = 'سبب الإعادة أو ملاحظة الاعتماد';
                const actions = element('div', undefined, 'review-actions');
                for (const [decision, text, cls] of [['approved', 'اعتماد التوثيق تجريبيًا', ''], ['returned', 'إعادة للمعلم', 'return-btn']]) {
                    const button = element('button', text, cls); button.type = 'button';
                    button.addEventListener('click', () => run(async () => {
                        const fresh = lessons.find(l => l.id === lesson.id);
                        await save(withReview(fresh, decision, note.value, new Date().toISOString()));
                        announce(decision === 'approved' ? 'تم اعتماد التوثيق داخل الديمو.' : 'تمت إعادة الحصة للمعلم مع الملاحظة.');
                    }));
                    actions.append(button);
                }
                card.append(label, note, actions);
            }
            list.append(card);
        }
    }
    function readImage(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onerror = () => reject(new Error('تعذرت قراءة الصورة.'));
            reader.onload = () => {
                const img = new Image();
                img.onerror = () => reject(new Error('الملف ليس صورة صالحة.'));
                img.onload = () => {
                    if (img.naturalWidth * img.naturalHeight > 40000000) return reject(new Error('أبعاد الصورة كبيرة جدًا. اختر صورة أصغر.'));
                    resolve(reader.result);
                };
                img.src = reader.result;
            };
            reader.readAsDataURL(file);
        });
    }
    for (const phase of ['start', 'end']) $(`${phase}-file`).addEventListener('change', event => {
        const file = event.target.files[0];
        if (!file) return;
        run(async () => {
            validateFile(file);
            const lesson = { ...current(), subject: $('lesson-subject').value.trim(), note: $('lesson-note').value.trim() };
            const data = await readImage(file);
            await save(withPhoto(lesson, phase, data, new Date().toISOString()));
            announce(phase === 'start' ? 'حُفظت صورة البداية. أضف صورة النهاية عند انتهاء الحصة.' : 'حُفظت صورة النهاية. الحصة جاهزة في «مراجعة المؤسسة».');
        });
        event.target.value = '';
    });
    for (const id of ['lesson-date', 'lesson-period']) $(id).addEventListener('change', () => {
        try { renderTeacher(); $('message').hidden = true; } catch (e) { announce(e.message, true); }
    });
    $('save-note').addEventListener('click', () => run(async () => {
        const lesson = current();
        await save({ ...lesson, subject: $('lesson-subject').value.trim(), note: $('lesson-note').value.trim() });
        announce('حُفظ موضوع الدرس وملاحظة المعلم.');
    }));
    for (const role of ['teacher', 'review']) $(`${role}-tab`).addEventListener('click', () => {
        for (const r of ['teacher', 'review']) {
            $(`${r}-panel`).hidden = r !== role;
            $(`${r}-tab`).classList.toggle('active', r === role);
            $(`${r}-tab`).setAttribute('aria-pressed', String(r === role));
        }
        $('message').hidden = true;
        if (role === 'review') renderReview();
    });
    $('review-filter').addEventListener('change', renderReview);
    $('sample-lesson').addEventListener('click', () => run(async () => {
        let lesson = current();
        if (lesson.start) throw new Error('هذه الحصة موثّقة بالفعل. اختر حصة أخرى لتجربة المثال.');
        const draw = title => {
            const canvas = document.createElement('canvas'); canvas.width = 900; canvas.height = 560;
            const ctx = canvas.getContext('2d');
            ctx.fillStyle = '#edf4fa'; ctx.fillRect(0, 0, 900, 560);
            ctx.fillStyle = '#325f5e'; ctx.fillRect(70, 45, 760, 260);
            ctx.fillStyle = '#fff'; ctx.textAlign = 'center'; ctx.font = 'bold 36px Tahoma'; ctx.fillText(title, 450, 120);
            ctx.font = '22px Tahoma'; ctx.fillText('رسم توضيحي للعرض — لا يمثل أشخاصًا حقيقيين', 450, 170);
            for (const [x, y, color] of [[690, 235, '#6598c8'], [200, 375, '#9baec0'], [400, 375, '#9baec0'], [600, 375, '#9baec0']]) {
                ctx.fillStyle = '#d6af8d'; ctx.beginPath(); ctx.arc(x, y, 24, 0, Math.PI * 2); ctx.fill();
                ctx.fillStyle = color; ctx.fillRect(x - 30, y + 30, 60, 80);
                if (y > 300) { ctx.fillStyle = '#c5a17a'; ctx.fillRect(x - 60, y + 78, 120, 20); }
            }
            ctx.fillStyle = '#516b82'; ctx.font = '20px Tahoma'; ctx.fillText('بيانات وصور توضيحية لتجربة سير العمل فقط', 450, 525);
            return canvas.toDataURL('image/png');
        };
        lesson = { ...lesson, subject: 'مثال توضيحي — كتابة الاسم', note: 'صور مرسومة وبيانات توضيحية لتجربة العرض فقط؛ ليست توثيقًا لحصة فعلية.' };
        lesson = withPhoto(lesson, 'start', draw('بداية الحصة'), new Date().toISOString());
        lesson = withPhoto(lesson, 'end', draw('نهاية الحصة'), new Date().toISOString());
        await save(lesson);
        announce('أُضيف مثال بصورتين توضيحيتين. افتح «مراجعة المؤسسة» لتجربة الاعتماد.');
    }));
    const open = indexedDB.open('emis-lesson-photo-presentation-v1', 1);
    open.onupgradeneeded = () => open.result.createObjectStore('lessons', { keyPath: 'id' });
    open.onsuccess = async () => {
        db = open.result;
        try { await refresh(); } catch (error) { announce(error.message, true); }
    };
    open.onerror = () => {
        announce('تعذر فتح التخزين المحلي. افتح الديمو في متصفح يسمح بحفظ بيانات الموقع.', true);
        document.querySelectorAll('input, select, textarea, #save-note').forEach(el => el.disabled = true);
    };
})();
