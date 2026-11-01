SET SESSION restrict_fk_on_non_standard_key=OFF;
SET FOREIGN_KEY_CHECKS=0;
-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: tst-rds-001.cylegaoegjx0.ap-southeast-1.rds.amazonaws.com
-- Generation Time: Jun 19, 2025 at 04:54 AM
-- Server version: 8.0.32
-- PHP Version: 7.4.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

ALTER TABLE `competency_criterias`
  ADD CONSTRAINT `compe_crite_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `compe_crite_fk_com_gra_typ_id` FOREIGN KEY (`competency_grading_type_id`) REFERENCES `competency_grading_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `compe_crite_fk_com_ite_id` FOREIGN KEY (`competency_item_id`) REFERENCES `competency_items` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `compe_crite_fk_com_tem_id` FOREIGN KEY (`competency_template_id`) REFERENCES `competency_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `competency_grading_options`
--
ALTER TABLE `competency_grading_options`
  ADD CONSTRAINT `compe_gradi_optio_fk_com_gra_typ_id` FOREIGN KEY (`competency_grading_type_id`) REFERENCES `competency_grading_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `competency_items`
--
ALTER TABLE `competency_items`
  ADD CONSTRAINT `compe_items_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `compe_items_fk_com_tem_id` FOREIGN KEY (`competency_template_id`) REFERENCES `competency_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `competency_items_periods`
--
ALTER TABLE `competency_items_periods`
  ADD CONSTRAINT `compe_items_perio_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `compe_items_perio_fk_com_ite_id` FOREIGN KEY (`competency_item_id`) REFERENCES `competency_items` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `compe_items_perio_fk_com_per_id` FOREIGN KEY (`competency_period_id`) REFERENCES `competency_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `compe_items_perio_fk_com_tem_id` FOREIGN KEY (`competency_template_id`) REFERENCES `competency_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `competency_periods`
--
ALTER TABLE `competency_periods`
  ADD CONSTRAINT `compe_perio_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `compe_perio_fk_com_tem_id` FOREIGN KEY (`competency_template_id`) REFERENCES `competency_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `competency_templates`
--
ALTER TABLE `competency_templates`
  ADD CONSTRAINT `compe_templ_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `compe_templ_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `contact_types`
--
ALTER TABLE `contact_types`
  ADD CONSTRAINT `conta_types_fk_con_opt_id` FOREIGN KEY (`contact_option_id`) REFERENCES `contact_options` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `counsellings`
--
ALTER TABLE `counsellings`
  ADD CONSTRAINT `insti_couns_fk_cou_id` FOREIGN KEY (`counselor_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_couns_fk_gui_typ_id` FOREIGN KEY (`guidance_type_id`) REFERENCES `guidance_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_couns_fk_reque_id` FOREIGN KEY (`requester_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_couns_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `custom_field_options`
--
ALTER TABLE `custom_field_options`
  ADD CONSTRAINT `custo_field_optio_fk_cus_fie_id` FOREIGN KEY (`custom_field_id`) REFERENCES `custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `custom_field_values`
--
ALTER TABLE `custom_field_values`
  ADD CONSTRAINT `custo_field_value_fk_cus_fie_id` FOREIGN KEY (`custom_field_id`) REFERENCES `custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `custo_field_value_fk_cus_rec_id` FOREIGN KEY (`custom_record_id`) REFERENCES `custom_records` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `custom_forms`
--
ALTER TABLE `custom_forms`
  ADD CONSTRAINT `custo_forms_fk_cus_mod_id` FOREIGN KEY (`custom_module_id`) REFERENCES `custom_modules` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `custom_forms_fields`
--
ALTER TABLE `custom_forms_fields`
  ADD CONSTRAINT `custo_forms_field_fk_cus_fie_id` FOREIGN KEY (`custom_field_id`) REFERENCES `custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `custo_forms_field_fk_cus_for_id` FOREIGN KEY (`custom_form_id`) REFERENCES `custom_forms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `custom_forms_filters`
--
ALTER TABLE `custom_forms_filters`
  ADD CONSTRAINT `custo_forms_filte_fk_cus_for_id` FOREIGN KEY (`custom_form_id`) REFERENCES `custom_forms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `custom_records`
--
ALTER TABLE `custom_records`
  ADD CONSTRAINT `custo_recor_fk_cus_for_id` FOREIGN KEY (`custom_form_id`) REFERENCES `custom_forms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `custom_table_cells`
--
ALTER TABLE `custom_table_cells`
  ADD CONSTRAINT `custo_table_cells_fk_cus_fie_id` FOREIGN KEY (`custom_field_id`) REFERENCES `custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `custo_table_cells_fk_cus_rec_id` FOREIGN KEY (`custom_record_id`) REFERENCES `custom_records` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `custo_table_cells_fk_cus_tab_col_id` FOREIGN KEY (`custom_table_column_id`) REFERENCES `custom_table_columns` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `custo_table_cells_fk_cus_tab_row_id` FOREIGN KEY (`custom_table_row_id`) REFERENCES `custom_table_rows` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `custom_table_columns`
--
ALTER TABLE `custom_table_columns`
  ADD CONSTRAINT `custo_table_colum_fk_cus_fie_id` FOREIGN KEY (`custom_field_id`) REFERENCES `custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `custom_table_rows`
--
ALTER TABLE `custom_table_rows`
  ADD CONSTRAINT `custo_table_rows_fk_cus_fie_id` FOREIGN KEY (`custom_field_id`) REFERENCES `custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `education_cycles`
--
ALTER TABLE `education_cycles`
  ADD CONSTRAINT `educa_cycle_fk_edu_lev_id` FOREIGN KEY (`education_level_id`) REFERENCES `education_levels` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `education_field_of_studies`
--
ALTER TABLE `education_field_of_studies`
  ADD CONSTRAINT `educa_field_of_studi_fk_edu_pro_ori_id` FOREIGN KEY (`education_programme_orientation_id`) REFERENCES `education_programme_orientations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `education_grades`
--
ALTER TABLE `education_grades`
  ADD CONSTRAINT `educa_grade_fk_edu_pro_id` FOREIGN KEY (`education_programme_id`) REFERENCES `education_programmes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `educa_grade_fk_edu_sta_id` FOREIGN KEY (`education_stage_id`) REFERENCES `education_stages` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `education_grades_cumulative_gpa`
--
ALTER TABLE `education_grades_cumulative_gpa`
  ADD CONSTRAINT `fk_main_education_grade_id` FOREIGN KEY (`main_education_grade_id`) REFERENCES `education_grades` (`id`);

--
-- Constraints for table `education_grades_subjects`
--
ALTER TABLE `education_grades_subjects`
  ADD CONSTRAINT `educa_grade_subje_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `educa_grade_subje_fk_edu_sub_id` FOREIGN KEY (`education_subject_id`) REFERENCES `education_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `education_levels`
--
ALTER TABLE `education_levels`
  ADD CONSTRAINT `educa_level_fk_edu_lev_isc_id` FOREIGN KEY (`education_level_isced_id`) REFERENCES `education_level_isced` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `educa_level_fk_edu_sys_id` FOREIGN KEY (`education_system_id`) REFERENCES `education_systems` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `education_programmes`
--
ALTER TABLE `education_programmes`
  ADD CONSTRAINT `educa_progr_fk_edu_cer_id` FOREIGN KEY (`education_certification_id`) REFERENCES `education_certifications` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `educa_progr_fk_edu_cyc_id` FOREIGN KEY (`education_cycle_id`) REFERENCES `education_cycles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `educa_progr_fk_edu_fie_of_stu_id` FOREIGN KEY (`education_field_of_study_id`) REFERENCES `education_field_of_studies` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `education_programmes_next_programmes`
--
ALTER TABLE `education_programmes_next_programmes`
  ADD CONSTRAINT `educa_progr_next_progr_fk_edu_pro_id` FOREIGN KEY (`education_programme_id`) REFERENCES `education_programmes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `education_subjects_field_of_studies`
--
ALTER TABLE `education_subjects_field_of_studies`
  ADD CONSTRAINT `educa_subje_field_of_studi_fk_edu_fie_of_stu_id` FOREIGN KEY (`education_field_of_study_id`) REFERENCES `education_field_of_studies` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `educa_subje_field_of_studi_fk_edu_sub_id` FOREIGN KEY (`education_subject_id`) REFERENCES `education_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `education_systems`
--
ALTER TABLE `education_systems`
  ADD CONSTRAINT `educa_syste_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `email_process_attachments`
--
ALTER TABLE `email_process_attachments`
  ADD CONSTRAINT `email_proce_attac_fk_ema_pro_id` FOREIGN KEY (`email_process_id`) REFERENCES `email_processes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `examinations`
