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
<?xml version="1.0" encoding="UTF-8"?>
<#-- CMA Payment List -->
<#list payments as payment>
	<#assign paidTransactions = transHash[payment.internalid]>
	<#assign ebank = ebanks[payment_index]>
	<#assign entity = entities[payment_index]>
	<#assign payCurrency = getCurrencySymbol(payment.currency)>
	<#assign achEffectiveDate = pfa.custrecord_2663_process_date>
	<#list paidTransactions as transaction>		<#-- Looping through each vendor bill in the bill payment record -->

<#if transaction.custbody_2663_comerica_paymentmethod == "ACH Credit">
<CMA>
	<BankSvcRq>
		<RqUID>${pfa.custrecord_2663_file_creation_timestamp?date?string("yyyyMMdd")}-0000-0000-0000-0000${pfa.id}</RqUID>
		<XferAddRq>
			<RqUID>${pfa.custrecord_2663_file_creation_timestamp?date?string("yyyyMMdd")}-0000-0000-0000-0000${pfa.id}</RqUID>
			<PmtRefId>${payment.tranid?replace('/','-')}</PmtRefId>
			<CustId>
				<SPName>Comerica</SPName>		<#-- Set To Comerica -->
				<CustPermId>${cbank.custpage_eft_custrecord_2663_bank_comp_id}</CustPermId>
			</CustId>
			<XferInfo>

				<DepAcctIdFrom>
					<AcctId>${cbank.custpage_eft_custrecord_2663_acct_num}</AcctId>
					<AcctType>DDA</AcctType>		<#-- Set To DDA -->
					<Name>${convertCharSet(setMaxLength(cbank.custrecord_2663_legal_name,27))}</Name>		<#-- ACH Max lengths: PPD/CCD/TEL/WEB is 22 chars -->
					<BankInfo>
						<BankIdType>${cbank.custpage_eft_custrecord_2663_ach_bankidtype}</BankIdType>
						<BankId>${cbank.custpage_eft_custrecord_2663_bank_code}</BankId>
					</BankInfo>
				</DepAcctIdFrom>

				<DepAcctIdTo>
					<AcctId>${ebank.custrecord_2663_entity_acct_no}</AcctId>
					<AcctType>DDA</AcctType>
					<Name>${setMaxLength(convertCharSet(buildEntityName(entity)),27)}</Name><#-- ACH Max lengths: PPD/CCD/TEL/WEB is 22 chars -->
					<BankInfo>
						<BankIdType>ABA</BankIdType>		<#-- For US ACH and Wire, Set To ABA -->
						<BankId>${ebank.custrecord_2663_entity_bank_no}</BankId>
						<Name>${convertCharSet(ebank.custrecord_2663_entity_bank_name)}</Name>
					</BankInfo>
				</DepAcctIdTo>

				<CurAmt>
					<Amt>${formatAmount(getAmount(payment),"dec")}</Amt>
					<CurCode>${payCurrency}</CurCode>
				</CurAmt>

				<DueDt>${achEffectiveDate?string("yyyy-MM-dd")}</DueDt>
				<Category>ACH Credit</Category>

				<PmtInstruction>
					<PmtFormat>CCD</PmtFormat>		<#-- Set To CCD -->
					<CompanyEntryDescription>${convertCharSet(setMaxLength(cbank.custrecord_2663_legal_name,10))}</CompanyEntryDescription>		<#-- Set To First 10 Charaters of Modern Systems -->
					<TransactionCode>22</TransactionCode>		<#-- Set To 22 -->
					<Desc>${payment.tranid}</Desc>
				</PmtInstruction>

			</XferInfo>
		</XferAddRq>
	</BankSvcRq>
</CMA>

<#elseif transaction.custbody_2663_comerica_paymentmethod == "Wire">
<CMA>
	<BankSvcRq>
		<RqUID>${pfa.custrecord_2663_file_creation_timestamp?date?string("yyyyMMdd")}-0000-0000-0000-0000${pfa.id}</RqUID>
		<XferAddRq>
			<RqUID>${pfa.custrecord_2663_file_creation_timestamp?date?string("yyyyMMdd")}-0000-0000-0000-0000${pfa.id}</RqUID>
			<PmtRefId>${payment.tranid?replace('/','-')}</PmtRefId>
			<CustId>
				<SPName>Comerica</SPName>		<#-- Set To Comerica -->
				<CustPermId>${cbank.custpage_eft_custrecord_2663_bank_comp_id}</CustPermId>
			</CustId>
			<XferInfo>

				<DepAcctIdFrom>
					<AcctId>${cbank.custpage_eft_custrecord_2663_acct_num}</AcctId>
					<AcctType>DDA</AcctType>		<#-- Set To DDA -->
					<Name>${convertCharSet(setMaxLength(cbank.custrecord_2663_legal_name,27))}</Name>		<#-- ACH Max lengths: PPD/CCD/TEL/WEB is 22 chars -->
					<BankInfo>
						<BankIdType>${cbank.custpage_eft_custrecord_2663_ach_bankidtype}</BankIdType>
						<BankId>${cbank.custpage_eft_custrecord_2663_bank_code}</BankId>
					</BankInfo>
				</DepAcctIdFrom>

				<DepAcctIdTo>
					<AcctId>${ebank.custrecord_2663_entity_acct_no}</AcctId>
					<AcctType>DDA</AcctType>
					<Name>${setMaxLength(convertCharSet(buildEntityName(entity)),27)}</Name><#-- ACH Max lengths: PPD/CCD/TEL/WEB is 22 chars -->
					<BankInfo>
						<BankIdType>ABA</BankIdType>		<#-- For US ACH and Wire, Set To ABA -->
						<BankId>${ebank.custrecord_2663_entity_bank_no}</BankId>
						<Name>${convertCharSet(ebank.custrecord_2663_entity_bank_name)}</Name>
					</BankInfo>
				</DepAcctIdTo>

				<CurAmt>
					<Amt>${formatAmount(getAmount(payment),"dec")}</Amt>
					<CurCode>${payCurrency}</CurCode>
				</CurAmt>

				<DueDt>${achEffectiveDate?string("yyyy-MM-dd")}</DueDt>
				<Category>Fedwire</Category>
			</XferInfo>
		</XferAddRq>
	</BankSvcRq>
