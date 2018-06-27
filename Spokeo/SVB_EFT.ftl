<#--Author: Michael Wang | mwang@netsuite.com-->
<#--SVB ACH CCD/PPD-->

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

    <#function computeTotalRecords recordCount>
        <#assign value = ((recordCount + 4) / 10) >
        <#assign value = value?ceiling >    
        <#return value>
    </#function>

<#-- Divide Payments, Entities, and Entity Banks into two groups (CCD, PPD) -->
    <#assign ccdPaymentsStr = "">
    <#assign ccdEbanksStr = "">
    <#assign ccdEntitiesStr = "">
    <#assign ppdPaymentsStr = "">
    <#assign ppdEbanksStr = "">
    <#assign ppdEntitiesStr = "">    
    <#-- avoid sequence concatenation, use sequence strings instead -->
    <#list payments as payment>
        <#assign ebank = ebanks[payment_index]>    
        <#assign entity = entities[payment_index]>
        <#if payment.custbody_si_payment_method == "ACH-CCD">
            <#assign ccdPaymentsStr = ccdPaymentsStr + "payments[" + payment_index?c?string + "],">
            <#assign ccdEbanksStr = ccdEbanksStr + "ebanks[" + payment_index?c?string + "],">
            <#assign ccdEntitiesStr = ccdEntitiesStr + "entities[" + payment_index?c?string + "],">
        </#if>
        <#if payment.custbody_si_payment_method == "ACH-PPD">
            <#assign ppdPaymentsStr = ppdPaymentsStr + "payments[" + payment_index?c?string + "],">
            <#assign ppdEbanksStr = ppdEbanksStr + "ebanks[" + payment_index?c?string + "],">
            <#assign ppdEntitiesStr = ppdEntitiesStr + "entities[" + payment_index?c?string + "],">
        </#if>    
    </#list>
    <#-- convert from strings to sequences -->
    <#assign ccdPayments = ("[" + removeEnding(ccdPaymentsStr, ",") + "]")?eval>
    <#assign ccdEbanks = ("[" + removeEnding(ccdEbanksStr, ",") + "]")?eval>
    <#assign ccdEntities = ("[" + removeEnding(ccdEntitiesStr, ",") + "]")?eval>
    <#assign ppdPayments = ("[" + removeEnding(ppdPaymentsStr, ",") + "]")?eval>
    <#assign ppdEbanks = ("[" + removeEnding(ppdEbanksStr, ",") + "]")?eval>
    <#assign ppdEntities = ("[" + removeEnding(ppdEntitiesStr, ",") + "]")?eval>
<#-- END: Divide Payments, Entities, and Entity Banks into two groups (CCD, PPD) -->

<#-- cached values -->
<#assign totalAmount = formatAmount(computeTotalAmount(payments))>

