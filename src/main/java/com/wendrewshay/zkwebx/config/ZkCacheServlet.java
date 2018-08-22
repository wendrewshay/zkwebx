package com.wendrewshay.zkwebx.config;

import com.wendrewshay.zkwebx.util.ZkCache;
import com.wendrewshay.zkwebx.util.ZkCfgFactory;
import com.wendrewshay.zkwebx.util.ZkManagerImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet(urlPatterns = "/cache",loadOnStartup = 1)
public class ZkCacheServlet extends HttpServlet {
	
	private static final Logger log = LoggerFactory.getLogger(ZkCacheServlet.class);
	
	private static final long serialVersionUID = 1L;

    /**
     * Default constructor. 
     */
    public ZkCacheServlet() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		for(Map<String , Object> m : ZkCfgFactory.createZkCfgManager().query()){
			log.info("ID : {},CONNECTSTR : {},SESSIONTIMEOUT : {}",new Object[]{m.get("ID"),m.get("CONNECTSTR"),m.get("SESSIONTIMEOUT")});
			ZkCache.put(m.get("ID").toString(), ZkManagerImpl.createZk().connect(m.get("CONNECTSTR").toString(), Integer.parseInt(m.get("SESSIONTIMEOUT").toString())));
		}
		
		for(String key : ZkCache.get_cache().keySet()){
			log.info("key : {} , zk : {}",key,ZkCache.get(key));
		}
	}
	
	@Override
	public void init() throws ServletException {
		ZkCache.init(ZkCfgFactory.createZkCfgManager());
		log.info("init {} zk instance" , ZkCache.size());
		super.init();
	}

}
