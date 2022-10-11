select distinct 
sp.id as script_profile_id,
sp.name as script_profile_name,
case when submitted_against_type='TPI' then submitted_against_id else 0 end tpi_id,
case when submitted_against_type='RLI' then submitted_against_id else fus_sp_rli.rli end rli_num,
case when lrm_platform.platform is not null then lrm_platform.platform  else coalesce(script_exec.model,'N/A') end as regression_platform,
coalesce(oreplace(oreplace(pl.platform,'-Series',''),'-series',''),'N/A') as "deepthought_platform",
coalesce(script_exec.model,'NA')  as regression_model,
script_exec.current_state,
script_exec.exec_result,
script_exec.dut_version,
script_exec.failure_category,
fsub.planned_release as "Planned Release",
fsub.edw_release_target as "Planned Release Target",
ft.taxonomy as "Profile FeatureTaxonomy"
from EDW.fus_script_profile sp 
left join EDW.fus_script_exec script_exec
on script_exec.script_profile_id=sp.id
left join fus_sp_rli on sp.id=fus_sp_rli.script_profile_id
left join EDW.rli_platform_mp pl on pl.id_num=rli_num
left join lrm_platform on lrm_platform.model=script_exec.model
left join fus_sp_taxonomy ft on ft.script_profile_id=sp.id
left join fus_submission fsub on fsub.id=script_exec.submission_id
where sp.id is not null 
--and sp.etrans_submission_id is not null
and rli_num is not null 
--and sp.name='evpn_mpls_mh_sa_vs_proxy_arp_mts_002.robot_136908_Default'
--and sp.current_transition_status='PASS' ---In Production
and script_exec.current_state='COMPLETED'