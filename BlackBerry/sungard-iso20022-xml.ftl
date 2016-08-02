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
			<#-- Payment Types That Use Swift Codes -->
				<#--<BIOCrBEI>${cbank.custrecord_2663_swift_code}</BIOCrBEI>-->
			<#-- Payment Types That Use BANK CODE (ABA/TRANSIT/BRANCH CODE) -->
			<#-- DM: Will need to add BICorBcd here -->
				<Othr>
					<Id>${cbank.custrecord_2663_bank_code}</Id>
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
	<#list paidTransactions as transaction><#-- Looping through each vendor bill in the bill payment record -->
<PmtInf>
	<PmtInfId>${cbank.custrecord_2663_file_name_prefix}${pfa.id}_${pfa.custrecord_2663_process_date?date?string("yyyyMMdd")}</PmtInfId> <#-- Format = RBS_PFA.ID_TotalPaymentCount (In this EFT File) -->
	<PmtMtd>TRF</PmtMtd>
	<NbOfTxs>1</NbOfTxs> <#-- Number of transactions will always be 1. One Bill per Payment<PmtInf> -->
	<CtrlSum>${formatAmount(getAmount(payment),"dec")}</CtrlSum>
	<PmtTpInf>
		<SvcLvl>
		<#-- Check if RBC Bank: RBC Requires Prtry tag -->
		<#if cbank.custrecord_2663_file_name_prefix?starts_with("RBC") == true>
			<Prtry>NORM</Prtry>
		<#else>
		<#-- Check Payment Type to assign code settings: Non SEPA = NURG, Urgent = URGP -->
			<#if transaction.custbody_bb_vb_prr_type == "DOMESTIC_WIRE" ||
				     transaction.custbody_bb_vb_prr_type == "DOMESTIC_WIRE_CANADA" ||
				     transaction.custbody_bb_vb_prr_type == "DOSMESTIC_WIRE_US" ||
				     transaction.custbody_bb_vb_prr_type == "FOREIGN_WIRE">-->
			<Cd>URGP</Cd>
			<#elseif transaction.custbody_bb_vb_prr_type == "SEPA">
				<Cd>SEPA</Cd>
			<#elseif transaction.custbody_bb_vb_prr_type == "ACH-CCD">
				<Cd>NURG</Cd>
			<#elseif transaction.custbody_bb_vb_prr_type == "ACH-CTX">
				<Cd>NURG</Cd>
				<LclInstrm>
		    		<Cd>CTX</Cd>
		        </LclInstrm>
		    <#else>
		        <Cd>NURG</Cd>
			</#if>
		</#if>
		</SvcLvl>
		<#-- DM: Forgot where I got this... -->
	<#-- 	<CtgyPurp>
            <Cd></Cd>
        </CtgyPurp> -->
	</PmtTpInf>
	<ReqdExctnDt>${pfa.custrecord_2663_process_date?string("yyyy-MM-dd")}</ReqdExctnDt>
	 <Dbtr>
        <Nm>${setMaxLength(convertToLatinCharSet(cbank.custrecord_2663_legal_name),70)}</Nm>
        <#-- DM: Added country field -->
        <#-- I don't think this should be Company Bank, I think it should be subsidiary address -->
        <PstlAdr>
            <PstCd>${cbank.custrecord_2663_subsidiary.zip}</PstCd>
            <CtrySubDvsn>${getStateCode(cbank.custrecord_2663_subsidiary.state)}</CtrySubDvsn>
           <#--  <Ctry>${getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)}</Ctry> -->
           <Ctry>${getCountryCode(cbank.custrecord_2663_subsidiary.country)}</Ctry>
        </PstlAdr>
        <#-- Tax ID for Argentina -->
        <#if transaction.custbody_bb_vb_ebd_tax_id?has_content>
            <Id>
                <OrgId>
                    <Othr>
                        <Id>${cbank.custrecord_2663_subsidiary.federalidnumber}</Id>
                        <SchmeNm>
                            <Cd>TXID</Cd>
                        </SchmeNm>
                    </Othr>
                </OrgId>
            </Id>
	    </#if>
        <#-- DM: <Id> and sub components are O? -->
    </Dbtr>
	<DbtrAcct>
		<Id>
		<#-- SEPA Payment Type uses IBAN (International Bank Account Number) -->
		<#if transaction.custbody_bb_vb_prr_type == "SEPA">
			<IBAN>${cbank.custpage_eft_custrecord_2663_iban}</IBAN>
		<#else>
			<Othr>
				<Id>${cbank.custpage_eft_custrecord_2663_acct_num}</Id>
			</Othr>
		</#if>
		</Id>
		<Ccy>${getCurrencySymbol(cbank.custrecord_2663_currency)}</Ccy>
	</DbtrAcct>
	<DbtrAgt>
		<FinInstnId>
			<BIC>${cbank.custpage_eft_custrecord_2663_bic}</BIC><#-- Needs Clarification -->
			<#-- DM: Added Country, listed as required field -->
            <PstlAdr>
                <Ctry>${getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)}</Ctry>
            </PstlAdr>
            <#-- DM: HSBC payments require clearing code if sent from ID, SA, UAE -->
           <#--  <#if (transaction.custbody_bb_vb_ebd_loc_clr_cd)?has_content> -->
                <ClrSysMmbId>
                    <MmbId>${transaction.custbody_bb_vb_ebd_loc_clr_cd}</MmbId>
                </ClrSysMmbId>
         <#--    </#if> -->
		</FinInstnId>
	</DbtrAgt>
	<#-- SEPA = SLEV, Non SEPA = SHAR
	<#if transaction.custbody_bb_vb_prr_type == "SEPA">
	<ChrgBr>SLEV</ChrgBr>
	</#if>
	<ChrgBr>SHAR</ChrgBr>-->
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
				<#if transaction.custbody_bb_vb_prr_type == "SEPA">
					<BIC>${transaction.custbody_bb_vb_ebd_swift_code}</BIC>
				<#else>
					<Othr>
						<Id>${transaction.custbody_bb_vb_ebd_bank_id}</Id>
					</Othr>
				</#if>
				<PstlAdr>
                 <#if transaction.custbody_bb_vb_ebd_stateprov?has_content>
                    <CtrySubDvsn>${getStateCode(transaction.custbody_bb_vb_ebd_stateprov)}</CtrySubDvsn>
                </#if>
                    <Ctry>${getCountryCode(transaction.custbody_bb_vb_ebd_acct_cnt)}</Ctry>
                </PstlAdr>
				
			</FinInstnId>
		</CdtrAgt>
		<Cdtr>
			<Nm>${setMaxLength(convertToLatinCharSet(buildEntityName(entity)),70)}</Nm>
			<PstlAdr>
				<Ctry>${getCountryCode(transaction.custbody_bb_vb_ebd_acct_cnt)}</Ctry>
			</PstlAdr>
		<#-- Tax ID for Chile -->
			<#if transaction.custbody_bb_vb_ebd_tax_id?has_content>
	            <Id>
	                <OrgId>
	                    <Othr>
	                        <Id>${transaction.custbody_bb_vb_ebd_tax_id}</Id>
	                        <SchmeNm>
	                            <Cd>TXID</Cd>
	                        </SchmeNm>
	                    </Othr>
	                </OrgId>
	            </Id>
	          </#if>
		 <#-- DM: HSBC Indonesia code -->
		 	<#if transaction.custbody_bb_vb_ebd_swift_code?starts_with("HSSEIDJ1")>
	            <CtryOfRes>ID</CtryOfRes>
	            <#-- For local payment currency -->
	            <#if getCurrencySymbol(payment.currency) == "IDR">
		            <Id>
		                <OrgId>
		                <#-- DON'T THINK THESE SHOULD BE HARDCODED IS ID EMPTY?? -->
		                    <Othr>
		                        <Id>${transaction.entity.billcountry}</Id>
		                        <Id>${transaction.entity.isperson}</Id>
		                        <#if transaction.entity.billcountry == "Indonesia">
		                        	<#if transaction.entity.isperson == "Company">
		                        		<Issr>/SKN/21</Issr>
		                        	<#else>
		                        		<Issr>/SKN/11</Issr>
		                        	</#if>
		                        <#else>
		                        	<#if transaction.entity.isperson == "Company">
		                        		<Issr>/SKN/22</Issr>
		                        	<#else>
		                        		<Issr>/SKN/12</Issr>
		                        	</#if>
		                        </#if>
		                    </Othr>
		                </OrgId>
		            </Id>
		        </#if>
	        </#if>
		</Cdtr>
		<CdtrAcct>
			<#--Check if entity has IBAN number (European Banks)-->
			<#if transaction.custbody_bb_vb_prr_type == "SEPA">
				<Id>
					<IBAN>${transaction.custbody_bb_vb_ebd_iban}</IBAN>
				</Id>
			<#else>
				<Id>
					<Othr>
						<Id>${transaction.custbody_bb_vb_ebd_bank_acct}</Id>
					</Othr>
				</Id>
			</#if>
		</CdtrAcct>

		<#-- DM: HSBC IDR Beneficiary code, status code, and purpose of transfer code here -->
		<#-- transaction.custbody_bb_vb_ebd_swift_code?starts_with("HSSEIDJ1") && 
		getCurrencySymbol(payment.currency) != "IDR" -->
		<#if true>
			<RgltryRptg>
			<#-- DON'T BELIEVE THESE SHOULD BE HARDCODED -->
	            <Dtls>
	            <#if transaction.entity.isperson == "Company">
            		<Tp>E0N</Tp>
		        <#else>
	                <Tp>E1N</Tp>
	            </#if>
	                <Cd></Cd>
	            </Dtls>
	        </RgltryRptg>
        </#if>
		<RmtInf>
			<Strd>
        		<RfrdDocInf>
					<Tp>
						<CdOrPrtry>
                    		<Cd>CINV</Cd>
                        </CdOrPrtry>
                    </Tp>
                    <#if getCurrencySymbol(payment.currency) == "JPY">
                    	<Nb>NNKNI</Nb>
                    <#else>
                		<Nb>SOLT02001038</Nb>
                	</#if>
                	<RltdDt>${transaction.trandate?string("yyyy-MM-dd")}</RltdDt>
                </RfrdDocInf>
                <RfrdDocAmt>
            		<DuePyblAmt Ccy="${getCurrencySymbol(payment.currency)}">${formatAmount(getAmount(payment),"dec")}</DuePyblAmt>
              		<DscntApldAmt Ccy="${getCurrencySymbol(payment.currency)}">${formatAmount(transaction.discountamount,"dec")}</DscntApldAmt>
             		<TaxAmt Ccy="${getCurrencySymbol(payment.currency)}">${formatAmount(transaction.taxtotal,"dec")}</TaxAmt>
              	</RfrdDocAmt>
         	</Strd>
		</RmtInf>
	</CdtTrfTxInf>
</PmtInf>
	</#list>
</#list>

</CstmrCdtTrfInitn>
</Document><#rt>
