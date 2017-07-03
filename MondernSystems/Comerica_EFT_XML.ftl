<#-- Author: Michael Wang | mwang@netsuite.com -->
<#-- Bank Format: Comerica XML -->
<#-- Banks: Comerica Bank -->
<#-- cached values -->
<#assign totalAmount = computeTotalAmount(payments)>

<#function convertCharSet text>
<#assign value = text>
<#assign value = value?replace("&", "&amp;")>
<#assign value = value?replace('>', "&gt;")>
<#assign value = value?replace('<', "&lt;")>
<#assign value = value?replace("'", "&apos;")>
<#assign value = value?replace('"', '&quot;')>
<#assign value = convertToLatinCharSet(value)>
<#return value>
</#function>

<#-- template building -->
#OUTPUT START#
<BATCHHEADER>BATCH${pfa.id}</BATCHHEADER>
<#-- CMA Payment List -->
<#list payments as payment>
	<#assign paidTransactions = transHash[payment.internalid]>
	<#assign ebank = ebanks[payment_index]>
	<#assign entity = entities[payment_index]>
	<#assign payCurrency = getCurrencySymbol(payment.currency)>
	<#assign achEffectiveDate = pfa.custrecord_2663_process_date>
<?xml version="1.0" encoding="UTF-8"?>
<CMA>
	<BankSvcRq>
		<RqUID>${pfa.custrecord_2663_file_creation_timestamp?date?string("yyyyMMdd")}-0000-0000-0000-0000${pfa.id}</RqUID>
		<XferAddRq>
			<RqUID>${pfa.custrecord_2663_file_creation_timestamp?date?string("yyyyMMdd")}-0000-0000-0000-0000${pfa.id}</RqUID>
			<PmtRefId>${payment.tranid?replace('/','-')}</PmtRefId>
			<CustId>
				<SPName>Comerica</SPName>		<#-- Set To Comerica -->
				<CustPermId>MOSY_CNG</CustPermId>		<#-- Set To MOSY_CNG For Modern Systems -->
			</CustId>
			<XferInfo>
				<DepAcctIdFrom>
					<AcctId>${cbank.custpage_eft_custrecord_2663_acct_num}</AcctId>
					<AcctType>DDA</AcctType>		<#-- Set To DDA -->
					<Name>${convertCharSet(setMaxLength(cbank.custrecord_2663_legal_name,27))}</Name>		<#-- ACH Max lengths: PPD/CCD/TEL/WEB is 22 chars -->
					<BankInfo>
						<BankIdType>BIC</BankIdType>		<#-- Set To BIC -->
						<BankId>MNBDUS33</BankId>		<#-- Set To MNBDUS33 -->
					</BankInfo>
				</DepAcctIdFrom>
				<DepAcctIdTo>
					<AcctId>${ebank.custrecord_2663_entity_acct_no}</AcctId>
					<AcctType>DDA</AcctType>
					<Name>${setMaxLength(convertCharSet(buildEntityName(entity)),27)}</Name>		<#-- ACH Max lengths: PPD/CCD/TEL/WEB is 22 chars -->
					<BankInfo>
					<#if payment.custbody_eft_payment_method == "ACH">
						<BankIdType>ABA</BankIdType>		<#-- For US ACH and Wire, Set To ABA -->
					<#elseif payment.custbody_eft_payment_method == "Wire" && ebank.custrecord_2663_entity_country == "United States">
						<BankIdType>ABA</BankIdType>
					<#elseif payment.custbody_eft_payment_method == "Wire" && ebank.custrecord_2663_entity_country != "United States">
						<BankIdType>BIC</BankIdType>		<#-- For International Wire, Set To BIC -->
					<#else>
						<BankIdType>ABA</BankIdType>		<#-- Default to ABA If No Payment Method -->
					</#if>
						<BankId>${ebank.custrecord_2663_entity_bank_no}</BankId>
						<Name>${convertCharSet(ebank.custrecord_2663_entity_bank_name)}</Name>
					<#-- Canadian Wire Payments Requirement -->
					<#if payment.custbody_eft_payment_method == "Wire" && ebank.custrecord_2663_entity_country == "Canada">
						<PostAddr>
						<#if ebank.custrecord_2663_entity_address1?has_content>
							<Addr1>${ebank.custrecord_2663_entity_address1}</Addr1>
							<City>${ebank.custrecord_2663_entity_city}</City>
							<StateProv>${ebank.custrecord_2663_entity_state}</StateProv>
							<PostalCode>${ebank.custrecord_2663_entity_zip}</PostalCode>
							<Country>CAN</Country>
						<#else>
							<Addr1>${ebank.custrecord_2663_entity_bank_code}</Addr1>
							<Country>CAN</Country>
						</#if>
						</PostAddr>
					</#if>
					</BankInfo>
				</DepAcctIdTo>
					<CurAmt>
						<Amt>${formatAmount(getAmount(payment),"dec")}</Amt>
						<CurCode>${payCurrency}</CurCode>
					</CurAmt>
				<#if payment.custbody_eft_payment_method == "Wire" && ebank.custrecord_2663_entity_country != "United States">
					<SendDt>${pfa.custrecord_2663_file_creation_timestamp?string("yyyy-MM-dd")}</SendDt>		<#-- Required for International Wire. Date funds deducted from originating Comerica account. Usually 2 days before the effective date, depends on the currency -->
					<DueDt>${pfa.custrecord_2663_process_date?string("yyyy-MM-dd")}</DueDt>
				<#else>
					<DueDt>${achEffectiveDate?string("yyyy-MM-dd")}</DueDt>
				</#if>
					
				<#if payment.custbody_eft_payment_method == "ACH">
					<Category>ACH Credit</Category>		<#-- For ACH, Set To ACH Credit -->
				<#elseif payment.custbody_eft_payment_method == "Wire" && ebank.custrecord_2663_entity_country == "United States">
					<Category>Fedwire</Category>		<#-- For US Wire, Set To Fedwire -->
				<#elseif payment.custbody_eft_payment_method == "Wire" && ebank.custrecord_2663_entity_country != "United States">
					<Category>International</Category>		<#-- For International Wire, Set To International -->
				<#else>
					<Category>ACH Credit</Category>		<#-- Default to ACH Credit If No Payment Method -->
				</#if>
				<#if payment.custbody_eft_payment_method == "ACH">
					<PmtInstruction>
						<PmtFormat>CCD</PmtFormat>		<#-- Set To CCD -->
						<CompanyEntryDescription>ModernSyst</CompanyEntryDescription>		<#-- Set To First 10 Charaters of Modern Systems -->
						<TransactionCode>22</TransactionCode>		<#-- Set To 22 -->
						<Desc>${payment.transactionnumber}</Desc>
					</PmtInstruction>
				</#if>
			</XferInfo>
		</XferAddRq>
	</BankSvcRq>
</CMA>
</#list>
<BATCHTRAILER>${payments?size?c}</BATCHTRAILER><#rt>
#OUTPUT END#
