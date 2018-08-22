<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<jsp:include page="head.jsp"></jsp:include>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>This is ZkWeb</title>
<script type="text/javascript">

	$(function(){
		initDataGrid();
	});

	function initDataGrid(){
		$('#zkweb_zkcfg').datagrid({
			onClickRow:function(rowIndex, rowData){
				//alert(rowData.DES);
				initTree(rowData.ID);
			},
			url:'zkcfg/queryZkCfg'
		});
	}
	

    /****************************************************************************************************************************/
    
    function initTree(cacheId){
    	
    	$('#zkTree').tree({
    		checkbox: false,
    		url: "zk/queryZnode?cacheId="+cacheId,
    		animate:true,
    		lines:true,
    		onContextMenu: function(e,node){  
                e.preventDefault();  
                $(this).tree('select',node.target);  
                $('#mm').menu('show',{  
                    left: e.pageX,  
                    top: e.pageY  
                });  
            },
    		onClick:function(node){
    			var tab = $('#zkTab').tabs('getSelected');
    			//var index = $('#zkTab').tabs('getTabIndex',tab);
    			//alert(index);
    			if(tab != null){
    				tab.title=node.text;
    				//tab.panel('refresh', "zk/queryZnodeInfo?path="+node.attributes.path);
    				$('#zkTab').tabs('update', {
    					tab: tab,
    					options: {
    						title: node.text,
    						href: "zk/queryZnodeInfo?path="+encodeURI(encodeURI(node.attributes.path))+"&cacheId="+cacheId  
    					}
    				});
    			}else {
    				$('#zkTab').tabs('add',{
    					id:0,
    		            title:node.text,  
    		            href: "zk/queryZnodeInfo?path="+encodeURI(encodeURI(node.attributes.path))+"&cacheId="+cacheId
    		            //closable:true  
    	        	}); 
    			}
    			
    		},
    		onBeforeExpand:function(node,param){
    			if(node.attributes != null){
    				$('#zkTree').tree('options').url = "zk/queryZnode?path="+encodeURI(encodeURI(node.attributes.path))+"&cacheId="+cacheId; 
    			}
    		}
    	});
    	
    }


    function remove(){ 
    	$.extend($.messager.defaults,{  
    		ok:"确定",  
    		cancel:"取消"  
    	});
    	
    	 var node = $('#zkTree').tree('getSelected');  
         if (node){  
         	if('/'==node.attributes.path || '/zookeeper'==node.attributes.path || '/zookeeper/quota'==node.attributes.path){
         		$.messager.alert('提示','不能删除此节点！');
         		return;
         	}
         	
         	 var _cfg = $('#zkweb_zkcfg').datagrid('getSelected');
             
             if(_cfg){
            	 
            	 $.messager.confirm('提示', '删除'+node.attributes.path+'下所有子节点！确认吗？', function(r){  
             	    if (r){  
                         //var s = node.text;  
                         if (node.attributes){  
                         	 _path = node.attributes.path ;
                         	 $.post("zk/deleteNode", {path: _path,cacheId:_cfg.ID},
                     				function(data){
                     					//alert("Data Loaded: " + data);
                     					$.messager.alert('提示', data);
                     					//initTree(_cfg.ID);
                     					//var tab = $('#zkTab').tabs('getTab',0);
                     					//alert(tab.title);
                     					$('#zkTab').tabs('close',0);
                     				}
                         	);
                         }  
             	    }  
                 }); 
             }

         }else {
         	$.messager.alert('提示', '请选择一个节点');
         };
    }  

    function collapse(){  
        var node = $('#zkTree').tree('getSelected');  
        $('#zkTree').tree('collapse',node.target);  
    }  

    function expand(){  
        var node = $('#zkTree').tree('getSelected');  
        $('#zkTree').tree('expand',node.target);  
    }

    function addzkNode(){
    	var _path = "/";
    	var node = $('#zkTree').tree('getSelected');  
        if (node){  
            //var s = node.text;  
            if (node.attributes){  
            	 _path = node.attributes.path ;
            }  
        }
        _nodeName = $('#zkNodeName').val();
        
        var _cfg = $('#zkweb_zkcfg').datagrid('getSelected');
        
        if(_cfg){
        	$.post("zk/createNode", { nodeName: _nodeName, path: _path,cacheId:_cfg.ID},
    			function(data){
    				//alert("Data Loaded: " + data);
    				$.messager.alert('提示', data);
    				$('#w').window('close');
    				initTree(_cfg.ID);
    			}
        	);
        }else {
        	
        	$.messager.alert('提示', '你必须选择一个配置');
        }
    }
    /****************************************************************************************************************************/
   
    function saveCfg(){
    	$.messager.progress();
	   	$('#zkweb_add_cfg_form').form('submit', {
	   		url: 'zkcfg/addZkCfg',
	   		onSubmit: function(){
	   			var isValid = $(this).form('validate');
	   			if (!isValid){
	   				$.messager.progress('close');	// hide progress bar while the form is invalid
	   			}
	   			return isValid;	// return false will stop the form submission
	   		},
	   		success: function(data){
	   			$.messager.alert('提示', data); 
		    	$('#zkweb_zkcfg').datagrid("reload");
		    	$('#zkweb_add_cfg').window('close');
	   			$.messager.progress('close');	// hide progress bar while submit successfully
	   		}
	   	});
    }
    
    function updateCfg(){
    	 
    	$.messager.progress();
	   	$('#zkweb_up_cfg_form').form('submit', {
	   		url: 'zkcfg/updateZkCfg',
	   		onSubmit: function(){
	   			var isValid = $(this).form('validate');
	   			if (!isValid){
	   				$.messager.progress('close');	// hide progress bar while the form is invalid
	   			}
	   			return isValid;	// return false will stop the form submission
	   		},
	   		success: function(data){
	   			$.messager.alert('提示', data); 
		    	$('#zkweb_zkcfg').datagrid("reload");
		    	$('#zkweb_up_cfg').window('close');
	   			$.messager.progress('close');	// hide progress bar while submit successfully
	   		}
	   	});
    }
    
    function openUpdateWin(){
    	
    	var _cfg = $('#zkweb_zkcfg').datagrid('getSelected');
    	if(_cfg){
    		$('#zkweb_up_cfg').window('open');
        	
        	$('#zkweb_up_cfg_form').form("load","zkcfg/queryZkCfgById?id="+_cfg.ID);
    	}else {
    		$.messager.alert('提示', '请选择一条记录');
    	}
    	
    }
    
    function openDelWin(){
    	
    	var _cfg = $('#zkweb_zkcfg').datagrid('getSelected');
    	if(_cfg){
    		
    		$.messager.confirm('提示', '确认删除这个配置吗?', function(r){  
                if (r){  
                    //alert('confirmed:'+r);  
					$.get('zkcfg/delZkCfg',{id:_cfg.ID},function(data){
						$.messager.alert('提示', data);
					});
					$('#zkweb_zkcfg').datagrid("reload");
					initTree();
					$('#zkTab').tabs('close',0);
                    //$('#zkweb_up_cfg').window('open');
                	//$('#zkweb_up_cfg_form').form("load","zkcfg/queryZkCfgById?id="+_cfg.ID);
                }  
            }); 
    		//$('#zkweb_zkcfg').datagrid('selectRow',0);
    	}else {
    		$.messager.alert('提示', '请选择一条记录');
    	}
    }