--
ALTER TABLE `examinations`
  ADD CONSTRAINT `exami_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `examination_centres`
--
ALTER TABLE `examination_centres`
  ADD CONSTRAINT `exami_centr_fk_are_id` FOREIGN KEY (`area_id`) REFERENCES `areas` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `examination_centres_examinations`
--
ALTER TABLE `examination_centres_examinations`
  ADD CONSTRAINT `exami_centr_exami_fk_exa_cen_id` FOREIGN KEY (`examination_centre_id`) REFERENCES `examination_centres` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_exami_fk_exa_id` FOREIGN KEY (`examination_id`) REFERENCES `examinations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `examination_centres_examinations_institutions`
--
ALTER TABLE `examination_centres_examinations_institutions`
  ADD CONSTRAINT `exami_centr_exami_insti_fk_exa_cen_id` FOREIGN KEY (`examination_centre_id`) REFERENCES `examination_centres` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_exami_insti_fk_exa_id` FOREIGN KEY (`examination_id`) REFERENCES `examinations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_exami_insti_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `examination_centres_examinations_invigilators`
--
ALTER TABLE `examination_centres_examinations_invigilators`
  ADD CONSTRAINT `exami_centr_exami_invig_fk_exa_cen_id` FOREIGN KEY (`examination_centre_id`) REFERENCES `examination_centres` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_exami_invig_fk_exa_id` FOREIGN KEY (`examination_id`) REFERENCES `examinations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_exami_invig_fk_invig_id` FOREIGN KEY (`invigilator_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `examination_centres_examinations_students`
--
ALTER TABLE `examination_centres_examinations_students`
  ADD CONSTRAINT `exami_centr_exami_stude_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_exami_stude_fk_exa_cen_id` FOREIGN KEY (`examination_centre_id`) REFERENCES `examination_centres` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_exami_stude_fk_exa_id` FOREIGN KEY (`examination_id`) REFERENCES `examinations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_exami_stude_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_exami_stude_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `examination_centres_examinations_subjects`
--
ALTER TABLE `examination_centres_examinations_subjects`
  ADD CONSTRAINT `exami_centr_exami_subje_fk_edu_sub_id` FOREIGN KEY (`education_subject_id`) REFERENCES `education_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_exami_subje_fk_exa_cen_id` FOREIGN KEY (`examination_centre_id`) REFERENCES `examination_centres` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_exami_subje_fk_exa_id` FOREIGN KEY (`examination_id`) REFERENCES `examinations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_exami_subje_fk_exa_ite_id` FOREIGN KEY (`examination_subject_id`) REFERENCES `examination_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `examination_centres_examinations_subjects_students`
--
ALTER TABLE `examination_centres_examinations_subjects_students`
  ADD CONSTRAINT `exami_centr_exami_subje_stude_fk_edu_sub_id` FOREIGN KEY (`education_subject_id`) REFERENCES `education_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_exami_subje_stude_fk_exa_cen_id` FOREIGN KEY (`examination_centre_id`) REFERENCES `examination_centres` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_exami_subje_stude_fk_exa_id` FOREIGN KEY (`examination_id`) REFERENCES `examinations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_exami_subje_stude_fk_exa_ite_id` FOREIGN KEY (`examination_subject_id`) REFERENCES `examination_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_exami_subje_stude_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `examination_centre_rooms`
--
ALTER TABLE `examination_centre_rooms`
  ADD CONSTRAINT `exami_centr_rooms_fk_exa_cen_id` FOREIGN KEY (`examination_centre_id`) REFERENCES `examination_centres` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `examination_centre_rooms_examinations`
--
ALTER TABLE `examination_centre_rooms_examinations`
  ADD CONSTRAINT `exami_centr_rooms_exami_fk_exa_cen_id` FOREIGN KEY (`examination_centre_id`) REFERENCES `examination_centres` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_rooms_exami_fk_exa_cen_roo_id` FOREIGN KEY (`examination_centre_room_id`) REFERENCES `examination_centre_rooms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_rooms_exami_fk_exa_id` FOREIGN KEY (`examination_id`) REFERENCES `examinations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `examination_centre_rooms_examinations_invigilators`
--
ALTER TABLE `examination_centre_rooms_examinations_invigilators`
  ADD CONSTRAINT `exami_centr_rooms_exami_invig_fk_exa_cen_id` FOREIGN KEY (`examination_centre_id`) REFERENCES `examination_centres` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_rooms_exami_invig_fk_exa_cen_roo_id` FOREIGN KEY (`examination_centre_room_id`) REFERENCES `examination_centre_rooms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_rooms_exami_invig_fk_exa_id` FOREIGN KEY (`examination_id`) REFERENCES `examinations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_rooms_exami_invig_fk_invig_id` FOREIGN KEY (`invigilator_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `examination_centre_rooms_examinations_students`
--
ALTER TABLE `examination_centre_rooms_examinations_students`
  ADD CONSTRAINT `exami_centr_rooms_exami_stude_fk_exa_cen_id` FOREIGN KEY (`examination_centre_id`) REFERENCES `examination_centres` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_rooms_exami_stude_fk_exa_cen_roo_id` FOREIGN KEY (`examination_centre_room_id`) REFERENCES `examination_centre_rooms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_rooms_exami_stude_fk_exa_id` FOREIGN KEY (`examination_id`) REFERENCES `examinations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_rooms_exami_stude_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `examination_centre_special_needs`
--
ALTER TABLE `examination_centre_special_needs`
  ADD CONSTRAINT `exami_centr_speci_needs_fk_exa_cen_id` FOREIGN KEY (`examination_centre_id`) REFERENCES `examination_centres` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_centr_speci_needs_fk_speci_need_type_id` FOREIGN KEY (`special_need_type_id`) REFERENCES `special_need_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `examination_grading_options`
--
ALTER TABLE `examination_grading_options`
  ADD CONSTRAINT `exami_gradi_optio_fk_exa_gra_typ_id` FOREIGN KEY (`examination_grading_type_id`) REFERENCES `examination_grading_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `examination_student_subjects`
--
ALTER TABLE `examination_student_subjects`
  ADD CONSTRAINT `examination_student_subjects_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`),
  ADD CONSTRAINT `examination_student_subjects_ibfk_2` FOREIGN KEY (`examination_subject_id`) REFERENCES `examination_subjects` (`id`);

--
-- Constraints for table `examination_student_subject_results`
--
ALTER TABLE `examination_student_subject_results`
  ADD CONSTRAINT `exami_item_resul_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_item_resul_fk_edu_sub_id` FOREIGN KEY (`education_subject_id`) REFERENCES `education_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_item_resul_fk_exa_cen_id` FOREIGN KEY (`examination_centre_id`) REFERENCES `examination_centres` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_item_resul_fk_exa_gra_opt_id` FOREIGN KEY (`examination_grading_option_id`) REFERENCES `examination_grading_options` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_item_resul_fk_exa_id` FOREIGN KEY (`examination_id`) REFERENCES `examinations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_item_resul_fk_exa_ite_id` FOREIGN KEY (`examination_subject_id`) REFERENCES `examination_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_item_resul_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_item_resul_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `examination_subjects`
--
ALTER TABLE `examination_subjects`
  ADD CONSTRAINT `exami_items_fk_edu_sub_id` FOREIGN KEY (`education_subject_id`) REFERENCES `education_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_items_fk_exa_gra_typ_id` FOREIGN KEY (`examination_grading_type_id`) REFERENCES `examination_grading_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `exami_items_fk_exa_id` FOREIGN KEY (`examination_id`) REFERENCES `examinations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `feeders_institutions`
--
ALTER TABLE `feeders_institutions`
  ADD CONSTRAINT `feede_insti_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `feede_insti_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `feede_insti_fk_fee_ins_id` FOREIGN KEY (`feeder_institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `feede_insti_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `floor_custom_field_values`
--
ALTER TABLE `floor_custom_field_values`
  ADD CONSTRAINT `floor_custo_field_value_fk_inf_cus_fie_id` FOREIGN KEY (`infrastructure_custom_field_id`) REFERENCES `infrastructure_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `floor_custo_field_value_fk_insti_floor_id` FOREIGN KEY (`institution_floor_id`) REFERENCES `institution_floors` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `gpa_grading_options`
--
ALTER TABLE `gpa_grading_options`
  ADD CONSTRAINT `fk_gpa_grading_type_id` FOREIGN KEY (`gpa_grading_type_id`) REFERENCES `gpa_grading_types` (`id`);

--
-- Constraints for table `guardian_relations`
--
ALTER TABLE `guardian_relations`
  ADD CONSTRAINT `guard_relat_fk_gen_id` FOREIGN KEY (`gender_id`) REFERENCES `genders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `historical_staff_leave`
--
ALTER TABLE `historical_staff_leave`
  ADD CONSTRAINT `histo_staff_leave_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `histo_staff_leave_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `histo_staff_leave_fk_staff_leave_type_id` FOREIGN KEY (`staff_leave_type_id`) REFERENCES `staff_leave_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `idp_google`
--
ALTER TABLE `idp_google`
  ADD CONSTRAINT `idp_googl_fk_syste_authe_id` FOREIGN KEY (`system_authentication_id`) REFERENCES `system_authentications` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `idp_oauth`
--
ALTER TABLE `idp_oauth`
  ADD CONSTRAINT `idp_oauth_fk_syste_authe_id` FOREIGN KEY (`system_authentication_id`) REFERENCES `system_authentications` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `idp_saml`
--
ALTER TABLE `idp_saml`
  ADD CONSTRAINT `idp_saml_fk_syste_authe_id` FOREIGN KEY (`system_authentication_id`) REFERENCES `system_authentications` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `infrastructure_custom_field_options`
--
ALTER TABLE `infrastructure_custom_field_options`
  ADD CONSTRAINT `infra_custo_field_optio_fk_inf_cus_fie_id` FOREIGN KEY (`infrastructure_custom_field_id`) REFERENCES `infrastructure_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `infrastructure_custom_forms`
--
ALTER TABLE `infrastructure_custom_forms`
  ADD CONSTRAINT `infra_custo_forms_fk_cus_mod_id` FOREIGN KEY (`custom_module_id`) REFERENCES `custom_modules` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `infrastructure_custom_forms_fields`
--
ALTER TABLE `infrastructure_custom_forms_fields`
  ADD CONSTRAINT `infra_custo_forms_field_fk_inf_cus_fie_id` FOREIGN KEY (`infrastructure_custom_field_id`) REFERENCES `infrastructure_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_custo_forms_field_fk_inf_cus_for_id` FOREIGN KEY (`infrastructure_custom_form_id`) REFERENCES `infrastructure_custom_forms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `infrastructure_custom_forms_filters`
--
ALTER TABLE `infrastructure_custom_forms_filters`
  ADD CONSTRAINT `infra_custo_forms_filte_fk_inf_cus_for_id` FOREIGN KEY (`infrastructure_custom_form_id`) REFERENCES `infrastructure_custom_forms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `infrastructure_needs`
--
ALTER TABLE `infrastructure_needs`
  ADD CONSTRAINT `infra_needs_fk_inf_nee_typ_id` FOREIGN KEY (`infrastructure_need_type_id`) REFERENCES `infrastructure_need_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_needs_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `infrastructure_projects`
--
ALTER TABLE `infrastructure_projects`
  ADD CONSTRAINT `infra_proje_fk_inf_pro_fun_sou_id` FOREIGN KEY (`infrastructure_project_funding_source_id`) REFERENCES `infrastructure_project_funding_sources` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_proje_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `infrastructure_projects_needs`
--
ALTER TABLE `infrastructure_projects_needs`
  ADD CONSTRAINT `infra_proje_needs_fk_inf_nee_id` FOREIGN KEY (`infrastructure_need_id`) REFERENCES `infrastructure_needs` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_proje_needs_fk_inf_pro_id` FOREIGN KEY (`infrastructure_project_id`) REFERENCES `infrastructure_projects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `infrastructure_utility_electricities`
--
ALTER TABLE `infrastructure_utility_electricities`
  ADD CONSTRAINT `infra_utili_elect_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_utili_elect_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_utili_elect_fk_utili_elect_condi_id` FOREIGN KEY (`utility_electricity_condition_id`) REFERENCES `utility_electricity_conditions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_utili_elect_fk_utili_elect_type_id` FOREIGN KEY (`utility_electricity_type_id`) REFERENCES `utility_electricity_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `infrastructure_utility_internets`
--
ALTER TABLE `infrastructure_utility_internets`
  ADD CONSTRAINT `infra_utili_inter_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_utili_inter_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_utili_inter_fk_utili_inter_bandw_id` FOREIGN KEY (`utility_internet_bandwidth_id`) REFERENCES `utility_internet_bandwidths` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_utili_inter_fk_utili_inter_condi_id` FOREIGN KEY (`utility_internet_condition_id`) REFERENCES `utility_internet_conditions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_utili_inter_fk_utili_inter_type_id` FOREIGN KEY (`utility_internet_type_id`) REFERENCES `utility_internet_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `infrastructure_utility_telephones`
--
ALTER TABLE `infrastructure_utility_telephones`
  ADD CONSTRAINT `infra_utili_telep_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_utili_telep_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_utili_telep_fk_utili_telep_condi_id` FOREIGN KEY (`utility_telephone_condition_id`) REFERENCES `utility_telephone_conditions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_utili_telep_fk_utili_telep_type_id` FOREIGN KEY (`utility_telephone_type_id`) REFERENCES `utility_telephone_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `infrastructure_wash_hygienes`
--
ALTER TABLE `infrastructure_wash_hygienes`
  ADD CONSTRAINT `infra_wash_hygie_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_hygie_fk_inf_was_hyg_edu_id` FOREIGN KEY (`infrastructure_wash_hygiene_education_id`) REFERENCES `infrastructure_wash_hygiene_educations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_hygie_fk_inf_was_hyg_soa_ava` FOREIGN KEY (`infrastructure_wash_hygiene_soapash_availability_id`) REFERENCES `infrastructure_wash_hygiene_soapash_availabilities` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_hygie_fk_inf_was_hyg_typ_id` FOREIGN KEY (`infrastructure_wash_hygiene_type_id`) REFERENCES `infrastructure_wash_hygiene_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_hygie_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `infrastructure_wash_hygiene_quantities`
--
ALTER TABLE `infrastructure_wash_hygiene_quantities`
  ADD CONSTRAINT `infra_wash_hygie_quant_fk_inf_was_hyg_id` FOREIGN KEY (`infrastructure_wash_hygiene_id`) REFERENCES `infrastructure_wash_hygienes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `infrastructure_wash_sanitations`
--
ALTER TABLE `infrastructure_wash_sanitations`
  ADD CONSTRAINT `infra_wash_sanit_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_sanit_fk_inf_was_san_acc_id` FOREIGN KEY (`infrastructure_wash_sanitation_accessibility_id`) REFERENCES `infrastructure_wash_sanitation_accessibilities` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_sanit_fk_inf_was_san_qua_id` FOREIGN KEY (`infrastructure_wash_sanitation_quality_id`) REFERENCES `infrastructure_wash_sanitation_qualities` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_sanit_fk_inf_was_san_typ_id` FOREIGN KEY (`infrastructure_wash_sanitation_type_id`) REFERENCES `infrastructure_wash_sanitation_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_sanit_fk_inf_was_san_use_id` FOREIGN KEY (`infrastructure_wash_sanitation_use_id`) REFERENCES `infrastructure_wash_sanitation_uses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_sanit_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `infrastructure_wash_sanitation_quantities`
--
ALTER TABLE `infrastructure_wash_sanitation_quantities`
  ADD CONSTRAINT `infra_wash_sanit_quant_fk_inf_was_san_id` FOREIGN KEY (`infrastructure_wash_sanitation_id`) REFERENCES `infrastructure_wash_sanitations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `infrastructure_wash_sewages`
--
ALTER TABLE `infrastructure_wash_sewages`
  ADD CONSTRAINT `infra_wash_sewag_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_sewag_fk_inf_was_sew_fun_id` FOREIGN KEY (`infrastructure_wash_sewage_functionality_id`) REFERENCES `infrastructure_wash_sewage_functionalities` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_sewag_fk_inf_was_sew_typ_id` FOREIGN KEY (`infrastructure_wash_sewage_type_id`) REFERENCES `infrastructure_wash_sewage_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_sewag_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `infrastructure_wash_wastes`
--
ALTER TABLE `infrastructure_wash_wastes`
  ADD CONSTRAINT `infra_wash_waste_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_waste_fk_inf_was_was_fun_id` FOREIGN KEY (`infrastructure_wash_waste_functionality_id`) REFERENCES `infrastructure_wash_waste_functionalities` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_waste_fk_inf_was_was_typ_id` FOREIGN KEY (`infrastructure_wash_waste_type_id`) REFERENCES `infrastructure_wash_waste_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_waste_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `infrastructure_wash_waters`
--
ALTER TABLE `infrastructure_wash_waters`
  ADD CONSTRAINT `infra_wash_water_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_water_fk_inf_was_wat_acc_id` FOREIGN KEY (`infrastructure_wash_water_accessibility_id`) REFERENCES `infrastructure_wash_water_accessibilities` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_water_fk_inf_was_wat_fun_id` FOREIGN KEY (`infrastructure_wash_water_functionality_id`) REFERENCES `infrastructure_wash_water_functionalities` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_water_fk_inf_was_wat_pro_id` FOREIGN KEY (`infrastructure_wash_water_proximity_id`) REFERENCES `infrastructure_wash_water_proximities` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_water_fk_inf_was_wat_quality_id` FOREIGN KEY (`infrastructure_wash_water_quality_id`) REFERENCES `infrastructure_wash_water_qualities` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_water_fk_inf_was_wat_quantity_id` FOREIGN KEY (`infrastructure_wash_water_quantity_id`) REFERENCES `infrastructure_wash_water_quantities` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_water_fk_inf_was_wat_typ_id` FOREIGN KEY (`infrastructure_wash_water_type_id`) REFERENCES `infrastructure_wash_water_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `infra_wash_water_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institutions`
--
ALTER TABLE `institutions`
  ADD CONSTRAINT `insti_fk_are_adm_id` FOREIGN KEY (`area_administrative_id`) REFERENCES `area_administratives` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_fk_are_id` FOREIGN KEY (`area_id`) REFERENCES `areas` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_fk_insti_gende_id` FOREIGN KEY (`institution_gender_id`) REFERENCES `institution_genders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_fk_insti_local_id` FOREIGN KEY (`institution_locality_id`) REFERENCES `institution_localities` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_fk_insti_owner_id` FOREIGN KEY (`institution_ownership_id`) REFERENCES `institution_ownerships` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_fk_insti_provi_id` FOREIGN KEY (`institution_provider_id`) REFERENCES `institution_providers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_fk_insti_secto_id` FOREIGN KEY (`institution_sector_id`) REFERENCES `institution_sectors` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_fk_insti_statu_id` FOREIGN KEY (`institution_status_id`) REFERENCES `institution_statuses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_fk_insti_type_id` FOREIGN KEY (`institution_type_id`) REFERENCES `institution_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_fk_secur_group_id` FOREIGN KEY (`security_group_id`) REFERENCES `security_groups` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_activities`
--
ALTER TABLE `institution_activities`
  ADD CONSTRAINT `insti_activ_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_assets`
--
ALTER TABLE `institution_assets`
  ADD CONSTRAINT `insti_asset_fk_ass_con_id` FOREIGN KEY (`asset_condition_id`) REFERENCES `asset_conditions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_asset_fk_ass_sta_id` FOREIGN KEY (`asset_status_id`) REFERENCES `asset_statuses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_asset_fk_ass_typ_id` FOREIGN KEY (`asset_type_id`) REFERENCES `asset_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_asset_fk_asset_make_id` FOREIGN KEY (`asset_make_id`) REFERENCES `asset_makes` (`id`),
  ADD CONSTRAINT `insti_asset_fk_asset_model_id` FOREIGN KEY (`asset_model_id`) REFERENCES `asset_models` (`id`),
  ADD CONSTRAINT `insti_asset_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_asset_fk_insti_room_id` FOREIGN KEY (`institution_room_id`) REFERENCES `institution_rooms` (`id`),
  ADD CONSTRAINT `insti_asset_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `security_users` (`id`);

--
-- Constraints for table `institution_associations`
--
ALTER TABLE `institution_associations`
  ADD CONSTRAINT `insti_assoc_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_assoc_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_association_staff`
--
ALTER TABLE `institution_association_staff`
  ADD CONSTRAINT `insti_assoc_staff_fk_ins_ass_id` FOREIGN KEY (`institution_association_id`) REFERENCES `institution_associations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_assoc_staff_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_association_student`
--
ALTER TABLE `institution_association_student`
  ADD CONSTRAINT `insti_assoc_stude_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_assoc_stude_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_assoc_stude_fk_ins_ass_id` FOREIGN KEY (`institution_association_id`) REFERENCES `institution_associations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_assoc_stude_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_assoc_stude_fk_stude_statu_id` FOREIGN KEY (`student_status_id`) REFERENCES `student_statuses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_attachments`
--
ALTER TABLE `institution_attachments`
  ADD CONSTRAINT `insti_attac_fk_ins_att_typ_id` FOREIGN KEY (`institution_attachment_type_id`) REFERENCES `institution_attachment_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_attac_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_bank_accounts`
--
ALTER TABLE `institution_bank_accounts`
  ADD CONSTRAINT `insti_bank_accou_fk_ban_bra_id` FOREIGN KEY (`bank_branch_id`) REFERENCES `bank_branches` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_bank_accou_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_budgets`
--
ALTER TABLE `institution_budgets`
  ADD CONSTRAINT `insti_budge_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_budge_fk_bud_typ_id` FOREIGN KEY (`budget_type_id`) REFERENCES `budget_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_budge_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_buses`
--
ALTER TABLE `institution_buses`
  ADD CONSTRAINT `insti_buses_fk_bus_typ_id` FOREIGN KEY (`bus_type_id`) REFERENCES `bus_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_buses_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_buses_fk_insti_trans_provi_id` FOREIGN KEY (`institution_transport_provider_id`) REFERENCES `institution_transport_providers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_buses_fk_trans_statu_id` FOREIGN KEY (`transport_status_id`) REFERENCES `transport_statuses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_buses_transport_features`
--
ALTER TABLE `institution_buses_transport_features`
  ADD CONSTRAINT `insti_buses_trans_featu_fk_ins_bus_id` FOREIGN KEY (`institution_bus_id`) REFERENCES `institution_buses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_buses_trans_featu_fk_trans_featu_id` FOREIGN KEY (`transport_feature_id`) REFERENCES `transport_features` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_cases`
--
ALTER TABLE `institution_cases`
  ADD CONSTRAINT `insti_cases_fk_ass_id` FOREIGN KEY (`assignee_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_cases_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_cases_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `institution_cases_ibfk_1` FOREIGN KEY (`case_type_id`) REFERENCES `case_types` (`id`),
  ADD CONSTRAINT `institution_cases_ibfk_2` FOREIGN KEY (`case_priority_id`) REFERENCES `case_priorities` (`id`);

--
-- Constraints for table `institution_case_comments`
--
ALTER TABLE `institution_case_comments`
  ADD CONSTRAINT `institution_case_comments_ibfk_1` FOREIGN KEY (`case_id`) REFERENCES `institution_cases` (`id`);

--
-- Constraints for table `institution_case_records`
--
ALTER TABLE `institution_case_records`
  ADD CONSTRAINT `insti_case_recor_fk_ins_cas_id` FOREIGN KEY (`institution_case_id`) REFERENCES `institution_cases` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_classes`
--
ALTER TABLE `institution_classes`
  ADD CONSTRAINT `insti_class_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_class_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_class_fk_insti_shift_id` FOREIGN KEY (`institution_shift_id`) REFERENCES `institution_shifts` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_classes_custom_field_values`
--
ALTER TABLE `institution_classes_custom_field_values`
  ADD CONSTRAINT `fk_custom_field` FOREIGN KEY (`institution_custom_field_id`) REFERENCES `institution_custom_fields` (`id`),
  ADD CONSTRAINT `fk_institution_class` FOREIGN KEY (`institution_class_id`) REFERENCES `institution_classes` (`id`);

--
-- Constraints for table `institution_classes_secondary_staff`
--
ALTER TABLE `institution_classes_secondary_staff`
  ADD CONSTRAINT `insti_class_secon_staff_fk_ins_cla_id` FOREIGN KEY (`institution_class_id`) REFERENCES `institution_classes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_class_secon_staff_fk_secon_staff_id` FOREIGN KEY (`secondary_staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_class_attendance_records`
--
ALTER TABLE `institution_class_attendance_records`
  ADD CONSTRAINT `insti_class_atten_recor_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_class_atten_recor_fk_ins_cla_id` FOREIGN KEY (`institution_class_id`) REFERENCES `institution_classes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_class_grades`
--
ALTER TABLE `institution_class_grades`
  ADD CONSTRAINT `insti_class_grade_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_class_grade_fk_ins_cla_id` FOREIGN KEY (`institution_class_id`) REFERENCES `institution_classes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_class_students`
--
ALTER TABLE `institution_class_students`
  ADD CONSTRAINT `insti_class_stude_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_class_stude_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_class_stude_fk_ins_cla_id` FOREIGN KEY (`institution_class_id`) REFERENCES `institution_classes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_class_stude_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_class_stude_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_class_stude_fk_stude_statu_id` FOREIGN KEY (`student_status_id`) REFERENCES `student_statuses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_class_subjects`
--
ALTER TABLE `institution_class_subjects`
  ADD CONSTRAINT `insti_class_subje_fk_ins_cla_id` FOREIGN KEY (`institution_class_id`) REFERENCES `institution_classes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_class_subje_fk_insti_subje_id` FOREIGN KEY (`institution_subject_id`) REFERENCES `institution_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_committees`
--
ALTER TABLE `institution_committees`
  ADD CONSTRAINT `insti_commi_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_commi_fk_ins_com_typ_id` FOREIGN KEY (`institution_committee_type_id`) REFERENCES `institution_committee_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_commi_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_committee_attachments`
--
ALTER TABLE `institution_committee_attachments`
  ADD CONSTRAINT `insti_commi_attac_fk_ins_com_id` FOREIGN KEY (`institution_committee_id`) REFERENCES `institution_committees` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_committee_meeting`
--
ALTER TABLE `institution_committee_meeting`
  ADD CONSTRAINT `insti_commi_meeti_fk_ins_com_id` FOREIGN KEY (`institution_committee_id`) REFERENCES `institution_committees` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_competency_item_comments`
--
ALTER TABLE `institution_competency_item_comments`
  ADD CONSTRAINT `insti_compe_item_comme_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_compe_item_comme_fk_com_ite_id` FOREIGN KEY (`competency_item_id`) REFERENCES `competency_items` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_compe_item_comme_fk_com_per_id` FOREIGN KEY (`competency_period_id`) REFERENCES `competency_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_compe_item_comme_fk_com_tem_id` FOREIGN KEY (`competency_template_id`) REFERENCES `competency_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_compe_item_comme_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_compe_item_comme_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_competency_period_comments`
--
ALTER TABLE `institution_competency_period_comments`
  ADD CONSTRAINT `insti_compe_perio_comme_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_compe_perio_comme_fk_com_per_id` FOREIGN KEY (`competency_period_id`) REFERENCES `competency_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_compe_perio_comme_fk_com_tem_id` FOREIGN KEY (`competency_template_id`) REFERENCES `competency_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_compe_perio_comme_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_compe_perio_comme_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_competency_results`
--
ALTER TABLE `institution_competency_results`
  ADD CONSTRAINT `insti_compe_resul_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_compe_resul_fk_com_cri_id` FOREIGN KEY (`competency_criteria_id`) REFERENCES `competency_criterias` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_compe_resul_fk_com_gra_opt_id` FOREIGN KEY (`competency_grading_option_id`) REFERENCES `competency_grading_options` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_compe_resul_fk_com_ite_id` FOREIGN KEY (`competency_item_id`) REFERENCES `competency_items` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_compe_resul_fk_com_per_id` FOREIGN KEY (`competency_period_id`) REFERENCES `competency_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_compe_resul_fk_com_tem_id` FOREIGN KEY (`competency_template_id`) REFERENCES `competency_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_compe_resul_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_compe_resul_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_consumables`
--
ALTER TABLE `institution_consumables`
  ADD CONSTRAINT `inst_consumables_fk_created_user_id` FOREIGN KEY (`created_user_id`) REFERENCES `security_users` (`id`),
  ADD CONSTRAINT `inst_consumables_fk_institution_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `inst_consumables_fk_item_type_id` FOREIGN KEY (`item_type_id`) REFERENCES `item_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `inst_consumables_fk_modified_user_id` FOREIGN KEY (`modified_user_id`) REFERENCES `security_users` (`id`),
  ADD CONSTRAINT `inst_consumables_fk_stock_unit_id` FOREIGN KEY (`stock_unit_id`) REFERENCES `stock_units` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `institution_consumable_transactions`
--
ALTER TABLE `institution_consumable_transactions`
  ADD CONSTRAINT `fk_institution_consumable_id` FOREIGN KEY (`institution_consumable_id`) REFERENCES `institution_consumables` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_trans_created_user_id` FOREIGN KEY (`created_user_id`) REFERENCES `security_users` (`id`),
  ADD CONSTRAINT `fk_trans_modified_user_id` FOREIGN KEY (`modified_user_id`) REFERENCES `security_users` (`id`);

--
-- Constraints for table `institution_contact_persons`
--
ALTER TABLE `institution_contact_persons`
  ADD CONSTRAINT `insti_conta_perso_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_curriculars`
--
ALTER TABLE `institution_curriculars`
  ADD CONSTRAINT `institution_curriculars_ibfk_1` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`);

--
-- Constraints for table `institution_curricular_staff`
--
ALTER TABLE `institution_curricular_staff`
  ADD CONSTRAINT `institution_curricular_staff_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`);

--
-- Constraints for table `institution_curricular_students`
--
ALTER TABLE `institution_curricular_students`
  ADD CONSTRAINT `institution_curricular_students_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`);

--
-- Constraints for table `institution_custom_field_options`
--
ALTER TABLE `institution_custom_field_options`
  ADD CONSTRAINT `insti_custo_field_optio_fk_ins_cus_fie_id` FOREIGN KEY (`institution_custom_field_id`) REFERENCES `institution_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_custom_field_values`
--
ALTER TABLE `institution_custom_field_values`
  ADD CONSTRAINT `insti_custo_field_value_fk_ins_cus_fie_id` FOREIGN KEY (`institution_custom_field_id`) REFERENCES `institution_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_custo_field_value_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_custom_forms`
--
ALTER TABLE `institution_custom_forms`
  ADD CONSTRAINT `insti_custo_forms_fk_cus_mod_id` FOREIGN KEY (`custom_module_id`) REFERENCES `custom_modules` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_custom_forms_fields`
--
ALTER TABLE `institution_custom_forms_fields`
  ADD CONSTRAINT `insti_custo_forms_field_fk_ins_cus_fie_id` FOREIGN KEY (`institution_custom_field_id`) REFERENCES `institution_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_custo_forms_field_fk_ins_cus_for_id` FOREIGN KEY (`institution_custom_form_id`) REFERENCES `institution_custom_forms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_custom_forms_filters`
--
ALTER TABLE `institution_custom_forms_filters`
  ADD CONSTRAINT `insti_custo_forms_filte_fk_ins_cus_for_id` FOREIGN KEY (`institution_custom_form_id`) REFERENCES `institution_custom_forms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_custom_table_cells`
--
ALTER TABLE `institution_custom_table_cells`
  ADD CONSTRAINT `insti_custo_table_cells_fk_ins_cus_fie_id` FOREIGN KEY (`institution_custom_field_id`) REFERENCES `institution_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_custo_table_cells_fk_ins_cus_tab_col_id` FOREIGN KEY (`institution_custom_table_column_id`) REFERENCES `institution_custom_table_columns` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_custo_table_cells_fk_ins_cus_tab_row_id` FOREIGN KEY (`institution_custom_table_row_id`) REFERENCES `institution_custom_table_rows` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_custo_table_cells_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_custom_table_columns`
--
ALTER TABLE `institution_custom_table_columns`
  ADD CONSTRAINT `insti_custo_table_colum_fk_ins_cus_fie_id` FOREIGN KEY (`institution_custom_field_id`) REFERENCES `institution_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_custom_table_rows`
--
ALTER TABLE `institution_custom_table_rows`
  ADD CONSTRAINT `insti_custo_table_rows_fk_ins_cus_fie_id` FOREIGN KEY (`institution_custom_field_id`) REFERENCES `institution_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_expenditures`
--
ALTER TABLE `institution_expenditures`
  ADD CONSTRAINT `insti_expen_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_expen_fk_bud_typ_id` FOREIGN KEY (`budget_type_id`) REFERENCES `budget_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_expen_fk_exp_typ_id` FOREIGN KEY (`expenditure_type_id`) REFERENCES `expenditure_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_expen_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_fees`
--
ALTER TABLE `institution_fees`
  ADD CONSTRAINT `insti_fees_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_fees_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_fees_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_fee_types`
--
ALTER TABLE `institution_fee_types`
  ADD CONSTRAINT `insti_fee_types_fk_fee_typ_id` FOREIGN KEY (`fee_type_id`) REFERENCES `fee_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_fee_types_fk_ins_fee_id` FOREIGN KEY (`institution_fee_id`) REFERENCES `institution_fees` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_grades`
--
ALTER TABLE `institution_grades`
  ADD CONSTRAINT `insti_grade_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_grade_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_incomes`
--
ALTER TABLE `institution_incomes`
  ADD CONSTRAINT `insti_incom_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_incom_fk_inc_sou_id` FOREIGN KEY (`income_source_id`) REFERENCES `income_sources` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_incom_fk_inc_typ_id` FOREIGN KEY (`income_type_id`) REFERENCES `income_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_incom_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_meal_programmes`
--
ALTER TABLE `institution_meal_programmes`
  ADD CONSTRAINT `insti_meal_progr_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_meal_progr_fk_del_sta_id` FOREIGN KEY (`delivery_status_id`) REFERENCES `meal_status_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_meal_progr_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_meal_progr_fk_meal_progr_id` FOREIGN KEY (`meal_programmes_id`) REFERENCES `meal_programmes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `institution_meal_programmes_ibfk_1` FOREIGN KEY (`meal_rating_id`) REFERENCES `meal_ratings` (`id`);

--
-- Constraints for table `institution_meal_students`
--
ALTER TABLE `institution_meal_students`
  ADD CONSTRAINT `insti_meal_stude_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_meal_stude_fk_ins_cla_id` FOREIGN KEY (`institution_class_id`) REFERENCES `institution_classes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_meal_stude_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_meal_stude_fk_meal_benef_id` FOREIGN KEY (`meal_benefit_id`) REFERENCES `meal_benefits` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_meal_stude_fk_meal_progr_id` FOREIGN KEY (`meal_programmes_id`) REFERENCES `meal_programmes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_meal_stude_fk_meal_recei_id` FOREIGN KEY (`meal_received_id`) REFERENCES `meal_received` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_meal_stude_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_outcome_results`
--
ALTER TABLE `institution_outcome_results`
  ADD CONSTRAINT `insti_outco_resul_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_outco_resul_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_outco_resul_fk_edu_sub_id` FOREIGN KEY (`education_subject_id`) REFERENCES `education_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_outco_resul_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_outco_resul_fk_outco_crite_id` FOREIGN KEY (`outcome_criteria_id`) REFERENCES `outcome_criterias` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_outco_resul_fk_outco_gradi_optio_id` FOREIGN KEY (`outcome_grading_option_id`) REFERENCES `outcome_grading_options` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_outco_resul_fk_outco_perio_id` FOREIGN KEY (`outcome_period_id`) REFERENCES `outcome_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_outco_resul_fk_outco_templ_id` FOREIGN KEY (`outcome_template_id`) REFERENCES `outcome_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_outco_resul_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_outcome_subject_comments`
--
ALTER TABLE `institution_outcome_subject_comments`
  ADD CONSTRAINT `insti_outco_subje_comme_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_outco_subje_comme_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_outco_subje_comme_fk_edu_sub_id` FOREIGN KEY (`education_subject_id`) REFERENCES `education_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_outco_subje_comme_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_outco_subje_comme_fk_outco_perio_id` FOREIGN KEY (`outcome_period_id`) REFERENCES `outcome_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_outco_subje_comme_fk_outco_templ_id` FOREIGN KEY (`outcome_template_id`) REFERENCES `outcome_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_outco_subje_comme_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_positions`
--
ALTER TABLE `institution_positions`
  ADD CONSTRAINT `insti_posit_fk_ass_id` FOREIGN KEY (`assignee_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_posit_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_posit_fk_staff_posit_title_id` FOREIGN KEY (`staff_position_title_id`) REFERENCES `staff_position_titles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_posit_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `institution_positions_ibfk_1` FOREIGN KEY (`shift_id`) REFERENCES `shift_options` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_program_grade_subjects`
--
ALTER TABLE `institution_program_grade_subjects`
  ADD CONSTRAINT `insti_progr_grade_subje_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_progr_grade_subje_fk_edu_gra_sub_id` FOREIGN KEY (`education_grade_subject_id`) REFERENCES `education_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_progr_grade_subje_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_progr_grade_subje_fk_insti_grade_id` FOREIGN KEY (`institution_grade_id`) REFERENCES `institution_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_providers`
--
ALTER TABLE `institution_providers`
  ADD CONSTRAINT `insti_provi_fk_insti_secto_id` FOREIGN KEY (`institution_sector_id`) REFERENCES `institution_sectors` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_quality_rubrics`
--
ALTER TABLE `institution_quality_rubrics`
  ADD CONSTRAINT `insti_quali_rubri_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_quali_rubri_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_quali_rubri_fk_ins_cla_id` FOREIGN KEY (`institution_class_id`) REFERENCES `institution_classes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_quali_rubri_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_quali_rubri_fk_insti_subje_id` FOREIGN KEY (`institution_subject_id`) REFERENCES `institution_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_quali_rubri_fk_rubri_templ_id` FOREIGN KEY (`rubric_template_id`) REFERENCES `rubric_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_quali_rubri_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_quality_rubric_answers`
--
ALTER TABLE `institution_quality_rubric_answers`
  ADD CONSTRAINT `insti_quali_rubri_answe_fk_insti_quali_rubri_id` FOREIGN KEY (`institution_quality_rubric_id`) REFERENCES `institution_quality_rubrics` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_quali_rubri_answe_fk_rubri_crite_id` FOREIGN KEY (`rubric_criteria_id`) REFERENCES `rubric_criterias` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_quali_rubri_answe_fk_rubri_crite_optio_id` FOREIGN KEY (`rubric_criteria_option_id`) REFERENCES `rubric_criteria_options` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_quali_rubri_answe_fk_rubri_secti_id` FOREIGN KEY (`rubric_section_id`) REFERENCES `rubric_sections` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_quality_visits`
--
ALTER TABLE `institution_quality_visits`
  ADD CONSTRAINT `insti_quali_visit_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_quali_visit_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_quali_visit_fk_insti_subje_id` FOREIGN KEY (`institution_subject_id`) REFERENCES `institution_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_quali_visit_fk_quali_visit_type_id` FOREIGN KEY (`quality_visit_type_id`) REFERENCES `quality_visit_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_quali_visit_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_repeater_surveys`
--
ALTER TABLE `institution_repeater_surveys`
  ADD CONSTRAINT `insti_repea_surve_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_repea_surve_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_repea_surve_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_repea_surve_fk_surve_form_id` FOREIGN KEY (`survey_form_id`) REFERENCES `survey_forms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_repeater_survey_answers`
--
ALTER TABLE `institution_repeater_survey_answers`
  ADD CONSTRAINT `insti_repea_surve_answe_fk_insti_repea_surve_id` FOREIGN KEY (`institution_repeater_survey_id`) REFERENCES `institution_repeater_surveys` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_repea_surve_answe_fk_surve_quest_id` FOREIGN KEY (`survey_question_id`) REFERENCES `survey_questions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_repeater_survey_table_cells`
--
ALTER TABLE `institution_repeater_survey_table_cells`
  ADD CONSTRAINT `insti_repea_surve_table_cells_fk_insti_repea_surve_id` FOREIGN KEY (`institution_repeater_survey_id`) REFERENCES `institution_repeater_surveys` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_repea_surve_table_cells_fk_surve_quest_id` FOREIGN KEY (`survey_question_id`) REFERENCES `survey_questions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_repea_surve_table_cells_fk_surve_table_colum_id` FOREIGN KEY (`survey_table_column_id`) REFERENCES `survey_table_columns` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_repea_surve_table_cells_fk_surve_table_row_id` FOREIGN KEY (`survey_table_row_id`) REFERENCES `survey_table_rows` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_report_cards`
--
ALTER TABLE `institution_report_cards`
  ADD CONSTRAINT `insti_repor_cards_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_repor_cards_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_repor_cards_fk_repor_card_id` FOREIGN KEY (`report_card_id`) REFERENCES `profile_templates` (`id`);

--
-- Constraints for table `institution_report_card_processes`
--
ALTER TABLE `institution_report_card_processes`
  ADD CONSTRAINT `insti_repor_card_proce_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_repor_card_proce_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_repor_card_proce_fk_repor_card_id` FOREIGN KEY (`report_card_id`) REFERENCES `profile_templates` (`id`);

--
-- Constraints for table `institution_risks`
--
ALTER TABLE `institution_risks`
  ADD CONSTRAINT `insti_risks_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_risks_fk_risk_id` FOREIGN KEY (`risk_id`) REFERENCES `risks` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_scanned`
--
ALTER TABLE `institution_scanned`
  ADD CONSTRAINT `institution_scanned_ibfk_1` FOREIGN KEY (`openemis_no`) REFERENCES `security_users` (`openemis_no`),
  ADD CONSTRAINT `institution_scanned_ibfk_2` FOREIGN KEY (`created_user_id`) REFERENCES `security_users` (`id`),
  ADD CONSTRAINT `institution_scanned_ibfk_3` FOREIGN KEY (`modified_user_id`) REFERENCES `security_users` (`id`);

--
-- Constraints for table `institution_schedule_curriculum_lessons`
--
ALTER TABLE `institution_schedule_curriculum_lessons`
  ADD CONSTRAINT `insti_sched_curri_lesso_fk_insti_sched_lesso_detai_id` FOREIGN KEY (`institution_schedule_lesson_detail_id`) REFERENCES `institution_schedule_lesson_details` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_sched_curri_lesso_fk_insti_subje_id` FOREIGN KEY (`institution_subject_id`) REFERENCES `institution_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_schedule_intervals`
--
ALTER TABLE `institution_schedule_intervals`
  ADD CONSTRAINT `insti_sched_inter_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_sched_inter_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_sched_inter_fk_insti_shift_id` FOREIGN KEY (`institution_shift_id`) REFERENCES `institution_shifts` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_schedule_lessons`
--
ALTER TABLE `institution_schedule_lessons`
  ADD CONSTRAINT `insti_sched_lesso_fk_insti_sched_times_id` FOREIGN KEY (`institution_schedule_timeslot_id`) REFERENCES `institution_schedule_timeslots` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_sched_lesso_fk_insti_sched_timet_id` FOREIGN KEY (`institution_schedule_timetable_id`) REFERENCES `institution_schedule_timetables` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_schedule_lesson_details`
--
ALTER TABLE `institution_schedule_lesson_details`
  ADD CONSTRAINT `insti_sched_lesso_detai_fk_insti_sched_times_id` FOREIGN KEY (`institution_schedule_timeslot_id`) REFERENCES `institution_schedule_timeslots` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_sched_lesso_detai_fk_insti_sched_timet_id` FOREIGN KEY (`institution_schedule_timetable_id`) REFERENCES `institution_schedule_timetables` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_schedule_lesson_rooms`
--
ALTER TABLE `institution_schedule_lesson_rooms`
  ADD CONSTRAINT `insti_sched_lesso_rooms_fk_insti_room_id` FOREIGN KEY (`institution_room_id`) REFERENCES `institution_rooms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_sched_lesso_rooms_fk_insti_sched_lesso_detai_id` FOREIGN KEY (`institution_schedule_lesson_detail_id`) REFERENCES `institution_schedule_lesson_details` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_schedule_non_curriculum_lessons`
--
ALTER TABLE `institution_schedule_non_curriculum_lessons`
  ADD CONSTRAINT `insti_sched_non_curri_lesso_fk_insti_sched_lesso_detai_id` FOREIGN KEY (`institution_schedule_lesson_detail_id`) REFERENCES `institution_schedule_lesson_details` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_schedule_terms`
--
ALTER TABLE `institution_schedule_terms`
  ADD CONSTRAINT `insti_sched_terms_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_sched_terms_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_schedule_timeslots`
--
ALTER TABLE `institution_schedule_timeslots`
  ADD CONSTRAINT `insti_sched_times_fk_insti_sched_inter_id` FOREIGN KEY (`institution_schedule_interval_id`) REFERENCES `institution_schedule_intervals` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_schedule_timetables`
--
ALTER TABLE `institution_schedule_timetables`
  ADD CONSTRAINT `insti_sched_timet_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_sched_timet_fk_ins_cla_id` FOREIGN KEY (`institution_class_id`) REFERENCES `institution_classes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_sched_timet_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_sched_timet_fk_insti_sched_inter_id` FOREIGN KEY (`institution_schedule_interval_id`) REFERENCES `institution_schedule_intervals` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_sched_timet_fk_insti_sched_term_id` FOREIGN KEY (`institution_schedule_term_id`) REFERENCES `institution_schedule_terms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_schedule_timetable_customizes`
--
ALTER TABLE `institution_schedule_timetable_customizes`
  ADD CONSTRAINT `insti_sched_timet_custo_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_sched_timet_custo_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_sched_timet_custo_fk_insti_sched_timet_id` FOREIGN KEY (`institution_schedule_timetable_id`) REFERENCES `institution_schedule_timetables` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_shifts`
--
ALTER TABLE `institution_shifts`
  ADD CONSTRAINT `insti_shift_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_shift_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_shift_fk_locat_insti_id` FOREIGN KEY (`location_institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_shift_fk_shift_optio_id` FOREIGN KEY (`shift_option_id`) REFERENCES `shift_options` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_shift_periods`
--
ALTER TABLE `institution_shift_periods`
  ADD CONSTRAINT `institution_shift_periods_ibfk_1` FOREIGN KEY (`institution_shift_period_id`) REFERENCES `institution_shifts` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `institution_shift_periods_ibfk_2` FOREIGN KEY (`period_id`) REFERENCES `student_attendance_per_day_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_staff`
--
ALTER TABLE `institution_staff`
  ADD CONSTRAINT `insti_posit_fk_staff_posit_grade_id` FOREIGN KEY (`staff_position_grade_id`) REFERENCES `staff_position_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_fk_insti_posit_id` FOREIGN KEY (`institution_position_id`) REFERENCES `institution_positions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_fk_staff_statu_id` FOREIGN KEY (`staff_status_id`) REFERENCES `staff_statuses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_fk_staff_type_id` FOREIGN KEY (`staff_type_id`) REFERENCES `staff_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_staff_appraisals`
--
ALTER TABLE `institution_staff_appraisals`
  ADD CONSTRAINT `insti_staff_appra_fk_app_for_id` FOREIGN KEY (`appraisal_form_id`) REFERENCES `appraisal_forms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_appra_fk_app_per_id` FOREIGN KEY (`appraisal_period_id`) REFERENCES `appraisal_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_appra_fk_app_typ_id` FOREIGN KEY (`appraisal_type_id`) REFERENCES `appraisal_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_appra_fk_ass_id` FOREIGN KEY (`assignee_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_appra_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_appra_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_appra_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_staff_attendances`
--
ALTER TABLE `institution_staff_attendances`
  ADD CONSTRAINT `insti_staff_atten_fk_abs_typ_id` FOREIGN KEY (`absence_type_id`) REFERENCES `absence_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_atten_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_atten_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_atten_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_staff_attendance_activities`
--
ALTER TABLE `institution_staff_attendance_activities`
  ADD CONSTRAINT `insti_staff_atten_activ_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_staff_duties`
--
ALTER TABLE `institution_staff_duties`
  ADD CONSTRAINT `insti_staff_dutie_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_dutie_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_dutie_fk_staff_dutie_id` FOREIGN KEY (`staff_duties_id`) REFERENCES `staff_duties` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_dutie_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_staff_leave`
--
ALTER TABLE `institution_staff_leave`
  ADD CONSTRAINT `insti_staff_leave_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_leave_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_leave_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_leave_fk_staff_leave_type_id` FOREIGN KEY (`staff_leave_type_id`) REFERENCES `staff_leave_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_leave_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_staff_leave_entitlements`
--
ALTER TABLE `institution_staff_leave_entitlements`
  ADD CONSTRAINT `fk_inst_staff_leave_institution_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `fk_inst_staff_leave_policy_id` FOREIGN KEY (`staff_leave_policy_id`) REFERENCES `staff_leave_policies` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `fk_inst_staff_leave_position_id` FOREIGN KEY (`institution_position_id`) REFERENCES `institution_positions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `fk_inst_staff_leave_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `fk_inst_staff_leave_type_id` FOREIGN KEY (`staff_leave_type_id`) REFERENCES `staff_leave_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_staff_position_profiles`
--
ALTER TABLE `institution_staff_position_profiles`
  ADD CONSTRAINT `insti_staff_posit_profi_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_posit_profi_fk_insti_posit_id` FOREIGN KEY (`institution_position_id`) REFERENCES `institution_positions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_posit_profi_fk_insti_staff_id` FOREIGN KEY (`institution_staff_id`) REFERENCES `institution_staff` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_posit_profi_fk_staff_chang_type_id` FOREIGN KEY (`staff_change_type_id`) REFERENCES `staff_change_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_posit_profi_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_posit_profi_fk_staff_type_id` FOREIGN KEY (`staff_type_id`) REFERENCES `staff_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_posit_profi_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_staff_releases`
--
ALTER TABLE `institution_staff_releases`
  ADD CONSTRAINT `insti_staff_relea_fk_ass_id` FOREIGN KEY (`assignee_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_relea_fk_new_insti_id` FOREIGN KEY (`new_institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_relea_fk_new_insti_posit_id` FOREIGN KEY (`new_institution_position_id`) REFERENCES `institution_positions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_relea_fk_new_staff_type_id` FOREIGN KEY (`new_staff_type_id`) REFERENCES `staff_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_relea_fk_previ_insti_id` FOREIGN KEY (`previous_institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_relea_fk_previ_insti_staff_id` FOREIGN KEY (`previous_institution_staff_id`) REFERENCES `institution_staff` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_relea_fk_previ_staff_type_id` FOREIGN KEY (`previous_staff_type_id`) REFERENCES `staff_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_relea_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_relea_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_staff_shifts`
--
ALTER TABLE `institution_staff_shifts`
  ADD CONSTRAINT `insti_staff_shift_fk_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `institution_shifts` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_shift_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_staff_surveys`
--
ALTER TABLE `institution_staff_surveys`
  ADD CONSTRAINT `institution_staff_surveys_ibfk_1` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`),
  ADD CONSTRAINT `institution_staff_surveys_ibfk_2` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`),
  ADD CONSTRAINT `institution_staff_surveys_ibfk_3` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`),
  ADD CONSTRAINT `institution_staff_surveys_ibfk_4` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`),
  ADD CONSTRAINT `institution_staff_surveys_ibfk_5` FOREIGN KEY (`survey_form_id`) REFERENCES `survey_forms` (`id`),
  ADD CONSTRAINT `institution_staff_surveys_ibfk_6` FOREIGN KEY (`parent_form_id`) REFERENCES `institution_surveys` (`survey_form_id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_staff_survey_answers`
--
ALTER TABLE `institution_staff_survey_answers`
  ADD CONSTRAINT `institution_staff_survey_answers_ibfk_1` FOREIGN KEY (`survey_question_id`) REFERENCES `survey_questions` (`id`),
  ADD CONSTRAINT `institution_staff_survey_answers_ibfk_2` FOREIGN KEY (`institution_staff_survey_id`) REFERENCES `institution_staff_surveys` (`id`);

--
-- Constraints for table `institution_staff_survey_table_cells`
--
ALTER TABLE `institution_staff_survey_table_cells`
  ADD CONSTRAINT `institution_staff_survey_table_cells_ibfk_1` FOREIGN KEY (`institution_staff_survey_id`) REFERENCES `institution_staff_surveys` (`id`),
  ADD CONSTRAINT `institution_staff_survey_table_cells_ibfk_2` FOREIGN KEY (`survey_question_id`) REFERENCES `survey_questions` (`id`),
  ADD CONSTRAINT `institution_staff_survey_table_cells_ibfk_3` FOREIGN KEY (`survey_table_column_id`) REFERENCES `survey_table_columns` (`id`),
  ADD CONSTRAINT `institution_staff_survey_table_cells_ibfk_4` FOREIGN KEY (`survey_table_row_id`) REFERENCES `survey_table_rows` (`id`);

--
-- Constraints for table `institution_staff_transfers`
--
ALTER TABLE `institution_staff_transfers`
  ADD CONSTRAINT `insti_staff_trans_fk_ass_id` FOREIGN KEY (`assignee_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_trans_fk_new_insti_id` FOREIGN KEY (`new_institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_trans_fk_new_insti_posit_id` FOREIGN KEY (`new_institution_position_id`) REFERENCES `institution_positions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_trans_fk_new_staff_type_id` FOREIGN KEY (`new_staff_type_id`) REFERENCES `staff_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_trans_fk_previ_insti_id` FOREIGN KEY (`previous_institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_trans_fk_previ_insti_staff_id` FOREIGN KEY (`previous_institution_staff_id`) REFERENCES `institution_staff` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_trans_fk_previ_staff_type_id` FOREIGN KEY (`previous_staff_type_id`) REFERENCES `staff_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_trans_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_staff_trans_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_students`
--
ALTER TABLE `institution_students`
  ADD CONSTRAINT `insti_stude_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_fk_stude_statu_id` FOREIGN KEY (`student_status_id`) REFERENCES `student_statuses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_students_gpa`
--
ALTER TABLE `institution_students_gpa`
  ADD CONSTRAINT `fk_academic_period_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`),
  ADD CONSTRAINT `fk_education_grade_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`),
  ADD CONSTRAINT `fk_education_grades_gpa_id` FOREIGN KEY (`education_grades_gpa_id`) REFERENCES `education_grades_gpa` (`id`),
  ADD CONSTRAINT `fk_institution_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`),
  ADD CONSTRAINT `fk_student_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`);

