package com.charts;

import java.net.InetAddress;
import java.net.UnknownHostException;

import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.InetSocketTransportAddress;
import org.elasticsearch.transport.client.PreBuiltTransportClient;

public class GetClientObjectUti extends Object {

	static TransportClient client = null;

	static {

		try {
			System.out.println("Client Object");
			client = new PreBuiltTransportClient(Settings.EMPTY)
					.addTransportAddress(new InetSocketTransportAddress(InetAddress.getByName("localhost"), 9300))
					.addTransportAddress(new InetSocketTransportAddress(InetAddress.getByName("localhost"), 9300));

		} catch (UnknownHostException e) {

			e.printStackTrace();
		}
	}

	public static TransportClient getObject() {
		return client;
	}

}