<#-- template building -->
#OUTPUT START#
<#--- Filed Header Record (1) --->
<#--P01-->1<#rt><#--Record Type Code (1)-->
<#--P02-->01<#rt><#--Priority Code-->
<#--P03--> ${cbank.custpage_eft_custrecord_2663_bank_num}<#rt><#--Immediate Destination-->
<#--P04-->${cbank.custpage_eft_custrecord_2663_bank_comp_id}<#rt><#--Imedediate Origin/Company Identification (Assigned by SVB)-->
<#--P05-->${pfa.custrecord_2663_file_creation_timestamp?string("yyMMdd")}<#rt><#--File Creation Date (yyMMdd)-->
<#--P06-->${pfa.custrecord_2663_file_creation_timestamp?string("HHmm")}<#rt><#--File Creation Time (HHmm)-->
<#--P07-->A<#rt><#--File ID Modifier-->
<#--P08-->094<#rt><#--Record Size-->
<#--P09-->10<#rt><#--Blocking Factor-->
<#--P10-->1<#rt><#--Format Code-->
<#--P11-->${setLength(custpage_eft_custrecord_2663_bank_name,23)}<#rt><#--Immediate Destination Name-->
<#--P12-->${setLength(cbank.custrecord_2663_print_company_name,23)}<#rt><#--Immediate Origin Name (Company Name Long)-->
<#--P13-->${setLength(" ",8)}<#rt><#--Reference Code - Leave Blank-->
${"\r\n"}<#--Line Break--><#rt>
<#if (ccdPayments?size > 0) && (ppdPayments?size == 0)>
<#assign entryHash = 0>
<#assign entryHashCCD = 0>
<#assign entryHashPPD = 0>
<#--- CCD Batch Header Record (5) --->
<#--P01-->5<#rt><#--Record Type Code (5)-->
<#--P02-->220<#rt><#--Service Class Code-->
<#--P03-->${setLength(cbank.custrecord_2663_legal_name,16)}<#rt><#--Your Company Name (Short)-->
<#--P04-->${setLength(" ",20)}<#rt><#--Company Discretionary Data - Leave Blank (20)-->
<#--P05-->${setLength(cbank.custpage_eft_custrecord_2663_bank_comp_id,10)}<#--ACH Company Identification. Assigned by SVB-->
<#--P06-->CCD<#rt><#--Standard Entry Class Code-->
<#--P07-->${setLength("Vendor Pay",10)}<#rt><#--Company Entry Description-->
<#--P08-->${pfa.custrecord_2663_process_date?string("yyMMdd")}<#rt><#--Company Descriptive Date (Show's on receiving bank statement)-->
<#--P09-->${pfa.custrecord_2663_process_date?string("yyMMdd")}<#rt><#--Effective Entry Date (Show's on receiving bank statement)-->
<#--P10-->   <#rt><#--(3) Settlement Date (Left blank, SVB to fill in automatically-->
<#--P11-->1<#rt><#--Originator Status Code = 1-->
<#--P12-->${cbank.custpage_eft_custrecord_2663_bank_num?string?substring(0, 8)}<#rt><#--Originating Financial Institution, SVB Routing Number-->
<#--P13-->${setPadding(pfa.id,"left","0",7)}<#rt><#--Batch Number-->
${"\r\n"}<#--Line Break--><#rt>
<#--- CCD Entry Detail Record (6) --->
<#assign totalPayments = 0>
<#assign recordCount = 0>
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
    <#assign payAmount = formatAmount(getAmount(payment))>
    <#assign totalPayments = totalPayments + 1>
    <#assign recordCount = recordCount + 2>
    <#assign traceNumber = cbank.custpage_eft_custrecord_2663_bank_num?string?substring(0, 8) + setPadding(recordCount,"left","0",7)?string>
    <#assign paidTransactions = transHash[payment.internalid]>
    <#--Entry Hash Calculation sum-->
    <#assign entryHashCCD = entryHashCCD + ebank.custrecord_2663_entity_bank_no?string?substring(0, 8)?number>
    <#--Entry Hash Calculation End-->
