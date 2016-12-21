
			<!-- jquery -->
			<script src="https://code.jquery.com/jquery-2.1.4.min.js"></script>

			<!-- easing -->
			<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js" type="text/javascript" language="javascript">	</script> 

			<!-- bootstrap -->
			<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
			
			<!-- blind & side toggle -->			
			<script src="/<%=fnRootFolder%>/Support/tixDashboard/includes/js/blindToggle.js"></script>

			<script type="text/javascript" language="javascript">

			
			$('#btn-options').click(function() 
			{
				$('div#panel-options > div:first-child').blindToggle(1000, 'easeOutBounce');
			});  


			//Prevents buttons from staying focused after click
			$(".btn").mouseup(function()
			{
			$(this).blur();
			});

			
			$("#search").focus(function(){
				// Select input field contents
				this.select();
				alert('search focused');
			});

			//highlight button group when input is clicked
			$(".input-navbar.form-control").focus(function()
			{ 
				 $(this).parent().addClass("focusClass"); 
			});
			$(".input-navbar.form-control").blur(function()
			{ 
				 $(this).parent().removeClass("focusClass"); 
			});

			//return to dashboard when clicked
			$("#btn-dashboard").click(function () 
			{
				window.location.href = "/<%=fnRootFolder%>/support/tixdashboard/index.asp";
			});

			//make checkboxes and radio buttons pretty
			$('input:not(.switch-input)').iCheck(
			{
				checkboxClass: 'icheckbox_square-grey',
				radioClass: 'iradio_square-grey',
				increaseArea: '30%'
			});


			//toggle features on and off
			$('input').on('ifToggled', function(event)
			{
				$(this).closest("tr").toggleClass("active")
			});


			//dataTables set up
			$('.table-data').dataTable( 
			{
				"paging":   false,
				"ordering": true,
				"info":     false,
				"filter":	false,
				"columnDefs": 
								[
									{ 
										"orderable": false, 
										"targets": 0 
									}
								],
				"order": [ 1, 'asc' ]
			});
			 

			</script>
			
			

			
	
			
			