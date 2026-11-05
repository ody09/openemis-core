<div role="group" aria-label="<?= __('إجراءات إضافة الطالب') ?>">
    <button ng-if="step === 'user_details'" type="button" class="btn close-btn"
            ng-click="cancelProcess()"><?= __('إلغاء') ?></button>
    <button ng-if="step !== 'user_details' && step !== 'summary' && step !== 'transfer_student'"
            type="button" class="btn btn-prev close-btn" ng-click="goToPrevStep()"
            ng-disabled="isValidating || isConfirming"><?= __('السابق') ?></button>
    <button ng-if="step === 'add_student'" type="button" class="btn btn-default"
            ng-disabled="(error | json) != '{}' || isValidating || isConfirming || gradeOptionsLoading || classOptionsLoading"
            ng-click="confirmUser()">
        <span ng-if="!isValidating && !isConfirming"><?= __('حفظ الطالب') ?></span>
        <span ng-if="isValidating && !isConfirming"><?= __('جارٍ التحقق…') ?></span>
        <span ng-if="isConfirming"><?= __('جارٍ الحفظ…') ?></span>
    </button>
    <button ng-if="step !== 'add_student' && step !== 'summary' && step !== 'transfer_student'"
            ng-disabled="(error | json) != '{}' || isNextButtonShouldDisable()"
            type="button" class="btn btn-default btn-next" ng-click="goToNextStep()" ng-switch="step">
        <span ng-switch-when="user_details"><?= __('البحث عن الطالب') ?></span>
        <span ng-switch-when="internal_search">
            <span ng-if="isInternalSearchSelected"><?= __('متابعة بالسجل المحدد') ?></span>
            <span ng-if="!isInternalSearchSelected && isExternalSearchEnable"><?= __('البحث في المصدر الخارجي') ?></span>
            <span ng-if="!isInternalSearchSelected && !isExternalSearchEnable"><?= __('متابعة كطالب جديد') ?></span>
        </span>
        <span ng-switch-when="external_search"><?= __('التالي: مراجعة البيانات') ?></span>
        <span ng-switch-when="confirmation"><?= __('التالي: بيانات القبول') ?></span>
    </button>
    <button ng-if="step === 'summary' && isDiffSchool" type="button" class="btn btn-default btn-next"
            ng-disabled="(error | json) != '{}'" ng-click="transferStudentNextStep()"><?= __('متابعة نقل الطالب') ?></button>
    <button ng-if="step === 'transfer_student' && notSaved" type="button" class="btn btn-default btn-next"
            ng-click="transferStudent()" ng-disabled="(error | json) != '{}' || isValidating || isConfirming">
        <span ng-if="!isValidating && !isConfirming"><?= __('حفظ طلب النقل') ?></span>
        <span ng-if="isValidating && !isConfirming"><?= __('جارٍ التحقق…') ?></span>
        <span ng-if="isConfirming"><?= __('جارٍ الحفظ…') ?></span>
    </button>
    <button ng-if="step === 'summary' && redirectToGuardian" type="button" class="btn btn-default btn-next"
            ng-click="addGuardian()"><?= __('التالي: إضافة ولي الأمر ورقمه') ?></button>
    <?= $this->Html->link(__('العودة إلى قائمة الطلاب'), [
        'plugin' => 'Institution', 'controller' => 'Institutions', 'action' => 'Students', 'index',
        $this->ControllerAction->paramsEncode(['id' => $institutionId, 'institution_id' => $institutionId]),
    ], ['class' => 'btn close-btn', 'ng-if' => "step === 'summary'"]) ?>
    <p class="text-danger" role="status" ng-if="(error | json) != '{}'">
        <?= __('راجع الرسائل تحت الحقول وصحّح البيانات لتتمكن من المتابعة.') ?>
    </p>
</div>
