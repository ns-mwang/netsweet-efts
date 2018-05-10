<#-- format specific processing -->
<#function buildEntityBillingAddress entity>
    <#assign address = "">
    <#if entity.billaddress1?has_content >
        <#assign address = entity.billaddress1 >
    <#elseif entity.shipaddress1?has_content >
        <#assign address = entity.shipaddress1 >
    <#elseif entity.address1?has_content >
        <#assign address = entity.address1 >
    </#if>
	<#assign address = address?replace('<br/>',' ')>
	<#assign address = address?replace('<br />',' ')>
    <#return address>
</#function>

<#function buildEntityBillingAddress2 entity>
    <#assign address = "">
    <#if entity.billaddress2?has_content >
        <#assign address = entity.billaddress2 >
    <#elseif entity.shipaddress1?has_content >
        <#assign address = entity.shipaddress2 >
    <#elseif entity.address1?has_content >
        <#assign address = entity.address2 >
    </#if>
	<#assign address = address?replace('<br/>',' ')>
	<#assign address = address?replace('<br />',' ')>
    <#return address>
</#function>

<#function buildEntityBillingCity entity>
	<#assign address = "">
	<#if entity.billcity?has_content >
		<#assign address = entity.billcity >
	<#elseif entity.shipcity?has_content >
		<#assign address = entity.shipcity >
	<#elseif entity.city?has_content >
		<#assign address = entity.city >
	</#if>
	<#assign address = address?replace('<br/>',' ')>
	<#assign address = address?replace('<br />',' ')>
	<#return address>
</#function>

<#function buildEntityBillingState entity>
	<#assign address = "">
	<#if entity.billstate?has_content >
		<#assign address = entity.billstate>
	<#elseif entity.shipstate?has_content >
		<#assign address = entity.shipstate>
	<#elseif entity.state?has_content >
		<#assign address = entity.state>
	</#if>
	<#assign address = address?replace('<br/>',' ')>
	<#assign address = address?replace('<br />',' ')>
	<#return address>
</#function>

<#function buildEntityBillingZip entity>
	<#assign address = "" > 
	<#if entity.billzipcode?has_content >
		<#assign address = entity.billzipcode >
	<#elseif entity.shipzip?has_content >
		<#assign address = entity.shipzip >
	<#elseif entity.zipcode?has_content >
		<#assign address = entity.zipcode >
	</#if>
		<#return address>
	<#assign address = address?replace('<br/>',' ')>
	<#assign address = address?replace('<br />',' ')>
</#function>

<#function getReferenceNote payment>
    <#assign paidTransactions = transHash[payment.internalid]>
    <#assign referenceNote = "">
    <#assign paidTransactionsCount = paidTransactions?size>
    <#if (paidTransactionsCount >= 1)>
        <#list paidTransactions as transaction>
            <#if transaction.tranid?has_content>
                <#if referenceNote?has_content>
                    <#assign referenceNote = referenceNote + ", " + transaction.tranid>
                <#else>
                    <#assign referenceNote = transaction.tranid>
                </#if>
            </#if>
        </#list>
    </#if>
    <#return referenceNote>
</#function>

<#function convertSEPACharSet text>
    <#assign value = text>
	<#assign value = value?replace('&amp;','and')>
    <#assign value = value?replace('*','.')>
    <#assign value = value?replace('$','.')>
    <#assign value = value?replace('%','.')>
	<#assign value = value?replace('/',' ')>
	<#assign value = value?replace('>',' ')>
	<#assign value = value?replace('<',' ')>
	<#assign value = convertToLatinCharSet(value)>
    <#return value>
</#function>


