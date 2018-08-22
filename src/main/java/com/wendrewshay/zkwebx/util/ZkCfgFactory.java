package com.wendrewshay.zkwebx.util;

public class ZkCfgFactory {

	private static ZkCfgManager _instance;
	
	public static ZkCfgManager createZkCfgManager(){
		if (_instance == null) {
			synchronized(ZkCfgFactory.class) {
				if (_instance == null) {
					_instance = new ZkCfgManagerImpl();
					_instance.init();
				}
			}
		}
		return _instance;
	}

}
