/****
 * Payme method class
 * @param id
 * @param name
 * @param title
 * @param creditCard
 * @param cardType
 * @param cardCvv
 * @param cardHolderName
 * @return
 */
function PaymentMethod(name, creditCard, cardType, cardCvv, cardHolderName, enableRecurring) {	
	this.name = name ;	
	this.creditCard = creditCard ;
	this.cardType = cardType ;
	this.cardCvv = cardCvv ;
	this.cardHolderName = cardHolderName ;
	this.enableRecurring = enableRecurring ;
}
/***
 * Get name of the payment method
 * @return string
 */
PaymentMethod.prototype.getName = function() {
	return this.name ;
}
/***
 * This is creditcard payment method or not	
 * @return int
 */
PaymentMethod.prototype.getCreditCard = function() {
	return this.creditCard ;
}
/****
 * Show creditcard type or not
 * @return string
 */
PaymentMethod.prototype.getCardType = function() {
	return this.cardType ;
}
/***
 * Check to see whether card cvv code is required
 * @return string
 */
PaymentMethod.prototype.getCardCvv = function() {
	return this.cardCvv ;
}
/***
 * Check to see whether this payment method require entering card holder name
 * @return
 */
PaymentMethod.prototype.getCardHolderName = function() {
	return this.cardHolderName ;
}
/***
* Get name of the payment method
* @return string
*/
PaymentMethod.prototype.getEnableRecurring = function() {
	  return this.enableRecurring ;
}
/***
 * Payment method class, hold all the payment methods
 */
function PaymentMethods() {
	this.length = 0 ;
	this.methods = new Array();
}
/***
 * Add a payment method to array
 * @param paymentMethod
 * @return
 */
 PaymentMethods.prototype.Add = function(paymentMethod) {	
	this.methods[this.length] = paymentMethod ;
	this.length = this.length + 1 ;
}
/***
 * Find a payment method based on it's name
 * @param name
 * @return {@link PaymentMethod}
 */
 PaymentMethods.prototype.Find = function(name) {
	for (var i = 0 ; i < this.length ; i++) {
		if (this.methods[i].name == name) {
			return this.methods[i] ;			
		}
	}
	return null ;
}
/***
 * Process event when someone change a payment method
 */ 
function changePaymentMethod() {			
	var form = document.os_form;			
	var paymentMethod;
	for (var i = 0; i < form.payment_method.length; i++) {
		if (form.payment_method[i].checked == true) {
			paymentMethod = form.payment_method[i].value ;
			break;
		}
	}									
	var trCardNumber = document.getElementById('tr_card_number');
	var trExpDate = document.getElementById('tr_exp_date');
	var trCvvCode = document.getElementById('tr_cvv_code');
	var trCardType = document.getElementById('tr_card_type') ;
	var trCardHolderName = document.getElementById('tr_card_holder_name');
	var trDonationType = document.getElementById('donation_type') ;
	var trFrequecy = document.getElementById('tr_frequency') ;
	var trNumberDonations = document.getElementById('tr_number_donations') ;
	
	//Echeck support
	var trBankRountingNumber = document.getElementById('tr_bank_rounting_number') ;
	var trBankAccountNumber = document.getElementById('tr_bank_account_number');
	var trBankAccountType = document.getElementById('tr_bank_account_type');
	var trBankName = document.getElementById('tr_bank_name');
	var trBankAccountHolder = document.getElementById('tr_bank_account_holder') ;
	
	method = methods.Find(paymentMethod);	
	if (method.getCreditCard()) {
		trCardNumber.style.display = "";				
		trExpDate.style.display = "";				
		trCvvCode.style.display = "";
		if (method.getCardType()) {
			trCardType.style.display = '';
		} else {
			trCardType.style.display = 'none';
		}
		if (method.getCardHolderName()) {
			trCardHolderName.style.display = '';
		} else {
			trCardHolderName.style.display = 'none';
		}
	} else {
		trCardNumber.style.display = "none";				
		trExpDate.style.display = "none";				
		trCvvCode.style.display = "none";
		trCardType.style.display = 'none';
		trCardHolderName.style.display = "none";		
	}	
	
	if (paymentMethod == 'os_echeck') {
		trBankRountingNumber.style.display = '' ;
		trBankAccountNumber.style.display = '' ;
		trBankAccountType.style.display = '' ;
		trBankName.style.display = '' ;
		trBankAccountHolder.style.display = '' ;
	} else {
		trBankRountingNumber.style.display = 'none' ;
		trBankAccountNumber.style.display = 'none' ;
		trBankAccountType.style.display = 'none' ;
		trBankName.style.display = 'none' ;
		trBankAccountHolder.style.display = 'none' ;
	}
	
	if (trDonationType) {
		var show = 1 ;
		if (form.campaign_id) {
			if (form.campaign_id.value > 0)
				show = recurrings [form.campaign_id.value] ;
		}
		if (method.getEnableRecurring() && show) {
			trDonationType.style.display = '' ;			
			if (form.donation_type[1].checked) {
				trFrequency.style.display = '';
				if (trNumberDonations) {
					trNumberDonations.style.display = '';
				}
			}			
		} else {
			trDonationType.style.display = 'none' ;
			trFrequecy.style.display = 'none' ;
			if (trNumberDonations) {
				trNumberDonations.style.display = 'none' ;
			}			
			form.donation_type[0].checked = true ;
		}
	}	
}				 