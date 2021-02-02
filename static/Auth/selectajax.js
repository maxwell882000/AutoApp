jQuery(function($){
    $(document).ready(function(){
        $("#id_project_select").change(function(){
            $.ajax({
                url:"/get_phases/",
                type:"POST",
                data:{project: $(this).val(),},
                success: function(result) {
                    console.log(result);
                    cols = document.getElementById("id_phase_select");
                    cols.options.length = 0;
                    for(var k in result){
                        cols.options.add(new Option(k, result[k]));
                    }
                },
                error: function(e){
                    console.error(JSON.stringify(e));
                },
            });
        });
    }); 
});