--
-- Constraints for table `institution_students_report_cards_comments`
--
ALTER TABLE `institution_students_report_cards_comments`
  ADD CONSTRAINT `insti_stude_repor_cards_comme_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_repor_cards_comme_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_repor_cards_comme_fk_edu_sub_id` FOREIGN KEY (`education_subject_id`) REFERENCES `education_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_repor_cards_comme_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_repor_cards_comme_fk_repor_card_comme_code_id` FOREIGN KEY (`report_card_comment_code_id`) REFERENCES `report_card_comment_codes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_repor_cards_comme_fk_repor_card_id` FOREIGN KEY (`report_card_id`) REFERENCES `report_cards` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_repor_cards_comme_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_repor_cards_comme_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_students_tmp`
--
ALTER TABLE `institution_students_tmp`
  ADD CONSTRAINT `insti_stude_tmp_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_student_absences`
--
ALTER TABLE `institution_student_absences`
  ADD CONSTRAINT `insti_stude_absen_fk_abs_typ_id` FOREIGN KEY (`absence_type_id`) REFERENCES `absence_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_absen_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_absen_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_absen_fk_ins_cla_id` FOREIGN KEY (`institution_class_id`) REFERENCES `institution_classes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_absen_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_absen_fk_insti_stude_absen_day_id` FOREIGN KEY (`institution_student_absence_day_id`) REFERENCES `institution_student_absence_days` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_absen_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_student_absence_days`
