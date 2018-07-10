<#--Author: Michael Wang | mwang@netsuite.com-->
<#--PNC Payable Advantages Flat File-->

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

<#-- cached values -->
<#assign totalAmount = formatAmount(computeTotalAmount(payments))>

<#-- template building -->
#OUTPUT START#
<#--- Filed Header Record (010) --->
<#--P01-->010<#rt><#--Record Identifier-->
<#--P02-->${cbank.custpage_eft_custrecord_2663_bank_comp_id}<#rt><#--Sender Identification Number-->
<#--P03-->AP0<#rt><#--Business Application Format ${cbank.custpage_eft_custrecord_2663_bank_code}-->
<#--P04-->${setLength(cbank.custrecord_2663_print_company_name,16)}<#rt><#--Customer Name-->
<#--P05-->${pfa.custrecord_2663_file_creation_timestamp?string("yyyyMMdd")}<#rt><#--Transmission Date (yyyyMMdd)-->
<#--P06-->${pfa.custrecord_2663_file_creation_timestamp?string("HHmm")}<#rt><#--Transmission Time (HHmm)-->
<#--P07-->${setLength(" ",10)}<#rt><#--Client File ID-->
<#--P08-->${setLength(" ",291)}<#rt><#--Filler-->
${"\r\n"}<#--Line Break--><#rt>
<#--- ACH Payment Record (060) --->
<#assign ACHTotalAmount = 0>
<#assign ACHRecordCount = 0>
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
    <#assign payAmount = formatAmount(getAmount(payment))>
    <#assign ACHTotalAmount = ACHTotalAmount + payAmount>
    <#assign ACHRecordCount = ACHRecordCount + 1>
<#--P01-->060<#rt><#--Record ID (060)-->
<#--P02-->ACH<#rt><#--Payment Type (ACH)-->
<#--P03--> <#rt><#--Canadian Indicator (C or Space)-->
<#--P04-->${setLength(" ",10)}<#rt><#--Vendor Number (OPT)-->
<#--P05-->${setLength(" ",4)}<#rt><#--Filler-->
<#--P06-->${setLength("USD",3)}<#rt><#--Currency Type-->${setPadding(payAmount,"left","0",10)}
<#--P07-->${setPadding("0","left","0",10)}<#rt><#--Trace Number-->
<#--P08-->${setLength(pfa.custrecord_2663_process_date?string("yyyyMMdd"),8)}<#rt><#--Payment Effective Date-->
<#--P09-->${setLength(" ",3)}<#rt><#--Filler-->
<#--P10-->${setPadding(payAmount,"left","0",10)}<#rt><#--Payment Amount-->
<#--P11-->${setPadding(buildEntityName(entity),"right"," ",22)}<#rt><#--Receiver Name-->
<#--P12-->${setLength(" ",13)}<#rt><#--Filler-->
<#--P13-->${setLength(" ",15)}<#rt><#--Individual ID-->
<#--P14-->${setLength(" ",20)}<#rt><#--Filler-->
<#--P15-->${setLength(" ",35)}<#rt><#--Receiver Address 1-->
<#--P16-->${setLength(" ",35)}<#rt><#--Receiver Address 2-->
<#--P17-->${setLength(" ",35)}<#rt><#--Receiver Address 3-->
<#--P18-->${setLength(" ",27)}<#rt><#--Receiver City-->
<#--P19-->${setLength(" ",2)}<#rt><#--Receiver State-->
<#--P20-->${setLength(" ",9)}<#rt><#--Receiver Zip-->
<#--P21-->${setLength(" ",4)}<#rt><#--Filler-->
<#--P22-->${setPadding("0","left","0",5)}<#rt><#--Number of Remittance Lines *NEED REVIEW*-->
<#--P23-->${setLength(" ",10)}<#rt><#--Filler-->
<#--P24-->${setPadding(ebank.custrecord_2663_entity_bank_no,"left","0",9)}<#rt><#--Receiver ABA (Transit Routing)-->
<#--P25-->${setLength(" ",3)}<#rt><#--Filler-->
<#--P26-->${setPadding(ebank.custrecord_2663_entity_acct_no,"right"," ",17)}<#rt><#--Receiver Account Number-->
<#--P27-->${setLength("22",2)}<#rt><#--ACH Tran Code (22)-->
<#--P28-->${setLength("CCD",3)}<#rt><#--ACH Type-->
<#--P29-->${setLength(" ",20)}<#rt><#--Discretionary Data-->
<#--P30-->${setLength(" ",9)}<#rt><#--Filler-->
${"\r\n"}<#--Line Break--><#rt>
<#--- File Trailer Record (090) --->
<#--P01-->090<#rt><#--Record Identifier-->
<#--P02-->${setPadding("0","left","0",13)}<#rt><#--Total Dollar amount of Checks-->
<#--P03-->${setPadding("0","left","0",7)}<#rt><#--Total Records, Checks-->
<#--P04-->${setPadding("ACHTotalAmount","left","0",13)}<#rt><#--Total Dollar amount of ACHs-->
<#--P05-->${setPadding(ACHRecordCount,"left","0",7)}<#rt><#--Total Records, ACHs-->
<#--P06-->${setPadding("0","left","0",13)}<#rt><#--Total Dollar amount of Wires-->
<#--P07-->${setPadding("0","left","0",7)}<#rt><#--Total Records, Wire-->
<#--P08-->${setPadding("0","left","0",13)}<#rt><#--Total Dollar amount of Cards-->
<#--P09-->${setPadding("0","left","0",7)}<#rt><#--Total Records,  Cards-->
<#--P10-->${setPadding("0","left","0",13)}<#rt><#--Total Payment Dollar Amounts-->
<#--P11-->${setPadding("0","left","0",7)}<#rt><#--Total Payment Records-->
<#--P12-->${setPadding("0","left","0",13)}<#rt><#--Total File Dollar Amounts-->
<#--P13-->${setPadding("0","left","0",7)}<#rt><#--Total File Records-->
<#--P14-->${setLength(" ",227)}<#rt><#--Filler-->
#OUTPUT END#