<#--P01-->6<#rt><#--Record Type Code (6)-->
<#--P02-->22<#rt><#--Transaction Code (27: Automated Deposit)-->
<#--P03-->${ebank.custrecord_2663_entity_bank_no?string?substring(0, 8)}<#rt><#--Receiving DFI ID (Routing Number)-->
<#--P04-->${ebank.custrecord_2663_entity_bank_no?string?substring(8)}<#rt><#--Check Digit the 9th digit of routing number <substring(8)>-->
<#--P05-->${setPadding(ebank.custrecord_2663_entity_acct_no,"right"," ",17)}<#rt><#--Bank Account Number-->
<#--P06-->${setPadding(payAmount,"left","0",10)}<#rt><#--Dollar Amount-->
<#--P07-->${setPadding(payment.transactionnumber,"right"," ",15)}<#rt><#--Individual Identification Number-->
<#--P08-->${setPadding(buildEntityName(entity),"right"," ",22)}<#rt><#--Individual Name-->
<#--P09-->  <#rt><#--Discretionary Data-->
<#--P10-->1<#rt><#--Addenda Record Indicatior (0:No 1:Yes)-->
<#--P11-->${traceNumber}<#rt><#--Trace Number-->
${"\r\n"}<#--Line Break--><#rt>
<#--- Addenda Detail Record (7) --->
705${setLength("RefNo:" + getReferenceNote(payment),80)}0001${setPadding(batchLineNum,"left","0",7)}<#rt>
${"\r\n"}<#--Line Break--><#rt>
</#list>
<#--Entry Hash Calculation sum-->
<#--- CCD Batch Control Record (8) --->
<#--P01-->8<#rt><#--Record Type Code (8)-->
<#--P02-->220<#rt><#--Service Class Code-->
<#--P03-->${setPadding(recordCount,"left","0",6)}<#rt><#--Entry/Addenda Count-->
<#--P04-->${setPadding(entryHashCCD,"left","0",10)}<#rt><#--Entry Hash-->
<#--P05-->000000000000<#rt><#--Total Debit Entry Dollar Amount-->
<#--P06-->${setPadding(totalAmount,"left","0",12)}<#rt><#--Total Credit Entry Dollar Amount-->
<#--P07-->${cbank.custpage_eft_custrecord_2663_bank_comp_id}<#rt><#--Company Identification-->
<#--P08-->${setLength(" ",19)}<#rt><#--Message Authentication Code Leave Blank (19)-->
<#--P09-->${setLength(" ",6)}<#rt><#--Reserved Leave Blank (6)-->
<#--P10-->${cbank.custpage_eft_custrecord_2663_bank_num?string?substring(0, 8)}<#rt><#--Originating Financial Institution, Chase Routing Number 8 digits without check digit-->
<#--P11-->${setPadding(pfa.id,"left","0",7)}<#rt><#--Batch Number-->
${"\r\n"}<#--Line Break--><#rt>
<#elseif (ccdPayments?size == 0) && (ppdPayments?size > 0) >
<#assign entryHash = 0>
<#assign entryHashCCD = 0>
<#assign entryHashPPD = 0>
<#--- PPD Batch Header Record (5) --->
<#--P01-->5<#rt><#--Record Type Code (5)-->
<#--P02-->220<#rt><#--Service Class Code-->
<#--P03-->${setLength(cbank.custrecord_2663_legal_name,16)}<#rt><#--Your Company Name (Short)-->
<#--P04-->${setLength(" ",20)}<#rt><#--Company Discretionary Data - Leave Blank (20)-->
<#--P05-->${setLength(cbank.custpage_eft_custrecord_2663_bank_comp_id,10)}<#--ACH Company Identification. Assigned by SVB-->
<#--P06-->PPD<#rt><#--Standard Entry Class Code-->
<#--P07-->${setLength("Vendor Pay",10)}<#rt><#--Company Entry Description-->
<#--P08-->${pfa.custrecord_2663_process_date?string("yyMMdd")}<#rt><#--Company Descriptive Date (Show's on receiving bank statement)-->
<#--P09-->${pfa.custrecord_2663_process_date?string("yyMMdd")}<#rt><#--Effective Entry Date (Show's on receiving bank statement)-->
<#--P10-->   <#rt><#--(3) Settlement Date (Left blank, SVB to fill in automatically-->
<#--P11-->1<#rt><#--Originator Status Code = 1-->
<#--P12-->${cbank.custpage_eft_custrecord_2663_bank_num?string?substring(0, 8)}<#rt><#--Originating Financial Institution, SVB Routing Number-->
<#--P13-->${setPadding(pfa.id,"left","0",7)}<#rt><#--Batch Number-->
${"\r\n"}<#--Line Break--><#rt>
<#--- PPD Entry Detail Record (6) --->
<#assign totalPayments = 0>
<#assign recordCount = 0>
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
    <#assign payAmount = formatAmount(getAmount(payment))>
    <#assign totalPayments = totalPayments + 1>
    <#assign recordCount = recordCount + 2>
    <#assign traceNumber = cbank.custpage_eft_custrecord_2663_bank_num?string?substring(0, 8) + setPadding(recordCount,"left","0",7)?string>
    <#assign paidTransactions = transHash[payment.internalid]>
    <#--Entry Hash Calculation sum-->
    <#assign entryHashPPD = entryHashPPD + ebank.custrecord_2663_entity_bank_no?string?substring(0, 8)?number>
    <#--Entry Hash Calculation End-->
