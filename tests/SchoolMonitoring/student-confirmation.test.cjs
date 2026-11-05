const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');

function wizard(validate, savedStudent = { admission: { id: 'pending-1' } }) {
    let controller;
    let validations = 0;
    let saves = 0;
    const angular = {
        module: () => ({ controller: (_name, factory) => { controller = factory; } }),
        element: () => ({ ready: () => {} }),
    };
    vm.runInNewContext(fs.readFileSync(path.join(__dirname,
        '../../plugins/Institution/webroot/js/angular/students/institutions.students.ctrl.js'), 'utf8'),
    { angular, document: {}, setTimeout: () => 1, console: { ...console, error: () => {} } });
    const service = {
        getEducationGradeAddStudent: (...args) => { validations++; return validate(...args); },
        getEducationGrade: (...args) => { validations++; return validate(...args); },
        getAddressArea: () => null, getAddressAreaId: () => null,
        getBirthplaceArea: () => null, getBirthplaceAreaId: () => null,
        saveStudentDetails: () => { saves++; return Promise.resolve({ data: { id: 42, saved_student: savedStudent } }); },
        getRedirectToGuardian: () => Promise.resolve({ data: [{ redirecttoguardian_status: false }] }),
    };
    const scope = {};
    controller({}, {}, scope, { localStorage: { getItem: () => null, removeItem: () => {} }, history: { back: () => {} } },
        () => () => '2026-11-04', { isAppendLoader: () => {} }, {}, {}, service, {}, {}, {});
    scope.selectedUserData = { username: 'student42', password: 'example-only', first_name: 'طالب',
        last_name: 'تجربة', academic_period_id: 34, education_grade_id: 221,
        openemis_no: 'DEMO-42', startDate: '2026-09-01', transferStartDate: '2026-11-04', transfer_reason_id: 1 };
    scope.userData = { is_diff_school: 0 };
    scope.step = 'add_student';
    return { scope, validations: () => validations, saves: () => saves };
}

const flush = () => new Promise(setImmediate);

test('confirmation waits for actual grade validation and ignores repeated clicks', async () => {
    let finish;
    const app = wizard(() => new Promise(resolve => { finish = resolve; }));
    const request = app.scope.confirmUser();
    app.scope.confirmUser();
    assert.equal(app.scope.isValidating, true);
    assert.equal(app.validations(), 1);
    assert.equal(app.saves(), 0);
    finish({ data: '"no"' });
    await request;
    await flush();
    assert.equal(app.saves(), 1);
    assert.equal(app.scope.isValidating, false);
    assert.equal(app.scope.step, 'summary');
    assert.equal(app.scope.savedPendingStatus, 'admission');
});

test('missing grade stays on the form without requesting validation or saving', async () => {
    const app = wizard(() => Promise.resolve({ data: '"no"' }));
    app.scope.selectedUserData.education_grade_id = null;
    await app.scope.confirmUser();
    assert.ok(app.scope.error.education_grade_id);
    assert.equal(app.validations(), 0);
    assert.equal(app.saves(), 0);
});

test('a completed grade is rejected and keeps the entered student data', async () => {
    const app = wizard(() => Promise.resolve({ data: '"yes"' }));
    await app.scope.confirmUser();
    assert.ok(app.scope.error.education_grade_id);
    assert.equal(app.saves(), 0);
    assert.equal(app.scope.selectedUserData.first_name, 'طالب');
    assert.equal(app.scope.isValidating, false);
});

test('a failed validation shows an error and allows a successful retry', async () => {
    let attempts = 0;
    const app = wizard(() => ++attempts === 1
        ? Promise.reject({ data: null, statusText: 'Offline' })
        : Promise.resolve({ data: 'no' }));
    await app.scope.confirmUser();
    assert.equal(app.saves(), 0);
    assert.equal(app.scope.messageClass, 'alert-danger');
    assert.ok(app.scope.message);
    assert.equal(app.scope.isValidating, false);
    await app.scope.confirmUser();
    await flush();
    assert.equal(app.saves(), 1);
});

test('unknown grade validation cannot save a student', async () => {
    const app = wizard(() => Promise.resolve({ data: '<html>Login</html>' }));
    await app.scope.confirmUser();
    assert.equal(app.saves(), 0);
    assert.equal(app.scope.messageClass, 'alert-danger');
    assert.equal(app.scope.isValidating, false);
});

test('transfer uses the actual validation response and ignores repeated clicks', async () => {
    let finish;
    const app = wizard((grade, student) => {
        assert.equal(grade, 221);
        assert.equal(student, 'DEMO-42');
        return new Promise(resolve => { finish = resolve; });
    });
    app.scope.step = 'transfer_student';
    const request = app.scope.transferStudent();
    app.scope.transferStudent();
    assert.equal(app.validations(), 1);
    assert.equal(app.saves(), 0);
    finish({ data: '"no"' });
    await request;
    await flush();
    assert.equal(app.saves(), 1);
    assert.equal(app.scope.isValidating, false);
});

test('pending enrollment guidance follows the saved server outcome', async () => {
    const app = wizard(() => Promise.resolve({ data: 'no' }), { enrolment: { id: 'enrollment-1' } });
    app.scope.saveUserDetails('confirmUser');
    await flush();
    assert.equal(app.scope.savedPendingStatus, 'enrolment');
    assert.equal(app.scope.redirectToGuardian, true);
    assert.match(app.scope.message, /التسجيل/);
    assert.doesNotMatch(app.scope.message, /حفظ القبول/);
});

test('adding another guardian keeps the school context for the return link', () => {
    let controller;
    const angular = {
        baseUrl: '',
        module: () => ({ controller: (_name, factory) => { controller = factory; } }),
        element: () => ({ ready: () => {} }),
    };
    vm.runInNewContext(fs.readFileSync(path.join(__dirname,
        '../../plugins/Directory/webroot/js/angular/directoryaddguardian/directory.directoryaddguardian.ctrl.js'), 'utf8'),
    { angular, document: {}, console });
    const scope = {};
    const window = { location: {}, localStorage: { getItem: () => null } };
    controller(scope, {}, window, {}, () => {}, {}, {}, {},
        { urlsafeB64Encode: text => Buffer.from(text).toString('base64url') }, {});
    scope.studentOpenEmisId = 'DEMO-42';
    scope.institutionId = 7;
    scope.addGuardian();
    const encoded = window.location.href.split('/').pop();
    const params = JSON.parse(Buffer.from(encoded, 'base64url').toString());
    assert.equal(params.institution_id, 7);
    assert.equal(params.openemis_no, 'DEMO-42');
});
