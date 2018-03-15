<?xml version="1.0"?><!DOCTYPE pdf PUBLIC "-//big.faceless.org//report" "report-1.1.dtd">
<pdf>
<head>
<#if .locale == "ru_RU">
    <link name="verdana" type="font" subtype="opentype" src="${nsfont.verdana}" src-bold="${nsfont.verdana_bold}" bytes="2" />
</#if>

<#assign cs = "{currencySymbol}">

<#function toCurrency value showSymbol=false>
    <#local retval = 0>
    <#local tmpcs = cs>
    <#if showSymbol == false>
        <#local tmpcs = "">
    </#if>
    <#if value &lt; 0 >
        <#local retval = value?string["#,##0.00"]>
        <#local retval = "(" + tmpcs + retval?replace("-","") + ")">
    <#else>
        <#local retval = tmpcs + value?string["#,##0.00"]>
    </#if>
    <#return retval>
</#function>

    <macrolist>
        <macro id="nlheader">
            <table class="header" style="width: 100%;"><tr>
	<td rowspan="3"><img src="http://shopping.sandbox.netsuite.com/core/media/media.nl?id=1503&amp;c=582041_SB1&amp;h=13eca13930f97fe62b7e" style="cursor: default; color: rgb(34, 34, 34); font-family: Arial, Verdana, sans-serif; font-size: 13.3333px; background-color: rgb(255, 255, 255); width: 200px; height: 51px;" /></td>
	<td rowspan="3">${companyInformation.mainaddress_text}</td>
	<td align="right"><span class="title">Consolidated Invoice</span></td>
	</tr>
	<tr>
	<td align="right"><span class="number">#${ci.name}</span></td>
	</tr>
	<tr>
	<td align="right">${ci.custrecord_nsts_ci_date}</td>
	</tr></table>
        </macro>
        <macro id="nlfooter">
            <table class="footer" style="width: 100%;"><tr>
	<td><barcode codetype="code128" showtext="true" value="${ci.name}"/></td>
	<td align="right"><pagenumber/> of <totalpages/></td>
	</tr></table>
        </macro>
    </macrolist>
    <style type="text/css">table {
        <#if .locale == "zh_CN">
            font-family: stsong, sans-serif;
        <#elseif .locale == "zh_TW">
            font-family: msung, sans-serif;
        <#elseif .locale == "ja_JP">
            font-family: heiseimin, sans-serif;
        <#elseif .locale == "ko_KR">
            font-family: hygothic, sans-serif;
        <#elseif .locale == "ru_RU">
            font-family: verdana;
        <#else>
            font-family: sans-serif;
        </#if>
            font-size: 9pt;
            table-layout: fixed;
        }
        th {
            font-weight: bold;
            font-size: 8pt;
            vertical-align: middle;
            padding: 5px 6px 3px;
            background-color: #e3e3e3;
            color: #333333;
        }
        td {
            padding: 4px 6px;
        }
        b {
            font-weight: bold;
            color: #333333;
        }
        table.header td {
            padding: 0px;
            font-size: 10pt;
        }
        table.footer td {
            padding: 0px;
            font-size: 8pt;
        }
        table.itemtable th {
            padding-bottom: 10px;
            padding-top: 10px;
        }
        table.body td {
            padding-top: 2px;
        }
        table.total {
            page-break-inside: avoid;
        }
        tr.totalrow {
            background-color: #e3e3e3;
            line-height: 200%;
        }
        td.totalboxtop {
            font-size: 12pt;
            background-color: #e3e3e3;
        }
        td.addressheader {
            font-size: 8pt;
            padding-top: 6px;
            padding-bottom: 2px;
        }
        td.address {
            padding-top: 0px;
        }
        td.totalboxmid {
            font-size: 28pt;
            padding-top: 20px;
            background-color: #e3e3e3;
        }
        td.totalboxbot {
            background-color: #e3e3e3;
            font-weight: bold;
        }
        span.title {
            font-size: 28pt;
        }
        span.number {
            font-size: 16pt;
        }
        span.itemname {
            font-weight: bold;
            line-height: 150%;
        }
        hr {
            width: 100%;
            color: #d3d3d3;
            background-color: #d3d3d3;
            height: 1px;
        }
</style>
</head>
<body header="nlheader" header-height="10%" footer="nlfooter" footer-height="20pt" padding="0.5in 0.5in 0.5in 0.5in" size="Letter">
    <table style="width: 100%; margin-top: 10px;"><tr>
	<td class="addressheader" colspan="3"><b>Bill To</b></td>
	<td class="addressheader" colspan="3"><b>Ship To</b></td>
	<td class="totalboxtop" colspan="5"><b>TOTAL</b></td>
	</tr>
	<tr>
	<td class="address" colspan="3" rowspan="2">${customer.billaddress}</td>
	<td class="address" colspan="3" rowspan="2">${customer.shipaddress}</td>
	<td align="right" class="totalboxmid" colspan="5">${toCurrency(ci.custrecord_nsts_ci_pdf_itemtotal,true)}</td>
	</tr>
	<tr>
	<td align="right" class="totalboxbot" colspan="5"><b>Due Date:</b>${ci.custrecord_nsts_ci_tran_duedate}</td>
	</tr></table>

<table class="body" style="width: 100%; margin-top: 10px;"><tr>
	<th>Terms</th>
	<th>Due Date</th>
	<th>&nbsp;</th>
	<!-- <th>${record.otherrefnum@label}</th> -->
	</tr>
	<tr>
	<td>${customer.terms}</td>
	<td>${ci.custrecord_nsts_ci_tran_duedate}</td>
	<td>&nbsp;</td>
	<!-- <td>${record.otherrefnum}</td> -->
	</tr></table>
<#if invoiceline?has_content>

<table class="itemtable" style="width: 100%; margin-top: 10px;"><!-- start items --><#list invoiceline as item><#if item_index==0>
<thead>
	<tr>
	<th align="center" colspan="10" rowspan="1">Project</th>
	<th colspan="12">Item</th>
	<th align="right" colspan="4">Amount</th>
	</tr>
</thead>
</#if><tr>
	<td align="center" colspan="10" line-height="150%" rowspan="1">${item.job}</td>
	<td colspan="12">${item.description}</td>
	<td align="right" colspan="4">${item.amount}</td>
	</tr>
	</#list><!-- end items --></table>

<hr /></#if>
<table class="total" style="width: 100%; margin-top: 10px;"><tr class="totalrow">
	<td background-color="#ffffff" colspan="4" style="background-color: rgb(255, 255, 255);"><strong>Payment Instructions:</strong></td>
	<td align="right"><b>Total</b></td>
	<td align="right">${toCurrency(ci.custrecord_nsts_ci_pdf_itemtotal,true)}</td>
	</tr>
	<tr>
	<td background-color="#ffffff" colspan="4" style="background-color: rgb(255, 255, 255);">Please send payment to the address listed at the top of this invoice. If you prefer to send via wire transfer:&nbsp; &nbsp; &nbsp; &nbsp;<br />&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<br />ABA Routing Number:&nbsp; 121100782&nbsp; &nbsp; &nbsp; &nbsp;<br />Account Number:&nbsp; 025187393&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;<br />Bank of the West<br />2050 N.California Blvd<br />Walnut Creek, CA&nbsp; 94596</td>
	<td align="right">&nbsp;</td>
	<td align="right">&nbsp;</td>
	</tr></table>
</body>
</pdf>