</CMA>

<#elseif transaction.custbody_2663_comerica_paymentmethod == "Card">
<CMA>
	<BankSvcRq>
		<RqUID>${pfa.custrecord_2663_file_creation_timestamp?date?string("yyyyMMdd")}-0000-0000-0000-0000${pfa.id}</RqUID>
		<XferAddRq>
			<RqUID>${pfa.custrecord_2663_file_creation_timestamp?date?string("yyyyMMdd")}-0000-0000-0000-0000${pfa.id}</RqUID>
			<PmtRefId>${payment.tranid?replace('/','-')}</PmtRefId>
			<CustId>
				<SPName>Comerica</SPName>
				<CustPermId>${cbank.custpage_eft_custrecord_2663_bank_comp_id}</CustPermId>
			</CustId>
			<XferInfo>

				<CardAcctId>
					<CorpNo>${cbank.custpage_eft_custrecord_2663_card_corpno}</CorpNo>
					<CompanyNo>${cbank.custpage_eft_custrecord_2663_card_compno}</CompanyNo>
					<VendorId>${setMaxLength(convertCharSet(buildEntityName(entity)),27)}</VendorId>
				</CardAcctId>

				<CurAmt>
					<Amt>${formatAmount(getAmount(payment),"dec")}</Amt>
					<CurCode>${payCurrency}</CurCode>
				</CurAmt>

				<DueDt>${achEffectiveDate?string("yyyy-MM-dd")}</DueDt>
				<Category>Card</Category>
				<CardInfo>
					<InvNumber>${payment.tranid}</InvNumber>
					<CardRefId>${payment.memo}</CardRefId>
				</CardInfo>

			</XferInfo>
		</XferAddRq>
	</BankSvcRq>
</CMA>

<#elseif transaction.custbody_2663_comerica_paymentmethod == "Check">
<CMA>
	<BankSvcRq>
		<RqUID>${pfa.custrecord_2663_file_creation_timestamp?date?string("yyyyMMdd")}-0000-0000-0000-0000${pfa.id}</RqUID>
		<XferAddRq>
			<RqUID>${pfa.custrecord_2663_file_creation_timestamp?date?string("yyyyMMdd")}-0000-0000-0000-0000${pfa.id}</RqUID>
			<PmtRefId>${payment.tranid?replace('/','-')}</PmtRefId>
			<Chknum></Chknum>	<#-- Left Blank for Comerica System to Fill Check Numbers -->
			<CustId>
				<SPName>Comerica</SPName>
				<CustPermId>${cbank.custpage_eft_custrecord_2663_bank_comp_id}</CustPermId>
			</CustId>
			<XferInfo>

				<DepAcctIdFrom>
					<AcctId>${cbank.custpage_eft_custrecord_2663_acct_num}</AcctId>
					<AcctType>DDA</AcctType>
					<Name>${convertCharSet(setMaxLength(cbank.custrecord_2663_legal_name,27))}</Name>
					<BankInfo>
						<BankIdType>${cbank.custpage_eft_custrecord_2663_check_bankidtype}</BankIdType>
						<BankId>${cbank.custpage_eft_custrecord_2663_bank_num}</BankId>
					</BankInfo>
				</DepAcctIdFrom>
				
				<CustPayeeInfo>
					<PayeeName1>${setMaxLength(convertCharSet(buildEntityName(entity)),27)}</PayeeName1>
					<PostAddr>
						<Addr1>${ebank.custrecord_2663_entity_address1}</Addr1>
						<City>${ebank.custrecord_2663_entity_city}</City>
						<StateProv>${ebank.custrecord_2663_entity_state}</StateProv>
						<PostalCode>${ebank.custrecord_2663_entity_zip}</PostalCode>
						<Country>${getCountryCode(ebank.custrecord_2663_entity_country)}</Country>
					</PostAddr>
				</CustPayeeInfo>

				<CurAmt>
					<Amt>${formatAmount(getAmount(payment),"dec")}</Amt>
					<CurCode>${payCurrency}</CurCode>
				</CurAmt>

				<DueDt>${achEffectiveDate?string("yyyy-MM-dd")}</DueDt>
				<Category>Check</Category>

				<MailInfo>
					<MailType>US</MailType>
				</MailInfo>
				<RemittanceInfo>${setPadding("INVOICE DATE","right"," ",20)} ${setPadding("INVOICE NUMBER","right"," ",20)} ${setPadding("NS TRANS NUMBER","right"," ",20)} ${setPadding("INVOICE AMT","left"," ",17)}${"\n"}${setPadding(payment.trandate?string("yyyy-MM-dd"),"right"," ",20)} ${setPadding(transaction.tranid,"right"," ",20)} ${setPadding(transaction.transactionnumber,"right"," ",20)} ${setPadding(formatAmount(getAmount(payment),"dec"),"left","0",17)}</RemittanceInfo>
			</XferInfo>
		</XferAddRq>
	</BankSvcRq>
</CMA>
<#else>
<#-- Error Message If No Payment Method -->
*** THIS TRANSACTION IS MISSING COMERICA PAYMENT METHOD ***
</#if>
	</#list>
</#list>
<BATCHTRAILER>${payments?size?c}</BATCHTRAILER><#rt>
#OUTPUT END#
