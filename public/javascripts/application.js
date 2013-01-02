function remove_fields(link) {
	$(link).previous("input[type=hidden]").value = "1";
	$(link).up(".fields").hide();
}

function add_fields(link, association, content) {
	var new_id = new Date().getTime();
	var regexp = new RegExp("new_" + association, "g")
	//alert(link);
	$(link).before(content.replace(regexp, new_id));
	/*$(link).up().insert({
	 before: content.replace(regexp, new_id)
	 });*/
}


$(document).ready(function() {
	$('input.submittable').each(function(elmt) {
		elmt.observe('click', function(ev) {
			this.form.request({
				onSuccess : function(response) {
					eval(response)
				}
			});
		});
	});

	$('href.submittable').each(function(elmt) {
		elmt.observe('click', function(ev) {
			this.form.request({
				onSuccess : function(response) {
					eval(response)
				}
			});
		});
	});

	$("#product_category_id").change(function() {
		$("select#product_category_id option:selected").each(function() {
			var field = "category";
			var id = $(this).val();

			$.ajax({
				url : "/get_by_javascript",
				type : "GET",
				dataType : "json",
				data : {
					field : field,
					id : id
				},
				success : function(data) {
					var options = '';
					$(data).each(function(index, value) {
						options += "<option value='" + value.manufacturer.id + "'>" + value.manufacturer.name + "</option>";
					});

					$("#product_manufacturer_id").html(options);

					$("#product_manufacturer_id").change(function() {
						$("select#product_manufacturer_id option:selected").each(function() {
							var field = "manufacturer";
							var id = $(this).val();

							$.ajax({
								url : "/get_by_javascript",
								type : "GET",
								dataType : "json",
								data : {
									field : field,
									id : id
								},
								success : function(data) {
									var options = '';
									$(data).each(function(index, value) {
										options += "<option value='" + value.carrier.id + "'>" + value.carrier.name + "</option>";
									});

									$("#product_carrier_id").html(options);
								},
								error : function(data) {

								}
							});
						});

					}).trigger('change');

				},
				error : function(data) {

				}
			});
		});

	}).trigger('change');

	$("#sell_now").live('click', function(event) {

		var item = $("#name").val();
		if (item == '' || item == "Sell your item") {
			//alert(item);
			event.preventDefault();
		}
	});

	if ($("#user_is_affiliate_admin").attr("checked") == "checked") {
		//	alert("yes checked");
		$("#user_user_id_input").hide();
	} else {
		$("#user_user_id_input").show();
	}

	$("#user_is_affiliate_admin").live('click', function() {
		//if()
		if ($(this).attr("checked") == "checked") {
			//	alert("yes checked");
			$("#user_user_id_input").hide();
		} else {
			$("#user_user_id_input").show();
		}
	});
	
	//alert($("#catologue_category_id :selected").text());
	
	if ($("#catologue_category_id :selected").text() == "Tablet") {
			//	alert("yes checked");
			$("#catologue_series_list_input").hide();
			$("#catologue_carrier_input").hide();
			
		} else {
			$("#catologue_series_list_input").show();
			$("#catologue_carrier_input").show();
	}
		
	$("#catologue_category_id").live('change', function(){
		if ($("#catologue_category_id :selected").text() == "Tablet") {
			//	alert("yes checked");
			$("#catologue_series_list_input").hide();
			$("#catologue_carrier_input").hide();
		} else {
			$("#catologue_series_list_input").show();
			$("#catologue_carrier_input").show();
		}
	});
});

/*
 document.observe('dom:loaded', function() {
 $$('input.submittable').each(function(elmt) {
 elmt.observe('click', function(ev) {
 this.form.request({
 onSuccess: function(response) {eval(response)}
 });
 });
 });

 $$('href.submittable').each(function(elmt) {
 elmt.observe('click', function(ev) {
 this.form.request({
 onSuccess: function(response) {eval(response)}
 });
 });
 });
 });
 */