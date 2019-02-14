<#-- Author: Kristian Latinak | klatinak@netsuite.com -->
<#-- Bank Format: iso 20022 xml | pain.001.001.03 -->
<#-- Banks: BoA -->

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

<#function convertSpecialCharSet text>
    <#assign value = text>
    <#assign value = value?replace('&amp;','+')>
	<#assign value = value?replace('&quot;','.')>
	<#assign value = value?replace('&apos','.')>
	<#assign value = value?replace('&lt','.')>
	<#assign value = value?replace('&gt','.')>
    <#assign value = value?replace('*','.')>
    <#assign value = value?replace('$','.')>
    <#assign value = value?replace('%','.')>
    <#assign value = convertToLatinCharSet(value)>
    <#return value>
</#function>

<#function removeSlash text>
    <#assign value = text>
    <#assign value = value?replace('/','S')>
    <#assign value = convertToLatinCharSet(value)>
    <#return value>
</#function>

<#assign countryCode = getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)>
<#assign currSymbol = cbank.custrecord_2663_currency>


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
		<NbOfTxs>${setMaxLength(payments?size?c,15)}</NbOfTxs>
		<CtrlSum>${formatAmount(totalAmount,"dec")}</CtrlSum>
		<InitgPty>
			<Nm>${setMaxLength(convertSpecialCharSet(cbank.custrecord_2663_legal_name),70)}</Nm>
			<Id>
				<OrgId>
				<#-- Payment Types That Use Swift Codes -->
					<#--<BIOCrBEI>${cbank.custpage_eft_custrecord_2663_swift_code}</BIOCrBEI>-->
				<#-- Payment Types That Use BANK CODE (ABA/TRANSIT/BRANCH CODE) -->
					<Othr>					
						<Id>${cbank.custpage_eft_custrecord_2663_issuer_num}</Id>					
					</Othr>
				</OrgId>
			</Id>
		</InitgPty>
	</GrpHdr>
	<PmtInf>
		<PmtInfId>${cbank.custrecord_2663_file_name_prefix}${pfa.id}_${pfa.custrecord_2663_process_date?date?string("yyyyMMdd")}</PmtInfId>
		<#-- Format = RBS_PFA.ID_TotalPaymentCount (In this EFT File) -->
		<PmtMtd>TRF</PmtMtd>
		<#if currSymbol == "EUR" || countryCode == "AU">
		<#assign btchBooking = pfa.custrecord_2663_aggregate>
		<BtchBookg>${btchBooking?then('true', 'false')}</BtchBookg>
		</#if>
		<NbOfTxs>${setMaxLength(payments?size?c,15)}</NbOfTxs>
		<CtrlSum>${formatAmount(totalAmount,"dec")}</CtrlSum>		
		<#if countryCode == "GB">
		<PmtTpInf>
			<#if currSymbol == "EUR">
			<InstrPrty>NORM</InstrPrty>
			</#if>
			<SvcLvl>
				<#-- Check if RBC Bank: RBC Requires Prtry tag -->
				<#if cbank.custrecord_2663_file_name_prefix?starts_with("RBC") == true>
				<Prtry>NORM</Prtry>
				<#else>
				<#-- Check Payment Type to assign code settings: Non SEPA = NURG, Urgent = URGP -->
				<#if currSymbol == "EUR">
				<Cd>SEPA</Cd>
				<#else>
				<Cd>NURG</Cd>
				</#if>
				</#if>
			</SvcLvl>
		</PmtTpInf>
		<#elseif countryCode == "CA">
		<PmtTpInf>
			<SvcLvl>
				<#-- Check if RBC Bank: RBC Requires Prtry tag -->
				<#if cbank.custrecord_2663_file_name_prefix?starts_with("RBC") == true>
				<Prtry>NORM</Prtry>
				<#else>
				<#-- Check Payment Type to assign code settings: Non SEPA = NURG, Urgent = URGP -->
				<Cd>NURG</Cd>
				</#if>
			</SvcLvl>
		</PmtTpInf>
		</#if>				
		<ReqdExctnDt>${pfa.custrecord_2663_process_date?string("yyyy-MM-dd")}</ReqdExctnDt>
		<Dbtr>
			<Nm>${setMaxLength(convertSpecialCharSet(cbank.custrecord_2663_legal_name),70)}</Nm>
			<PstlAdr>
				<#if cbank.custpage_eft_custrecord_2663_bank_address1?has_content>
				<StrtNm>${cbank.custpage_eft_custrecord_2663_bank_address1}</StrtNm>
				</#if>
				<PstCd>${setMaxLength(cbank.custpage_eft_custrecord_2663_bank_zip,16)}</PstCd>
				<TwnNm>${setMaxLength(cbank.custpage_eft_custrecord_2663_bank_city,35)}</TwnNm>
				<Ctry>${getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)}</Ctry>
			</PstlAdr>
		</Dbtr>		
		<DbtrAcct>
			<Id>
				<#-- SEPA Payment Type uses IBAN (International Bank Account Number) -->
				<Othr>
					<#if currSymbol == "EUR">
					<Id>${cbank.custpage_eft_custrecord_2663_iban}</Id>
					<#else>
					<Id>${cbank.custpage_eft_custrecord_2663_acct_num}</Id>
					</#if>
				</Othr>
			</Id>
			<Ccy>${getCurrencySymbol(cbank.custrecord_2663_currency)}</Ccy>
		</DbtrAcct>		
		<DbtrAgt>	
			<FinInstnId>
				<BIC>${cbank.custpage_eft_custrecord_2663_bic}</BIC>
				<#if countryCode == "AU" || currSymbol == "GBP">		
				<ClrSysMmbId>
					<MmbId>${cbank.custpage_eft_custrecord_2663_bank_code}</MmbId>
				</ClrSysMmbId>
				</#if>
				<Nm>BANK OF AMERICA</Nm>
				<PstlAdr>
					<Ctry>${countryCode}</Ctry>
				</PstlAdr>
			</FinInstnId>
			<BrnchId>
				<Id>${cbank.custpage_eft_custrecord_2663_branch_num}</Id>
			</BrnchId>
		</DbtrAgt>	
	<#-- SEPA = SLEV, Non SEPA = SHAR -->
		<#if currSymbol == "EUR">
			<ChrgBr>SLEV</ChrgBr>
		<#else>
			<ChrgBr>DEBT</ChrgBr>
		</#if>
		<#list payments as payment>
		<#assign ebank = ebanks[payment_index]>
		<#assign entity = entities[payment_index]>
		<#assign currSymbolE = getCurrencySymbol(payment.currency)>
		<CdtTrfTxInf>
			<PmtId>
			<#if countryCode == "CA">
				<InstrId>${removeSlash(payment.tranid)}AND${pfa.custrecord_2663_process_date?string("yyyyMMdd")}</InstrId>
				<EndToEndId>${removeSlash(payment.tranid)}AND${pfa.custrecord_2663_process_date?string("yyyyMMdd")}</EndToEndId>
			</#if>
			<#if countryCode == "AU">
				<InstrId>${payment.tranid}_${pfa.custrecord_2663_process_date?string("MMdd")}</InstrId>
				<EndToEndId>${payment.tranid}_${pfa.custrecord_2663_process_date?string("MMdd")}</EndToEndId>
			</#if>
			<#if countryCode == "GB">
				<InstrId>${cbank.custrecord_2663_file_name_prefix}${payment.tranid}_${pfa.custrecord_2663_process_date?string("yyyyMMdd")}</InstrId>
				<EndToEndId>${cbank.custrecord_2663_file_name_prefix}${payment.tranid}_${pfa.custrecord_2663_process_date?string("yyyyMMdd")}</EndToEndId>
			</#if>
			</PmtId>
			<#if countryCode == "AU">
			<PmtTpInf>
				<SvcLvl>
					<Cd>URGP</Cd>
				</SvcLvl>
			</PmtTpInf>
			</#if>
			<Amt>
				<InstdAmt Ccy="${getCurrencySymbol(payment.currency)}">${formatAmount(getAmount(payment),"dec")}</InstdAmt>
			</Amt>			
			<CdtrAgt>
				<FinInstnId>
					<#assign countryCodeE = getCountryCode(ebank.custrecord_2663_entity_country)>
					<#if countryCode == "CA">
					<ClrSysMmbId>
						<ClrSysId>
							<Cd>CACPA</Cd>
						</ClrSysId>
						<#--<MmbId>${ebank.custrecord_2663_entity_bank_no}</MmbId>
						<MmbId>0${ebank.custrecord_2663_entity_bank_code}${ebank.custrecord_2663_entity_transit_code}</MmbId>
					</ClrSysMmbId>
					<#if countryCode == "GB">
					<Nm>${convertSpecialCharSet(ebank.custrecord_2663_entity_bank_name)}</Nm>
					</#if>
					<#if countryCode == "AU">
					<Nm>${convertSpecialCharSet(ebank.custrecord_2663_entity_bank_name)}</Nm>
					</#if>
					<PstlAdr>
						<Ctry>CA</Ctry>
					</PstlAdr>
					</#if>
					<#if countryCodeE == "AU">
					<ClrSysMmbId>
						<ClrSysId>
							<Cd>AUBSB</Cd>
						</ClrSysId>
						<MmbId>${ebank.custrecord_2663_entity_bank_no}</MmbId>
					</ClrSysMmbId>
					<Nm>${convertSpecialCharSet(ebank.custrecord_2663_entity_bank_name)}</Nm>
					<PstlAdr>
						<Ctry>AU</Ctry>
					</PstlAdr>
					</#if>
					<#if countryCodeE == "GB">					
					<#if currSymbolE == "EUR">
					<BIC>${ebank.custrecord_2663_entity_bic}</BIC>					
					<#else>
					<ClrSysMmbId>
						<ClrSysId>
							<Cd>GBDSC</Cd>
						</ClrSysId>
						<MmbId>${ebank.custrecord_2663_entity_bank_no}</MmbId>
					</ClrSysMmbId>
					</#if>
					<Nm>${convertSpecialCharSet(ebank.custrecord_2663_entity_bank_name)}</Nm>
					<PstlAdr>
						<Ctry>GB</Ctry>
					</PstlAdr>
					</#if>										
				</FinInstnId>
			</CdtrAgt>			
			<Cdtr>
				<#if countryCode == "AU">
				<Nm>${setMaxLength(convertSpecialCharSet(buildEntityName(entity)),70)}</Nm>	
				<#else>
				<Nm>${setMaxLength(convertSpecialCharSet(buildEntityName(entity)),30)}</Nm>	
				</#if>
				<#if countryCode == "CA" || countryCode == "AU">
				<PstlAdr>
					<#if entity.billaddress1?has_content><StrtNm>${entity.billaddress1}</StrtNm></#if>
					<#if entity.billzipcode?has_content><PstCd>${entity.billzipcode}</PstCd></#if>
					<#if entity.billcity?has_content><TwnNm>${entity.billcity}</TwnNm></#if>
					<#if entity.billcountry?has_content><Ctry>${getCountryCode(entity.billcountry)}</Ctry></#if>			
				</PstlAdr>				
				<#else>				
				<PstlAdr>
				<#assign checkAdd = buildEntityBillingAddress(entity)>
				<#--<#if checkAdd?has_content><StrtNm>${buildEntityBillingAddress(entity)}</StrtNm></#if>-->
				<#--<#assign checkZip = buildEntityBillingZip(entity)>-->
				<#--<#if checkZip?has_content><PstCd>${buildEntityBillingZip(entity)}</PstCd></#if>-->
				<#assign checkCity = buildEntityBillingCity(entity)>
				<#--<#if checkCity?has_content><TwnNm>${entity.billcity}</TwnNm></#if>-->
				<Ctry>${getCountryCode(entity.billcountry)}</Ctry>
				</PstlAdr>
				</#if>
			</Cdtr>
			<CdtrAcct>
				<Id>
					<#if currSymbolE == "EUR">							
					<IBAN>${ebank.custrecord_2663_entity_iban}</IBAN>	
					<#else>
					<Othr>							
						<Id>${ebank.custrecord_2663_entity_acct_no}</Id>					
					</Othr>
					</#if>
				</Id>
			</CdtrAcct>
				<#if countryCode != "CA">
				<RmtInf>
					<Ustrd>${setMaxLength(convertSpecialCharSet(getReferenceNote(payment)),140)}</Ustrd>
				</RmtInf>
				</#if>
		</CdtTrfTxInf>
	</#list>
	</PmtInf>
	</CstmrCdtTrfInitn>
</Document>
<#rt>
#OUTPUT END#
