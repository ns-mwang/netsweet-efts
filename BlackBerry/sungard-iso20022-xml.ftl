<#-- Author: Michael Wang | mwang@netsuite.com -->
<#-- Bank Format: iso 20022 xml | pain.001.001.03 -->
<#-- Banks: BoA, HSBC, RBC, Wells Fargo -->
<#-- cached values -->

<#function convertCharSet text>
<#assign value = text>
<#assign value = value?replace('&','+')>
<#assign value = value?replace('*','.')>
<#assign value = value?replace('$','.')>
<#assign value = value?replace('%','.')>
<#assign value = convertToLatinCharSet(value)>
<#return value>
</#function>

<#assign totalAmount = computeTotalAmount(payments)>

<#-- template building -->
#OUTPUT START#
<?xml version="1.0" encoding="UTF-8"?>
<Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03">
<CstmrCdtTrfInitn>
<#escape x as x?xml>
<GrpHdr>
    <MsgId>${cbank.custrecord_2663_file_name_prefix?replace("_", "-")}${pfa.id}-${pfa.custrecord_2663_process_date?date?string("yyyyMMdd")}</MsgId> <#--Max Length = 35;Format = -->
    <CreDtTm>${pfa.custrecord_2663_file_creation_timestamp?date?string("yyyy-MM-dd")}T${pfa.custrecord_2663_file_creation_timestamp?time?string("HH:mm:ss")}</CreDtTm>
    <NbOfTxs>${payments?size?c}</NbOfTxs>
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
            <#if cbank.custrecord_2663_file_name_prefix?starts_with("RBC")>
            <Prtry>NORM</Prtry>
            <#elseif transaction.custbody_bb_vb_prr_type == "DOMESTIC WIRE" ||
                 transaction.custbody_bb_vb_prr_type == "DOMESTIC WIRE CANADA" ||
                 transaction.custbody_bb_vb_prr_type == "DOSMESTIC WIRE US" ||
                 transaction.custbody_bb_vb_prr_type == "FOREIGN WIRE">
            <Cd>URGP</Cd>
            <#elseif transaction.custbody_bb_vb_prr_type == "SEPA">
            <Cd>SEPA</Cd>
            <#elseif transaction.custbody_bb_vb_prr_type == "ACH-CCD">
            <Cd>NURG</Cd>
            <#elseif transaction.custbody_bb_vb_prr_type == "ACH-CTX">
            <Cd>NURG</Cd>
            <#else> <#-- Catch all Other Payment Types -->
            <Cd>NURG</Cd>
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
        <Nm>${setMaxLength(convertToLatinCharSet(cbank.custrecord_2663_legal_name),70)}</Nm>
        <#-- DM: Added country field -->
        <#-- I don't think this should be Company Bank, I think it should be subsidiary address -->
        <PstlAdr>
            <StrtNm>${cbank.custrecord_2663_subsidiary.address1}</StrtNm>
            <#if cbank.custrecord_2663_subsidiary.zip?has_content>
            <PstCd>${cbank.custrecord_2663_subsidiary.zip}</PstCd>
            </#if>
            <#if cbank.custrecord_2663_subsidiary.city?has_content>
            <TwnNm>${cbank.custrecord_2663_subsidiary.city}</TwnNm>
            </#if>
            <#if getStateCode(cbank.custrecord_2663_subsidiary.state)?has_content>
                <CtrySubDvsn>${getStateCode(cbank.custrecord_2663_subsidiary.state)}</CtrySubDvsn>
            </#if>
           <#--  <Ctry>${getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)}</Ctry> -->
           <Ctry>${getCountryCode(cbank.custrecord_2663_subsidiary.country)}</Ctry>
        </PstlAdr>

        <#-- VAT NUMBER NOT ON ROOT SUB RECORD -->

        <#-- <#if cbank.custrecord_2663_subsidiary.federalidnumber)?has_content>
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
        </#if> -->
        <#-- DM: <Id> and sub components are O? -->
        <#if cbank.custrecord_2663_file_name_prefix?starts_with("RBC")>
            <Id>
                <OrgId>
                    <Othr>
                        <Id>7350020000</Id>
                        <SchmeNm>
                            <Cd>BANK</Cd>
                        </SchmeNm>
                    </Othr>
                </OrgId>
            </Id>
        </#if>
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
            <#else>
                <Othr>
                    <Id>${cbank.custpage_eft_custrecord_2663_bank_code}</Id>
                </Othr>
            </#if>
            <#-- <ClrSysMmbId> Identifies the originating bank. Format CCTTT99999999999 -->
            <ClrSysMmbId>
                <#if cbank.custrecord_2663_file_name_prefix?starts_with("RBC")>
                <ClrSysId>
                	<Cd>CACPA</Cd>
                </ClrSysId>
                </#if>
                <MmbId>${cbank.custpage_eft_custrecord_2663_bank_code}</MmbId>
            </ClrSysMmbId>
            <Nm>${cbank.custpage_eft_custrecord_2663_bank_name}</Nm>
            <PstlAdr>
            	<#if cbank.custpage_eft_custrecord_2663_bank_zip?has_content>
                <PstCd>${cbank.custpage_eft_custrecord_2663_bank_zip}</PstCd>
            	</#if>
                
                <#if cbank.custpage_eft_custrecord_2663_bank_city?has_content>
                <TwnNm>${cbank.custpage_eft_custrecord_2663_bank_city}</TwnNm>
                </#if>
                <Ctry>${getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)}</Ctry>
                <#-- DM: Commenting this out because throws error when blank -->
                <#-- <AdrLine>${cbank.custpage_eft_custrecord_2663_address1}</AdrLine> -->
            </PstlAdr>
    </FinInstnId>
    </DbtrAgt>
    <CdtTrfTxInf>
        <PmtId>
            <#-- InstrId is O -->
            <InstrId>${cbank.custrecord_2663_file_name_prefix?replace("_","-")}${payment.tranid}-${pfa.custrecord_2663_process_date?string("yyyyMMdd")}</InstrId>
            <EndToEndId>${cbank.custrecord_2663_file_name_prefix?replace("_","-")}${payment.tranid}-${pfa.custrecord_2663_process_date?string("yyyyMMdd")}</EndToEndId>
        </PmtId>
        <#-- DM: PmTpInf listed as R, but is present at PaymentInformation, so not needed  -->
        <Amt>
            <InstdAmt Ccy="${getCurrencySymbol(payment.currency)}">${formatAmount(getAmount(payment),"dec")}</InstdAmt>
        </Amt>

        <CdtrAgt>
            <FinInstnId>
                <#if transaction.custbody_bb_vb_ebd_swift_code?has_content>
                    <BIC>${transaction.custbody_bb_vb_ebd_swift_code}</BIC>
                    <ClrSysMmbId>
                    <#if cbank.custrecord_2663_file_name_prefix?starts_with("RBC")>
                        <#if getCountryCode(transaction.custbody_bb_vb_ebd_acct_cnt) == "US">
                            <ClrSysId>
                                <Cd>USABA</Cd>
                            </ClrSysId>
                        <#elseif getCountryCode(transaction.custbody_bb_vb_ebd_acct_cnt) == "CA">
                            <ClrSysId>
                                <Cd>CACPA</Cd>
                            </ClrSysId>
                        </#if>
                    </#if>
                    <MmbId>${transaction.custbody_bb_vb_ebd_loc_clr_cd}</MmbId>
                </ClrSysMmbId>
                <#else>
                    <Othr>
                        <Id>${transaction.custbody_bb_vb_ebd_bank_id}</Id>
                    </Othr>
                </#if>
                
                <#-- <ClrSysMmbId> Identifies the originating bank. Format CCTTT99999999999 -->
                
                <Nm>${transaction.custbody_bb_vb_ebd_en_bk_det_ref}</Nm>
                <PstlAdr>
                    <#if transaction.custbody_bb_vb_ebd_zip_pc?has_content>
                    <PstCd>${transaction.custbody_bb_vb_ebd_zip_pc}</PstCd>
                    </#if>
                    <#if transaction.custbody_bb_vb_ebd_city?has_content>
                    <TwnNm>${transaction.custbody_bb_vb_ebd_city}</TwnNm>
                    </#if>
                    <Ctry>${getCountryCode(transaction.custbody_bb_vb_ebd_acct_cnt)}</Ctry>
                    <AdrLine>${transaction.custbody_bb_vb_ebd_address}</AdrLine>
                    <#if getStateCode(transaction.custbody_bb_vb_ebd_stateprov)?has_content>
                        <CtrySubDvsn>${getStateCode(transaction.custbody_bb_vb_ebd_stateprov)}</CtrySubDvsn>
                    </#if>
                </PstlAdr>
            </FinInstnId>
        </CdtrAgt>
        <Cdtr>
            <#-- DM: MISSING: Need either PrvtId OR orgID -->
            <Nm>${setMaxLength(convertToLatinCharSet(buildEntityName(entity)),70)}</Nm>
            <#-- DM: Postal Address Ctry listed as R, added -->
            <PstlAdr>
                <Ctry>${getCountryCode(entity.billcountry)}</Ctry>
                <#if getStateCode(entity.billstate)?has_content >
                    <CtrySubDvsn>${getStateCode(entity.billstate)}</CtrySubDvsn>
                </#if>
            </PstlAdr>
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
            <#if transaction.custbody_bb_vb_ebd_swift_code?starts_with("HSSEIDJ1")>
                <CtryOfRes>ID</CtryOfRes>
                <#-- For local payment currency -->
                <#if getCurrencySymbol(payment.currency) == "IDR">
                    <Id>
                        <OrgId>
                        <#-- DON'T THINK THESE SHOULD BE HARDCODED IS ID EMPTY?? -->
                            <Othr>
                                
                                <#if entity.billcountry == "Indonesia">
                                    <#if entity.isperson == "No">
                                        <Issr>/SKN/21</Issr>
                                    <#else>
                                        <Issr>/SKN/11</Issr>
                                    </#if>
                                <#else>
                                    <#if entity.isperson == "No">
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

        <#if ransaction.custbody_bb_vb_ebd_swift_code?starts_with("HSSEIDJ1") && getCurrencySymbol(payment.currency) != "IDR">
            <RgltryRptg>
            <#-- DON'T BELIEVE THESE SHOULD BE HARDCODED -->
                <Dtls>
                <#if entity.isperson == "No">
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
                <RfrdDocAmt>
                    <DuePyblAmt Ccy="${getCurrencySymbol(payment.currency)}">${formatAmount(getAmount(payment),"dec")}</DuePyblAmt>
                    <#if formatAmount(transaction.discountamount, "dec") gt 0>
                        <DscntApldAmt Ccy="${getCurrencySymbol(payment.currency)}">${formatAmount(transaction.discountamount,"dec")}</DscntApldAmt>
                    <#else>
                        <DscntApldAmt Ccy="${getCurrencySymbol(payment.currency)}">${formatAmount(0, "dec")}</DscntApldAmt>
                    </#if>
                    <TaxAmt Ccy="${getCurrencySymbol(payment.currency)}">${formatAmount(transaction.taxtotal?string?number, "dec")}</TaxAmt>
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
