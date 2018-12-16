//= require jquery
//= require jquery_ujs
//= require activegrid
//= require highcharts
//= require PIE
//= require iepngfix_tilebg
//= require_self

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready( function() {
	
	update_cost_center_supplier_fields();

	$(".ncm_form input[name='ncm[cost_center_type]']").change( function() {
			update_cost_center_supplier_fields();
	});
	
	function update_cost_center_supplier_fields(){
		if ( $('.ncm_form #ncm_cost_center_type_supplier').is(':checked') ) {
			hide_cost_center();
			show_suppliers();
		} else {
			hide_suppliers();
		}

		if ( $('.ncm_form #ncm_cost_center_type_cost_center').is(':checked') ) {
			hide_suppliers();
			show_cost_center();
		} else {
			hide_cost_center();
		}
	}
	
	function show_suppliers(){
		$(".ncm_form .supplier_name").css("display","block");
		$(".ncm_form .supplier_code").css("display","block");
		$(".ncm_form .supplier_address").css("display","block");
		$(".ncm_form .supplier_city").css("display","block");
		$(".ncm_form .supplier_state").css("display","block");
		$(".ncm_form .supplier_zip").css("display","block");
		$(".ncm_form .supplier_contact").css("display","block");
		$(".ncm_form .supplier_phone").css("display","block");
	}
	
	function hide_suppliers(){
		// $(".ncm_form #ncm_supplier_name").val("");
		// $(".ncm_form #ncm_supplier_code").val("");
		// $(".ncm_form #ncm_supplier_address").val("");
		// $(".ncm_form #ncm_supplier_city").val("");
		// $(".ncm_form #ncm_supplier_state").val("");
		// $(".ncm_form #ncm_supplier_zip").val("");
		// $(".ncm_form #ncm_supplier_contact").val("");
		// $(".ncm_form #ncm_supplier_phone").val("");
		
		$(".ncm_form .supplier_name").css("display","none");
		$(".ncm_form .supplier_code").css("display","none");
		$(".ncm_form .supplier_address").css("display","none");
		$(".ncm_form .supplier_city").css("display","none");
		$(".ncm_form .supplier_state").css("display","none");
		$(".ncm_form .supplier_zip").css("display","none");
		$(".ncm_form .supplier_contact").css("display","none");
		$(".ncm_form .supplier_phone").css("display","none");
	}
	
	function hide_cost_center(){
		$(".ncm_form #ncm_cost_center_name").val("");
		$(".ncm_form .cost_center_name").css("display","none");
	}
	
	function show_cost_center(){
		$(".ncm_form .cost_center_name").css("display","block");
	}
	
	
	$('#ncm_job_id').change( function(){
		$.get("/ncms/last_ncm_based_on_job/", { job_id: $('.ncm_form #ncm_job_id').val() } ).success(function(data) {
			$(".ncm_form #ncm_description").val(data.ncm.description);
			$(".ncm_form #ncm_location_id").val(data.ncm.location_id);
			$(".ncm_form #ncm_temporary_location").val(data.ncm.temporary_location);
			$(".ncm_form #ncm_sqe_pqe").val(data.ncm.sqe_pqe);
			$(".ncm_form #ncm_mi_name").val(data.ncm.mi_name);
			$(".ncm_form #ncm_work_instructions").val(data.ncm.work_instructions);
			$(".ncm_form #ncm_part_name").val(data.ncm.part_name);
			$(".ncm_form #ncm_customer_id").val(data.ncm.customer_id);
			
			if (data.ncm.cost_center_type == "Supplier") {
				$('.ncm_form #ncm_cost_center_type_supplier').prop('checked', true);
				$('.ncm_form #ncm_cost_center_type_cost_center').prop('checked', false);
			} else {
				$('.ncm_form #ncm_cost_center_type_supplier').prop('checked', false);
				$('.ncm_form #ncm_cost_center_type_cost_center').prop('checked', true);
			}
			update_cost_center_supplier_fields();
			
			$(".ncm_form #ncm_cost_center_name").val(data.ncm.cost_center_name);
			$(".ncm_form #ncm_supplier_name").val(data.ncm.ncm_supplier_name);
			$(".ncm_form #ncm_supplier_code").val(data.ncm.ncm_supplier_code);
			$(".ncm_form #ncm_supplier_address").val(data.ncm.ncm_supplier_address);
			$(".ncm_form #ncm_supplier_city").val(data.ncm.ncm_supplier_city);
			$(".ncm_form #ncm_supplier_state").val(data.ncm.ncm_supplier_state);
			$(".ncm_form #ncm_supplier_zip").val(data.ncm.ncm_supplier_zip);
			$(".ncm_form #ncm_supplier_contact").val(data.ncm.ncm_supplier_contact);
			$(".ncm_form #ncm_supplier_phone").val(data.ncm.ncm_supplier_phone);
		});
	});
	
	
});


