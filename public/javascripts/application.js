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

	
		$("#product_category_id").change(function() 
		{
			$("select#product_category_id option:selected").each(function() 
			{
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
					$("#product_manufacturer_id").html(data);				
				},
				error : function(data) {
					
				}
				});
			});

		}).trigger('change');
	
	
	
		
			
	/*
	 $("#item_select_button").live('click',function(event){
	 event.preventDefault();

	 var item = $("span.center.jcf-unselectable").text();
	 alert(item);

	 });
	 */
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