<#-- template building -->
#OUTPUT START#
<?xml version="1.0" encoding="UTF-8"?>
<Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03 pain.001.001.03.xsd">
<CstmrCdtTrfInitn>
<GrpHdr>
<MsgId>${pfa.id}</MsgId>
<CreDtTm>${pfa.custrecord_2663_file_creation_timestamp?date?string("yyyy-MM-dd")}T${pfa.custrecord_2663_file_creation_timestamp?time?string("HH:mm:ss")}</CreDtTm>
<NbOfTxs>${payments?size?c}</NbOfTxs>
<CtrlSum>${formatAmount(computeTotalAmount(payments),"decLessThan1")}</CtrlSum>
<InitgPty>
<Nm>${setMaxLength(convertToLatinCharSet(cbank.custpage_eft_custrecord_2663_statement_name),70)}</Nm>
<Id>
<OrgId>
<Othr>
<Id>${cbank.custpage_eft_custrecord_2663_bank_comp_id}</Id>
<SchmeNm>
<Cd>CUST</Cd>
</SchmeNm>
</Othr>
</OrgId>
</Id>
</InitgPty>
</GrpHdr>
<PmtInf>
<PmtInfId>${pfa.id}-1</PmtInfId>
<PmtMtd>TRF</PmtMtd>
<BtchBookg>true</BtchBookg>
<PmtTpInf>
<SvcLvl>
<Cd>NURG</Cd>
</SvcLvl>
<CtgyPurp>
<Cd>SUPP</Cd>
</CtgyPurp>
</PmtTpInf>
<ReqdExctnDt>${pfa.custrecord_2663_process_date?string("yyyy-MM-dd")}</ReqdExctnDt>
<Dbtr>
<Nm>${setMaxLength(convertToLatinCharSet(cbank.custpage_eft_custrecord_2663_statement_name),70)}</Nm>
<PstlAdr>
<StrtNm>${cbank.custrecord_2663_address_line_1}</StrtNm>
<PstCd>${cbank.custrecord_2663_zip}</PstCd>
<TwnNm>${cbank.custrecord_2663_city}</TwnNm>
<Ctry>${getCountryCode(cbank.custrecord_2663_country)}</Ctry>
</PstlAdr>
</Dbtr>
<DbtrAcct>
<Id>
<IBAN>${cbank.custpage_eft_custrecord_2663_iban}</IBAN>
</Id>
</DbtrAcct>
<DbtrAgt>
<FinInstnId>
<BIC>${cbank.custpage_eft_custrecord_2663_bic}</BIC>
</FinInstnId>
</DbtrAgt>
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
<CdtTrfTxInf>
<PmtId>
<InstrId>${pfa.id}-${payment.tranid}</InstrId>
<EndToEndId>${pfa.id}-${payment.tranid}</EndToEndId>
</PmtId>
<Amt>
<InstdAmt Ccy="NOK">${formatAmount(getAmount(payment),"decLessThan1")}</InstdAmt>
</Amt>
<Cdtr>
<Nm>${setMaxLength(convertSEPACharSet(buildEntityName(entity, false)),70)}</Nm>
<PstlAdr>
<#assign checkAdd = buildEntityBillingAddress(entity)>
<#if checkAdd?has_content>
<StrtNm>${buildEntityBillingAddress(entity)}</StrtNm>
</#if>
<#assign checkZip = buildEntityBillingZip(entity)>
<#if checkZip?has_content>
<PstCd>${buildEntityBillingZip(entity)}</PstCd>
</#if>
<#assign checkCity = buildEntityBillingCity(entity)>
<#if checkCity?has_content>
<TwnNm>${buildEntityBillingCity(entity)}</TwnNm>
</#if>
<Ctry>${getCountryCode(ebank.custrecord_2663_entity_country)}</Ctry>
</PstlAdr>
</Cdtr>
<CdtrAcct>
<Id>
<Othr>
<Id>${ebank.custrecord_2663_entity_bban}</Id>
<SchmeNm>
<Cd>BBAN</Cd>
</SchmeNm>
</Othr>
</Id>
</CdtrAcct>
<RmtInf>
<#assign paidTransactions = transHash[payment.internalid]>
<#list paidTransactions as transaction>
<#if transaction.custbody_2663_isr_reference?has_content>
<Strd>
<CdtrRefInf>
<Tp>
<CdOrPrtry>
<Cd>SCOR</Cd>
</CdOrPrtry>
</Tp>
<Ref>${transaction.custbody_2663_isr_reference}</Ref>
</CdtrRefInf>
</Strd>
<#else>
<Ustrd>${setMaxLength(transaction.tranid,140)}</Ustrd>
</#if>
</#list>
</RmtInf>
</CdtTrfTxInf>
</#list>
</PmtInf>
</CstmrCdtTrfInitn>
</Document><#rt>
#OUTPUT END#
