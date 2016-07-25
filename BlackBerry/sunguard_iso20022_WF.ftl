<#-- Author: Michael Wang | mwang@netsuite.com -->
<#-- Bank Format: iso 20022 xml | pain.001.001.03 -->
<#-- Banks: BoA, HSBC, RBC, Wells Fargo -->
<#-- This Template Version: Wells Fargo -->
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
            <#if cbank.custpage_eft_custrecord_2663_bank_num?has_content>
            <#-- Bank Comp ID (BICOrBEI) -->
                <BIOCrBEI>${cbank.custpage_eft_custrecord_2663_bank_num}</BIOCrBEI>
            <#else>
            <#-- Bank Comp ID (Other) -->
                <Othr>
                    <Id>${cbank.custpage_eft_custrecord_bb_2663_bank_comp_id}</Id>
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
    <PmtInfId>${cbank.custrecord_2663_file_name_prefix}${pfa.id}_${pfa.custrecord_2663_process_date?date?string("yyyyMMdd")}</PmtInfId> <#-- Format = RBS_PFA.ID_TotalPaymentCount (In this EFT File) -->
    <PmtMtd>TRF</PmtMtd>
    <NbOfTxs>1</NbOfTxs> <#-- Number of transactions will always be 1. One Bill per Payment<PmtInf> -->
    <PmtTpInf>
        <SvcLvl>
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
        </SvcLvl>
    </PmtTpInf>
    <ReqdExctnDt>${pfa.custrecord_2663_process_date?string("yyyy-MM-dd")}</ReqdExctnDt>
    <Dbtr>
        <Nm>${setMaxLength(convertToLatinCharSet(
        <PstlAdr>
            <PstCd>${cbank.custrecord_2663_subsidiary.zip}</PstCd>
            <CtrySubDvsn>${getStateCode(cbank.custrecord_2663_subsidiary.state)}</CtrySubDvsn>
           <#--  <Ctry>${getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)}</Ctry> -->
           <Ctry>${getCountryCode(cbank.custrecord_2663_subsidiary.country)}</Ctry>
        </PstlAdr>
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
            <#if cbank.custpage_eft_custrecord_2663_bic?has_content>
                <BIC>${cbank.custpage_eft_custrecord_2663_bic}</BIC>
            <#else>
                <Othr>
                    <Id>${cbank.custpage_eft_custrecord_2663_bank_code}</Id>
                </Othr>
            </#if>
            <#-- <ClrSysMmbId> Identifies the originating bank. Format CCTTT99999999999 where:
                • CC is the two-letter country code.
                • TTT is the bank type. Currently, Wells Fargo accepts only
                the following bank types:
                ABA American Banking Association routing number CPA Canadian Payments Association routing number PID CHIPS universal participant identification
                • 999 is the bank ID for the originating account. This will almost always be a Wells Fargo routing/transit number, such as 121000248 or 091000019.
                If BIC is sent, it takes precedence over MmbId as the originating bank ID and MmbId will be mapped as the branch identification code.
                Common name: Originating Bank ID
                Common name: Originating Bank ID Type Common name: Originating Bank Country Code -->
                <#--<ClrSysMmbId>
                    <MmbId>USABA121140399</MmbId>
                </ClrSysMmbId>-->
            <PstlAdr>
                <Ctry></Ctry>
                <Nm>${cbank.custpage_eft_custrecord_2663_bank_name}</Nm>
                <PstCd>${cbank.custpage_eft_custrecord_2663_bank_zip}</PstCd>
                <TwnNm>${cbank.custpage_eft_custrecord_2663_bank_city}</TwnNm>
                <Ctry>${getCountryCode(cbank.custpage_eft_custrecord_2663_bank_country)}</Ctry>
                <AdrLine>${cbank.custpage_eft_custrecord_2663_address1}</AdrLine>
            </PstlAdr>
        </FinInstnId>
    </DbtrAgt>
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
                <#-- <ClrSysMmbId> Identifies the originating bank. Format CCTTT99999999999 where:
                • CC is the two-letter country code.
                • TTT is the bank type. Currently, Wells Fargo accepts only
                the following bank types:
                ABA American Banking Association routing number CPA Canadian Payments Association routing number PID CHIPS universal participant identification
                • 999 is the bank ID for the originating account. This will almost always be a Wells Fargo routing/transit number, such as 121000248 or 091000019.
                If BIC is sent, it takes precedence over MmbId as the originating bank ID and MmbId will be mapped as the branch identification code.
                Common name: Originating Bank ID
                Common name: Originating Bank ID Type Common name: Originating Bank Country Code -->
                <#--<ClrSysMmbId>
                    <MmbId>USABA121140399</MmbId>
                </ClrSysMmbId>-->
                <#--<Nm>Bank Name TBD</Nm>-->
                <PstlAdr>
                    <PstCd>${transaction.custbody_bb_vb_ebd_zip_pc}</PstCd>
                    <TwnNm>${transaction.custbody_bb_vb_ebd_city}</TwnNm>
                    <Ctry>${getCountryCode(transaction.custbody_bb_vb_ebd_acct_cnt)}</Ctry>
                    <AdrLine>${transaction.custbody_bb_vb_ebd_address}</AdrLine>
                </PstlAdr>
            </FinInstnId>
        </CdtrAgt>
        <Cdtr>
            <Nm>${setMaxLength(convertToLatinCharSet(buildEntityName(entity)),70)}</Nm>
            <PstlAdr>
                <Ctry>${getCountryCode(transaction.custbody_bb_vb_ebd_acct_cnt)}</Ctry>
            </PstlAdr>
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
        <RmtInf>
            <Strd>
                <RfrdDocInf>
                    <Tp>
                        <CdOrPrtry>
                            <Cd>CINV</Cd>
                        </CdOrPrtry>
                    </Tp>
                    <Nb>SOLT02001038</Nb>
                    <RltdDt>${transaction.trandate?string("yyyy-MM-dd")}</RltdDt>
                </RfrdDocInf>
                <RfrdDocAmt>
                    <DuePyblAmt Ccy="${getCurrencySymbol(payment.currency)}">${formatAmount(getAmount(payment),"dec")}</DuePyblAmt>
                    <DscntApldAmt Ccy="${getCurrencySymbol(payment.currency)}">${formatAmount(transaction.discountamount,"dec")}</DscntApldAmt>
                    <TaxAmt Ccy="${getCurrencySymbol(payment.currency)}">${formatAmount(transaction.taxtotal,"dec")}</TaxAmt>
                </RfrdDocAmt>
                <#--
                <RfrdDocAmt>
                    <DuePyblAmt Ccy="USD">7870</DuePyblAmt>
                    <DscntApldAmt Ccy="USD">0</DscntApldAmt>
                    <TaxAmt Ccy="USD">0</TaxAmt>
                </RfrdDocAmt>
                -->
            </Strd>
        </RmtInf>
    </CdtTrfTxInf>
</PmtInf>
    </#list>
</#list>

</CstmrCdtTrfInitn>
</Document><#rt>
#OUTPUT END#
