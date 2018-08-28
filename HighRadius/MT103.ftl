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
:20:${payment.tranid}
:32A:${pfa.custrecord_2663_process_date?string("yyyyMMddyyyyMMdd")}${setLength(getCurrencySymbol(payment.currency)?upper_case,3)}${formatAmount(getAmount(payment),"dec",",")}
:36:1.000000A
:50:/${getBankAccountNumber(cbank)}
${removeInvalidCharacter(cbank.custpage_eft_custrecord_2663_statement_name)}
${removeInvalidCharacter(cbank.custpage_eft_custrecord_2663_bank_address1)}
${removeInvalidCharacter(cbank.custpage_eft_custrecord_2663_bank_address2)}
${removeInvalidCharacter(cbank.custpage_eft_custrecord_2663_bank_country)}
:57D:${ebank.custrecord_2663_entity_bic}
<#if ebank.custrecord_2663_entity_bank_name?has_content>
${removeInvalidCharacter(ebank.custrecord_2663_entity_bank_name)}
</#if>
<#if  ebank.custrecord_2663_entity_address1?has_content>
${removeInvalidCharacter(ebank.custrecord_2663_entity_address1)}
</#if>
<#if ebank.custrecord_2663_entity_address2?has_content>
${removeInvalidCharacter(ebank.custrecord_2663_entity_address2)}
</#if>
<#if ebank.custrecord_2663_entity_country?has_content>
${ebank.custrecord_2663_entity_country}
</#if>
:59:/${getEntityAccountNumber(ebank)}
<#if entityName?has_content>
${removeInvalidCharacter(entityName)}
</#if>
<#if entityAddress?has_content>
${removeInvalidCharacter(entityAddress)}
</#if>
<#if entity.city?has_content>
${removeInvalidCharacter(entity.city)}
</#if>
<#if entity.billcountrycode?has_content>
${entity.billcountrycode}
</#if>
:70:${cbank.custrecord_2663_print_company_name}
<#if referenceNote?has_content>
${removeInvalidCharacter(referenceNote)}
<#if (referenceNote?length > 35)>
${removeInvalidCharacter(referenceNote?substring(35))}
</#if>
<#if (referenceNote?length > 70)>
${removeInvalidCharacter(referenceNote?substring(70))}
</#if>
</#if>
:71A:/${ebank.custrecord_2663_customer_code}
-
</#list>
#REMOVE EOL#
#OUTPUT END#
