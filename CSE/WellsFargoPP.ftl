<#-- format specific processing -->

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
${setPadding(cbank.custpage_pp_custrecord_2663_acct_num,"left","0",12)}H${setLength("",22)}${setLength(pfa.custrecord_2663_file_creation_timestamp?date?string("MMddyy"),6)}${setLength("",69)}
<#list payments as payment>
    <#assign entity = entities[payment_index]>
${setPadding(cbank.custpage_pp_custrecord_2663_acct_num,"left","0",12)}${setLength(getVoidCheckIndicator(payment),1)}${setPadding(getChequeNumber(payment),"left","0",10)}${setPadding(formatAmount(getAmount(payment)),"left","0",12)}${setLength(payment.trandate?string("MMddyy"),6)}${setLength("",3)}${setLength(buildEntityName(entity,true),50)}${setLength("",16)}
</#list>
${setPadding(cbank.custpage_pp_custrecord_2663_acct_num,"left","0",12)}T${setPadding(payments?size?c,"left","0",10)}${setPadding(formatAmount(computeTotalAmount(payments)),"left","0",12)}${setLength("",75)}
#OUTPUT END#
