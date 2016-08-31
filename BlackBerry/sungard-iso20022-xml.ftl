<#-- Author: Michael Wang | mwang@netsuite.com -->
<#-- Bank Format: iso 20022 xml | pain.001.001.03 -->
<#-- Banks: BoA, HSBC, RBC, Wells Fargo -->
<#-- cached values -->
<#-- <#ftl output_format="XML" auto_esc=true /> -->
<#assign clrcodeMap = {
                        "AT": "ATBLZ",
                        "AU": "AUBSB",
                        "CA": "CACPA",
                        "CH": "CHBCC",
                        "CN": "CNAPS",
                        "DE": "DEBLZ",
                        "ES": "ESNCC",
                        "GB": "GBDSC",
                        "GR": "GRBIC",
                        "HK": "HKNCC",
                        "IE": "IENCC",
                        "IN": "INFSC",
                        "IT": "ITNCC",
                        "JP": "JPZGN",
                        "NZ": "NZNCC",
                        "PL": "PLKNR",
                        "PT": "PTNCC",
                        "RU": "RUCBC",
                        "SE": "SESBA",
                        "SG": "SGIBG",
                        "TH": "THCBC",
                        "TW": "TWNCC",
                        "US": "USABA",
                        "ZA": "ZANCC"
                        }
>

<#function filterSpecialChars string>
    <#local specialChars = {
        "’": "&apos;",
        "–":"-"
    }
    >
    <#list specialChars?keys as char>
        <#local string = string?replace(char, specialChars[char])>
    </#list>
    <#return string>
</#function>

<#assign compBankCtry = getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)>
<#assign entBankCtry = getCountryCode(transaction.custbody_bb_vb_ebd_acct_cnt)>
<#-- This will change, need to map country External ISO Code, then figure out if it's concatenated (WF) or placed in <Cd> (All others) -->

<#function getDbtrMmbId>
    <#assign rtnum = cbank.custpage_eft_custrecord_2663_bank_code>
    <#assign abacode = cbank.custpage_eft_custrecord_bb_2663_us_aba>
    <#assign country = cbank.custpage_eft_custrecord_bb_2663_bank_country>
    
    <#if abacode?has_content && country == "US">
        <#return abacode>
    <#elseif rtnum?has_content>
        <#return rtnum>
    <#else>
        <#return "">
    </#if>
</#function>

<#function getCdtrMmbId>
    <#return transaction.custbody_bb_vb_ebd_loc_clr_cd>
</#function>

<#function getTranCount>
<#assign tranCount = 0>
    <#list payments as payment>
        <#assign tranCount = tranCount + transHash[payment.internalid]?size>
    </#list>
<#return tranCount>
</#function>
<#assign totalAmount = computeTotalAmount(payments)>

<#-- template building -->
#OUTPUT START#
<#escape x as x?xml>
<?xml version="1.0" encoding="UTF-8"?>
<Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03">
<CstmrCdtTrfInitn>