<#--P01-->6<#rt><#--Record Type Code (6)-->
<#--P02-->22<#rt><#--Transaction Code (27: Automated Deposit)-->
<#--P03-->${ebank.custrecord_2663_entity_bank_no?string?substring(0, 8)}<#rt><#--Receiving DFI ID (Routing Number)-->
<#--P04-->${ebank.custrecord_2663_entity_bank_no?string?substring(8)}<#rt><#--Check Digit the 9th digit of routing number <substring(8)>-->
<#--P05-->${setPadding(ebank.custrecord_2663_entity_acct_no,"right"," ",17)}<#rt><#--Bank Account Number-->
<#--P06-->${setPadding(payAmount,"left","0",10)}<#rt><#--Dollar Amount-->
<#--P07-->${setPadding(payment.transactionnumber,"right"," ",15)}<#rt><#--Individual Identification Number-->
<#--P08-->${setPadding(buildEntityName(entity),"right"," ",22)}<#rt><#--Individual Name-->
<#--P09-->  <#rt><#--Discretionary Data-->
<#--P10-->1<#rt><#--Addenda Record Indicatior (0:No 1:Yes)-->
<#--P11-->${traceNumber}<#rt><#--Trace Number-->
${"\r\n"}<#--Line Break--><#rt>
<#--- Addenda Detail Record (7) --->
705${setLength("RefNo:" + getReferenceNote(payment),80)}0001${setPadding(batchLineNum,"left","0",7)}<#rt>
${"\r\n"}<#--Line Break--><#rt>
</#list>
<#--- PPD Batch Control Record (8) --->
<#--P01-->8<#rt><#--Record Type Code (8)-->
<#--P02-->220<#rt><#--Service Class Code-->
<#--P03-->${setPadding(recordCount,"left","0",6)}<#rt><#--Entry/Addenda Count-->
<#--P04-->${setPadding(entryHashPPD,"left","0",10)}<#rt><#--Entry Hash-->
<#--P05-->000000000000<#rt><#--Total Debit Entry Dollar Amount-->
<#--P06-->${setPadding(totalAmount,"left","0",12)}<#rt><#--Total Credit Entry Dollar Amount-->
<#--P07-->${cbank.custpage_eft_custrecord_2663_bank_comp_id}<#rt><#--Company Identification-->
<#--P08-->${setLength(" ",19)}<#rt><#--Message Authentication Code Leave Blank (19)-->
<#--P09-->${setLength(" ",6)}<#rt><#--Reserved Leave Blank (6)-->
<#--P10-->${cbank.custpage_eft_custrecord_2663_bank_num?string?substring(0, 8)}<#rt><#--Originating Financial Institution, Chase Routing Number 8 digits without check digit-->
<#--P11-->${setPadding(pfa.id,"left","0",7)}<#rt><#--Batch Number-->
${"\r\n"}<#--Line Break--><#rt>
<#elseif (ccdPayments?size > 0) && (ppdPayments?size > 0) >
<#assign entryHash = 0>
<#assign entryHashCCD = 0>
<#assign entryHashPPD = 0>
<#--- CCD Batch Header Record (5) --->
<#--P01-->5<#rt><#--Record Type Code (5)-->
<#--P02-->220<#rt><#--Service Class Code-->
<#--P03-->${setLength(cbank.custrecord_2663_legal_name,16)}<#rt><#--Your Company Name (Short)-->
<#--P04-->${setLength(" ",20)}<#rt><#--Company Discretionary Data - Leave Blank (20)-->
<#--P05-->${setLength(cbank.custpage_eft_custrecord_2663_bank_comp_id,10)}<#--ACH Company Identification. Assigned by SVB-->
<#--P06-->CCD<#rt><#--Standard Entry Class Code-->
<#--P07-->${setLength("Vendor Pay",10)}<#rt><#--Company Entry Description-->
<#--P08-->${pfa.custrecord_2663_process_date?string("yyMMdd")}<#rt><#--Company Descriptive Date (Show's on receiving bank statement)-->
<#--P09-->${pfa.custrecord_2663_process_date?string("yyMMdd")}<#rt><#--Effective Entry Date (Show's on receiving bank statement)-->
<#--P10-->   <#rt><#--(3) Settlement Date (Left blank, SVB to fill in automatically-->
<#--P11-->1<#rt><#--Originator Status Code = 1-->
<#--P12-->${cbank.custpage_eft_custrecord_2663_bank_num?string?substring(0, 8)}<#rt><#--Originating Financial Institution, SVB Routing Number-->
<#--P13-->${setPadding(pfa.id,"left","0",7)}<#rt><#--Batch Number-->
${"\r\n"}<#--Line Break--><#rt>
<#--- CCD Entry Detail Record (6) --->
<#assign totalPayments = 0>
<#assign recordCount = 0>
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
    <#assign payAmount = formatAmount(getAmount(payment))>
    <#assign totalPayments = totalPayments + 1>
    <#assign recordCount = recordCount + 2>
    <#assign traceNumber = cbank.custpage_eft_custrecord_2663_bank_num?string?substring(0, 8) + setPadding(recordCount,"left","0",7)?string>
    <#assign paidTransactions = transHash[payment.internalid]>
    <#--Entry Hash Calculation sum-->
    <#assign entryHashCCD = entryHashCCD + ebank.custrecord_2663_entity_bank_no?string?substring(0, 8)?number>
    <#--Entry Hash Calculation End-->
