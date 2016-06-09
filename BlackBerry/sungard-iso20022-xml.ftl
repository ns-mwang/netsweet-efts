<#-- Author: Michael Wang | mwang@netsuite.com -->
<#-- Bank Format: iso 20022 xml -->
<#-- Banks: BoA, HSBC, RBC, Wells Fargo -->
<#-- cached values -->
<#assign totalAmount = computeTotalAmount(payments)>
<#-- template building -->
#OUTPUT START#
<?xml version="1.0" encoding="UTF-8"?>
<Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<CstmrCdtTrfInitn>

<GrpHdr>
	<MsgId>RBS${getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)}_${pfa.custrecord_2663_process_date?date?string("yyyy-MM-dd")}_ID${pfa.id}</MsgId> <#--Max Length = 35;Format = RBS_FileCreationDate_PFA.ID-->
	<CreDtTm>${pfa.custrecord_2663_file_creation_timestamp?date?string("yyyy-MM-dd")}T${pfa.custrecord_2663_file_creation_timestamp?time?string("HH:mm:ss")}</CreDtTm>
	<NbOfTxs>${payments?size?c}</NbOfTxs>
	<CtrlSum>${formatAmount(totalAmount,"dec")}</CtrlSum>
	<InitgPty>
		<Nm>${setMaxLength(convertToLatinCharSet(cbank.custrecord_2663_legal_name),70)}</Nm>
	</InitgPty>
</GrpHdr>

<#-- Looping through each payments in the Payment File Administration -->
<#list payments as payment>
	<#assign paidTransactions = transHash[payment.internalid]>
	<#assign ebank = ebanks[payment_index]>
	<#assign entity = entities[payment_index]>
	<#-- Check for SEPA(Single Euro Payments Area) Payments -->
	<#if ebank.custrecord_2663_bank_payment_method == "Wire">
		<#assign isWire = "true">
		<#assign isSEPA = "false">
		<#assign isACH = "false">
	<#else>
		<#assign isWire = "false">
		<#if getCurrencySymbol(payment.currency) == "EUR">
			<#assign isSEPA = "true">
		<#else>
			<#assign isSEPA = "false">
		</#if>
		<#if ebank.custrecord_2663_bank_payment_method == "ACH">
			<#assign isACH = "true">
		<#else>
			<#assign isACH = "false">
		</#if>
	</#if>
<PmtInf>
	<PmtInfId>RBS_${pfa.id}_${payments?size?c}</PmtInfId> <#-- Format = RBS_PFA.ID_TotalPaymentCount (In this EFT File) -->
	<PmtMtd>TRF</PmtMtd>
	<NbOfTxs>1</NbOfTxs> <#-- Number of transactions will always be 1. One Bill per Payment<PmtInf> -->
	<CtrlSum>${formatAmount(getAmount(payment),"dec")}</CtrlSum>
	<PmtTpInf>
		<SvcLvl>
		<#-- Non SEPA = NURG, Urgent = URGP -->
		<#if isWire == "true">
			<Cd>URGP</Cd>
		<#elseif isSEPA == "true">
			<Cd>SEPA</Cd>
		<#else>
			<Cd>NURG</Cd>
		</#if>
		</SvcLvl>
	</PmtTpInf>
	<ReqdExctnDt>${pfa.custrecord_2663_process_date?string("yyyy-MM-dd")}</ReqdExctnDt>
	<Dbtr>
		<Nm>${setMaxLength(convertToLatinCharSet(cbank.custrecord_2663_legal_name),70)}</Nm>
		<PstlAdr>
			<Ctry>${getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)}</Ctry>
		</PstlAdr>
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
	<#-- SEPA = SLEV, Non SEPA = SHAR -->
	<#if isSEPA == "true">
	<ChrgBr>SLEV</ChrgBr>
	</#if>
	<#if isWire == "true" || isACH == "true">
	<ChrgBr>SHAR</ChrgBr>
	</#if>
	<CdtTrfTxInf>
		<PmtId>
			<InstrId>GBT_${getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)}_${pfa.custrecord_2663_process_date?string("yyyyMMdd")}_ID${payment.tranid}</InstrId>
			<EndToEndId>GBT_${getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)}_${pfa.custrecord_2663_process_date?string("yyyyMMdd")}_ID${payment.tranid}</EndToEndId>
		</PmtId>
		<Amt>
			<InstdAmt Ccy="${getCurrencySymbol(payment.currency)}">${formatAmount(getAmount(payment),"dec")}</InstdAmt>
		</Amt>
		<CdtrAgt>
			<FinInstnId>
			<#--Check if entity has BIC/Swift Code-->
			<#if isSEPA == "true">
				<#if ebank.custrecord_2663_entity_bic?has_content>
					<BIC>${ebank.custrecord_2663_entity_bic}</BIC>
				</#if>
			<#--If no BIC/Swift Code, a routing number will be used (Most US Banks)-->	
			<#else>
				<#if isWire == "true">
					<Othr>
						<Id>${ebank.custrecord_2663_entity_bank_no}</Id>
					</Othr>
				</#if>
			</#if>
			</FinInstnId>
		</CdtrAgt>
		<Cdtr>
			<Nm>${setMaxLength(convertToLatinCharSet(buildEntityName(entity)),70)}</Nm>
		<PstlAdr>
			<Ctry>${getCountryCode(ebank.custrecord_2663_entity_country)}</Ctry>
		</PstlAdr>
		</Cdtr>
		<CdtrAcct>
		<#--Check if entity has IBAN number (European Banks)-->
		<#if isSEPA == "true" &&
		<#if ebank.custrecord_2663_entity_iban?has_content>
			<Id>
				<IBAN>${ebank.custrecord_2663_entity_iban}</IBAN>
			</Id>
		<#--Check if entity only has bank account number-->	
		<#else>
			<#if isWire == "true">
				<Id>
					<Othr>
						<Id>${ebank.custrecord_2663_entity_acct_no}</Id>
					</Othr>
				</Id>
			</#if>
		</#if>
		</CdtrAcct>
		<RmtInf>
		<#list paidTransactions as transaction>
			<#if transaction.tranid?has_content>
			<Ustrd>${cbank.custrecord_2663_legal_name}_${convertToLatinCharSet(buildEntityName(entity))}_${formatAmount(getAmount(payment),"dec")}${getCurrencySymbol(payment.currency)}_${transaction.tranid}</Ustrd>
			<#else>
			<Ustrd>${cbank.custrecord_2663_legal_name}_${convertToLatinCharSet(buildEntityName(entity))}_${formatAmount(getAmount(payment),"dec")}${getCurrencySymbol(payment.currency)}_${payment.transactionnumber}(Netsuite#)</Ustrd>
			</#if>
		</#list>
		</RmtInf>
	</CdtTrfTxInf>
</PmtInf>
</#list>

</CstmrCdtTrfInitn>
</Document><#rt>
#OUTPUT END#
