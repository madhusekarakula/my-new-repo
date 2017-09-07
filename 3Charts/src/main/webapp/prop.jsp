<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page isELIgnored="false" language="java"
	contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.bundle.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.bundle.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>

<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
	<jsp:include page="/prop"></jsp:include>
	<table border=2px align="center" width="200">
		<tr width="400">
			<c:forEach var="ids" items="${allids}">

				<td><canvas id="${ids}" width="300" height="250"></canvas></td>

			</c:forEach>
		</tr>
	</table>
	<script type="text/javascript">
	
	
	function get_random_color() 
	{
		var colour=[];
	    var color = "";
	    for(var i = 0; i < 6; i++) {
	        var sub = Math.floor(Math.random() * 256).toString(16);
	        color += (sub.length == 1 ? "0" + sub : sub);
	     colour[i]="#" +color;
	    }
	    console.log(colour);
	    return  colour;
	}


	var console = {};
	console.log = function(){};
	//console._commandLineAPI.clear();
	///2222222222222222222
	
var piechart1;
var barchart1;
var linechart1;
var doughnutchart1;
var map=new Map();
		function setSession(fieldname, labelname) {
			console.log("second ajax call");
			$.ajax({
						url : "NextProp",
						type : "POST",
						data : {
							field : fieldname,
							label : labelname,
					
						},
					
						success : function(data1) {
							alert("success feunc");
							
					
							
							for ( var index in data1) {
								
								var labeldata = [];
								var labelcounts = [];
								data = data1[index];

								$.each(data.bucketKeys, function(i, item) {
									labeldata.push(item);

								});

								$.each(data.bucketCounts, function(i, item) {
									labelcounts.push(item);

								});

								///options file or drill file
								if (data.chartType == "bar") {
									bar(labeldata,labelcounts,data);

								} else if (data.chartType == "pie") {
									pie(labeldata,labelcounts,data);

								} else if (data.chartType == "line") {
									line(labeldata,labelcounts,data);

								}else if (data.chartType == "doughnut") {
									doughnut(labeldata,labelcounts,data);

							}
								
								console.log(myMap.get(data.id));
					          myMap.get(data.id).destroy();
					
					// map.get(data.id).destroy();
								function pie(labeldata,labelcounts,data) {
									var datedrilpiechartdata = {
										labels : labeldata,
										datasets : [ {
											label : 'PieChart MakerName & Count',
											data : labelcounts,
											backgroundColor :  get_random_color(),

											borderColor : get_random_color(),
											borderWidth : [ 1, 1, 1, 1, 1 ]
										} ]
									};

									 piechart1 = new Chart(document
											.getElementById(data.id), {
										type : data.chartType,
										data : datedrilpiechartdata,
										options :{
											'onClick' : function(event,
													item) {
												var labelname = labeldata[item[0]._index];
												console.log(labelname);
											 var fieldname = data.fieldname;
											 piechart1.destroy();
											setSession(fieldname,labelname);
											
											}
										}
									});
								//piechart1.destroy();
								}
																					
								
								
								function doughnut(labeldata,labelcounts,data) {
									var datedrilpiechartdata = {
										labels : labeldata,
										datasets : [ {
											label : 'PieChart MakerName & Count',
											data : labelcounts,
											backgroundColor : get_random_color(),

											borderColor :  get_random_color(),
											borderWidth : [ 1, 1, 1, 1, 1 ]
										} ]
									};

									 doughnutchart1 = new Chart(document
											.getElementById(data.id), {
										type : data.chartType,
										data : datedrilpiechartdata,
										options :{
											'onClick' : function(event,
													item) {
												var labelname = labeldata[item[0]._index];
												console.log(labelname);
											 var fieldname = data.fieldname;
											setSession(fieldname,labelname);
											}
										}
									});
									// doughnutchart1.destroy();
									//map.set(data.id,doughnutchart1);
								}
								
								
								
								
								
								
								
								
								
								function line(labeldata,labelcounts,data) {
									var datedrillinechartdata = {
										labels : labeldata,
										datasets : [
												{
													label : 'Yearwise MakerNames&Count',

													data : labelcounts,
													//label:b,
													fill : false,
													lineTension : 0.1,
													backgroundColor :  get_random_color(),
													borderColor :  get_random_color(),
													pointHoverBackgroundColor : "rgba(59, 89, 152, 1)",
													pointHoverBorderColor : "rgba(59, 89, 152, 1)",
												},

										]
									};
                                    
									 linechart1 = new Chart(document
											.getElementById(data.id), {
										type : data.chartType,
										data : datedrillinechartdata,
										options :{
											'onClick' : function(event,
													item) {
												var labelname = labeldata[item[0]._index];
												console.log(labelname);
											 var fieldname = data.fieldname;
											setSession(fieldname,labelname);
											}
										}
									});
									//map.set(data.id,linechart1);
								//	linechart1.destroy();
								}

								function bar(labeldata,labelcounts,data) {

									var datedrilbarchartdata = {

										labels : labeldata,
										datasets : [ {
											//label:b,
											label : 'Yearwise MakerNames&Count',
											data : labelcounts,
											backgroundColor : get_random_color(),
											borderColor :  get_random_color(),
											borderWidth : 1
										} ]
									};

									 barchart1 = new Chart(document												
											.getElementById(data.id), {
										type : data.chartType,
										data : datedrilbarchartdata,
										options :{
											'onClick' : function(event,
													item) {
												var labelname = labeldata[item[0]._index];
												console.log(labelname);
											 var fieldname = data.fieldname;
											setSession(fieldname,labelname);
											}
										}
								
									});
									//map.set(data.id,barchart1);
									//barchart1.destroy();
								} //bar func close
							} // for loop close
						}

					});
		}

		var linechart;
		var piechart;
		var barchart;
		var doughnutchart;
		var myMap = new Map();  

		/////1111////.....................................................................................................................................
		$(document).ready(second);
		function second() {
			console.log("first ajax call");
			$
					.ajax({
						url : "prop",
						type : "POST",
						dataType : "json",
						success : function(data1) {

							for ( var index in data1) {
								var labeldata = [];
								var labelcounts = [];
								data = data1[index];

								$.each(data.bucketKeys, function(i, item) {
									labeldata.push(item);

								});

								$.each(data.bucketCounts, function(i, item) {
									labelcounts.push(item);

								});

								///options file or drill file
								if (data.chartType == "bar") {
									bar(labeldata,labelcounts,data);

								} else if (data.chartType == "pie") {
									pie(labeldata,labelcounts,data);

								} else if (data.chartType == "line") {
									line(labeldata,labelcounts,data);

								}else if (data.chartType == "doughnut") {
									doughnut(labeldata,labelcounts,data);

								}
								
								
								/*    var options = {
								    		'onClick' :function (event, item)  {
								    			setSession(event, item)
								    			} ,

								    		 tooltips :  {
									    		    callbacks: {
									    		        label: function(seconddrill) {
									    		        	
									    		        	  return  "  makerName::   "+aa[seconddrill.index] +"  nofvechicles::   "+	 bb[seconddrill.index];
									    		        	
									    		   			
									    		        }
									    		    }
									    		}
							                
							                
								    };
									
								     */
									
									
								
								

								function pie(labeldata,labelcounts,data) {
									var datedrilpiechartdata = {
										labels : labeldata,
										datasets : [ {
											label : 'PieChart MakerName & Count',
											data : labelcounts,
											backgroundColor : get_random_color(),





											borderColor : 
												 get_random_color(),
											borderWidth : [ 1, 1, 1, 1, 1 ]
										} ]
									};

									piechart = new Chart(
											document.getElementById(data.id),
											{
												type : data.chartType,
												data : datedrilpiechartdata,
												options : {
													'onClick' : function(event,
															item) {
														var labelname = labeldata[item[0]._index];
														console.log(labelname);
													 var fieldname = data.fieldname;
													setSession(fieldname,labelname);
													}
												}
											});
									myMap.set(data.id,piechart);
									
								}

										function doughnut(labeldata,labelcounts,data) {
											var datedrillinechartdata = {
												labels : labeldata,
												datasets : [
														{
															label : 'Yearwise MakerNames&Count',

															data : labelcounts,
															//label:b,
															fill : false,
															lineTension : 0.1,
															backgroundColor : "rgba(59, 89, 152, 0.75)",
															borderColor : "rgba(59, 89, 152, 1)",
															pointHoverBackgroundColor : "rgba(59, 89, 152, 1)",
															pointHoverBorderColor : "rgba(59, 89, 152, 1)",
														},

												]
											};
										
											doughnutchart = new Chart(
													document.getElementById(data.id),
													{
														type : data.chartType,
														data : datedrillinechartdata,
														options : {
															'onClick' : function(event,
																	item) {
																var labelname = labeldata[item[0]._index];
																console.log(labelname);
																var fieldname = data.fieldname;
																//var ids=data.id;
																setSession(fieldname,
																labelname);
															}
														}

													});
										myMap.set(data.id,doughnutchart);
										}
								     
								     
								function line(labeldata,labelcounts,data) {
									var datedrillinechartdata = {
										labels : labeldata,
										datasets : [
												{
													label : 'Yearwise MakerNames&Count',

													data : labelcounts,
													//label:b,
													fill : false,
													lineTension : 0.1,
													backgroundColor :  get_random_color(),
													borderColor :  get_random_color(),
													pointHoverBackgroundColor : "rgba(59, 89, 152, 1)",
													pointHoverBorderColor : "rgba(59, 89, 152, 1)",
												},

										]
									};
								
									linechart = new Chart(
											document.getElementById(data.id),
											{
												type : data.chartType,
												data : datedrillinechartdata,
												options : {
													'onClick' : function(event,
															item) {
														var labelname = labeldata[item[0]._index];
														console.log(labelname);
														var fieldname = data.fieldname;
														//var ids=data.id;
														setSession(fieldname,
														labelname);
													}
												}

											});
								myMap.set(data.id,linechart);
								}

								function bar(labeldata,labelcounts,data) {

									var datedrilbarchartdata = {

										labels : labeldata,
										datasets : [ {
											//label:b,
											label : 'Yearwise MakerNames&Count',
											data : labelcounts,
											backgroundColor :  get_random_color(),
											borderColor : get_random_color(),
											borderWidth : 1
										} ]
									};

									barchart = new Chart(
											document.getElementById(data.id),
											{
												type : data.chartType,
												data : datedrilbarchartdata,
												options : {
													'onClick' : function(event,
															item) {
														var labelname = labeldata[item[0]._index];
														console.log(labelname);
														var fieldname = data.fieldname;
														//	var ids=data.id;
														setSession(fieldname,
																labelname);
													}
												}
											});
									myMap.set(data.id,barchart);
								} //bar func close
							}
							console.log(myMap);
						}
					});// ajax
		}
	</script>
</body>
</html>