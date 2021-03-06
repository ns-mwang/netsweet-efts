<#-- format specific processing -->

<#function buildEntityAddress entity>    
    <#assign address1 = entity.address1>
    <#assign address2 = entity.address2>
    <#assign address3 = entity.address3>
    <#assign address = "">
    <#if address1?has_content>
        <#assign address = address + address1>
    </#if>
    <#if address2?has_content>
        <#if address?has_content>
            <#assign address = address + "," + address2>
        <#else>
            <#assign address = address2>
        </#if>
    </#if>
    <#if address3?has_content>
        <#if address?has_content>
            <#assign address = address + "," + address3>
        <#else>
            <#assign address = address3>
        </#if>
    </#if>    
    <#return address>
</#function>

<#function getReferenceNote payment>
    <#assign paidTransactions = transHash[payment.internalid]>
    <#assign referenceNote = "">
    <#assign paidTransactionsCount = paidTransactions?size>
    <#if (paidTransactionsCount >= 1)>
    	<#list paidTransactions as transaction>
    		<#if transaction.tranid?has_content>
    			<#if referenceNote?has_content>
    				<#assign referenceNote = referenceNote + "," + transaction.tranid>
    			<#else>
    				<#assign referenceNote = transaction.tranid>
    			</#if>
		    </#if>
		</#list>
    </#if>
	<#return referenceNote>
</#function>

<#function getBankAccountNumber cbank>
	<#if cbank.custpage_eft_custrecord_2663_acct_num?has_content>
		<#return cbank.custpage_eft_custrecord_2663_acct_num>
	<#elseif cbank.custpage_eft_custrecord_2663_iban?has_content>
		<#return cbank.custpage_eft_custrecord_2663_iban>
	</#if>
	<#return "">
</#function>

<#function getEntityAccountNumber ebank>
	<#if ebank.custrecord_2663_entity_acct_no?has_content>
		<#return ebank.custrecord_2663_entity_acct_no>
	<#elseif ebank.custrecord_2663_entity_iban?has_content>
		<#return ebank.custrecord_2663_entity_iban>
	</#if>
	<#return "">
</#function>

<#function removeInvalidCharacter str>
	<#assign firstChar = str?substring(0,1)>
	<#if firstChar == ":" || firstChar == "-">
		<#return str?substring(1)>
	</#if>
	<#return str>
</#function>


<#-- template building -->
#OUTPUT START#
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
    <#assign entityName = buildEntityName(entity,false)>
    <#assign entityAddress = buildEntityAddress(entity)>
    <#assign referenceNote = getReferenceNote(payment)>
:20:${setLength(payment.tranid,16)}
:32A:${pfa.custrecord_2663_process_date?string("yyyyMMddyyyyMMdd")}${setLength(getCurrencySymbol(payment.currency)?upper_case,3)}${setLength(formatAmount(getAmount(payment),"dec",","),15)}
:36:1.000000A
:50:/${setLength(getBankAccountNumber(cbank),34)}
${setLength(removeInvalidCharacter(cbank.custpage_eft_custrecord_2663_statement_name),35)}
${setLength(removeInvalidCharacter(cbank.custpage_eft_custrecord_2663_bank_address1),35)}
${setLength(removeInvalidCharacter(cbank.custpage_eft_custrecord_2663_bank_address2),35)}
${setLength(removeInvalidCharacter(cbank.custpage_eft_custrecord_2663_bank_country),35)}
:57D:${ebank.custrecord_2663_entity_bic}
<#if ebank.custrecord_2663_entity_bank_name?has_content>
${setLength(removeInvalidCharacter(ebank.custrecord_2663_entity_bank_name),35)}
</#if>
<#if  ebank.custrecord_2663_entity_address1?has_content>
${setLength(removeInvalidCharacter(ebank.custrecord_2663_entity_address1),35)}
</#if>
<#if ebank.custrecord_2663_entity_address2?has_content>
${setLength(removeInvalidCharacter(ebank.custrecord_2663_entity_address2),35)}
</#if>
<#if ebank.custrecord_2663_entity_country?has_content>
${setLength(ebank.custrecord_2663_entity_country,35)}
</#if>
:59:/${setLength(getEntityAccountNumber(ebank),34)}
<#if entityName?has_content>
${setLength(removeInvalidCharacter(entityName),35)}
</#if>
<#if entityAddress?has_content>
${setLength(removeInvalidCharacter(entityAddress),35)}
</#if>
<#if entity.city?has_content>
${setLength(removeInvalidCharacter(entity.city),35)}
</#if>
<#if entity.billcountrycode?has_content>
${setLength(entity.billcountrycode,35)}
</#if>
:70:${setLength(cbank.custrecord_2663_print_company_name,35)}
<#if referenceNote?has_content>
${setLength(removeInvalidCharacter(referenceNote),35)}
<#if (referenceNote?length > 35)>
${setLength(removeInvalidCharacter(referenceNote?substring(35)),35)}
</#if>
<#if (referenceNote?length > 70)>
${setLength(removeInvalidCharacter(referenceNote?substring(70)),35)}
</#if>
</#if>
:71A:/${setLength(ebank.custrecord_2663_customer_code,3)}
-
</#list>
#REMOVE EOL#
#OUTPUT END#