<#--P01-->6<#rt><#--Record Type Code (6)-->
<#--P02-->22<#rt><#--Transaction Code (27: Automated Deposit)-->
<#--P03-->${ebank.custrecord_2663_entity_bank_no?string?substring(0, 8)}<#rt><#--Receiving DFI ID (Routing Number)-->
<#--P04-->${ebank.custrecord_2663_entity_bank_no?string?substring(8)}<#rt><#--Check Digit the 9th digit of routing number <substring(8)>-->
<#--P05-->${setPadding(ebank.custrecord_2663_entity_acct_no,"right"," ",17)}<#rt><#--Bank Account Number-->
<#--P06-->${setPadding(payAmount,"left","0",10)}<#rt><#--Dollar Amount-->
<#--P07-->${setPadding(payment.transactionnumber,"right"," ",15)}<#rt><#--Individual Identification Number-->
<#--P08-->${setPadding(buildEntityName(entity),"right"," ",22)}<#rt><#--Individual Name-->
<#--P09-->  <#rt><#--Discretionary Data-->
<#--P10-->1<#rt><#--Addenda Record Indicatior (0:No 1:Yes)-->
<#--P11-->${traceNumber}<#rt><#--Trace Number-->
${"\r\n"}<#--Line Break--><#rt>
<#--- Addenda Detail Record (7) --->
705${setLength("RefNo:" + getReferenceNote(payment),80)}0001${setPadding(batchLineNum,"left","0",7)}<#rt>
${"\r\n"}<#--Line Break--><#rt>
</#list>
<#--- CCD Batch Control Record (8) --->
<#--P01-->8<#rt><#--Record Type Code (8)-->
<#--P02-->220<#rt><#--Service Class Code-->
<#--P03-->${setPadding(recordCount,"left","0",6)}<#rt><#--Entry/Addenda Count-->
<#--P04-->${setPadding(entryHashCCD,"left","0",10)}<#rt><#--Entry Hash-->
<#--P05-->000000000000<#rt><#--Total Debit Entry Dollar Amount-->
<#--P06-->${setPadding(totalAmount,"left","0",12)}<#rt><#--Total Credit Entry Dollar Amount-->
<#--P07-->${cbank.custpage_eft_custrecord_2663_bank_comp_id}<#rt><#--Company Identification-->
<#--P08-->${setLength(" ",19)}<#rt><#--Message Authentication Code Leave Blank (19)-->
<#--P09-->${setLength(" ",6)}<#rt><#--Reserved Leave Blank (6)-->
<#--P10-->${cbank.custpage_eft_custrecord_2663_bank_num?string?substring(0, 8)}<#rt><#--Originating Financial Institution, Chase Routing Number 8 digits without check digit-->
<#--P11-->${setPadding(pfa.id,"left","0",7)}<#rt><#--Batch Number-->
${"\r\n"}<#--Line Break--><#rt>
<#--- PPD Batch Header Record (5) --->
<#--P01-->5<#rt><#--Record Type Code (5)-->
<#--P02-->220<#rt><#--Service Class Code-->
<#--P03-->${setLength(cbank.custrecord_2663_legal_name,16)}<#rt><#--Your Company Name (Short)-->
<#--P04-->${setLength(" ",20)}<#rt><#--Company Discretionary Data - Leave Blank (20)-->
<#--P05-->${setLength(cbank.custpage_eft_custrecord_2663_bank_comp_id,10)}<#--ACH Company Identification. Assigned by SVB-->
<#--P06-->PPD<#rt><#--Standard Entry Class Code-->
<#--P07-->${setLength("Vendor Pay",10)}<#rt><#--Company Entry Description-->
<#--P08-->${pfa.custrecord_2663_process_date?string("yyMMdd")}<#rt><#--Company Descriptive Date (Show's on receiving bank statement)-->
<#--P09-->${pfa.custrecord_2663_process_date?string("yyMMdd")}<#rt><#--Effective Entry Date (Show's on receiving bank statement)-->
<#--P10-->   <#rt><#--(3) Settlement Date (Left blank, SVB to fill in automatically-->
<#--P11-->1<#rt><#--Originator Status Code = 1-->
<#--P12-->${cbank.custpage_eft_custrecord_2663_bank_num?string?substring(0, 8)}<#rt><#--Originating Financial Institution, SVB Routing Number-->
<#--P13-->${setPadding(pfa.id,"left","0",7)}<#rt><#--Batch Number-->
${"\r\n"}<#--Line Break--><#rt>
<#--- PPD Entry Detail Record (6) --->
<#assign totalPayments = 0>
<#assign recordCount = 0>
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
    <#assign payAmount = formatAmount(getAmount(payment))>
    <#assign totalPayments = totalPayments + 1>
    <#assign recordCount = recordCount + 2>
    <#assign traceNumber = cbank.custpage_eft_custrecord_2663_bank_num?string?substring(0, 8) + setPadding(recordCount,"left","0",7)?string>
    <#assign paidTransactions = transHash[payment.internalid]>
    <#--Entry Hash Calculation sum-->
    <#assign entryHashPPD = entryHashPPD + ebank.custrecord_2663_entity_bank_no?string?substring(0, 8)?number>
    <#--Entry Hash Calculation End-->
