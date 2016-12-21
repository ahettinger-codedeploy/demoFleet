	
	function setModalValues(r) {

		var info = "<p>";
		for (i = 0; i < r.state.length; i++) {
			info += r.state[i].message + "<br />";
		}
		info += "</p>";
		$('#flash').html(info);

		$('#flash').removeClass("success");
		$('#flash').removeClass("error");	
		if (r.state[0].returnCode != '0') {
			$('#flash').addClass("error");
		} else {
			$('#flash').addClass("success");
		}

		var totalQty = 0;

		for (i = 0; i < r.items.length; i++) {
			$('.modal-qty').html("QTY: " + r.items[i].quantity);
			$('.modal-total').html(r.items[i].totalPrice);
			$('.modal-product-details').html(r.items[i].attributes);
			totalQty += r.items[i].quantity * 1;
		}


		if (r.cartSummary.length > 0) {
			$('.modal-my-cart-totals').html('<p>Total Items: ' + r.cartSummary[0].numItems + '</p><p>SubTotal: ' + r.cartSummary[0].orderTotal + '</p>');
		    $('#qtyAdded').html(r.cartSummary[0].numItems - 1);
		}
		
	}

	function setCartSummary(r) {
		$('#cartSummaryValues').text(r.cartSummary[0].numItems + ' items |' + r.cartSummary[0].orderTotal);
		$('#cartSummaryLink').html('<strong><a href=\"' + r.cartSummary[0].cartSummaryLink + '\">View Cart &raquo;</a></strong>');
	}
	
