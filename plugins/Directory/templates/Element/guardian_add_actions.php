<div role="group" aria-label="<?= __('إجراءات إضافة ولي الأمر') ?>">
    <button ng-if="step === 'user_details'" type="button" class="btn close-btn"
            ng-click="cancelProcess()"><?= __('إلغاء') ?></button>
    <button ng-if="step !== 'user_details' && step !== 'summary'" type="button" class="btn btn-prev close-btn"
            ng-click="goToPrevStep()"><?= __('السابق') ?></button>
    <button ng-if="step !== 'confirmation' && step !== 'summary'" type="button" class="btn btn-default btn-next"
            ng-disabled="(error | json) != '{}' || isNextButtonShouldDisable()" ng-click="goToNextStep()">
        <span ng-if="step === 'user_details'"><?= __('البحث عن ولي الأمر') ?></span>
        <span ng-if="step !== 'user_details'"><?= __('التالي: مراجعة بيانات ولي الأمر') ?></span>
    </button>
    <button ng-if="step === 'confirmation'" type="button" class="btn btn-default"
            ng-click="validateConfirmDetails()" ng-disabled="(error | json) != '{}'">
        <?= __('حفظ ولي الأمر وربطه بالطالب') ?>
    </button>
    <button ng-if="step === 'summary'" type="button" class="btn btn-default"
            ng-click="addGuardian()"><?= __('إضافة ولي أمر آخر') ?></button>
    <?php if (!empty($institutionId)) : ?>
        <?= $this->Html->link(__('العودة إلى قائمة الطلاب لمتابعة القبول'), [
            'plugin' => 'Institution', 'controller' => 'Institutions', 'action' => 'Students', 'index',
            $this->ControllerAction->paramsEncode(['id' => $institutionId, 'institution_id' => $institutionId]),
        ], ['class' => 'btn close-btn', 'ng-if' => "step === 'summary'"]) ?>
    <?php else : ?>
        <button ng-if="step === 'summary'" type="button" class="btn close-btn"
                ng-click="cancelProcess()"><?= __('إغلاق') ?></button>
    <?php endif; ?>
</div>
