const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');

function wizard(savedStudent, overrides = {}, utils = { isAppendLoader: () => {} }) {
    let controller;
    const angular = {
        baseUrl: '',
        module: () => ({ controller: (_name, factory) => { controller = factory; } }),
        element: () => ({ ready: () => {} }),
    };
    vm.runInNewContext(fs.readFileSync(path.join(__dirname, '../../plugins/Institution/webroot/js/angular/students/institutions.students.ctrl.js'), 'utf8'), { angular, document: {}, console: { ...console, error: () => {} } });
    const scope = {};
    const window = { localStorage: { getItem: () => null, removeItem: () => {} }, location: {}, history: { back: () => {} } };
    const service = {
        getAddressArea: () => null, getAddressAreaId: () => null, getBirthplaceArea: () => null, getBirthplaceAreaId: () => null,
        saveStudentDetails: () => Promise.resolve({ data: { id: 42, saved_student: savedStudent } }),
        getRedirectToGuardian: () => Promise.resolve({ data: [{ redirecttoguardian_status: false }] }),
        ...overrides,
    };
    controller({}, {}, scope, window, () => () => '2026-11-01', utils, {}, {}, service, {},
        { urlsafeB64Encode: text => Buffer.from(text).toString('base64url') }, {});
    scope.userData = { is_diff_school: 0 };
    scope.selectedUserData = { openemis_no: 'DEMO-42' };
    scope.studentAdmissionStatusValue = 12;
    scope.studentAdmissionStatus = 'Pending Admission';
    return { scope, window };
}

test('saved pending admission reaches guardian action with the returned student ID', async () => {
    const { scope, window } = wizard({ admission: { id: 'pending-1' } });
    scope.institutionId = 7;
    scope.saveUserDetails('confirmUser');
    await new Promise(setImmediate);
    assert.equal(scope.step, 'summary');
    assert.equal(scope.redirectToGuardian, true);
    scope.addGuardian();
    const encoded = new URL(window.location.href, 'http://localhost').searchParams.get('queryString');
    const params = JSON.parse(Buffer.from(encoded, 'base64url').toString());
    assert.equal(params.student_id, 42);
    assert.equal(params.user_id, 42);
    assert.equal(params.institution_id, 7);
});

test('empty school year clears previous grade and class and explains the missing setup', async () => {
    const { scope } = wizard({}, { getEducationGrades: () => Promise.resolve({ data: [] }) });
    scope.selectedUserData = { academic_period_id: 33, academic_period_name: '2024', education_grade_id: 221, class_id: 1 };
    scope.educationGradeOptions = [{ education_grade_id: 221 }];
    scope.classOptions = [{ id: 1 }];
    await scope.getEducationGrades();
    assert.equal(scope.selectedUserData.education_grade_id, null);
    assert.equal(scope.selectedUserData.class_id, null);
    assert.equal(scope.classOptions.length, 0);
    assert.match(scope.gradeOptionsMessage, /2024/);
    assert.match(scope.gradeOptionsMessage, /لا توجد صفوف/);
    assert.equal(scope.gradeOptionsLoading, false);
});

test('late empty result from the previous year cannot replace the current year grades', async () => {
    let finishOld;
    const { scope } = wizard({}, {
        getEducationGrades: params => params.academic_periods === 33
            ? new Promise(resolve => { finishOld = resolve; })
            : Promise.resolve({ data: [{ education_grade_id: 221, name: 'Kindergarten 1' }] }),
    });
    scope.selectedUserData = { academic_period_id: 33 };
    const oldRequest = scope.getEducationGrades();
    scope.selectedUserData.academic_period_id = 34;
    await scope.getEducationGrades();
    finishOld({ data: [] });
    await oldRequest;
    assert.equal(scope.educationGradeOptions[0].education_grade_id, 221);
    assert.equal(scope.gradeOptionsMessage, '');
});

test('changing grade clears the previous class and ignores its late class result', async () => {
    let finishOld;
    const { scope } = wizard({}, {
        getClasses: params => params.grade_id === 220
            ? new Promise(resolve => { finishOld = resolve; })
            : Promise.resolve({ data: [{ id: 1, name: 'تمهيدي أول — أ' }] }),
    });
    scope.selectedUserData = { academic_period_id: 34, education_grade_id: 220, class_id: 99 };
    scope.classOptions = [{ id: 99 }];
    const oldRequest = scope.getClasses();
    assert.equal(scope.selectedUserData.class_id, null);
    assert.equal(scope.classOptions.length, 0);
    scope.selectedUserData.education_grade_id = 221;
    await scope.getClasses();
    finishOld({ data: [] });
    await oldRequest;
    assert.equal(scope.classOptions[0].id, 1);
});

