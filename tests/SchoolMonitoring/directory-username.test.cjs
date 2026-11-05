const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');

function directory(openemisNo, search = () => Promise.resolve({ data: { data: [], total: 0 } })) {
    let factory;
    let requests = 0;
    const angular = { baseUrl: '', copy: value => value, isDefined: value => value !== undefined,
        module: () => ({ service: (_name, value) => { factory = value; } }) };
    vm.runInNewContext(fs.readFileSync(path.join(__dirname,
        '../../plugins/Directory/webroot/js/angular/directoryadd/directory.directoryadd.svc.js'), 'utf8'), { angular, console: { ...console, error: () => {} }, setTimeout: () => 0 });
    const q = { defer: () => {
        let resolve, reject;
        const promise = new Promise((yes, no) => { resolve = yes; reject = no; });
        return { promise, resolve, reject };
    } };
    const service = factory({ get: () => {
        requests++;
        return Promise.resolve({ data: { openemis_no: openemisNo } });
    }, post: (_url, body) => search(body.params) }, q, {}, {},
        { getTranslatedGridLocale: () => Promise.resolve({}) }, {}, { isAppendLoader: () => {} }, {});
    return { service, requests: () => requests };
}

test('new five-character OpenEMIS IDs receive a six-character username without changing the ID', async () => {
    const { service } = directory('00009');
    const scope = { selectedUserData: {} };
    await service.setUniqueOpenEmisId(scope);
    assert.equal(scope.selectedUserData.openemis_no, '00009');
    assert.equal(scope.selectedUserData.username, '000009');
});

async function searchGrid(service) {
    let source;
    const watchers = [];
    const scope = { step: 'internal_search', selectedUserData: {
        first_name: 'طالب', last_name: 'اختبار', date_of_birth: '2012-04-06', gender_id: 1,
    }, translateFields: {}, pageSize: 10, $watch: (read, notify) => {
        const watcher = { read, notify, active: true };
        watchers.push(watcher);
        return () => { watcher.active = false; };
    } };
    service.goToInternalSearch(scope);
    await new Promise(setImmediate);
    scope.internalGridOptions.api = { setDatasource: value => { source = value; }, sizeColumnsToFit: () => {} };
    // kd-ag-grid replaces onGridReady when radio selection is enabled.
    scope.internalGridOptions.onGridReady = () => {};
    scope.internalGridOptions.onGridReady();
    watchers.filter(watcher => watcher.active).forEach(watcher => watcher.notify(watcher.read()));
    return { scope, source };
}

test('a successful empty search enables new-person entry and completes the empty grid', async () => {
    const { service } = directory('unused');
    const { scope, source } = await searchGrid(service);
    assert.ok(source, 'Search should start when the grid is ready.');
    let rows, failed = false;
    source.getRows({ startRow: 0, endRow: 10, successCallback: data => { rows = data; }, failCallback: () => { failed = true; } });
    await new Promise(setImmediate);
    assert.equal(rows.length, 0);
    assert.equal(failed, false);
    assert.equal(scope.internalSearchLoading, false);
    assert.equal(service.isNextButtonShouldDisable(scope), false);
});

test('a failed search blocks Next and explains the failure instead of implying no matches', async () => {
    const { service } = directory('unused', () => Promise.reject({ status: 500 }));
    const { scope, source } = await searchGrid(service);
    assert.ok(source);
    source.getRows({ startRow: 0, endRow: 10, successCallback: () => assert.fail('Failed search is not an empty result'), failCallback: () => {} });
    await new Promise(setImmediate);
    assert.equal(scope.internalSearchFailed, true);
    assert.equal(service.isNextButtonShouldDisable(scope), true);
    assert.match(service.getNextButtonDisabledReason(scope), /تعذر/);
});

test('an unmatched OpenEMIS lookup explains returning to enter a new person', () => {
    const { service } = directory('unused');
    const scope = { step: 'internal_search', selectedUserData: { openemis_no: 'student00009' } };
    assert.equal(service.isNextButtonShouldDisable(scope), true);
    assert.equal(typeof service.getNextButtonDisabledReason, 'function');
    assert.match(service.getNextButtonDisabledReason(scope), /OpenEMIS/);
    assert.match(service.getNextButtonDisabledReason(scope), /عودة/);
});

test('longer generated IDs keep their username unchanged', async () => {
    const { service } = directory('100009');
    const scope = { selectedUserData: {} };
    await service.setUniqueOpenEmisId(scope);
    assert.equal(scope.selectedUserData.username, '100009');
});

test('an existing account keeps its username and does not generate another ID', async () => {
    const { service, requests } = directory('unused');
    const scope = { isInternalSearchSelected: true, selectedUserData: { openemis_no: '00009', username: 'existingTeacher' } };
    await service.setUniqueOpenEmisId(scope);
    assert.equal(scope.selectedUserData.username, 'existingTeacher');
    assert.equal(requests(), 0);
});

test('a selected person without an account gets a valid suggested username', async () => {
    const { service, requests } = directory('unused');
    const scope = { isExternalSearchSelected: true, selectedUserData: { openemis_no: '00009' } };
    await service.setUniqueOpenEmisId(scope);
    assert.equal(scope.selectedUserData.username, '000009');
    assert.equal(requests(), 0);
});
