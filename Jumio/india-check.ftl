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
    <style type="text/css">
	table {
    position: relative;
    overflow: hidden;
    font-size: 10pt;
    font-family: Calibri, sans-serif;
    }
    td p {
    align:left
    font-size: 10pt;
    font-family: Calibri, sans-serif;
    }
</style>
</head>
<body padding="0.944cm 0.5905cm 0.944cm 0.5905cm" size="letter">
    <#list records as check>
<table align="center" border="0" cellpadding="1" cellspacing="1" style="height:3.62in;width:7.95in;"><tr>
	<td>
	<table style="position: absolute;overflow: hidden;left: 250pt;top: 0;width: 85pt;"><tr>
		<td align="center">A/c Payee</td>
		</tr></table>

	<table style="position: absolute;overflow: hidden;left: 15.6cm;top: 0cm;height: 18pt;width: 108pt; letter-spacing: 0.3cm;"><tr>
		<td>${check.trandate?string("ddMMYYY")}</td>
		</tr></table>

	<table style="position: absolute;overflow: hidden;left: 1.0in;top: 1.1cm;height: 18pt;width: 393pt;"><tr>
		<#if check.entity.printoncheckas?length !=0>
    	<td>${check.entity.printoncheckas}</td>
   		<#else>
     	<td>${check.entity}</td>
   		</#if>
		</tr></table>

	<table style="position: absolute;overflow: hidden;left: 1.3in;top: 1.9cm;height: 18pt;width: 250pt;"><tr>
		<td>${check.wordHundredThousands}</td>
		<td>${check.wordTenThousands}</td>
		<td>${check.wordThousands}</td>
		<td>${check.wordHundreds}</td>
		<td>${check.wordTens}</td>
		<td>${check.wordOnes}</td>
		</tr></table>

	<table style="position: absolute;overflow: hidden;left: 15cm;top: 2.4cm;height: 18pt;width: 111pt;"><tr>
		<td><#if (check.usertotal?length > 0)>**${check.usertotal?replace("$","")}<#else>**${check.total?replace("$","")}</#if></td>
		</tr></table>

	</td>
	</tr></table>
</#list>
</body>
</pdf>