test('clearing a grade during class loading removes the loader after the old request finishes', async () => {
    const loaders = [];
    let finish;
    const { scope } = wizard({}, { getClasses: () => new Promise(resolve => { finish = resolve; }) },
        { isAppendLoader: value => loaders.push(value) });
    scope.selectedUserData = { academic_period_id: 34, education_grade_id: 221 };
    const request = scope.getClasses();
    scope.selectedUserData.education_grade_id = null;
    await scope.getClasses();
    finish({ data: [{ id: 1 }] });
    await request;
    assert.equal(loaders.at(-1), false);
    assert.equal(scope.classOptionsLoading, false);
    assert.equal(scope.classOptions.length, 0);
});

test('missing enrollment outcome stays retryable and does not show success', async () => {
    const { scope } = wizard({ error: 'Admission was not saved' });
    scope.saveUserDetails('confirmUser');
    await new Promise(setImmediate);
    assert.equal(scope.notSaved, true);
    assert.equal(scope.messageClass, 'alert-danger');
    assert.notEqual(scope.step, 'summary');
});

test('server validation identifies the field and preserves entered data for correction', async () => {
    let attempts = 0;
    const { scope } = wizard({}, { saveStudentDetails: () => ++attempts === 1
        ? Promise.reject({ status: 422, data: { message: 'Validation failed', errors: {
            username: { ruleMinLength: 'Username must be at least 6 characters' },
        } } })
        : Promise.resolve({ data: { id: 42, saved_student: { admission: { id: 'pending-1' } } } }),
    });
    scope.selectedUserData.username = '00009';
    scope.step = 'add_student';
    scope.saveUserDetails('confirmUser');
    await new Promise(setImmediate);
    assert.match(scope.validationErrors.join(' '), /اسم المستخدم/);
    assert.match(scope.validationErrors.join(' '), /6/);
    assert.equal(scope.selectedUserData.username, '00009');
    assert.equal(scope.isConfirming, false);
    assert.equal(scope.step, 'add_student');
    scope.selectedUserData.username = 'student00009';
    scope.saveUserDetails('confirmUser');
    await new Promise(setImmediate);
    assert.equal(scope.validationErrors.length, 0);
    assert.equal(scope.step, 'summary');
});

test('a network failure without a JSON body still unlocks confirmation and shows a message', async () => {
    const { scope } = wizard({}, { saveStudentDetails: () => Promise.reject({ data: null, statusText: 'Network unavailable' }) });
    scope.saveUserDetails('confirmUser');
    await new Promise(setImmediate);
    assert.equal(scope.isConfirming, false);
    assert.equal(scope.message, 'Network unavailable');
});

test('basic student details with a nationality do not force an optional identity document', async () => {
    const { scope } = wizard({}, { checkUserAlreadyExistByIdentity: () => Promise.resolve({ data: { user_exist: 0 } }) });
    scope.selectedUserData = { first_name: 'طالب', last_name: 'اختبار', gender_id: 1,
        date_of_birth: '2012-04-06', nationality_id: 14, openemis_no: '', identity_type_id: null, identity_number: '' };
    scope.step = 'user_details';
    scope.goToInternalSearch = () => {};
    await scope.validateDetails();
    assert.equal(Object.keys(scope.error).length, 0);
    assert.equal(scope.step, 'internal_search');
});

test('a null OpenEMIS search value does not bypass missing basic details', async () => {
    const { scope } = wizard({});
    scope.selectedUserData = { openemis_no: null, first_name: 'طالب', last_name: 'اختبار', gender_id: 1 };
    scope.step = 'user_details';
    scope.goToInternalSearch = () => assert.fail('Incomplete data must stay on the details step');
    await scope.validateDetails();
    assert.ok(scope.error.date_of_birth);
    assert.equal(scope.step, 'user_details');
});

test('failed admission explains the date error and the saved profile without showing success', async () => {
    const { scope } = wizard({ error: 'تعذر حفظ القبول قيد الانتظار.', errors: {
        start_date: { ruleInAcademicPeriod: 'Date is not within the academic period.' },
    } });
    scope.step = 'add_student';
    scope.saveUserDetails('confirmUser');
    await new Promise(setImmediate);
    assert.equal(scope.notSaved, true);
    assert.equal(scope.step, 'add_student');
    assert.match(scope.message, /DEMO-42/);
    assert.match(scope.validationErrors.join(' '), /تاريخ بدء الدراسة/);
    assert.match(scope.validationErrors.join(' '), /السنة الدراسية/);
    assert.equal(scope.isConfirming, false);
});
