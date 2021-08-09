<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<style>
        table {
            margin: 25px 0;
            width: 200px;
        }
  
        table th, table td {
            padding: 10px;
            text-align: center;
        }
  
        table, th, td {
            border: 1px solid;
        }
    </style>


<meta charset="ISO-8859-1">
<title>Track Scholar Tracker</title>
</head>
<body>
	<p>Ronin Address: <input size="100" id="ronin" type="text" value=""></input><button>Submit</button></p>
	<p>Current SLP Price: <span id="spanslpPrice"></span></p>
	
<div id="loading">
  <p><img src="https://miro.medium.com/max/784/0*hHrpP8vfkK_cCg1C.gif"  width="100" height="100"/> Please Wait</p>
</div>
<div id="div1"></div>
<table>
	<thead>
		<tr>
			<td>IGN</td>
			<td>Ronin</td>
			<td>MMR</td>
			<td>Adventure SLP</td>
			<td>Unclaim SLP</td>
			<td>Peso</td>
			<td>Claimed SLP</td>
			<td>Next Claimed Date</td>
		</tr>
	</thead>
	<tbody>
	
	</tbody>

</table>
</body>
<script>
 $(document).ready(function(){
  $('#loading').hide();
  $("button").click(function(){
	 roninFull = document.getElementById("ronin").value;
	 ronin = roninFull.substring(6, roninFull.length);
	 ronin = "0x" + ronin;
	
	 var mmrAPI = "https://game-api.skymavis.com/game-api/leaderboard?client_id="+ronin+"&offset=0&limit=100";
	 var slpAPI = "https://game-api.skymavis.com/game-api/clients/"+ronin+"/items?offset=0&limit=20";
	 var advAPI = "https://game-api.skymavis.com/game-api/clients/"+ronin+"/pve-best-scores/worlds/1/pve-stats?offset=0&limit=40";
	 var slpPrice = "https://api.coingecko.com/api/v3/coins/smooth-love-potion";
	
	 $.when($.ajax(mmrAPI,
     {
         type: 'GET',
         data: {
         },
         success: function (data) {
       	 
        	  mmr = data.items[data.items.length - 1].elo;
    		  name = data.items[data.items.length - 1].name;
       	  
           	  markup = "<tr> " +
         		"<td>"+name+"</td>" +
         		"<td>"+ roninFull +"</td>" +
         	    "<td>"+ mmr +"</td>";
         	   
       	}
      })).then(function(){
    	  $.when($.ajax(advAPI,
    		         {
    		             type: 'GET',
    		             data: {
    		             },
    		             success: function (data) {
    		           	 
    		            	 advSlp = data.gained_slp_response.gained_slp;
    		           	  
    		               	  markup = markup +
    		               	 "<td>"+ advSlp +"</td>" ;
    		             	   
    		           	}
    		          })).then(function(){
    		        		          
    		        	  $.when($.ajax(slpAPI,
 		        		         {
	        		             type: 'GET',
	        		             data: {
	        		             },
	        		             success: function (data) {
	        		           	 
	        		            	 unclaimSLP = data.items[0].total;
	        		            	 balance = claimSLP = data.items[0].blockchain_related.balance;
	  	                	    	claimSLP = data.items[0].blockchain_related.signature.amount;
	  	                	    	timestamp = data.items[0].last_claimed_item_at;
	  	                	    	 date = new Date(timestamp*1000);
	  	                	    	date.setDate(date.getDate() + 14); 
	  	                	    	
	        		           	     
	        		           	  
	        		           		  markup = markup +
	  	  	                		"<td>"+ (unclaimSLP - balance) +"</td>";
	        		           	  
	  	                		
	  			              	
	        		             	   
	        		           	}
	        		          })).then(function(){
    		     		        	   $.ajax(slpPrice,
    		     		        		         {
    		     		        		             type: 'GET',
    		     		        		             data: {
    		     		        		             },
    		     		        		             success: function (data) {
    		     		        		           	    document.getElementById("spanslpPrice").innerHTML = "&#8369;" +data.market_data.current_price.php;
    		     		        		           	 	pesoConvert = number_format((data.market_data.current_price.php * (unclaimSLP - balance)), 2, '.', ',');
    		     		        		           	 
    		     		        		            	
    		     		        		            	 markup = markup +
    		     		 	  			              	"<td>&#8369;"+ pesoConvert +"</td>" +
    		     		 	  			                "<td>"+ claimSLP +"</td>"+
    		     		 	  			            	"<td>"+ date.toLocaleDateString("en-US") +"</td><tr>";
    		     		 	  			              	  tableBody = $("table tbody");
    		     		 	  			              	  tableBody.append(markup); 
    		     		  	                		
    		     		        		             	   
    		     		        		           	}
    		     		        		          }); 
    		     			 
					        		        	  
    		     			 
    		     		 		  });
    		  
    			 
    			 
    			 
    		 		  });
 
 
 
      });
	 
	  $(document).ajaxStart(function(){
		    $('#loading').show();
		 }).ajaxStop(function(){
		    $('#loading').hide();
		 });
	
  });
  
  

});  
 
 function number_format (number, decimals, dec_point, thousands_sep) {
     number = number.toFixed(decimals);

     var nstr = number.toString();
     nstr += '';
     x = nstr.split('.');
     x1 = x[0];
     x2 = x.length > 1 ? dec_point + x[1] : '';
     var rgx = /(\d+)(\d{3})/;

     while (rgx.test(x1))
         x1 = x1.replace(rgx, '$1' + thousands_sep + '$2');

     return x1 + x2;
 }
 


 

/* $(document).ready(function(){
	  $("button").click(function(){
	    $.ajax({url: "https://game-api.skymavis.com/game-api/clients/0x3fdaf608774b6ce0a2b0815136285f6265930d9f/items?offset=0&limit=20", success: function(result){
	      $("#div1").html(result);
	    }});
	  }) */
</script>
</html>