<refFields type='Comerica EFT XML'>
	<refField id="custrecord_2663_bank_comp_id" label="Immediate Origin" mandatory="true" helptext="Enter your company's TAX Id or 10-digit number assigned by the bank to identify your company's ACH files."/>
	<refField id="custrecord_2663_issuer_num" label="Company ID" mandatory="true" helptext="Enter your company's Tax ID or company number assigned by your bank."/>
	<refField id="custrecord_2663_acct_num" label="Account Number" mandatory="true" helptext="Enter your company's bank account number."/>
	<refField id="custrecord_2663_bank_num" label="Routing Number" mandatory="true" helptext="Enter the bank's transit routing number."/>
	<refField id="custrecord_2663_bank_name" label="Immediate Destination Name" mandatory="true" helptext="Enter the name of the bank's site where the payment will be processed. You can enter a maximum of 23 characters."/>
	<refField id="custrecord_2663_bank_acct_type" label="Bank Account Type" helptext="Select Checking or Savings to indicate the bank account type."/>
	<refField id="custrecord_2663_balance_line" label="Create Balanced Files" helptext="If your bank requires balanced files for EFT transactions, check this box to include a balancing line in the payment file to indicate the amount debited from your company's bank account. Clear this box if your bank accepts unbalanced files."/>
	<refField id="custrecord_2663_pad_blocks" label="Add Pad Blocks" helptext="Some banks require payment files to contain lines in multiples of 10. Check this box to add lines with "9" characters at the end of the payment file when the total number of records is not a multiple of 10. Clear this box if your bank does not require pad blocks."/>
	<refField id="custrecord_2663_processor_code" label="Federal Reserve Routing Symbol" displaytype="disabled" helptext="This field displays the Federal Reserve Routing Symbol based on the routing number that you entered."/>
	<refField id="custrecord_2663_bank_code" label="ABA Institution Identifier" displaytype="disabled" helptext="This field displays the ABA institution identifier based on the routing number that you entered."/>
	<refField id="custrecord_2663_country_check" label="Check Digit" displaytype="disabled" helptext="This field diplays the check digit based on the routing number that you entered."/>
</refFields>