--
ALTER TABLE `institution_student_absence_days`
  ADD CONSTRAINT `insti_stude_absen_days_fk_abs_typ_id` FOREIGN KEY (`absence_type_id`) REFERENCES `absence_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_absen_days_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_absen_days_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_student_absence_details`
--
ALTER TABLE `institution_student_absence_details`
  ADD CONSTRAINT `insti_stude_absen_detai_fk_abs_typ_id` FOREIGN KEY (`absence_type_id`) REFERENCES `absence_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_absen_detai_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_absen_detai_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_absen_detai_fk_ins_cla_id` FOREIGN KEY (`institution_class_id`) REFERENCES `institution_classes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_absen_detai_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_absen_detai_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_student_admission`
--
ALTER TABLE `institution_student_admission`
  ADD CONSTRAINT `insti_stude_admis_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`),
  ADD CONSTRAINT `insti_stude_admis_fk_ass_id` FOREIGN KEY (`assignee_id`) REFERENCES `security_users` (`id`),
  ADD CONSTRAINT `insti_stude_admis_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`),
  ADD CONSTRAINT `insti_stude_admis_fk_ins_cla_id` FOREIGN KEY (`institution_class_id`) REFERENCES `institution_classes` (`id`),
  ADD CONSTRAINT `insti_stude_admis_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`),
  ADD CONSTRAINT `insti_stude_admis_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`),
  ADD CONSTRAINT `insti_stude_admis_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`);

--
-- Constraints for table `institution_student_enrolment`
--
ALTER TABLE `institution_student_enrolment`
  ADD CONSTRAINT `insti_stude_enrol_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`),
  ADD CONSTRAINT `insti_stude_enrol_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`),
  ADD CONSTRAINT `insti_stude_enrol_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`),
  ADD CONSTRAINT `insti_stude_enrol_fk_status_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`),
  ADD CONSTRAINT `insti_stude_enrol_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`);

--
-- Constraints for table `institution_student_programmes`
--
ALTER TABLE `institution_student_programmes`
  ADD CONSTRAINT `institution_student_programmes_ibfk_1` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `institution_student_programmes_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `institution_student_programmes_ibfk_3` FOREIGN KEY (`education_programme_id`) REFERENCES `education_programmes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `institution_student_risks`