</script>

</head>


<body class="easyui-layout" id="zkweb_body">  

    <div data-options="region:'north',border:false" style="height:200px">
    
	    <center>
	    <table class="easyui-datagrid" title="zookeeper cfg" id="zkweb_zkcfg"
	           data-options="pagination:true,singleSelect:true,fitColumns:true,rownumbers:true,pageSize:5" toolbar="#zkweb_tb" >  
	        <thead>  
	            <tr>  
	                <th data-options="field:'ID'">ID</th>  
	                <th data-options="field:'DES'">DES</th>  
	                <th data-options="field:'CONNECTSTR'">CONNECTSTR</th>  
	                <th data-options="field:'SESSIONTIMEOUT'">SESSIONTIMEOUT</th>  
	            </tr>  
	        </thead>  
	    </table> 
	    
	    <div id="zkweb_tb">    
		    <a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="javascript:$('#zkweb_add_cfg').window('open');">添加</a>    
		    <a href="#" class="easyui-linkbutton" iconCls="icon-save" plain="true" onclick="openUpdateWin()">更新</a>    
		    <a href="#" class="easyui-linkbutton" iconCls="icon-no" plain="true" onclick="openDelWin()">删除</a>    
		</div>
	   	</center>
		    	
    </div> 
   
    <!--
    <div data-options="region:'east',split:true,collapsed:true,title:'East'" style="width:100px;padding:10px;">east region</div>  
    
    <div data-options="region:'south',border:false" style="height:50px;background:#A9FACD;padding:10px;">south region</div>  
    -->
    <div data-options="region:'west',split:true,title:'zookeeper tree'" style="width:150px;padding:10px;height:120px;">
    	<ul id="zkTree" class="easyui-tree" >
    	</ul> 
    	<!-- right -->
    	<div id="mm" class="easyui-menu" style="width:120px;">  
	        <div onclick="javascript:$('#w').window('open');" data-options="iconCls:'icon-add'">添加</div>  
	        <div onclick="remove()" data-options="iconCls:'icon-remove'">删除</div>  
	        <div class="menu-sep"></div>  
	        <div onclick="expand()">展开</div>  
	        <div onclick="collapse()">收起</div>  
        </div>
    </div> 
    
    <div data-options="region:'center'" border="false" style="overflow: hidden;">  
	    <div class="easyui-tabs" id="zkTab" data-options="tools:'#tab-tools',toolPosition:'left'">  
		    <div title="Home" style="padding:10px;">  
		        Welcome! 
		    </div>  
		</div>  
		<div id="tab-tools">  
        	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'" onclick="javascript:$('#w').window('open');"></a>  
        	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-remove'" onclick="remove()"></a>  
    	</div>
		
    </div>  
    
    <!-- add -->
    <div id="w" class="easyui-window" title="添加节点" data-options="iconCls:'icon-add',modal:true,closed:true,maximizable:false" style="width:500px;padding:10px;">  
        
        <div style="text-align:center;padding:5px">
        	输入节点名称:
       		<input id="zkNodeName" class="easyui-validatebox" type="text" data-options="required:true,tipPosition:'right'"></input> 
        </div>
        
        <div style="text-align:center;padding:5px">
        	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="addzkNode()">保存</a>
        	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#w').window('close');" >取消</a>  
        </div>
        
    </div>
    
    <div id="zkweb_add_cfg" class="easyui-window" title="添加配置信息" data-options="iconCls:'icon-add',modal:true,closed:true,maximizable:false" style="width:280px;height:170px;padding:10px;">  
        
        <form id="zkweb_add_cfg_form" method="post" action="zkcfg/addZkCfg">  
		    <table>    
		        <tr>    
		            <td>DES:</td>    
		            <td><input name="des" type="text"></input></td>    
		        </tr>    
		        <tr>    
		            <td>CONNECTSTR:</td>    
		            <td><input name="connectstr" type="text"></input></td>    
		        </tr>    
		        <tr>    
		            <td>SESSIONTIMEOUT:</td>    
		            <td><input name="sessiontimeout" type="text"></input></td>    
		        </tr>    
		        <tr>    
		            <td>
		            	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveCfg()">保存</a>
		            </td>    
		            <td>
		            	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#zkweb_add_cfg').window('close');" >取消</a> 
		            </td>    
		        </tr>    
		    </table>  
		</form>
        
    </div>  
    
    <div id="zkweb_up_cfg" class="easyui-window" title="更新配置信息" data-options="iconCls:'icon-update',modal:true,closed:true,maximizable:false" style="width:280px;height:170px;padding:10px;">  
        
        <form id="zkweb_up_cfg_form" method="post" action="zkcfg/updateZkCfg">  
            <input type="hidden" name="id"/>
		    <table>    
		        <tr>    
		            <td>DES:</td>    
		            <td><input name="des" type="text"></input></td>    
		        </tr>    
		        <tr>    
		            <td>CONNECTSTR:</td>    
		            <td><input name="connectstr" type="text"></input></td>    
		        </tr>    
		        <tr>    
		            <td>SESSIONTIMEOUT:</td>    
		            <td><input name="sessiontimeout" type="text"></input></td>    
		        </tr>    
		        <tr>    
		            <td>
		            	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="updateCfg()">保存</a>
		            </td>    
		            <td>
		            	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#zkweb_up_cfg').window('close');" >取消</a> 
		            </td>    
		        </tr>    
		    </table>  
		</form>
        
    </div>  

</body> 

</html>