<GrpHdr>
    <MsgId>${cbank.custrecord_2663_file_name_prefix?replace("_", "-")}${pfa.id}-${pfa.custrecord_2663_process_date?date?string("yyyyMMdd")}</MsgId> <#--Max Length = 35;Format = -->
    <CreDtTm>${pfa.custrecord_2663_file_creation_timestamp?date?string("yyyy-MM-dd")}T${pfa.custrecord_2663_file_creation_timestamp?time?string("HH:mm:ss")}</CreDtTm>
    <#-- transHash[payment.internalid]?size -->
    
    <NbOfTxs>${getTranCount()}</NbOfTxs>
    <CtrlSum>${formatAmount(totalAmount,"dec")}</CtrlSum>
    <InitgPty>
        <Id>
            <OrgId>
                <#-- Payment Types That Use BICOrBEI -->
            <#if cbank.custrecord_2663_file_name_prefix?starts_with("RBC") || cbank.custrecord_2663_file_name_prefix?starts_with("WF")>
                <BICOrBEI>${cbank.custpage_eft_custrecord_2663_bank_num}</BICOrBEI>
                <#-- Payment Types That Use BANK Othr/Id -->
            <#elseif cbank.custrecord_2663_file_name_prefix?starts_with("BOFA") || cbank.custrecord_2663_file_name_prefix?starts_with("HSBC")>
                <Othr>
                    <Id>${cbank.custpage_eft_custrecord_2663_bank_num}</Id>
                </Othr>
                <#else>
                <Othr>
                    <Id>${cbank.custpage_eft_custrecord_2663_bank_num}</Id>
                </Othr>
                </#if>
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
    <PmtInfId>${cbank.custrecord_2663_file_name_prefix?replace("_","-")}${pfa.id}-${pfa.custrecord_2663_process_date?date?string("yyyyMMdd")}</PmtInfId> <#-- Format = RBS_PFA.ID_TotalPaymentCount (In this EFT File) -->
    <PmtMtd>TRF</PmtMtd>
    <NbOfTxs>1</NbOfTxs>
    <#-- Number of transactions will always be 1. One Bill per Payment<PmtInf> -->
    <PmtTpInf>
        <SvcLvl>
            <#if transaction.custbody_bb_vb_prr_type == "DOMESTIC WIRE" ||
                 transaction.custbody_bb_vb_prr_type == "DOMESTIC WIRE CANADA" ||
                 transaction.custbody_bb_vb_prr_type == "DOSMESTIC WIRE US" ||
                 transaction.custbody_bb_vb_prr_type == "FOREIGN WIRE" ||
                 transaction.custbody_bb_vb_prr_type == "INTERNATIONAL WIRE">
                <#if cbank.custrecord_2663_file_name_prefix?starts_with("RBC")>
                <Prtry>URGP</Prtry>
                <#else>
                <Cd>URGP</Cd>
                </#if>
            <#elseif transaction.custbody_bb_vb_prr_type == "SEPA">
                <#if cbank.custrecord_2663_file_name_prefix?starts_with("RBC")>
                <Prtry>SEPA</Prtry>
                <#else>
                <Cd>SEPA</Cd>
                </#if>
            <#elseif transaction.custbody_bb_vb_prr_type == "ACH-CCD">
                <#if cbank.custrecord_2663_file_name_prefix?starts_with("RBC")>
                <Prtry>NORM</Prtry>
                <#else>
                <Cd>NURG</Cd>
                </#if>
            <#elseif transaction.custbody_bb_vb_prr_type == "ACH-CTX">
                <#if cbank.custrecord_2663_file_name_prefix?starts_with("RBC")>
                <Prtry>NORM</Prtry>
                <#else>
                <Cd>NURG</Cd>
                </#if>
            <#else> <#-- Catch all Other Payment Types -->
                <#if cbank.custrecord_2663_file_name_prefix?starts_with("RBC")>
                <Prtry>NORM</Prtry>
                <#else>
                <Cd>NURG</Cd>
                </#if>
            </#if>
        </SvcLvl>
        <#if transaction.custbody_bb_vb_prr_type == "ACH-CTX">
        <LclInstrm>
            <Cd>CTX</Cd>
        </LclInstrm>
        <#elseif transaction.custbody_bb_vb_prr_type == "ACH-CCD">
        <LclInstrm>
            <Cd>CCD</Cd>
        </LclInstrm>
        </#if>
        <CtgyPurp>
            <Cd>SUPP</Cd>
        </CtgyPurp>
    </PmtTpInf>
    <ReqdExctnDt>${pfa.custrecord_2663_process_date?string("yyyy-MM-dd")}</ReqdExctnDt>
    <Dbtr>
        <Nm>${filterSpecialChars(setMaxLength(convertToLatinCharSet(cbank.custrecord_2663_legal_name)?xml,70))}</Nm>
        <#-- DM: Added country field -->
        <#-- I don't think this should be Company Bank, I think it should be subsidiary address -->
        <#if cbank.custrecord_2663_subsidiary.country?has_content>
        <PstlAdr>
            <#if cbank.custrecord_2663_subsidiary.zip?has_content>
            <PstCd>${cbank.custrecord_2663_subsidiary.zip}</PstCd>
            </#if>
            <#if cbank.custrecord_2663_subsidiary.city?has_content>
            <TwnNm>${convertToLatinCharSet(cbank.custrecord_2663_subsidiary.city)}</TwnNm>
            </#if>
            <#if getStateCode(cbank.custrecord_2663_subsidiary.state)?has_content>
                <CtrySubDvsn>${getStateCode(cbank.custrecord_2663_subsidiary.state)}</CtrySubDvsn>
            <#elseif cbank.custrecord_2663_subsidiary.state?has_content>
                <CtrySubDvsn>${(cbank.custrecord_2663_subsidiary.state)}</CtrySubDvsn>
            </#if>

           <#--  <Ctry>${getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)}</Ctry> -->
           <Ctry>${getCountryCode(cbank.custrecord_2663_subsidiary.country)}</Ctry>
           <#if cbank.custrecord_2663_subsidiary.address1?has_content>
           <AdrLine>${filterSpecialChars(setMaxLength((convertToLatinCharSet(cbank.custrecord_2663_subsidiary.address1) + " " + convertToLatinCharSet(cbank.custrecord_2663_subsidiary.address2)), 70)?trim)}</AdrLine>
           </#if>
        </PstlAdr>
        </#if>

        <#if cbank.custpage_eft_custrecord_2663_bank_comp_id?has_content>
            <Id>
                <OrgId>
                    <Othr>
                        <Id>${cbank.custpage_eft_custrecord_2663_bank_comp_id}</Id>
                        <#if !cbank.custrecord_2663_file_name_prefix?starts_with("HSBC")>
                        <SchmeNm>
                            <#if cbank.custrecord_2663_file_name_prefix?starts_with("RBC")>
                                <Prtry>BANK</Prtry>
                            <#elseif cbank.custrecord_2663_file_name_prefix?starts_with("BOFA") && getCountryCode(cbank.custrecord_2663_subsidiary.country) == "BR">
                                <Prtry>CONVENIO</Prtry>
                            <#elseif cbank.custrecord_2663_file_name_prefix?starts_with("BOFA")>
                                <Prtry>CHID</Prtry>
                            <#elseif cbank.custrecord_2663_file_name_prefix?starts_with("WF")>
                                <Prtry>ACH</Prtry>
                            </#if>
                        </SchmeNm>
                        </#if>
                    </Othr>
                </OrgId>
            </Id>
        </#if>

        <#-- VAT NUMBER NOT ON ROOT SUB RECORD -->

        <#if cbank.custrecord_2663_subsidiary.taxidnum?has_content && getCountryCode(cbank.custrecord_2663_subsidiary.country) == "AR">
            <Id>
                <OrgId>
                    <Othr>
                        <Id>${cbank.custrecord_2663_subsidiary.taxidnum}</Id>
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
         <#if cbank.custrecord_2663_file_name_prefix?starts_with("WF")>
        <Tp>
            <Cd>CACC</Cd>
        </Tp>
        </#if>
        <Ccy>${getCurrencySymbol(cbank.custrecord_2663_currency)}</Ccy>
    </DbtrAcct>
    <#-- DM: Looks like this requires Mmbid, PstlAdr (country), BrnchId?, id,   -->
    <DbtrAgt>
        <FinInstnId>
            <#if cbank.custpage_eft_custrecord_2663_bic?has_content>
                <BIC>${cbank.custpage_eft_custrecord_2663_bic}</BIC>
            </#if>
            <#-- <ClrSysMmbId> Identifies the originating bank. Format CCTTT99999999999 -->

             <#if getDbtrMmbId()?has_content && !cbank.custpage_eft_custrecord_2663_iban?has_content>
            <ClrSysMmbId>
                <#if cbank.custrecord_2663_file_name_prefix?starts_with("WF") && (clrcodeMap[getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)])??>
                <MmbId>${clrcodeMap[getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)] + getDbtrMmbId()}</MmbId>
                <#elseif (clrcodeMap[getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)])??>
                <ClrSysId>
                    <Cd>${(clrcodeMap[getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)])}</Cd>
                </ClrSysId>
                <MmbId>${getDbtrMmbId()}</MmbId>
                <#else>
                <MmbId>${getDbtrMmbId()}</MmbId>
                </#if>
            </ClrSysMmbId>
            </#if>
            <Nm>${cbank.custpage_eft_custrecord_2663_bank_name}</Nm>
            <#if cbank.custpage_eft_custrecord_2663_bank_country?has_content>
            <PstlAdr>
                <#if cbank.custpage_eft_custrecord_2663_bank_zip?has_content>
                <PstCd>${cbank.custpage_eft_custrecord_2663_bank_zip}</PstCd>
                </#if>
                <#if cbank.custpage_eft_custrecord_2663_bank_city?has_content>
                <TwnNm>${convertToLatinCharSet(cbank.custpage_eft_custrecord_2663_bank_city)}</TwnNm>
                <#if getStateCode(cbank.custpage_eft_custrecord_2663_bank_state)?has_content>
                <CtrySubDvsn>${getStateCode(cbank.custpage_eft_custrecord_2663_bank_state)}</CtrySubDvsn>
                <#elseif cbank.custpage_eft_custrecord_2663_bank_state?has_content>
                <CtrySubDvsn>${cbank.custpage_eft_custrecord_2663_bank_state}</CtrySubDvsn>
                </#if>
                </#if>
                <Ctry>${getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)}</Ctry>
                <#if cbank.custpage_eft_ccustrecord_2663_bank_address1?has_content>
           <AdrLine>${filterSpecialChars(setMaxLength(convertToLatinCharSet(cbank.custpage_eft_ccustrecord_2663_bank_address1), 70))}</AdrLine>
           </#if>
            </PstlAdr>
            </#if>
            <#if !cbank.custpage_eft_custrecord_2663_bic?has_content>
                <Othr>
                    <Id>${cbank.custpage_eft_custrecord_2663_bank_code}</Id>
                </Othr>
            </#if>
            
        </FinInstnId>
        <#if cbank.custpage_eft_custrecord_2663_branch_num?has_content>
                 <BrnchId>
                        <Id>${cbank.custpage_eft_custrecord_2663_branch_num}</Id>
                    <PstlAdr>
                        <Ctry>${getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)}</Ctry>
                    </PstlAdr>
                </BrnchId>
            </#if>
        
    </DbtrAgt>
    <CdtTrfTxInf>
        <PmtId>
            <#-- InstrId is O -->
            <#-- <InstrId>${cbank.custrecord_2663_file_name_prefix?replace("_","")}${payment.tranid?replace(r"0+", "", 'r')?replace("/", "")}${pfa.custrecord_2663_process_date?string("yyyyMMdd")}</InstrId>
            <EndToEndId>${cbank.custrecord_2663_file_name_prefix?replace("_","")}${payment.tranid?replace(r"0+", "", 'r')?replace("/", "")}${pfa.custrecord_2663_process_date?string("yyyyMMdd")}</EndToEndId> -->
            <InstrId>${setMaxLength(transaction.internalid  + entity.internalid + payment.internalid, 15)}</InstrId>
            <EndToEndId>${setMaxLength(entity.internalid + transaction.internalid + payment.internalid, 15)}</EndToEndId>
        </PmtId>
        <#-- DM: PmTpInf listed as R, but is present at PaymentInformation, so not needed  -->
        <Amt>
            <InstdAmt Ccy="${getCurrencySymbol(payment.currency)}">${formatAmount(transaction.fxamount,"dec")}</InstdAmt>
        </Amt>

        <CdtrAgt>
            <FinInstnId>
                <#if transaction.custbody_bb_vb_ebd_swift_code?has_content>
                    <BIC>${transaction.custbody_bb_vb_ebd_swift_code}</BIC>
                    <#if transaction.custbody_bb_vb_ebd_loc_clr_cd?has_content && !transaction.custbody_bb_vb_ebd_iban?has_content>
                    <ClrSysMmbId>
                    <#if cbank.custrecord_2663_file_name_prefix?starts_with("WF") && clrcodeMap[getCountryCode(transaction.custbody_bb_vb_ebd_acct_cnt)]??>
                        <MmbId>${clrcodeMap[getCountryCode(transaction.custbody_bb_vb_ebd_acct_cnt)] + transaction.custbody_bb_vb_ebd_loc_clr_cd}</MmbId>
                    <#elseif clrcodeMap[getCountryCode(transaction.custbody_bb_vb_ebd_acct_cnt)]??>
                    <ClrSysId>
                        <Cd>${clrcodeMap[getCountryCode(transaction.custbody_bb_vb_ebd_acct_cnt)]}</Cd>
                    </ClrSysId>
                    <MmbId>${transaction.custbody_bb_vb_ebd_loc_clr_cd}</MmbId>
                    <#else>
                    <MmbId>${transaction.custbody_bb_vb_ebd_loc_clr_cd}</MmbId>
                    </#if>
                </ClrSysMmbId>
                    </#if>
                </#if>
                
                <#-- <ClrSysMmbId> Identifies the originating bank. Format CCTTT99999999999 -->
                <#if transaction.custbody_bb_vb_ebd_bank_name?has_content>
                <Nm>${transaction.custbody_bb_vb_ebd_bank_name}</Nm>
                <#else>
                <Nm>${transaction.custbody_bb_vb_ebd_en_bk_det_ref}</Nm>
                </#if>
                <#if transaction.custbody_bb_vb_ebd_acct_cnt?has_content>
                <PstlAdr>
                    <#if transaction.custbody_bb_vb_ebd_zip_pc?has_content>
                    <PstCd>${transaction.custbody_bb_vb_ebd_zip_pc}</PstCd>
                    </#if>
                    <#if transaction.custbody_bb_vb_ebd_city?has_content>
                    <TwnNm>${convertToLatinCharSet(transaction.custbody_bb_vb_ebd_city)}</TwnNm>
                    </#if>
                    <#if getStateCode(transaction.custbody_bb_vb_ebd_stateprov)?has_content>
                    <CtrySubDvsn>${getStateCode(transaction.custbody_bb_vb_ebd_stateprov)}</CtrySubDvsn>
                    <#elseif (transaction.custbody_bb_vb_ebd_stateprov)?has_content>
                    <CtrySubDvsn>${(transaction.custbody_bb_vb_ebd_stateprov)}</CtrySubDvsn>
                    </#if>
                    <Ctry>${getCountryCode(transaction.custbody_bb_vb_ebd_acct_cnt)}</Ctry>
                     <#if transaction.custbody_bb_vb_ebd_address?has_content>
                     <#-- May need to add NewLine here -->
                    <AdrLine>${filterSpecialChars(setMaxLength((convertToLatinCharSet(transaction.custbody_bb_vb_ebd_address) + " " + convertToLatinCharSet(transaction.custbody_bb_vb_ebd_address2)), 70)?trim)}</AdrLine>
                    </#if>
                </PstlAdr>
                </#if>
                <#if !transaction.custbody_bb_vb_ebd_swift_code?has_content>
                    <Othr>
                        <Id>${transaction.custbody_bb_vb_ebd_bank_id}</Id>
                    </Othr>
                </#if>
            </FinInstnId>
        </CdtrAgt>
        <Cdtr>
            <Nm>${filterSpecialChars(setMaxLength(convertToLatinCharSet(buildEntityName(entity)),70))}</Nm>
            <#-- DM: Postal Address Ctry listed as R, added -->
            <#if entity.billcountry?has_content>
            <PstlAdr>
            <#if entity.billzipcode?has_content>
            <PstCd>${entity.billzipcode}</PstCd>
            </#if>
            <#if entity.billcity?has_content>
            <TwnNm>${convertToLatinCharSet(entity.billcity)}</TwnNm>
            </#if>
            <#if getStateCode(entity.billstate)?has_content>
                <CtrySubDvsn>${getStateCode(entity.billstate)}</CtrySubDvsn>
            <#elseif (entity.billstate)?has_content>
                <CtrySubDvsn>${(entity.billstate)}</CtrySubDvsn>
            </#if>
           <#--  <Ctry>${getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)}</Ctry> -->
            <Ctry>${getCountryCode(entity.billcountry)}</Ctry>
            <#if entity.billaddress1?has_content>
            <AdrLine>${filterSpecialChars(setMaxLength(convertToLatinCharSet(entity.billaddress1) + " " + convertToLatinCharSet(entity.billaddress2), 70)?trim)}</AdrLine>
            </#if>
            </PstlAdr>
            </#if>
            <#if transaction.custbody_bb_vb_ebd_tax_id?has_content>
            <Id>
                <OrgId>
                    <Othr>
                        <Id>${transaction.custbody_bb_vb_ebd_tax_id}</Id>
                        <SchmeNm>
                            <#if getCountryCode(entity.billcountry) == "BR">
                            <Cd>EMBARGO</Cd>
                            <#else>
                            <Cd>TXID</Cd>
                            </#if>
                        </SchmeNm>
                    </Othr>
                </OrgId>
            </Id>
            </#if>
            <#if cbank.custrecord_2663_file_name_prefix?starts_with("HSBC") && getCountryCode(transaction.custbody_bb_vb_ebd_acct_cnt) == "ID">
             <#if getCurrencySymbol(payment.currency) == "IDR">
                    <Id>
                        <OrgId>
                            <Othr>
                                <Id>012</Id>
                            <#if entity.isperson?string == "No">
                                <#if entity.billcountry?string == "Indonesia">
                                    <Issr>/SKN/21</Issr>
                                <#else>
                                    <Issr>/SKN/22</Issr>
                                </#if>
                            <#else>
                                <#if entity.billcountry?string == "Indonesia">
                                    <Issr>/SKN/11</Issr>
                                <#else>
                                    <Issr>/SKN/12</Issr>
                                </#if>
                            </#if>
                            </Othr>
                        </OrgId>
                    </Id>
                </#if>
                <CtryOfRes>ID</CtryOfRes>
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

        <#if cbank.custrecord_2663_file_name_prefix?starts_with("WF")>
        <Purp>
            <Prtry>DEP</Prtry>
        </Purp>
        </#if>

        <#if cbank.custrecord_2663_file_name_prefix?starts_with("HSBC") && getCurrencySymbol(payment.currency) != "IDR"  && getCountryCode(transaction.custbody_bb_vb_ebd_acct_cnt) == "ID">
            <RgltryRptg>
            <#-- DON'T BELIEVE THESE SHOULD BE HARDCODED -->
                <Dtls>
                <#if entity.isperson?string == "No">
                    <Tp>E0N</Tp>
                <#else>
                    <Tp>E1N</Tp>
                </#if>
                    <Cd>012</Cd>
                </Dtls>
            </RgltryRptg>
        </#if>
        <RmtInf>
            <Strd>
                <RfrdDocInf>
                    <Tp>
                        <CdOrPrtry>
                            <Cd>CINV</Cd> <#-- DM: Should this be hard coded? MW: I believe this is a static setting for the bank -->
                        </CdOrPrtry>
                    </Tp>
                    <#if getCurrencySymbol(payment.currency) == "JPY">
                        <Nb>NNKNI</Nb>
                    <#else>
                        <Nb>SOLT02001038</Nb>
                    </#if>
                    <RltdDt>${transaction.trandate?string("yyyy-MM-dd")}</RltdDt>
                </RfrdDocInf>
                <#assign tmptxamt = formatAmount(transaction.taxtotal, "dec")?number / transaction.exchangerate>
                <RfrdDocAmt>
                    <DuePyblAmt Ccy="${getCurrencySymbol(payment.currency)}">${formatAmount(transaction.fxamount ,"dec")}</DuePyblAmt>
                    <DscntApldAmt Ccy="${getCurrencySymbol(payment.currency)}">${formatAmount(transaction.discountamount?string?number/transaction.exchangerate,"dec")}</DscntApldAmt>
                    <TaxAmt Ccy="${getCurrencySymbol(payment.currency)}">${formatAmount(tmptxamt, "dec")!"0"}</TaxAmt>
                </RfrdDocAmt>
            </Strd>
        </RmtInf>
    </CdtTrfTxInf>
</PmtInf>
    </#list>
</#list>
</CstmrCdtTrfInitn>
</Document><#rt>
</#escape>
#OUTPUT END#
