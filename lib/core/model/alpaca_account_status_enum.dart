import 'package:piapiri_v2/common/utils/images_path.dart';

enum AlpacaAccountStatusEnum {
  incative('INACTIVE', 'status_inactive_title', 'status_inactive_description', null),
  onboarding('ONBOARDING', 'status_onboarding_title', 'status_onboarding_description', null),
  submitted('SUBMITTED', 'status_submitted_title', 'status_submitted_description', null),
  submissionFailed('SUBMISSION_FAILED', 'status_submission_failed_title', 'status_submission_failed_description', null),
  actionRequired('ACTION_REQUIRED', 'status_action_required_title', 'status_action_required_description', null),
  accountUpdated('ACCOUNT_UPDATED', 'status_account_updated_title', 'status_account_updated_description', null),
  approvalPending(
      'APPROVAL_PENDING', 'status_approval_pending_title', 'status_approval_pending_description', ImagesPath.clock),
  approved('APPROVED', 'status_approved_title', 'status_approved_description', ImagesPath.checkCircle),
  rejected('REJECTED', 'status_rejected_title', 'status_rejected_description', ImagesPath.x),
  active('ACTIVE', 'status_active_title', 'status_active_description', ImagesPath.checkCircle),
  accountClosed('ACCOUNT_CLOSED', 'status_account_closed_title', 'status_account_closed_description', null);

  const AlpacaAccountStatusEnum(this.value, this.localizationKey, this.descriptionKey, this.iconPath);
  final String value;
  final String localizationKey;
  final String descriptionKey;
  final String? iconPath;
}
