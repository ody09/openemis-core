const { test } = require('node:test');
const assert = require('node:assert/strict');
const { validateFile, statusOf, withPhoto, withReview } = require('../../webroot/lesson-photo-demo.js');
test('accepts bounded photo files and rejects empty, oversized and unsupported files', () => {
    validateFile({type:'image/jpeg',size:1024});
    validateFile({type:'image/png',size:5*1024*1024});
    for (const file of [{type:'image/svg+xml',size:30},{type:'image/png',size:0},{type:'image/webp',size:5*1024*1024+1}]) assert.throws(() => validateFile(file));
});
test('requires start before end, preserves initial record and locks saved evidence', () => {
    const original={id:'demo'};
    assert.throws(() => withPhoto(original,'end','x','2026-11-03T09:00:00Z'));
    const start=withPhoto(original,'start','x','2026-11-03T09:00:00Z');
    assert.equal(original.start,undefined);
    assert.equal(statusOf(start),'started');
    assert.throws(() => withPhoto(start,'start','y','later'));
    assert.equal(statusOf(withPhoto(start,'end','y','2026-11-03T09:40:00Z')),'pending');
});
test('review needs two photos and returns require a reason', () => {
    assert.equal(statusOf({}),'draft');
    assert.throws(() => withReview({start:{}},'approved','','now'));
    const lesson={start:{},end:{}};
    assert.throws(() => withReview(lesson,'returned','  ','now'));
    assert.equal(statusOf(withReview(lesson,'approved','مراجعة تجريبية','now')),'approved');
    const returned=withReview(lesson,'returned',' صورة غير واضحة ','now');
    assert.equal(statusOf(returned),'returned');
    assert.equal(returned.review.note,'صورة غير واضحة');
});
