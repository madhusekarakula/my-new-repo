package com.charts;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.aggregations.AggregationBuilders;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;

import com.google.gson.Gson;

public class NextProp extends HttpServlet {
	private static final long serialVersionUID = 1L;
	TransportClient client;

	Map<String, Object> chartParameterMap = new HashMap<String, Object>();
	Properties properties = new Properties();
	Map<String, Object> drilldata = new HashMap<String, Object>();

	public Map<String, Object> getCharts(String chartID, Map<String, Object> map,HttpSession session) throws IOException {
		// System.out.println(chartID);
		ArrayList<String> bucketKey = new ArrayList<String>();
		ArrayList<Long> bucketCount = new ArrayList<Long>();
		Properties properties = new Properties();
		properties.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("db.properties"));

		String[] chart = properties.getProperty(chartID).split(" ");

		chartParameterMap.put("index", chart[0]);
		chartParameterMap.put("docType", chart[1]);
		chartParameterMap.put("fieldname", chart[2]);
		chartParameterMap.put("size", chart[3]);
		chartParameterMap.put("chartType", chart[4]);
		chartParameterMap.put("agg", chart[5]);
		chartParameterMap.put("id", chartID);

		
			
		if(session.getAttribute("drill")!=null)
		{
			
		
		       BoolQueryBuilder qb2 = QueryBuilders.boolQuery()
			   .must(QueryBuilders.matchQuery(map.get("field").toString(), map.get("label").toString()));
		
		SearchResponse response1 = client.prepareSearch(chartParameterMap.get("index").toString())
				.setTypes(chartParameterMap.get("docType").toString()).setQuery(qb2)
				.addAggregation(AggregationBuilders.terms(chartParameterMap.get("agg").toString())
						.field(chartParameterMap.get("fieldname").toString())
						.size(Integer.parseInt(chartParameterMap.get("size").toString()))
						.order(Terms.Order.count(false)))
				.execute().actionGet();

		Terms agg = response1.getAggregations().get(chartParameterMap.get("agg").toString());

		// For each entry Bucket is used
		for (Terms.Bucket entry : agg.getBuckets()) {
			// JSONObject member = new JSONObject();
			String key = entry.getKey().toString(); // bucket key
			long docCount = entry.getDocCount();// bucket docCount
			bucketKey.add(key);
			bucketCount.add(docCount);
		}
		}
		chartParameterMap.put("bucketKeys", bucketKey);
		chartParameterMap.put("bucketCounts", bucketCount);
		System.out.println(chartParameterMap);
		
		return chartParameterMap;
	} // for
	    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	String field = req.getParameter("field");
		//System.out.println(field);
		/*String []allfields=req.getParameterValues("field");
		for (int i = 0; i < allfields.length; i++) {
			String field=allfields[i];
	*/
		String label = req.getParameter("label");
		System.out.println(field);
		System.out.println(label);
			drilldata.put("field", field);
		drilldata.put("label", label);
		 HttpSession session=req.getSession();
		session.setAttribute("drill", drilldata);
	
	
		client = GetClientObjectUti.getObject();

		Map<String, Object> mapobject = null;
		PrintWriter pw = resp.getWriter();
		resp.setContentType("text/json");
		properties.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("db.properties"));

		String[] allid = properties.getProperty("allids").split(" ");
		pw.println("[");
		for (int i = 0; i < allid.length; i++) {
			mapobject = getCharts(allid[i], drilldata,session);
			Gson gson = new Gson();
			String gsonTojson = gson.toJson(mapobject);
			pw.println(gsonTojson);
			if (i != allid.length - 1)
				pw.println(",");
			System.out.println(pw);
		}
		pw.println("]");

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}

}
