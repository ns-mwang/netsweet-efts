EBD:
<refFields type="SEPA Credit Transfer (ABN AMRO)">
   <refField id="custrecord_2663_entity_bic" label="BIC" mandatory="false" />
   <refField id='custrecord_2663_entity_iban' label='IBAN' mandatory='false' /> 
</refFields>

RF:
<refFields type="SEPA Credit Transfer (ABN AMRO)">
	<refField id='custrecord_2663_bank_comp_id' label='Company Id' mandatory='false' />
	<refField id='custrecord_2663_bic' label='BIC' mandatory='false' />
	<refField id='custrecord_2663_issuer_num' label='Issuer' mandatory='false' />
   	<refField id='custrecord_2663_iban' label='IBAN' mandatory='false' />
   	<refField id='custrecord_2663_statement_name' label='Company Name' mandatory='false' />
   	<refField id='custrecord_2663_bank_address1' label='Address Line 1' mandatory='false' />
   	<refField id='custrecord_2663_bank_address2' label='Address Line 2' mandatory='false' />
   	<refField id='custrecord_2663_bank_country' label='Country' mandatory='false' />
</refFields>


<#-- format specific processing -->
<#function buildEntityBillingAddress1 entity>
    <#assign address = "">
    <#if entity.billaddress1?has_content >
        <#assign address = entity.billaddress1 >
    <#elseif entity.shipaddress1?has_content >
        <#assign address = entity.shipaddress1 >
    <#elseif entity.address1?has_content >
        <#assign address = entity.address1 >
    </#if>

    
    <#if (address?length > 70) >
        <#assign address = address?substring(0,70) >
    </#if>  
    <#return address>
</#function>

<#function buildEntityBillingAddress2 entity>
    <#assign address = "">
    <#if entity.billaddress2?has_content >
        <#assign address = entity.billaddress2 >
    <#elseif entity.shipaddress2?has_content >
        <#assign address = entity.shipaddress2 >
    <#elseif entity.address2?has_content >
        <#assign address = entity.address2 >
    </#if>

    
    <#if (address?length > 70) >
        <#assign address = address?substring(0,70) >
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
                    <#assign referenceNote = referenceNote + ", " + transaction.tranid>
                <#else>
                    <#assign referenceNote = transaction.tranid>
                </#if>
            </#if>
        </#list>
    </#if>
    <#return referenceNote>
</#function>
<#-- template building -->
#OUTPUT START#
<?xml version="1.0" encoding="UTF-8"?>
<Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
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
<Issr>${cbank.custpage_eft_custrecord_2663_issuer_num}</Issr>
</Othr>
</OrgId>
</Id>
</InitgPty>
</GrpHdr>
<PmtInf>
<PmtInfId>${pfa.id}-1</PmtInfId>
<PmtMtd>TRF</PmtMtd>
<BtchBookg>true</BtchBookg>
<NbOfTxs>${payments?size?c}</NbOfTxs>
<CtrlSum>${formatAmount(computeTotalAmount(payments),"decLessThan1")}</CtrlSum>
<PmtTpInf>
<InstrPrty>NORM</InstrPrty>
<SvcLvl>
<Cd>SEPA</Cd>
</SvcLvl>
</PmtTpInf>
<ReqdExctnDt>${pfa.custrecord_2663_process_date?string("yyyy-MM-dd")}</ReqdExctnDt>
<Dbtr>
<Nm>${setMaxLength(convertToLatinCharSet(cbank.custpage_eft_custrecord_2663_statement_name),70)}</Nm>
<PstlAdr>
<Ctry>${getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)}</Ctry>
<AdrLine>${setMaxLength(convertToLatinCharSet(cbank.custpage_eft_custrecord_2663_bank_address1),70)} ${setMaxLength(convertToLatinCharSet(cbank.custpage_eft_custrecord_2663_bank_address2),70)}</AdrLine>
</PstlAdr>
<Id>
<OrgId>
<Othr>
<Id>${cbank.custpage_eft_custrecord_2663_bank_comp_id}</Id>
</Othr>
</OrgId>
</Id>
</Dbtr>
<DbtrAcct>
<Id>
<IBAN>${cbank.custpage_eft_custrecord_2663_iban}</IBAN>
</Id>
<Ccy>${getCurrencySymbol(cbank.custrecord_2663_currency)}</Ccy>
</DbtrAcct>
<DbtrAgt>
<FinInstnId>
<BIC>${cbank.custpage_eft_custrecord_2663_bic}</BIC>
</FinInstnId>
</DbtrAgt>
<UltmtDbtr>
<Nm>${setMaxLength(convertToLatinCharSet(cbank.custpage_eft_custrecord_2663_statement_name),70)}</Nm>
<Id>
<OrgId>
<Othr>
<Id>${cbank.custpage_eft_custrecord_2663_bank_comp_id}</Id>
</Othr>
</OrgId>
</Id>
</UltmtDbtr>
<ChrgBr>SLEV</ChrgBr>
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
<CdtTrfTxInf>
<PmtId>
<InstrId>${pfa.id}-${payment.tranid}</InstrId>
<EndToEndId>${pfa.id}-${payment.tranid}</EndToEndId>
</PmtId>
<Amt>
<InstdAmt Ccy="EUR">${formatAmount(getAmount(payment),"decLessThan1")}</InstdAmt>
</Amt>
<CdtrAgt>
<FinInstnId>
<BIC>${ebank.custrecord_2663_entity_bic}</BIC>
</FinInstnId>
</CdtrAgt>
<Cdtr>
<Nm>${setMaxLength(convertToLatinCharSet(buildEntityName(entity, false)),70)}</Nm>
<PstlAdr>
<Ctry>${convertToLatinCharSet(entity.billcountrycode)}</Ctry>
<AdrLine>${setMaxLength(convertToLatinCharSet(buildEntityBillingAddress1(entity)),70)} ${setMaxLength(convertToLatinCharSet(buildEntityBillingAddress2(entity)),70)}</AdrLine>
</PstlAdr>
<Id>
<OrgId>
<Othr>
<Id>${convertToLatinCharSet(entity.internalid)}</Id>
</Othr>
</OrgId>
</Id>
</Cdtr>
<CdtrAcct>
<Id>
<IBAN>${ebank.custrecord_2663_entity_iban}</IBAN>
</Id>
<Ccy>EUR</Ccy>
</CdtrAcct>
<RmtInf>
<Ustrd>${setMaxLength(convertToLatinCharSet(getReferenceNote(payment)),140)}</Ustrd>
</RmtInf>
</CdtTrfTxInf>
</#list>
</PmtInf>
</CstmrCdtTrfInitn>
</Document><#rt>
#OUTPUT END#