--
ALTER TABLE `institution_student_risks`
  ADD CONSTRAINT `insti_stude_risks_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_risks_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_risks_fk_risk_id` FOREIGN KEY (`risk_id`) REFERENCES `risks` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_risks_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_student_surveys`
--
ALTER TABLE `institution_student_surveys`
  ADD CONSTRAINT `insti_stude_surve_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_surve_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_surve_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_surve_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_surve_fk_surve_form_id` FOREIGN KEY (`survey_form_id`) REFERENCES `survey_forms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_student_survey_answers`
--
ALTER TABLE `institution_student_survey_answers`
  ADD CONSTRAINT `insti_stude_surve_answe_fk_insti_stude_surve_id` FOREIGN KEY (`institution_student_survey_id`) REFERENCES `institution_student_surveys` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_surve_answe_fk_surve_quest_id` FOREIGN KEY (`survey_question_id`) REFERENCES `survey_questions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_student_survey_table_cells`
--
ALTER TABLE `institution_student_survey_table_cells`
  ADD CONSTRAINT `insti_stude_surve_table_cells_fk_insti_stude_surve_id` FOREIGN KEY (`institution_student_survey_id`) REFERENCES `institution_student_surveys` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_surve_table_cells_fk_surve_quest_id` FOREIGN KEY (`survey_question_id`) REFERENCES `survey_questions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_surve_table_cells_fk_surve_table_colum_id` FOREIGN KEY (`survey_table_column_id`) REFERENCES `survey_table_columns` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_surve_table_cells_fk_surve_table_row_id` FOREIGN KEY (`survey_table_row_id`) REFERENCES `survey_table_rows` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_student_transfers`
--
ALTER TABLE `institution_student_transfers`
  ADD CONSTRAINT `insti_stude_trans_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_trans_fk_ass_id` FOREIGN KEY (`assignee_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_trans_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_trans_fk_ins_cla_id` FOREIGN KEY (`institution_class_id`) REFERENCES `institution_classes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_trans_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_trans_fk_previ_acade_perio_id` FOREIGN KEY (`previous_academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_trans_fk_previ_educa_grade_id` FOREIGN KEY (`previous_education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_trans_fk_previ_insti_id` FOREIGN KEY (`previous_institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_trans_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_trans_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_trans_fk_stude_trans_reaso_id` FOREIGN KEY (`student_transfer_reason_id`) REFERENCES `student_transfer_reasons` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_student_visits`
