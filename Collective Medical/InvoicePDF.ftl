<?xml version="1.0"?><!DOCTYPE pdf PUBLIC "-//big.faceless.org//report" "report-1.1.dtd">
<pdf>
<head>
	<link name="NotoSans" type="font" subtype="truetype" src="${nsfont.NotoSans_Regular}" src-bold="${nsfont.NotoSans_Bold}" src-italic="${nsfont.NotoSans_Italic}" src-bolditalic="${nsfont.NotoSans_BoldItalic}" bytes="2" />
	<#if .locale == "zh_CN">
		<link name="NotoSansCJKsc" type="font" subtype="opentype" src="${nsfont.NotoSansCJKsc_Regular}" src-bold="${nsfont.NotoSansCJKsc_Bold}" bytes="2" />
	<#elseif .locale == "zh_TW">
		<link name="NotoSansCJKtc" type="font" subtype="opentype" src="${nsfont.NotoSansCJKtc_Regular}" src-bold="${nsfont.NotoSansCJKtc_Bold}" bytes="2" />
	<#elseif .locale == "ja_JP">
		<link name="NotoSansCJKjp" type="font" subtype="opentype" src="${nsfont.NotoSansCJKjp_Regular}" src-bold="${nsfont.NotoSansCJKjp_Bold}" bytes="2" />
	<#elseif .locale == "ko_KR">
		<link name="NotoSansCJKkr" type="font" subtype="opentype" src="${nsfont.NotoSansCJKkr_Regular}" src-bold="${nsfont.NotoSansCJKkr_Bold}" bytes="2" />
	<#elseif .locale == "th_TH">
		<link name="NotoSansThai" type="font" subtype="opentype" src="${nsfont.NotoSansThai_Regular}" src-bold="${nsfont.NotoSansThai_Bold}" bytes="2" />
	</#if>
    <macrolist>
        <macro id="nlheader">
    <table class="header" style="width: 100%;">
      <tr>
        <td colspan="2"><#if companyInformation.logoUrl?length != 0><img src="${companyInformation.logoUrl}" style="margin: 7px" /> </#if></td>
        <td align="right"><span class="title">${record@title}</span></td>
      </tr>
      <tr>
        <td class="address" colspan="2" style="margin-left: 5px;"><span class="nameandaddress">${companyInformation.companyName}</span><br /><span class="nameandaddress">${companyInformation.mainaddress_text?replace("United States","")}</span></td>
        <td align="right"><span class="number">#${record.tranid}</span></td>
      </tr>
      <tr>
        <td colspan="3" align="right"><span class="number">${record.trandate}</span></td>
      </tr>
    </table>
        </macro>
        <macro id="nlfooter">
            <table class="footer" style="width: 100%;"><tr>
	<td><barcode codetype="code128" showtext="true" value="${record.tranid}"/></td>
	<td align="right"><pagenumber/> of <totalpages/></td>
	</tr></table>
        </macro>
    </macrolist>
    <style type="text/css">* {
		<#if .locale == "zh_CN">
			font-family: NotoSans, NotoSansCJKsc, sans-serif;
		<#elseif .locale == "zh_TW">
			font-family: NotoSans, NotoSansCJKtc, sans-serif;
		<#elseif .locale == "ja_JP">
			font-family: NotoSans, NotoSansCJKjp, sans-serif;
		<#elseif .locale == "ko_KR">
			font-family: NotoSans, NotoSansCJKkr, sans-serif;
		<#elseif .locale == "th_TH">
			font-family: NotoSans, NotoSansThai, sans-serif;
		<#else>
			font-family: NotoSans, sans-serif;
		</#if>
		}
		table {
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
		td p { align:left }
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
          	line-height: 120%;
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
    <table style="width: 100%; margin-top: 10px;">
    <tr><td height="40">&nbsp;</td></tr>
    <tr>
	<td class="addressheader" colspan="3"><b>${record.billaddress@label}</b></td>
	<td class="addressheader" colspan="3"><b>${record.shipaddress@label}</b></td>
	<td class="totalboxtop" colspan="5"><b>${record.total@label?upper_case}</b></td>
	</tr>
	<tr>
	<td class="address" colspan="3" rowspan="2">${record.billaddress?replace("United States","")}</td>
	<td class="address" colspan="3" rowspan="2">${record.shipaddress?replace("United States","")}</td>
	<td align="right" class="totalboxmid" colspan="5">${record.total}</td>
	</tr>
	<tr>
	<td align="right" class="totalboxbot" colspan="5"><b>${record.duedate@label}:</b> ${record.duedate}</td>
	</tr></table>

<table class="body" style="width: 100%; margin-top: 10px;"><tr>
	<th>${record.terms@label}</th>
	<th>${record.duedate@label}</th>
	<th>${record.otherrefnum@label}</th>
	<th>${record.salesrep@label}</th>
	<th>${record.shipmethod@label}</th>
	<th>${record.partner@label}</th>
	</tr>
	<tr>
	<td>${record.terms}</td>
	<td>${record.duedate}</td>
	<td>${record.otherrefnum}</td>
	<td>${record.salesrep}</td>
	<td>${record.shipmethod}</td>
	<td>${record.partner}</td>
	</tr></table>
<#if record.item?has_content>

<table class="itemtable" style="width: 100%; margin-top: 10px;"><!-- start items --><#list record.item as item><#if item_index==0>
<thead>
	<tr>
	<th align="center" colspan="3">${item.quantity@label}</th>
	<th colspan="12">${item.item@label}</th>
	<th colspan="3">${item.options@label}</th>
	<th align="right" colspan="4">${item.rate@label}</th>
	<th align="right" colspan="4">${item.amount@label}</th>
	</tr>
</thead>
</#if><tr>
	<td align="center" colspan="3" line-height="150%">${item.quantity}</td>
	<td colspan="12"><span class="itemname">${item.item}</span><br />${item.description}</td>
	<td colspan="3">${item.options}</td>
	<td align="right" colspan="4">${item.rate}</td>
	<td align="right" colspan="4">${item.amount}</td>
	</tr>
	</#list><!-- end items --></table>

<hr /></#if>
<table class="total" style="width: 100%; margin-top: 10px;"><tr>
	<td colspan="4">&nbsp;</td>
	<td align="right"><b>${record.subtotal@label}</b></td>
	<td align="right">${record.subtotal}</td>
	</tr>
	<tr>
	<td colspan="4">&nbsp;</td>
	<td align="right"><b>${record.taxtotal@label} (${record.taxrate}%)</b></td>
	<td align="right">${record.taxtotal}</td>
	</tr>
	<tr class="totalrow">
	<td background-color="#ffffff" colspan="4">&nbsp;</td>
	<td align="right"><b>${record.total@label}</b></td>
	<td align="right">${record.total}</td>
	</tr></table>

<hr style="clear: both; visibility: hidden;"></hr>
<table style="width: 100%;">
	<tr>
      <td height="45">&nbsp;</td>
  	</tr>
  	<tr>
      <td align="left" style="line-height: 120%;"><span class="address"><b>Pay by Check</b><br />${companyInformation.mainaddress_text?replace("United States","")}<br /><b>Pay via ACH</b><br />Silicon Valley Bank<br />3003 Tasman<br />Santa Clara, CA 95054<br /><br />Account #: 3302283747<br />ABA/Routing: 121140399<br />Please reference invoice numbers(s) with your payment</span></td>
  	</tr>
</table>
</body>
</pdf>
