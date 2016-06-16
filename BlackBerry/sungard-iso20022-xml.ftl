<#-- Author: Michael Wang | mwang@netsuite.com -->
<#-- Bank Format: iso 20022 xml | pain.001.001.03 -->
<#-- Banks: BoA, HSBC, RBC, Wells Fargo -->
<#-- cached values -->
<#assign totalAmount = computeTotalAmount(payments)>
<#-- template building -->
#OUTPUT START#
<?xml version="1.0" encoding="UTF-8"?>
<Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03">
<CstmrCdtTrfInitn>

<GrpHdr>
	<MsgId>${cbank.custrecord_2663_file_name_prefix}${pfa.id}_${pfa.custrecord_2663_process_date?date?string("yyyyMMdd")}</MsgId> <#--Max Length = 35;Format = -->
	<CreDtTm>${pfa.custrecord_2663_file_creation_timestamp?date?string("yyyy-MM-dd")}T${pfa.custrecord_2663_file_creation_timestamp?time?string("HH:mm:ss")}</CreDtTm>
	<NbOfTxs>${payments?size?c}</NbOfTxs>
	<CtrlSum>${formatAmount(totalAmount,"dec")}</CtrlSum>
	<InitgPty>
		<Id>
			<OrgId>
				<BIOCrBEI>${cbank.custrecord_2663_bic}</BIOCrBEI>
				
				<Othr>
					<Id>${cbank.custrecord_2663_bank_comp_id}</Id>
				</Othr>
			</OrgId>
		</Id>
	</InitgPty>
	<#--<Nm>${setMaxLength(convertToLatinCharSet(cbank.custrecord_2663_legal_name),70)}</Nm>-->
</GrpHdr>

<#-- Looping through each payments in the Payment File Administration -->
<#list payments as payment>
	<#assign paidTransactions = transHash[payment.internalid]>
	<#assign ebank = ebanks[payment_index]>
	<#assign entity = entities[payment_index]>
	<#list paidTransactions as transaction>

<PmtInf>
	<PmtInfId>${cbank.custrecord_2663_file_name_prefix}${pfa.id}_${pfa.custrecord_2663_process_date?date?string("yyyyMMdd")}</PmtInfId> <#-- Format = RBS_PFA.ID_TotalPaymentCount (In this EFT File) -->
	<PmtMtd>TRF</PmtMtd>
	<NbOfTxs>1</NbOfTxs> <#-- Number of transactions will always be 1. One Bill per Payment<PmtInf> -->
	<CtrlSum>${formatAmount(getAmount(payment),"dec")}</CtrlSum>
	<PmtTpInf>
		<SvcLvl>
		<#-- Non SEPA = NURG, Urgent = URGP -->
			<#if transaction.custbody__bb_vb_prr_type == 'DOMESTIC_WIRE' || 'DOMESTIC_WIRE_CANADA' || 'DOSMESTIC_WIRE_US' || 'FOREIGN_WIRE'>
			<Cd>URGP</Cd>
			</#if>
			<#if transaction.custbody__bb_vb_prr_type == 'SEPA'>
			<Cd>SEPA</Cd>
			</#if>
			<#if transaction.custbody__bb_vb_prr_type == 'ACH-CCD' || 'ACH-CTX'>
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
	<#if transaction.custbody__bb_vb_prr_type == 'SEPA'>
	<ChrgBr>SLEV</ChrgBr>
	</#if>
	<ChrgBr>SHAR</ChrgBr>
	<CdtTrfTxInf>
		<PmtId>
			<InstrId>${cbank.custrecord_2663_file_name_prefix}${payment.tranid}_${pfa.custrecord_2663_process_date?string("yyyyMMdd")}</InstrId>
			<EndToEndId>${cbank.custrecord_2663_file_name_prefix}${payment.tranid}_${pfa.custrecord_2663_process_date?string("yyyyMMdd")}</EndToEndId>
		</PmtId>
		<Amt>
			<InstdAmt Ccy="${getCurrencySymbol(payment.currency)}">${formatAmount(getAmount(payment),"dec")}</InstdAmt>
		</Amt>
		<CdtrAgt>
			<FinInstnId>
			<#--Check if entity has BIC/Swift Code-->
					<BIC>${ebank.custrecord_2663_entity_bic}</BIC>
			<#--If no BIC/Swift Code, a routing number will be used (Most US Banks)-->	
					<Othr>
						<Id>${ebank.custrecord_2663_entity_bank_no}</Id>
					</Othr>
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
			<Id>
				<IBAN>${ebank.custrecord_2663_entity_iban}</IBAN>
			</Id>
		<#--Check if entity only has bank account number-->	
				<Id>
					<Othr>
						<Id>${ebank.custrecord_2663_entity_acct_no}</Id>
					</Othr>
				</Id>
		</CdtrAcct>
		<RmtInf>
			<Ustrd>${cbank.custrecord_2663_legal_name}_${convertToLatinCharSet(buildEntityName(entity))}_${formatAmount(getAmount(payment),"dec")}${getCurrencySymbol(payment.currency)}_${transaction.tranid}</Ustrd>
		</RmtInf>
	</CdtTrfTxInf>
</PmtInf>
	</#list>
</#list>

</CstmrCdtTrfInitn>
</Document><#rt>
#OUTPUT END#