--
ALTER TABLE `institution_student_visits`
  ADD CONSTRAINT `insti_stude_visit_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_visit_fk_eva_id` FOREIGN KEY (`evaluator_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_visit_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_visit_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_visit_fk_stude_visit_purpo_type_id` FOREIGN KEY (`student_visit_purpose_type_id`) REFERENCES `student_visit_purpose_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_visit_fk_stude_visit_type_id` FOREIGN KEY (`student_visit_type_id`) REFERENCES `student_visit_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_student_visit_requests`
--
ALTER TABLE `institution_student_visit_requests`
  ADD CONSTRAINT `insti_stude_visit_reque_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_visit_reque_fk_ass_id` FOREIGN KEY (`assignee_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_visit_reque_fk_eva_id` FOREIGN KEY (`evaluator_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_visit_reque_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_visit_reque_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_visit_reque_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_visit_reque_fk_stude_visit_purpo_type_id` FOREIGN KEY (`student_visit_purpose_type_id`) REFERENCES `student_visit_purpose_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_visit_reque_fk_stude_visit_type_id` FOREIGN KEY (`student_visit_type_id`) REFERENCES `student_visit_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_student_withdraw`
--
ALTER TABLE `institution_student_withdraw`
  ADD CONSTRAINT `insti_stude_withd_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_withd_fk_ass_id` FOREIGN KEY (`assignee_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_withd_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_withd_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_withd_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_withd_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_stude_withd_fk_stude_withd_reaso_id` FOREIGN KEY (`student_withdraw_reason_id`) REFERENCES `student_withdraw_reasons` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_subjects`
--
ALTER TABLE `institution_subjects`
  ADD CONSTRAINT `insti_subje_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_subje_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_subje_fk_edu_sub_id` FOREIGN KEY (`education_subject_id`) REFERENCES `education_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_subje_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_subjects_rooms`
--
ALTER TABLE `institution_subjects_rooms`
  ADD CONSTRAINT `insti_subje_rooms_fk_insti_room_id` FOREIGN KEY (`institution_room_id`) REFERENCES `institution_rooms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_subje_rooms_fk_insti_subje_id` FOREIGN KEY (`institution_subject_id`) REFERENCES `institution_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_subject_staff`
--
ALTER TABLE `institution_subject_staff`
  ADD CONSTRAINT `insti_subje_staff_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_subje_staff_fk_insti_subje_id` FOREIGN KEY (`institution_subject_id`) REFERENCES `institution_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_subje_staff_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_subject_students`
--
ALTER TABLE `institution_subject_students`
  ADD CONSTRAINT `insti_subje_stude_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_subje_stude_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_subje_stude_fk_edu_sub_id` FOREIGN KEY (`education_subject_id`) REFERENCES `education_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_subje_stude_fk_ins_cla_id` FOREIGN KEY (`institution_class_id`) REFERENCES `institution_classes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_subje_stude_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_subje_stude_fk_insti_subje_id` FOREIGN KEY (`institution_subject_id`) REFERENCES `institution_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_subje_stude_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_subje_stude_fk_stude_statu_id` FOREIGN KEY (`student_status_id`) REFERENCES `student_statuses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_surveys`
--
ALTER TABLE `institution_surveys`
  ADD CONSTRAINT `insti_surve_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_surve_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_surve_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_surve_fk_surve_form_id` FOREIGN KEY (`survey_form_id`) REFERENCES `survey_forms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_survey_answers`
--
ALTER TABLE `institution_survey_answers`
  ADD CONSTRAINT `insti_surve_answe_fk_insti_surve_id` FOREIGN KEY (`institution_survey_id`) REFERENCES `institution_surveys` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_surve_answe_fk_surve_quest_id` FOREIGN KEY (`survey_question_id`) REFERENCES `survey_questions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_survey_table_cells`
--
ALTER TABLE `institution_survey_table_cells`
  ADD CONSTRAINT `insti_surve_table_cells_fk_insti_surve_id` FOREIGN KEY (`institution_survey_id`) REFERENCES `institution_surveys` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_surve_table_cells_fk_surve_quest_id` FOREIGN KEY (`survey_question_id`) REFERENCES `survey_questions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_surve_table_cells_fk_surve_table_colum_id` FOREIGN KEY (`survey_table_column_id`) REFERENCES `survey_table_columns` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_surve_table_cells_fk_surve_table_row_id` FOREIGN KEY (`survey_table_row_id`) REFERENCES `survey_table_rows` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_textbooks`
--
ALTER TABLE `institution_textbooks`
  ADD CONSTRAINT `insti_textb_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_textb_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_textb_fk_edu_sub_id` FOREIGN KEY (`education_subject_id`) REFERENCES `education_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_textb_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_textb_fk_stude_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_textb_fk_textb_condi_id` FOREIGN KEY (`textbook_condition_id`) REFERENCES `textbook_conditions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_textb_fk_textb_id` FOREIGN KEY (`textbook_id`) REFERENCES `textbooks` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_textb_fk_textb_statu_id` FOREIGN KEY (`textbook_status_id`) REFERENCES `textbook_statuses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_transport_providers`
--
ALTER TABLE `institution_transport_providers`
  ADD CONSTRAINT `insti_trans_provi_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_trips`
--
ALTER TABLE `institution_trips`
  ADD CONSTRAINT `insti_trips_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_trips_fk_ins_bus_id` FOREIGN KEY (`institution_bus_id`) REFERENCES `institution_buses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_trips_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_trips_fk_insti_trans_provi_id` FOREIGN KEY (`institution_transport_provider_id`) REFERENCES `institution_transport_providers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_trips_fk_trip_type_id` FOREIGN KEY (`trip_type_id`) REFERENCES `trip_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_trip_days`
--
ALTER TABLE `institution_trip_days`
  ADD CONSTRAINT `insti_trip_days_fk_insti_trip_id` FOREIGN KEY (`institution_trip_id`) REFERENCES `institution_trips` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_trip_passengers`
--
ALTER TABLE `institution_trip_passengers`
  ADD CONSTRAINT `insti_trip_passe_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_trip_passe_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_trip_passe_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_trip_passe_fk_insti_trip_id` FOREIGN KEY (`institution_trip_id`) REFERENCES `institution_trips` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_trip_passe_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `institution_visit_requests`
--
ALTER TABLE `institution_visit_requests`
  ADD CONSTRAINT `insti_visit_reque_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_visit_reque_fk_ass_id` FOREIGN KEY (`assignee_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_visit_reque_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_visit_reque_fk_quali_visit_type_id` FOREIGN KEY (`quality_visit_type_id`) REFERENCES `quality_visit_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `insti_visit_reque_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `item_types`
--
ALTER TABLE `item_types`
  ADD CONSTRAINT `fk_item_stock_unit_id` FOREIGN KEY (`stock_unit_id`) REFERENCES `stock_units` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `land_custom_field_values`
--
ALTER TABLE `land_custom_field_values`
  ADD CONSTRAINT `land_custo_field_value_fk_inf_cus_fie_id` FOREIGN KEY (`infrastructure_custom_field_id`) REFERENCES `infrastructure_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `land_custo_field_value_fk_insti_land_id` FOREIGN KEY (`institution_land_id`) REFERENCES `institution_lands` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `license_classifications`
--
ALTER TABLE `license_classifications`
  ADD CONSTRAINT `licen_class_fk_licen_type_id` FOREIGN KEY (`license_type_id`) REFERENCES `license_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `locale_content_translations`
--
ALTER TABLE `locale_content_translations`
  ADD CONSTRAINT `local_conte_trans_fk_local_conte_id` FOREIGN KEY (`locale_content_id`) REFERENCES `locale_contents` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `local_conte_trans_fk_local_id` FOREIGN KEY (`locale_id`) REFERENCES `locales` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `meal_food_records`
--
ALTER TABLE `meal_food_records`
  ADD CONSTRAINT `meal_food_records_ibfk_1` FOREIGN KEY (`meal_programmes_id`) REFERENCES `meal_programmes` (`id`),
  ADD CONSTRAINT `meal_food_records_ibfk_2` FOREIGN KEY (`food_type_id`) REFERENCES `food_types` (`id`);

--
-- Constraints for table `meal_institution_programmes`
--
ALTER TABLE `meal_institution_programmes`
  ADD CONSTRAINT `meal_insti_progr_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `meal_insti_progr_fk_meal_progr_id` FOREIGN KEY (`meal_programme_id`) REFERENCES `meal_programmes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `meal_nutritional_records`
--
ALTER TABLE `meal_nutritional_records`
  ADD CONSTRAINT `meal_nutri_recor_fk_meal_progr_id` FOREIGN KEY (`meal_programmes_id`) REFERENCES `meal_programmes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `meal_nutri_recor_fk_nutri_conte_id` FOREIGN KEY (`nutritional_content_id`) REFERENCES `meal_nutritions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `meal_programmes`
--
ALTER TABLE `meal_programmes`
  ADD CONSTRAINT `meal_progr_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `message_recipients`
--
ALTER TABLE `message_recipients`
  ADD CONSTRAINT `message_recipients_ibfk_1` FOREIGN KEY (`message_id`) REFERENCES `messaging` (`id`),
  ADD CONSTRAINT `message_recipients_ibfk_2` FOREIGN KEY (`recipient_id`) REFERENCES `security_users` (`id`);

--
-- Constraints for table `messaging`
--
ALTER TABLE `messaging`
  ADD CONSTRAINT `messaging_ibfk_1` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`),
  ADD CONSTRAINT `messaging_ibfk_2` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`);

--
-- Constraints for table `messaging_security_roles`
--
ALTER TABLE `messaging_security_roles`
  ADD CONSTRAINT `messaging_security_roles_ibfk_1` FOREIGN KEY (`message_id`) REFERENCES `messaging` (`id`),
  ADD CONSTRAINT `messaging_security_roles_ibfk_2` FOREIGN KEY (`security_role_id`) REFERENCES `security_roles` (`id`);

--
-- Constraints for table `moodle_api_created_users`
--
ALTER TABLE `moodle_api_created_users`
  ADD CONSTRAINT `moodl_api_creat_users_fk_cor_use_id` FOREIGN KEY (`core_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `outcome_criterias`
--
ALTER TABLE `outcome_criterias`
  ADD CONSTRAINT `outco_crite_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `outco_crite_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `outco_crite_fk_edu_sub_id` FOREIGN KEY (`education_subject_id`) REFERENCES `education_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `outco_crite_fk_outco_gradi_type_id` FOREIGN KEY (`outcome_grading_type_id`) REFERENCES `outcome_grading_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `outco_crite_fk_outco_templ_id` FOREIGN KEY (`outcome_template_id`) REFERENCES `outcome_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `outcome_grading_options`
--
ALTER TABLE `outcome_grading_options`
  ADD CONSTRAINT `outco_gradi_optio_fk_outco_gradi_type_id` FOREIGN KEY (`outcome_grading_type_id`) REFERENCES `outcome_grading_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `outcome_periods`
--
ALTER TABLE `outcome_periods`
  ADD CONSTRAINT `outco_perio_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `outco_perio_fk_outco_templ_id` FOREIGN KEY (`outcome_template_id`) REFERENCES `outcome_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `outcome_templates`
--
ALTER TABLE `outcome_templates`
  ADD CONSTRAINT `fk_outcome_grading_type_id` FOREIGN KEY (`outcome_grading_type_id`) REFERENCES `outcome_grading_types` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `outco_templ_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `outco_templ_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `profile_templates`
--
ALTER TABLE `profile_templates`
  ADD CONSTRAINT `profi_templ_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `qualification_specialisations`
--
ALTER TABLE `qualification_specialisations`
  ADD CONSTRAINT `quali_speci_fk_edu_fie_of_stu_id` FOREIGN KEY (`education_field_of_study_id`) REFERENCES `education_field_of_studies` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `qualification_titles`
--
ALTER TABLE `qualification_titles`
  ADD CONSTRAINT `quali_title_fk_quali_level_id` FOREIGN KEY (`qualification_level_id`) REFERENCES `qualification_levels` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `report_cards`
--
ALTER TABLE `report_cards`
  ADD CONSTRAINT `repor_cards_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `repor_cards_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `report_card_email_processes`
--
ALTER TABLE `report_card_email_processes`
  ADD CONSTRAINT `repor_card_email_proce_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `repor_card_email_proce_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `repor_card_email_proce_fk_ins_cla_id` FOREIGN KEY (`institution_class_id`) REFERENCES `institution_classes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `repor_card_email_proce_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `repor_card_email_proce_fk_repor_card_id` FOREIGN KEY (`report_card_id`) REFERENCES `report_cards` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `repor_card_email_proce_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `report_card_excluded_security_roles`
--
ALTER TABLE `report_card_excluded_security_roles`
  ADD CONSTRAINT `report_card_excluded_security_roles_ibfk_1` FOREIGN KEY (`report_card_id`) REFERENCES `report_cards` (`id`),
  ADD CONSTRAINT `report_card_excluded_security_roles_ibfk_2` FOREIGN KEY (`security_role_id`) REFERENCES `security_roles` (`id`);

--
-- Constraints for table `report_card_processes`
--
ALTER TABLE `report_card_processes`
  ADD CONSTRAINT `repor_card_proce_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `repor_card_proce_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `repor_card_proce_fk_ins_cla_id` FOREIGN KEY (`institution_class_id`) REFERENCES `institution_classes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `repor_card_proce_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `repor_card_proce_fk_repor_card_id` FOREIGN KEY (`report_card_id`) REFERENCES `report_cards` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `repor_card_proce_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `report_card_subjects`
--
ALTER TABLE `report_card_subjects`
  ADD CONSTRAINT `repor_card_subje_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `repor_card_subje_fk_edu_sub_id` FOREIGN KEY (`education_subject_id`) REFERENCES `education_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `repor_card_subje_fk_repor_card_id` FOREIGN KEY (`report_card_id`) REFERENCES `report_cards` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `risks`
--
ALTER TABLE `risks`
  ADD CONSTRAINT `risks_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `risk_criterias`
--
ALTER TABLE `risk_criterias`
  ADD CONSTRAINT `risk_crite_fk_risk_id` FOREIGN KEY (`risk_id`) REFERENCES `risks` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `room_custom_field_values`
--
ALTER TABLE `room_custom_field_values`
  ADD CONSTRAINT `room_custo_field_value_fk_inf_cus_fie_id` FOREIGN KEY (`infrastructure_custom_field_id`) REFERENCES `infrastructure_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `room_custo_field_value_fk_insti_room_id` FOREIGN KEY (`institution_room_id`) REFERENCES `institution_rooms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `rubric_criterias`
--
ALTER TABLE `rubric_criterias`
  ADD CONSTRAINT `rubri_crite_fk_rubri_secti_id` FOREIGN KEY (`rubric_section_id`) REFERENCES `rubric_sections` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `rubric_criteria_options`
--
ALTER TABLE `rubric_criteria_options`
  ADD CONSTRAINT `rubri_crite_optio_fk_rubri_crite_id` FOREIGN KEY (`rubric_criteria_id`) REFERENCES `rubric_criterias` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `rubri_crite_optio_fk_rubri_templ_optio_id` FOREIGN KEY (`rubric_template_option_id`) REFERENCES `rubric_template_options` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `rubric_sections`
--
ALTER TABLE `rubric_sections`
  ADD CONSTRAINT `rubri_secti_fk_rubri_templ_id` FOREIGN KEY (`rubric_template_id`) REFERENCES `rubric_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `rubric_statuses`
--
ALTER TABLE `rubric_statuses`
  ADD CONSTRAINT `rubri_statu_fk_rubri_templ_id` FOREIGN KEY (`rubric_template_id`) REFERENCES `rubric_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `rubric_status_periods`
--
ALTER TABLE `rubric_status_periods`
  ADD CONSTRAINT `rubri_statu_perio_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `rubri_statu_perio_fk_rubri_statu_id` FOREIGN KEY (`rubric_status_id`) REFERENCES `rubric_statuses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `rubric_status_programmes`
--
ALTER TABLE `rubric_status_programmes`
  ADD CONSTRAINT `rubri_statu_progr_fk_edu_pro_id` FOREIGN KEY (`education_programme_id`) REFERENCES `education_programmes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `rubri_statu_progr_fk_rubri_statu_id` FOREIGN KEY (`rubric_status_id`) REFERENCES `rubric_statuses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `rubric_status_roles`
--
ALTER TABLE `rubric_status_roles`
  ADD CONSTRAINT `rubri_statu_roles_fk_rubri_statu_id` FOREIGN KEY (`rubric_status_id`) REFERENCES `rubric_statuses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `rubri_statu_roles_fk_sec_rol_id` FOREIGN KEY (`security_role_id`) REFERENCES `security_roles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `rubric_template_options`
--
ALTER TABLE `rubric_template_options`
  ADD CONSTRAINT `rubri_templ_optio_fk_rubri_templ_id` FOREIGN KEY (`rubric_template_id`) REFERENCES `rubric_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `scholarships`
--
ALTER TABLE `scholarships`
  ADD CONSTRAINT `schol_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_fk_schol_finan_assis_type_id` FOREIGN KEY (`scholarship_financial_assistance_type_id`) REFERENCES `scholarship_financial_assistance_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_fk_schol_fundi_sourc_id` FOREIGN KEY (`scholarship_funding_source_id`) REFERENCES `scholarship_funding_sources` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `scholarships_ibfk_1` FOREIGN KEY (`scholarship_financial_assistance_id`) REFERENCES `scholarship_financial_assistances` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `scholarships_field_of_studies`
--
ALTER TABLE `scholarships_field_of_studies`
  ADD CONSTRAINT `schol_field_of_studi_fk_edu_fie_of_stu_id` FOREIGN KEY (`education_field_of_study_id`) REFERENCES `education_field_of_studies` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_field_of_studi_fk_schol_id` FOREIGN KEY (`scholarship_id`) REFERENCES `scholarships` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `scholarships_scholarship_attachment_types`
--
ALTER TABLE `scholarships_scholarship_attachment_types`
  ADD CONSTRAINT `schol_schol_attac_types_fk_schol_attac_type_id` FOREIGN KEY (`scholarship_attachment_type_id`) REFERENCES `scholarship_attachment_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_schol_attac_types_fk_schol_id` FOREIGN KEY (`scholarship_id`) REFERENCES `scholarships` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `scholarship_applications`
--
ALTER TABLE `scholarship_applications`
  ADD CONSTRAINT `schol_appli_fk_app_id` FOREIGN KEY (`applicant_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_appli_fk_ass_id` FOREIGN KEY (`assignee_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_appli_fk_schol_id` FOREIGN KEY (`scholarship_id`) REFERENCES `scholarships` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_appli_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `scholarship_application_attachments`
--
ALTER TABLE `scholarship_application_attachments`
  ADD CONSTRAINT `schol_appli_attac_fk_app_id` FOREIGN KEY (`applicant_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_appli_attac_fk_schol_attac_type_id` FOREIGN KEY (`scholarship_attachment_type_id`) REFERENCES `scholarship_attachment_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_appli_attac_fk_schol_id` FOREIGN KEY (`scholarship_id`) REFERENCES `scholarships` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `scholarship_application_institution_choices`
--
ALTER TABLE `scholarship_application_institution_choices`
  ADD CONSTRAINT `schol_appli_insti_choic_fk_app_id` FOREIGN KEY (`applicant_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_appli_insti_choic_fk_cou_id` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_appli_insti_choic_fk_edu_fie_of_stu_id` FOREIGN KEY (`education_field_of_study_id`) REFERENCES `education_field_of_studies` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_appli_insti_choic_fk_quali_level_id` FOREIGN KEY (`qualification_level_id`) REFERENCES `qualification_levels` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_appli_insti_choic_fk_schol_id` FOREIGN KEY (`scholarship_id`) REFERENCES `scholarships` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_appli_insti_choic_fk_schol_insti_choic_statu_id` FOREIGN KEY (`scholarship_institution_choice_status_id`) REFERENCES `scholarship_institution_choice_statuses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_appli_insti_choic_fk_schol_insti_choic_type_id` FOREIGN KEY (`scholarship_institution_choice_type_id`) REFERENCES `scholarship_institution_choice_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `scholarship_financial_assistances`
--
ALTER TABLE `scholarship_financial_assistances`
  ADD CONSTRAINT `scholarship_financial_assistances_ibfk_1` FOREIGN KEY (`modified_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `scholarship_financial_assistances_ibfk_2` FOREIGN KEY (`created_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `scholarship_loans`
--
ALTER TABLE `scholarship_loans`
  ADD CONSTRAINT `schol_loans_fk_schol_id` FOREIGN KEY (`scholarship_id`) REFERENCES `scholarships` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_loans_fk_schol_payme_frequ_id` FOREIGN KEY (`scholarship_payment_frequency_id`) REFERENCES `scholarship_payment_frequencies` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `scholarship_recipients`
--
ALTER TABLE `scholarship_recipients`
  ADD CONSTRAINT `schol_recip_fk_recip_id` FOREIGN KEY (`recipient_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_recip_fk_schol_id` FOREIGN KEY (`scholarship_id`) REFERENCES `scholarships` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_recip_fk_schol_recip_activ_statu_id` FOREIGN KEY (`scholarship_recipient_activity_status_id`) REFERENCES `scholarship_recipient_activity_statuses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `scholarship_recipient_academic_standings`
--
ALTER TABLE `scholarship_recipient_academic_standings`
  ADD CONSTRAINT `schol_recip_acade_stand_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_recip_acade_stand_fk_recip_id` FOREIGN KEY (`recipient_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_recip_acade_stand_fk_schol_id` FOREIGN KEY (`scholarship_id`) REFERENCES `scholarships` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_recip_acade_stand_fk_schol_semes_id` FOREIGN KEY (`scholarship_semester_id`) REFERENCES `scholarship_semesters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `scholarship_recipient_activities`
--
ALTER TABLE `scholarship_recipient_activities`
  ADD CONSTRAINT `schol_recip_activ_fk_recip_id` FOREIGN KEY (`recipient_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_recip_activ_fk_schol_id` FOREIGN KEY (`scholarship_id`) REFERENCES `scholarships` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `scholarship_recipient_collections`
--
ALTER TABLE `scholarship_recipient_collections`
  ADD CONSTRAINT `schol_recip_colle_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_recip_colle_fk_recip_id` FOREIGN KEY (`recipient_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_recip_colle_fk_schol_id` FOREIGN KEY (`scholarship_id`) REFERENCES `scholarships` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `scholarship_recipient_disbursements`
--
ALTER TABLE `scholarship_recipient_disbursements`
  ADD CONSTRAINT `schol_recip_disbu_fk_recip_id` FOREIGN KEY (`recipient_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_recip_disbu_fk_schol_disbu_categ_id` FOREIGN KEY (`scholarship_disbursement_category_id`) REFERENCES `scholarship_disbursement_categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_recip_disbu_fk_schol_id` FOREIGN KEY (`scholarship_id`) REFERENCES `scholarships` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_recip_disbu_fk_schol_recip_payme_struc_id` FOREIGN KEY (`scholarship_recipient_payment_structure_id`) REFERENCES `scholarship_recipient_payment_structures` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_recip_disbu_fk_schol_semes_id` FOREIGN KEY (`scholarship_semester_id`) REFERENCES `scholarship_semesters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `scholarship_recipient_payment_structures`
--
ALTER TABLE `scholarship_recipient_payment_structures`
  ADD CONSTRAINT `schol_recip_payme_struc_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_recip_payme_struc_fk_recip_id` FOREIGN KEY (`recipient_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_recip_payme_struc_fk_schol_id` FOREIGN KEY (`scholarship_id`) REFERENCES `scholarships` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `scholarship_recipient_payment_structure_estimates`
--
ALTER TABLE `scholarship_recipient_payment_structure_estimates`
  ADD CONSTRAINT `schol_recip_payme_struc_estim_fk_recip_id` FOREIGN KEY (`recipient_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_recip_payme_struc_estim_fk_schol_disbu_categ_id` FOREIGN KEY (`scholarship_disbursement_category_id`) REFERENCES `scholarship_disbursement_categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_recip_payme_struc_estim_fk_schol_id` FOREIGN KEY (`scholarship_id`) REFERENCES `scholarships` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `schol_recip_payme_struc_estim_fk_schol_recip_payme_struc_id` FOREIGN KEY (`scholarship_recipient_payment_structure_id`) REFERENCES `scholarship_recipient_payment_structures` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `security_group_areas`
--
ALTER TABLE `security_group_areas`
  ADD CONSTRAINT `secur_group_areas_fk_are_id` FOREIGN KEY (`area_id`) REFERENCES `areas` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `secur_group_areas_fk_secur_group_id` FOREIGN KEY (`security_group_id`) REFERENCES `security_groups` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `security_group_institutions`
--
ALTER TABLE `security_group_institutions`
  ADD CONSTRAINT `secur_group_insti_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `secur_group_insti_fk_secur_group_id` FOREIGN KEY (`security_group_id`) REFERENCES `security_groups` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `security_group_users`
--
ALTER TABLE `security_group_users`
  ADD CONSTRAINT `secur_group_users_fk_sec_rol_id` FOREIGN KEY (`security_role_id`) REFERENCES `security_roles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `secur_group_users_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `security_role_functions`
--
ALTER TABLE `security_role_functions`
  ADD CONSTRAINT `secur_role_funct_fk_sec_rol_id` FOREIGN KEY (`security_role_id`) REFERENCES `security_roles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `secur_role_funct_fk_secur_funct_id` FOREIGN KEY (`security_function_id`) REFERENCES `security_functions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `security_users`
--
ALTER TABLE `security_users`
  ADD CONSTRAINT `secur_users_fk_add_are_id` FOREIGN KEY (`address_area_id`) REFERENCES `area_administratives` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `secur_users_fk_bir_are_id` FOREIGN KEY (`birthplace_area_id`) REFERENCES `area_administratives` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `secur_users_fk_gen_id` FOREIGN KEY (`gender_id`) REFERENCES `genders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `secur_users_fk_ide_typ_id` FOREIGN KEY (`identity_type_id`) REFERENCES `identity_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `secur_users_fk_natio_id` FOREIGN KEY (`nationality_id`) REFERENCES `nationalities` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `security_user_password_requests`
--
ALTER TABLE `security_user_password_requests`
  ADD CONSTRAINT `secur_user_passw_reque_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_behaviours`
--
ALTER TABLE `staff_behaviours`
  ADD CONSTRAINT `staff_behav_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_behav_fk_beh_cla_id` FOREIGN KEY (`behaviour_classification_id`) REFERENCES `behaviour_classifications` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_behav_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_behav_fk_staff_behav_categ_id` FOREIGN KEY (`staff_behaviour_category_id`) REFERENCES `staff_behaviour_categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_behav_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_behaviour_attachments`
--
ALTER TABLE `staff_behaviour_attachments`
  ADD CONSTRAINT `staff_behav_attac_fk_staff_behav_id` FOREIGN KEY (`staff_behaviour_id`) REFERENCES `staff_behaviours` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_custom_field_options`
--
ALTER TABLE `staff_custom_field_options`
  ADD CONSTRAINT `staff_custo_field_optio_fk_staff_custo_field_id` FOREIGN KEY (`staff_custom_field_id`) REFERENCES `staff_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_custom_field_values`
--
ALTER TABLE `staff_custom_field_values`
  ADD CONSTRAINT `staff_custo_field_value_fk_staff_custo_field_id` FOREIGN KEY (`staff_custom_field_id`) REFERENCES `staff_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_custo_field_value_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_custom_forms`
--
ALTER TABLE `staff_custom_forms`
  ADD CONSTRAINT `staff_custo_forms_fk_cus_mod_id` FOREIGN KEY (`custom_module_id`) REFERENCES `custom_modules` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_custom_forms_fields`
--
ALTER TABLE `staff_custom_forms_fields`
  ADD CONSTRAINT `staff_custo_forms_field_fk_staff_custo_field_id` FOREIGN KEY (`staff_custom_field_id`) REFERENCES `staff_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_custo_forms_field_fk_staff_custo_form_id` FOREIGN KEY (`staff_custom_form_id`) REFERENCES `staff_custom_forms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_custom_table_cells`
--
ALTER TABLE `staff_custom_table_cells`
  ADD CONSTRAINT `staff_custo_table_cells_fk_staff_custo_field_id` FOREIGN KEY (`staff_custom_field_id`) REFERENCES `staff_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_custo_table_cells_fk_staff_custo_table_colum_id` FOREIGN KEY (`staff_custom_table_column_id`) REFERENCES `staff_custom_table_columns` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_custo_table_cells_fk_staff_custo_table_row_id` FOREIGN KEY (`staff_custom_table_row_id`) REFERENCES `staff_custom_table_rows` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_custo_table_cells_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_custom_table_columns`
--
ALTER TABLE `staff_custom_table_columns`
  ADD CONSTRAINT `staff_custo_table_colum_fk_staff_custo_field_id` FOREIGN KEY (`staff_custom_field_id`) REFERENCES `staff_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_custom_table_rows`
--
ALTER TABLE `staff_custom_table_rows`
  ADD CONSTRAINT `staff_custo_table_rows_fk_staff_custo_field_id` FOREIGN KEY (`staff_custom_field_id`) REFERENCES `staff_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_employment_statuses`
--
ALTER TABLE `staff_employment_statuses`
  ADD CONSTRAINT `staff_emplo_statu_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_emplo_statu_fk_statu_type_id` FOREIGN KEY (`status_type_id`) REFERENCES `employment_status_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_extracurriculars`
--
ALTER TABLE `staff_extracurriculars`
  ADD CONSTRAINT `staff_extra_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_extra_fk_ext_typ_id` FOREIGN KEY (`extracurricular_type_id`) REFERENCES `extracurricular_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_extra_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_leave_entitlements`
--
ALTER TABLE `staff_leave_entitlements`
  ADD CONSTRAINT `fk_staff_leave_entitlements_leave_type_id` FOREIGN KEY (`staff_leave_type_id`) REFERENCES `staff_leave_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `fk_staff_leave_entitlements_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_leave_policy_types`
--
ALTER TABLE `staff_leave_policy_types`
  ADD CONSTRAINT `fk_staff_leave_policy_types_policy_id` FOREIGN KEY (`staff_leave_policy_id`) REFERENCES `staff_leave_policies` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `fk_staff_leave_policy_types_type_id` FOREIGN KEY (`staff_leave_type_id`) REFERENCES `staff_leave_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_licenses`
--
ALTER TABLE `staff_licenses`
  ADD CONSTRAINT `staff_licen_fk_ass_id` FOREIGN KEY (`assignee_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_licen_fk_licen_type_id` FOREIGN KEY (`license_type_id`) REFERENCES `license_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_licen_fk_staff_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_licen_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_licenses_classifications`
--
ALTER TABLE `staff_licenses_classifications`
  ADD CONSTRAINT `staff_licen_class_fk_licen_class_id` FOREIGN KEY (`license_classification_id`) REFERENCES `license_classifications` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_licen_class_fk_staff_licen_id` FOREIGN KEY (`staff_license_id`) REFERENCES `staff_licenses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_memberships`
--
ALTER TABLE `staff_memberships`
  ADD CONSTRAINT `staff_membe_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_payslips`
--
ALTER TABLE `staff_payslips`
  ADD CONSTRAINT `staff_paysl_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_position_titles`
--
ALTER TABLE `staff_position_titles`
  ADD CONSTRAINT `fk_staff_position_titles_policy_id` FOREIGN KEY (`staff_leave_policy_id`) REFERENCES `staff_leave_policies` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_posit_title_fk_sec_rol_id` FOREIGN KEY (`security_role_id`) REFERENCES `security_roles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_position_titles_grades`
--
ALTER TABLE `staff_position_titles_grades`
  ADD CONSTRAINT `staff_posit_title_grade_fk_staff_posit_title_id` FOREIGN KEY (`staff_position_title_id`) REFERENCES `staff_position_titles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_profile_templates`
--
ALTER TABLE `staff_profile_templates`
  ADD CONSTRAINT `staff_profi_templ_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_qualifications`
--
ALTER TABLE `staff_qualifications`
  ADD CONSTRAINT `staff_quali_fk_edu_fie_of_stu_id` FOREIGN KEY (`education_field_of_study_id`) REFERENCES `education_field_of_studies` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_quali_fk_quali_count_id` FOREIGN KEY (`qualification_country_id`) REFERENCES `countries` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_quali_fk_quali_title_id` FOREIGN KEY (`qualification_title_id`) REFERENCES `qualification_titles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_quali_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_qualifications_specialisations`
--
ALTER TABLE `staff_qualifications_specialisations`
  ADD CONSTRAINT `staff_quali_speci_fk_quali_speci_id` FOREIGN KEY (`qualification_specialisation_id`) REFERENCES `qualification_specialisations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_quali_speci_fk_staff_quali_id` FOREIGN KEY (`staff_qualification_id`) REFERENCES `staff_qualifications` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_qualifications_subjects`
--
ALTER TABLE `staff_qualifications_subjects`
  ADD CONSTRAINT `staff_quali_subje_fk_edu_sub_id` FOREIGN KEY (`education_subject_id`) REFERENCES `education_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_quali_subje_fk_staff_quali_id` FOREIGN KEY (`staff_qualification_id`) REFERENCES `staff_qualifications` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_report_cards`
--
ALTER TABLE `staff_report_cards`
  ADD CONSTRAINT `staff_repor_cards_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_repor_cards_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_repor_cards_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_repor_cards_fk_staff_profi_templ_id` FOREIGN KEY (`staff_profile_template_id`) REFERENCES `staff_profile_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_report_card_email_processes`
--
ALTER TABLE `staff_report_card_email_processes`
  ADD CONSTRAINT `staff_repor_card_email_proce_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_repor_card_email_proce_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_repor_card_email_proce_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_repor_card_email_proce_fk_staff_profi_templ_id` FOREIGN KEY (`staff_profile_template_id`) REFERENCES `staff_profile_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_report_card_processes`
--
ALTER TABLE `staff_report_card_processes`
  ADD CONSTRAINT `staff_repor_card_proce_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_repor_card_proce_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_repor_card_proce_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_repor_card_proce_fk_staff_profi_templ_id` FOREIGN KEY (`staff_profile_template_id`) REFERENCES `staff_profile_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_salaries`
--
ALTER TABLE `staff_salaries`
  ADD CONSTRAINT `staff_salar_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_salary_transactions`
--
ALTER TABLE `staff_salary_transactions`
  ADD CONSTRAINT `staff_salar_trans_fk_salar_addit_type_id` FOREIGN KEY (`salary_addition_type_id`) REFERENCES `salary_addition_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_salar_trans_fk_salar_deduc_type_id` FOREIGN KEY (`salary_deduction_type_id`) REFERENCES `salary_deduction_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_salar_trans_fk_staff_salar_id` FOREIGN KEY (`staff_salary_id`) REFERENCES `staff_salaries` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_trainings`
--
ALTER TABLE `staff_trainings`
  ADD CONSTRAINT `staff_train_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_train_fk_staff_train_categ_id` FOREIGN KEY (`staff_training_category_id`) REFERENCES `staff_training_categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_train_fk_train_field_of_study_id` FOREIGN KEY (`training_field_of_study_id`) REFERENCES `training_field_of_studies` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_training_applications`
--
ALTER TABLE `staff_training_applications`
  ADD CONSTRAINT `staff_train_appli_fk_ass_id` FOREIGN KEY (`assignee_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_train_appli_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_train_appli_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_train_appli_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_train_appli_fk_train_sessi_id` FOREIGN KEY (`training_session_id`) REFERENCES `training_sessions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_training_needs`
--
ALTER TABLE `staff_training_needs`
  ADD CONSTRAINT `staff_train_needs_fk_ass_id` FOREIGN KEY (`assignee_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_train_needs_fk_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_train_needs_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_train_needs_fk_train_cours_id` FOREIGN KEY (`training_course_id`) REFERENCES `training_courses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_train_needs_fk_train_need_categ_id` FOREIGN KEY (`training_need_category_id`) REFERENCES `training_need_categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_train_needs_fk_train_need_compe_id` FOREIGN KEY (`training_need_competency_id`) REFERENCES `training_need_competencies` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_train_needs_fk_train_need_sub_stand_id` FOREIGN KEY (`training_need_sub_standard_id`) REFERENCES `training_need_sub_standards` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `staff_train_needs_fk_train_prior_id` FOREIGN KEY (`training_priority_id`) REFERENCES `training_priorities` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_training_self_studies`
--
ALTER TABLE `staff_training_self_studies`
  ADD CONSTRAINT `staff_train_self_studi_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_training_self_study_attachments`
--
ALTER TABLE `staff_training_self_study_attachments`
  ADD CONSTRAINT `staff_train_self_study_attac_fk_staff_train_self_study_id` FOREIGN KEY (`staff_training_self_study_id`) REFERENCES `staff_training_self_studies` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `staff_training_self_study_results`
--
ALTER TABLE `staff_training_self_study_results`
  ADD CONSTRAINT `staff_train_self_study_resul_fk_staff_train_self_study_id` FOREIGN KEY (`staff_training_self_study_id`) REFERENCES `staff_training_self_studies` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_admission_custom_field_values`
--
ALTER TABLE `student_admission_custom_field_values`
  ADD CONSTRAINT `student_admission_custom_field_values_ibfk_1` FOREIGN KEY (`student_custom_field_id`) REFERENCES `student_custom_fields` (`id`),
  ADD CONSTRAINT `student_admission_custom_field_values_ibfk_2` FOREIGN KEY (`institution_student_admission_id`) REFERENCES `institution_student_admission` (`id`),
  ADD CONSTRAINT `student_admission_custom_field_values_ibfk_3` FOREIGN KEY (`modified_user_id`) REFERENCES `security_users` (`id`),
  ADD CONSTRAINT `student_admission_custom_field_values_ibfk_4` FOREIGN KEY (`created_user_id`) REFERENCES `security_users` (`id`);

--
-- Constraints for table `student_attendance_marked_records`
--
ALTER TABLE `student_attendance_marked_records`
  ADD CONSTRAINT `stude_atten_marke_recor_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_atten_marke_recor_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_atten_marke_recor_fk_ins_cla_id` FOREIGN KEY (`institution_class_id`) REFERENCES `institution_classes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_atten_marke_recor_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_attendance_mark_types`
--
ALTER TABLE `student_attendance_mark_types`
  ADD CONSTRAINT `stude_atten_mark_types_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_atten_mark_types_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_atten_mark_types_fk_stude_atten_type_id` FOREIGN KEY (`student_attendance_type_id`) REFERENCES `student_attendance_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_attendance_per_day_periods`
--
ALTER TABLE `student_attendance_per_day_periods`
  ADD CONSTRAINT `stude_atten_per_day_perio_fk_stude_atten_mark_type_id` FOREIGN KEY (`student_attendance_mark_type_id`) REFERENCES `student_attendance_mark_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_behaviours`
--
ALTER TABLE `student_behaviours`
  ADD CONSTRAINT `stude_behav_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_behav_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_behav_fk_stude_behav_categ_id` FOREIGN KEY (`student_behaviour_category_id`) REFERENCES `student_behaviour_categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_behav_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `student_behaviours_ibfk_1` FOREIGN KEY (`student_behaviour_classification_id`) REFERENCES `student_behaviour_classifications` (`id`);

--
-- Constraints for table `student_behaviour_attachments`
--
ALTER TABLE `student_behaviour_attachments`
  ADD CONSTRAINT `stude_behav_attac_fk_stude_behav_id` FOREIGN KEY (`student_behaviour_id`) REFERENCES `student_behaviours` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_custom_field_options`
--
ALTER TABLE `student_custom_field_options`
  ADD CONSTRAINT `stude_custo_field_optio_fk_stude_custo_field_id` FOREIGN KEY (`student_custom_field_id`) REFERENCES `student_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_custom_field_values`
--
ALTER TABLE `student_custom_field_values`
  ADD CONSTRAINT `stude_custo_field_value_fk_stude_custo_field_id` FOREIGN KEY (`student_custom_field_id`) REFERENCES `student_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_custo_field_value_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_custom_forms`
--
ALTER TABLE `student_custom_forms`
  ADD CONSTRAINT `stude_custo_forms_fk_cus_mod_id` FOREIGN KEY (`custom_module_id`) REFERENCES `custom_modules` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_custom_forms_fields`
--
ALTER TABLE `student_custom_forms_fields`
  ADD CONSTRAINT `stude_custo_forms_field_fk_stude_custo_field_id` FOREIGN KEY (`student_custom_field_id`) REFERENCES `student_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_custo_forms_field_fk_stude_custo_form_id` FOREIGN KEY (`student_custom_form_id`) REFERENCES `student_custom_forms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_custom_table_cells`
--
ALTER TABLE `student_custom_table_cells`
  ADD CONSTRAINT `stude_custo_table_cells_fk_stude_custo_field_id` FOREIGN KEY (`student_custom_field_id`) REFERENCES `student_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_custo_table_cells_fk_stude_custo_table_colum_id` FOREIGN KEY (`student_custom_table_column_id`) REFERENCES `student_custom_table_columns` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_custo_table_cells_fk_stude_custo_table_row_id` FOREIGN KEY (`student_custom_table_row_id`) REFERENCES `student_custom_table_rows` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_custo_table_cells_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_custom_table_columns`
--
ALTER TABLE `student_custom_table_columns`
  ADD CONSTRAINT `stude_custo_table_colum_fk_stude_custo_field_id` FOREIGN KEY (`student_custom_field_id`) REFERENCES `student_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_custom_table_rows`
--
ALTER TABLE `student_custom_table_rows`
  ADD CONSTRAINT `stude_custo_table_rows_fk_stude_custo_field_id` FOREIGN KEY (`student_custom_field_id`) REFERENCES `student_custom_fields` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_extracurriculars`
--
ALTER TABLE `student_extracurriculars`
  ADD CONSTRAINT `stude_extra_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_extra_fk_ext_typ_id` FOREIGN KEY (`extracurricular_type_id`) REFERENCES `extracurricular_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_extra_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_fees`
--
ALTER TABLE `student_fees`
  ADD CONSTRAINT `stude_fees_fk_ins_fee_id` FOREIGN KEY (`institution_fee_id`) REFERENCES `institution_fees` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_fees_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_guardians`
--
ALTER TABLE `student_guardians`
  ADD CONSTRAINT `stude_guard_fk_gua_id` FOREIGN KEY (`guardian_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_guard_fk_gua_rel_id` FOREIGN KEY (`guardian_relation_id`) REFERENCES `guardian_relations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_guard_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_mark_type_statuses`
--
ALTER TABLE `student_mark_type_statuses`
  ADD CONSTRAINT `stude_mark_type_statu_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_mark_type_statu_fk_stude_atten_mark_type_id` FOREIGN KEY (`student_attendance_mark_type_id`) REFERENCES `student_attendance_mark_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_mark_type_status_grades`
--
ALTER TABLE `student_mark_type_status_grades`
  ADD CONSTRAINT `stude_mark_type_statu_grade_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_mark_type_statu_grade_fk_stude_mark_type_statu_id` FOREIGN KEY (`student_mark_type_status_id`) REFERENCES `student_mark_type_statuses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_meal_marked_records`
--
ALTER TABLE `student_meal_marked_records`
  ADD CONSTRAINT `stude_meal_marke_recor_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_meal_marke_recor_fk_ins_cla_id` FOREIGN KEY (`institution_class_id`) REFERENCES `institution_classes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_meal_marke_recor_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_meal_marke_recor_fk_meal_benef_id` FOREIGN KEY (`meal_benefit_id`) REFERENCES `meal_benefits` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_meal_marke_recor_fk_meal_progr_id` FOREIGN KEY (`meal_programmes_id`) REFERENCES `meal_programmes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_profile_templates`
--
ALTER TABLE `student_profile_templates`
  ADD CONSTRAINT `stude_profi_templ_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_report_cards`
--
ALTER TABLE `student_report_cards`
  ADD CONSTRAINT `stude_repor_cards_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_repor_cards_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_repor_cards_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_repor_cards_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_repor_cards_fk_stude_profi_templ_id` FOREIGN KEY (`student_profile_template_id`) REFERENCES `student_profile_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_report_card_email_processes`
--
ALTER TABLE `student_report_card_email_processes`
  ADD CONSTRAINT `stude_repor_card_email_proce_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_repor_card_email_proce_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_repor_card_email_proce_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_repor_card_email_proce_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_repor_card_email_proce_fk_stude_profi_templ_id` FOREIGN KEY (`student_profile_template_id`) REFERENCES `student_profile_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_report_card_processes`
--
ALTER TABLE `student_report_card_processes`
  ADD CONSTRAINT `stude_repor_card_proce_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_repor_card_proce_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_repor_card_proce_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_repor_card_proce_fk_stude_id` FOREIGN KEY (`student_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_repor_card_proce_fk_stude_profi_templ_id` FOREIGN KEY (`student_profile_template_id`) REFERENCES `student_profile_templates` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_risks_criterias`
--
ALTER TABLE `student_risks_criterias`
  ADD CONSTRAINT `stude_risks_crite_fk_insti_stude_risk_id` FOREIGN KEY (`institution_student_risk_id`) REFERENCES `institution_student_risks` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_risks_crite_fk_risk_crite_id` FOREIGN KEY (`risk_criteria_id`) REFERENCES `risk_criterias` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `student_status_updates`
--
ALTER TABLE `student_status_updates`
  ADD CONSTRAINT `stude_statu_updat_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_statu_updat_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_statu_updat_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_statu_updat_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `stude_statu_updat_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `student_statuses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `summary_assessment_item_results`
--
ALTER TABLE `summary_assessment_item_results`
  ADD CONSTRAINT `summa_asses_item_results_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `summa_asses_item_results_fk_are_id` FOREIGN KEY (`area_id`) REFERENCES `areas` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `summa_asses_item_results_fk_ass_id` FOREIGN KEY (`assessment_id`) REFERENCES `assessments` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `summa_asses_item_results_fk_ass_per_id` FOREIGN KEY (`assessment_period_id`) REFERENCES `assessment_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `summa_asses_item_results_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `summa_asses_item_results_fk_ins_id` FOREIGN KEY (`institution_id`) REFERENCES `institutions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `summa_asses_item_results_fk_insti_provi_id` FOREIGN KEY (`institution_provider_id`) REFERENCES `institution_providers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `survey_forms`
--
ALTER TABLE `survey_forms`
  ADD CONSTRAINT `surve_forms_fk_cus_mod_id` FOREIGN KEY (`custom_module_id`) REFERENCES `custom_modules` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `survey_forms_filters`
--
ALTER TABLE `survey_forms_filters`
  ADD CONSTRAINT `surve_forms_filte_fk_surve_form_id` FOREIGN KEY (`survey_form_id`) REFERENCES `survey_forms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `survey_forms_questions`
--
ALTER TABLE `survey_forms_questions`
  ADD CONSTRAINT `surve_forms_quest_fk_surve_form_id` FOREIGN KEY (`survey_form_id`) REFERENCES `survey_forms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `surve_forms_quest_fk_surve_quest_id` FOREIGN KEY (`survey_question_id`) REFERENCES `survey_questions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `survey_question_choices`
--
ALTER TABLE `survey_question_choices`
  ADD CONSTRAINT `surve_quest_choic_fk_surve_quest_id` FOREIGN KEY (`survey_question_id`) REFERENCES `survey_questions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `survey_rules`
--
ALTER TABLE `survey_rules`
  ADD CONSTRAINT `surve_rules_fk_surve_form_id` FOREIGN KEY (`survey_form_id`) REFERENCES `survey_forms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `surve_rules_fk_surve_quest_id` FOREIGN KEY (`survey_question_id`) REFERENCES `survey_questions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `survey_statuses`
--
ALTER TABLE `survey_statuses`
  ADD CONSTRAINT `surve_statu_fk_surve_form_id` FOREIGN KEY (`survey_form_id`) REFERENCES `survey_forms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `survey_status_periods`
--
ALTER TABLE `survey_status_periods`
  ADD CONSTRAINT `surve_statu_perio_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `surve_statu_perio_fk_surve_statu_id` FOREIGN KEY (`survey_status_id`) REFERENCES `survey_statuses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `survey_table_columns`
--
ALTER TABLE `survey_table_columns`
  ADD CONSTRAINT `surve_table_colum_fk_surve_quest_id` FOREIGN KEY (`survey_question_id`) REFERENCES `survey_questions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `survey_table_rows`
--
ALTER TABLE `survey_table_rows`
  ADD CONSTRAINT `surve_table_rows_fk_surve_quest_id` FOREIGN KEY (`survey_question_id`) REFERENCES `survey_questions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `system_authentications`
--
ALTER TABLE `system_authentications`
  ADD CONSTRAINT `syste_authe_fk_aut_typ_id` FOREIGN KEY (`authentication_type_id`) REFERENCES `authentication_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `textbooks`
--
ALTER TABLE `textbooks`
  ADD CONSTRAINT `fk_textbook_dimensions` FOREIGN KEY (`textbook_dimension_id`) REFERENCES `textbook_dimensions` (`id`),
  ADD CONSTRAINT `textb_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `textb_fk_edu_gra_id` FOREIGN KEY (`education_grade_id`) REFERENCES `education_grades` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `textb_fk_edu_sub_id` FOREIGN KEY (`education_subject_id`) REFERENCES `education_subjects` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `themes`
--
ALTER TABLE `themes`
  ADD CONSTRAINT `fk_themes_config_item` FOREIGN KEY (`config_item_id`) REFERENCES `config_items` (`id`);

--
-- Constraints for table `training_courses`
--
ALTER TABLE `training_courses`
  ADD CONSTRAINT `train_cours_fk_ass_id` FOREIGN KEY (`assignee_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_cours_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_cours_fk_train_cours_categ_id` FOREIGN KEY (`training_course_category_id`) REFERENCES `training_course_categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_cours_fk_train_cours_type_id` FOREIGN KEY (`training_course_type_id`) REFERENCES `training_course_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_cours_fk_train_field_of_study_id` FOREIGN KEY (`training_field_of_study_id`) REFERENCES `training_field_of_studies` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_cours_fk_train_level_id` FOREIGN KEY (`training_level_id`) REFERENCES `training_levels` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_cours_fk_train_mode_of_deliv_id` FOREIGN KEY (`training_mode_of_delivery_id`) REFERENCES `training_mode_deliveries` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_cours_fk_train_requi_id` FOREIGN KEY (`training_requirement_id`) REFERENCES `training_requirements` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `training_courses_prerequisites`
--
ALTER TABLE `training_courses_prerequisites`
  ADD CONSTRAINT `train_cours_prere_fk_prere_train_cours_id` FOREIGN KEY (`prerequisite_training_course_id`) REFERENCES `training_courses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_cours_prere_fk_train_cours_id` FOREIGN KEY (`training_course_id`) REFERENCES `training_courses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `training_courses_providers`
--
ALTER TABLE `training_courses_providers`
  ADD CONSTRAINT `train_cours_provi_fk_train_cours_id` FOREIGN KEY (`training_course_id`) REFERENCES `training_courses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_cours_provi_fk_train_provi_id` FOREIGN KEY (`training_provider_id`) REFERENCES `training_providers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `training_courses_result_types`
--
ALTER TABLE `training_courses_result_types`
  ADD CONSTRAINT `train_cours_resul_types_fk_train_cours_id` FOREIGN KEY (`training_course_id`) REFERENCES `training_courses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_cours_resul_types_fk_train_resul_type_id` FOREIGN KEY (`training_result_type_id`) REFERENCES `training_result_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `training_courses_specialisations`
--
ALTER TABLE `training_courses_specialisations`
  ADD CONSTRAINT `train_cours_speci_fk_train_cours_id` FOREIGN KEY (`training_course_id`) REFERENCES `training_courses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_cours_speci_fk_train_speci_id` FOREIGN KEY (`training_specialisation_id`) REFERENCES `training_specialisations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `training_courses_target_populations`
--
ALTER TABLE `training_courses_target_populations`
  ADD CONSTRAINT `train_cours_targe_popul_fk_train_cours_id` FOREIGN KEY (`training_course_id`) REFERENCES `training_courses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `training_need_sub_standards`
--
ALTER TABLE `training_need_sub_standards`
  ADD CONSTRAINT `train_need_sub_stand_fk_train_need_stand_id` FOREIGN KEY (`training_need_standard_id`) REFERENCES `training_need_standards` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `training_sessions`
--
ALTER TABLE `training_sessions`
  ADD CONSTRAINT `train_sessi_fk_are_id` FOREIGN KEY (`area_id`) REFERENCES `areas` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_sessi_fk_ass_id` FOREIGN KEY (`assignee_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_sessi_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_sessi_fk_train_cours_id` FOREIGN KEY (`training_course_id`) REFERENCES `training_courses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_sessi_fk_train_provi_id` FOREIGN KEY (`training_provider_id`) REFERENCES `training_providers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `training_sessions_trainees`
--
ALTER TABLE `training_sessions_trainees`
  ADD CONSTRAINT `train_sessi_train_fk_trainee_id` FOREIGN KEY (`trainee_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_sessi_trainees_fk_train_sessi_id` FOREIGN KEY (`training_session_id`) REFERENCES `training_sessions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `training_session_evaluators`
--
ALTER TABLE `training_session_evaluators`
  ADD CONSTRAINT `train_sess_eval_fk_eval_id` FOREIGN KEY (`evaluator_id`) REFERENCES `security_users` (`id`),
  ADD CONSTRAINT `train_sess_eval_fk_train_sess_id` FOREIGN KEY (`training_session_id`) REFERENCES `training_sessions` (`id`);

--
-- Constraints for table `training_session_results`
--
ALTER TABLE `training_session_results`
  ADD CONSTRAINT `train_sessi_resul_fk_ass_id` FOREIGN KEY (`assignee_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_sessi_resul_fk_statu_id` FOREIGN KEY (`status_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_sessi_resul_fk_train_sessi_id` FOREIGN KEY (`training_session_id`) REFERENCES `training_sessions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `training_session_trainee_results`
--
ALTER TABLE `training_session_trainee_results`
  ADD CONSTRAINT `train_sessi_train_resul_fk_train_id` FOREIGN KEY (`trainee_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_sessi_train_resul_fk_train_resul_type_id` FOREIGN KEY (`training_result_type_id`) REFERENCES `training_result_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_sessi_train_resul_fk_train_sessi_id` FOREIGN KEY (`training_session_id`) REFERENCES `training_sessions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `training_session_trainers`
--
ALTER TABLE `training_session_trainers`
  ADD CONSTRAINT `train_sessi_train_fk_trainer_id` FOREIGN KEY (`trainer_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `train_sessi_trainers_fk_train_sessi_id` FOREIGN KEY (`training_session_id`) REFERENCES `training_sessions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `transfer_logs`
--
ALTER TABLE `transfer_logs`
  ADD CONSTRAINT `trans_logs_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_activities`
--
ALTER TABLE `user_activities`
  ADD CONSTRAINT `user_activ_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_attachments`
--
ALTER TABLE `user_attachments`
  ADD CONSTRAINT `user_attac_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_attac_fk_staff_attac_type_id` FOREIGN KEY (`staff_attachment_type_id`) REFERENCES `staff_attachment_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_attac_fk_stude_attac_type_id` FOREIGN KEY (`student_attachment_type_id`) REFERENCES `student_attachment_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_attachments_roles`
--
ALTER TABLE `user_attachments_roles`
  ADD CONSTRAINT `user_attac_roles_fk_sec_rol_id` FOREIGN KEY (`security_role_id`) REFERENCES `security_roles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_attac_roles_fk_user_attac_id` FOREIGN KEY (`user_attachment_id`) REFERENCES `user_attachments` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_awards`
--
ALTER TABLE `user_awards`
  ADD CONSTRAINT `user_award_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_bank_accounts`
--
ALTER TABLE `user_bank_accounts`
  ADD CONSTRAINT `user_bank_accou_fk_ban_bra_id` FOREIGN KEY (`bank_branch_id`) REFERENCES `bank_branches` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_bank_accou_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_body_masses`
--
ALTER TABLE `user_body_masses`
  ADD CONSTRAINT `user_body_masse_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_body_masse_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_comments`
--
ALTER TABLE `user_comments`
  ADD CONSTRAINT `user_comme_fk_com_typ_id` FOREIGN KEY (`comment_type_id`) REFERENCES `comment_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_comme_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_contacts`
--
ALTER TABLE `user_contacts`
  ADD CONSTRAINT `user_conta_fk_con_typ_id` FOREIGN KEY (`contact_type_id`) REFERENCES `contact_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_conta_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_demographics`
--
ALTER TABLE `user_demographics`
  ADD CONSTRAINT `user_demog_fk_dem_typ_id` FOREIGN KEY (`demographic_types_id`) REFERENCES `demographic_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_demog_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_employments`
--
ALTER TABLE `user_employments`
  ADD CONSTRAINT `user_emplo_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_employments_ibfk_1` FOREIGN KEY (`industry_id`) REFERENCES `industries` (`id`);

--
-- Constraints for table `user_healths`
--
ALTER TABLE `user_healths`
  ADD CONSTRAINT `user_healt_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_health_allergies`
--
ALTER TABLE `user_health_allergies`
  ADD CONSTRAINT `user_healt_aller_fk_hea_all_typ_id` FOREIGN KEY (`health_allergy_type_id`) REFERENCES `health_allergy_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_healt_aller_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_health_consultations`
--
ALTER TABLE `user_health_consultations`
  ADD CONSTRAINT `user_healt_consu_fk_hea_con_typ_id` FOREIGN KEY (`health_consultation_type_id`) REFERENCES `health_consultation_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_healt_consu_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_health_families`
--
ALTER TABLE `user_health_families`
  ADD CONSTRAINT `user_healt_famil_fk_hea_con_id` FOREIGN KEY (`health_condition_id`) REFERENCES `health_conditions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_healt_famil_fk_hea_rel_id` FOREIGN KEY (`health_relationship_id`) REFERENCES `health_relationships` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_healt_famil_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_health_histories`
--
ALTER TABLE `user_health_histories`
  ADD CONSTRAINT `user_healt_histo_fk_hea_con_id` FOREIGN KEY (`health_condition_id`) REFERENCES `health_conditions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_healt_histo_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_health_immunizations`
--
ALTER TABLE `user_health_immunizations`
  ADD CONSTRAINT `user_healt_immun_fk_hea_imm_typ_id` FOREIGN KEY (`health_immunization_type_id`) REFERENCES `health_immunization_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_healt_immun_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_health_medications`
--
ALTER TABLE `user_health_medications`
  ADD CONSTRAINT `user_healt_medic_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_health_tests`
--
ALTER TABLE `user_health_tests`
  ADD CONSTRAINT `user_healt_tests_fk_hea_tes_typ_id` FOREIGN KEY (`health_test_type_id`) REFERENCES `health_test_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_healt_tests_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_identities`
--
ALTER TABLE `user_identities`
  ADD CONSTRAINT `user_ident_fk_ide_typ_id` FOREIGN KEY (`identity_type_id`) REFERENCES `identity_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_ident_fk_natio_id` FOREIGN KEY (`nationality_id`) REFERENCES `nationalities` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_ident_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_insurances`
--
ALTER TABLE `user_insurances`
  ADD CONSTRAINT `user_insur_fk_insur_provi_id` FOREIGN KEY (`insurance_provider_id`) REFERENCES `insurance_providers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_insur_fk_insur_type_id` FOREIGN KEY (`insurance_type_id`) REFERENCES `insurance_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_insur_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_languages`
--
ALTER TABLE `user_languages`
  ADD CONSTRAINT `user_langu_fk_langu_id` FOREIGN KEY (`language_id`) REFERENCES `languages` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_langu_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_nationalities`
--
ALTER TABLE `user_nationalities`
  ADD CONSTRAINT `user_natio_fk_natio_id` FOREIGN KEY (`nationality_id`) REFERENCES `nationalities` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_natio_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_special_needs_assessments`
--
ALTER TABLE `user_special_needs_assessments`
  ADD CONSTRAINT `user_speci_needs_asses_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_speci_needs_asses_fk_speci_need_diffi_id` FOREIGN KEY (`special_need_difficulty_id`) REFERENCES `special_need_difficulties` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_speci_needs_asses_fk_speci_need_type_id` FOREIGN KEY (`special_need_type_id`) REFERENCES `special_need_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_special_needs_devices`
--
ALTER TABLE `user_special_needs_devices`
  ADD CONSTRAINT `user_speci_needs_devic_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_speci_needs_devic_fk_speci_needs_devic_type_id` FOREIGN KEY (`special_needs_device_type_id`) REFERENCES `special_needs_device_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_special_needs_diagnostics`
--
ALTER TABLE `user_special_needs_diagnostics`
  ADD CONSTRAINT `user_special_needs_diagnostics_ibfk_1` FOREIGN KEY (`special_needs_diagnostics_degree_id`) REFERENCES `special_needs_diagnostics_degree` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_special_needs_plans`
--
ALTER TABLE `user_special_needs_plans`
  ADD CONSTRAINT `user_speci_needs_plans_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_special_needs_referrals`
--
ALTER TABLE `user_special_needs_referrals`
  ADD CONSTRAINT `user_speci_needs_refer_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_speci_needs_refer_fk_reaso_type_id` FOREIGN KEY (`reason_type_id`) REFERENCES `special_need_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_speci_needs_refer_fk_refer_id` FOREIGN KEY (`referrer_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_speci_needs_refer_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_speci_needs_refer_fk_speci_needs_refer_type_id` FOREIGN KEY (`special_needs_referrer_type_id`) REFERENCES `special_needs_referrer_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `user_special_needs_services`
--
ALTER TABLE `user_special_needs_services`
  ADD CONSTRAINT `user_speci_needs_servi_fk_aca_per_id` FOREIGN KEY (`academic_period_id`) REFERENCES `academic_periods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_speci_needs_servi_fk_secur_user_id` FOREIGN KEY (`security_user_id`) REFERENCES `security_users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_speci_needs_servi_fk_speci_needs_servi_type_id` FOREIGN KEY (`special_needs_service_type_id`) REFERENCES `special_needs_service_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `webhook_events`
--
ALTER TABLE `webhook_events`
  ADD CONSTRAINT `webho_event_fk_webho_id` FOREIGN KEY (`webhook_id`) REFERENCES `webhooks` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `workflows`
--
ALTER TABLE `workflows`
  ADD CONSTRAINT `workf_fk_workf_model_id` FOREIGN KEY (`workflow_model_id`) REFERENCES `workflow_models` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `workflows_filters`
--
ALTER TABLE `workflows_filters`
  ADD CONSTRAINT `workf_filte_fk_workf_id` FOREIGN KEY (`workflow_id`) REFERENCES `workflows` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `workflow_actions`
--
ALTER TABLE `workflow_actions`
  ADD CONSTRAINT `workf_actio_fk_workf_step_id` FOREIGN KEY (`workflow_step_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `workflow_rules`
--
ALTER TABLE `workflow_rules`
  ADD CONSTRAINT `workf_rules_fk_workf_id` FOREIGN KEY (`workflow_id`) REFERENCES `workflows` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `workflow_rule_events`
--
ALTER TABLE `workflow_rule_events`
  ADD CONSTRAINT `workf_rule_event_fk_workf_rule_id` FOREIGN KEY (`workflow_rule_id`) REFERENCES `workflow_rules` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `workflow_statuses`
--
ALTER TABLE `workflow_statuses`
  ADD CONSTRAINT `workf_statu_fk_workf_model_id` FOREIGN KEY (`workflow_model_id`) REFERENCES `workflow_models` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `workflow_statuses_steps`
--
ALTER TABLE `workflow_statuses_steps`
  ADD CONSTRAINT `workf_statu_steps_fk_workf_statu_id` FOREIGN KEY (`workflow_status_id`) REFERENCES `workflow_statuses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `workf_statu_steps_fk_workf_step_id` FOREIGN KEY (`workflow_step_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `workflow_steps`
--
ALTER TABLE `workflow_steps`
  ADD CONSTRAINT `workf_steps_fk_workf_id` FOREIGN KEY (`workflow_id`) REFERENCES `workflows` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `workflow_steps_params`
--
ALTER TABLE `workflow_steps_params`
  ADD CONSTRAINT `workf_steps_param_fk_workf_step_id` FOREIGN KEY (`workflow_step_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `workflow_steps_roles`
--
ALTER TABLE `workflow_steps_roles`
  ADD CONSTRAINT `workf_steps_roles_fk_sec_rol_id` FOREIGN KEY (`security_role_id`) REFERENCES `security_roles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `workf_steps_roles_fk_workf_step_id` FOREIGN KEY (`workflow_step_id`) REFERENCES `workflow_steps` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `workflow_transitions`
--
ALTER TABLE `workflow_transitions`
  ADD CONSTRAINT `workf_trans_fk_workf_model_id` FOREIGN KEY (`workflow_model_id`) REFERENCES `workflow_models` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