<#--P01-->6<#rt><#--Record Type Code (6)-->
<#--P02-->22<#rt><#--Transaction Code (27: Automated Deposit)-->
<#--P03-->${ebank.custrecord_2663_entity_bank_no?string?substring(0, 8)}<#rt><#--Receiving DFI ID (Routing Number)-->
<#--P04-->${ebank.custrecord_2663_entity_bank_no?string?substring(8)}<#rt><#--Check Digit the 9th digit of routing number <substring(8)>-->
<#--P05-->${setPadding(ebank.custrecord_2663_entity_acct_no,"right"," ",17)}<#rt><#--Bank Account Number-->
<#--P06-->${setPadding(payAmount,"left","0",10)}<#rt><#--Dollar Amount-->
<#--P07-->${setPadding(payment.transactionnumber,"right"," ",15)}<#rt><#--Individual Identification Number-->
<#--P08-->${setPadding(buildEntityName(entity),"right"," ",22)}<#rt><#--Individual Name-->
<#--P09-->  <#rt><#--Discretionary Data-->
<#--P10-->1<#rt><#--Addenda Record Indicatior (0:No 1:Yes)-->
<#--P11-->${traceNumber}<#rt><#--Trace Number-->
${"\r\n"}<#--Line Break--><#rt>
<#--- Addenda Detail Record (7) --->
705${setLength("RefNo:" + getReferenceNote(payment),80)}0001${setPadding(batchLineNum,"left","0",7)}<#rt>
${"\r\n"}<#--Line Break--><#rt>
</#list>
<#--- PPD Batch Control Record (8) --->
<#--P01-->8<#rt><#--Record Type Code (8)-->
<#--P02-->220<#rt><#--Service Class Code-->
<#--P03-->${setPadding(recordCount,"left","0",6)}<#rt><#--Entry/Addenda Count-->
<#--P04-->${setPadding(entryHashPPD,"left","0",10)}<#rt><#--Entry Hash-->
<#--P05-->000000000000<#rt><#--Total Debit Entry Dollar Amount-->
<#--P06-->${setPadding(totalAmount,"left","0",12)}<#rt><#--Total Credit Entry Dollar Amount-->
<#--P07-->${cbank.custpage_eft_custrecord_2663_bank_comp_id}<#rt><#--Company Identification-->
<#--P08-->${setLength(" ",19)}<#rt><#--Message Authentication Code Leave Blank (19)-->
<#--P09-->${setLength(" ",6)}<#rt><#--Reserved Leave Blank (6)-->
<#--P10-->${cbank.custpage_eft_custrecord_2663_bank_num?string?substring(0, 8)}<#rt><#--Originating Financial Institution, Chase Routing Number 8 digits without check digit-->
<#--P11-->${setPadding(pfa.id,"left","0",7)}<#rt><#--Batch Number-->
${"\r\n"}<#--Line Break--><#rt>
</#if>
<#--Entry Hash Total Calculation-->
<#assign entryHash = entryHash + entryHashCCD + entryHashPPD>
<#--- File Control Record (9) --->
<#--P01-->9<#rt><#--Record Type Code (9)-->
<#--P02-->000001<#rt><#--Batch Count-->
<#--P03-->${setPadding(computeTotalRecords(recordCount),"left","0",6)}<#rt><#--Block Count-->
<#--P04-->${setPadding(recordCount,"left","0",8)}<#rt><#--Entry/Addenda Count-->
<#--P05-->${setPadding(entryHash,"left","0",10)}<#rt><#--Entry Hash-->
<#--P06-->000000000000<#rt><#--Total Debit Entry Dollar Amount in File-->
<#--P07-->${setPadding(totalAmount,"left","0",12)}<#rt><#--Total Credit Entry Dollar Amount in File-->
<#--P08-->${setLength(" ",39)}<#rt><#--Leave Blank (39)-->
#OUTPUT END#
