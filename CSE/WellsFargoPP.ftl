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
*03<#rt>  <#-- Always *03 -->
${setPadding(cbank.custpage_pp_custrecord_2663_acct_num,"left","0",12)}<#rt>  <#-- WF Bank ID (5)-->
${setPadding(cbank.custpage_pp_custrecord_2663_acct_num,"left","0",12)}<#rt>  <#-- CSE WF Bank Account Num (15)-->
0  <#-- File Status Alwats Zero -->
<#-- DETAIL RECORD -->
<#list payments as payment>
    <#assign entity = entities[payment_index]>
${setPadding(getChequeNumber(payment),"left","0",10)}<#rt>  <#-- Check Serial Num (10) -->
${setLength(pfa.custrecord_2663_file_creation_timestamp?date?string("MMddyy"),6)}<#rt>  <#-- Issue Date (6)(MMddyy) -->
${setPadding(cbank.custpage_pp_custrecord_2663_acct_num,"left","0",12)}<#rt>  <#-- Entity Account Num (15) -->
320<#rt>  <#-- Trans Code Always 320/Check Register -->
${setPadding(formatAmount(getAmount(payment)),"left","0",12)}<#rt>  <#-- Payment Amount (10) -->
${setLength(buildEntityName(entity,true),50)}<#rt>  <#-- Payee Info (45-84) -->
</#list>
<#-- TRAILER RECORD -->
&${setLength("",75)}<#rt>
${setPadding(payments?size?c,"left","0",10)}<#rt>
${setPadding(formatAmount(computeTotalAmount(payments)),"left","0",12)}<#rt>
#OUTPUT END#
