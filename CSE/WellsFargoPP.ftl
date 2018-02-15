<#-- Wells Fargo Positive Pay Template-->
<#-- Author: Michael Wang / mwang@netsuite.com -->

<#function getVoidCheckIndicator payment>
    <#assign value = "O">
    <#assign reversalDate = payment.reversaldate>
    <#if reversalDate?has_content>
        <#assign value = "V">
    </#if>
    <#return value>
</#function>

<#function getChequeNumber payment>
  <#assign value = "">
    <#if payment.recordtype == "cashrefund">
        <#assign value = payment.otherrefnum>
    <#else>
      <#assign value = payment.tranid>
    </#if>
    <#return value>
</#function>

<#-- template building -->

#OUTPUT START#
<#-- FILE HEADER RECORD -->
*03<#-- Always *03 --><#rt>
${setPadding(cbank.custpage_pp_custrecord_2663_bank_comp_id,"left","0",5)}<#-- WF Bank ID (5)--><#rt>
${setPadding(cbank.custpage_pp_custrecord_2663_acct_num,"left","0",15)}<#-- CSE WF Account Num (15)--><#rt>
0<#-- File Status Alwats Zero -->

<#-- DETAIL RECORD -->
<#list payments as payment>
    <#assign entity = entities[payment_index]>
${setPadding(getChequeNumber(payment),"left","0",10)}<#-- Check Serial Num (10) --><#rt>
${setLength(pfa.custrecord_2663_file_creation_timestamp?date?string("MMddyy"),6)}<#-- Issue Date (6)(MMddyy) --><#rt>
${setPadding(cbank.custpage_pp_custrecord_2663_acct_num,"left","0",15)}<#-- CSE WF Account Num (15) --><#rt>
320<#-- Trans Code Always 320/Check Register --><#rt>
${setPadding(formatAmount(getAmount(payment)),"left","0",10)}<#-- Payment Amount (10) --><#rt>
${setLength(buildEntityName(entity,true),40)}<#-- Payee Info (45-84) -->
</#list>
<#-- TRAILER RECORD -->
&${setLength("",14)}<#rt>
${setPadding(payments?size?c,"left","0",7)}<#rt>
${setLength("",3)}<#rt>
${setPadding(formatAmount(computeTotalAmount(payments)),"left","0",13)}<#rt>
#OUTPUT END#
