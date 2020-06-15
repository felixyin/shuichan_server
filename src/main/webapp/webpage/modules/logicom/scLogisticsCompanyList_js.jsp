<%@ page contentType="text/html;charset=UTF-8" %>
<script>
$(document).ready(function() {
	// 双击行，自动展开明细
	$(document).on('dblclick', '#scLogisticsCompanyTable>tbody>tr:not(".detail-view")', function () {
		$(this).find('.detail-icon').click();
	});
	$('#scLogisticsCompanyTable').bootstrapTable({
		 
		  //请求方法
               method: 'post',
               //类型json
               dataType: "json",
               contentType: "application/x-www-form-urlencoded",
               //显示检索按钮
	       showSearch: true,
               //显示刷新按钮
               showRefresh: true,
               //显示切换手机试图按钮
               showToggle: true,
               //显示 内容列下拉框
    	       showColumns: true,
    	       //显示到处按钮
    	       showExport: true,
    	       //显示切换分页按钮
    	       showPaginationSwitch: true,
    	       //显示详情按钮
    	       detailView: true,
    	       	//显示详细内容函数
	           detailFormatter: "detailFormatter",
    	       //最低显示2行
    	       minimumCountColumns: 2,
               //是否显示行间隔色
               striped: true,
               //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）     
               cache: false,    
               //是否显示分页（*）  
               pagination: true,   
                //排序方式 
               sortOrder: "asc",  
               //初始化加载第一页，默认第一页
               pageNumber:1,   
               //每页的记录行数（*）   
               pageSize: 10,  
               //可供选择的每页的行数（*）    
               pageList: [10, 25, 50, 100],
               //这个接口需要处理bootstrap table传递的固定参数,并返回特定格式的json数据  
               url: "${ctx}/logicom/scLogisticsCompany/data",
               //默认值为 'limit',传给服务端的参数为：limit, offset, search, sort, order Else
               //queryParamsType:'',   
               ////查询参数,每次调用是会带上这个参数，可自定义                         
               queryParams : function(params) {
               	var searchParam = $("#searchForm").serializeJSON();
               	searchParam.pageNo = params.limit === undefined? "1" :params.offset/params.limit+1;
               	searchParam.pageSize = params.limit === undefined? -1 : params.limit;
               	searchParam.orderBy = params.sort === undefined? "" : params.sort+ " "+  params.order;
                   return searchParam;
               },
               //分页方式：client客户端分页，server服务端分页（*）
               sidePagination: "server",
               contextMenuTrigger:"right",//pc端 按右键弹出菜单
               contextMenuTriggerMobile:"press",//手机端 弹出菜单，click：单击， press：长按。
               contextMenu: '#context-menu',
               onContextMenuItem: function(row, $el){
                   if($el.data("item") == "edit"){
                   		edit(row.id);
                   }else if($el.data("item") == "view"){
                       view(row.id);
                   } else if($el.data("item") == "delete"){
                        jp.confirm('确认要删除该物流公司记录吗？', function(){
                       	jp.loading();
                       	jp.get("${ctx}/logicom/scLogisticsCompany/delete?id="+row.id, function(data){
                   	  		if(data.success){
                   	  			$('#scLogisticsCompanyTable').bootstrapTable('refresh');
                   	  			jp.success(data.msg);
                   	  		}else{
                   	  			jp.error(data.msg);
                   	  		}
                   	  	})
                   	   
                   	});
                      
                   } 
               },
              
               onClickRow: function(row, $el){
               },
               	onShowSearch: function () {
			$("#search-collapse").slideToggle();
		},
               columns: [{
		        checkbox: true
		       
		    }
			,{
		        field: 'name',
		        title: '物流名称',
		        sortable: true,
		        sortName: 'name'
		        ,formatter:function(value, row , index){
		        	value = jp.unescapeHTML(value);
				   <c:choose>
					   <c:when test="${fns:hasPermission('logicom:scLogisticsCompany:edit')}">
					      return "<a href='javascript:edit(\""+row.id+"\")'>"+value+"</a>";
				      </c:when>
					  <c:when test="${fns:hasPermission('logicom:scLogisticsCompany:view')}">
					      return "<a href='javascript:view(\""+row.id+"\")'>"+value+"</a>";
				      </c:when>
					  <c:otherwise>
					      return value;
				      </c:otherwise>
				   </c:choose>
		         }
		       
		    }
			,{
		        field: 'office.name',
		        title: '所属工厂',
		        sortable: true,
		        sortName: 'office.name'
		       
		    }
			,{
		        field: 'remarks',
		        title: '备注信息',
		        sortable: true,
		        sortName: 'remarks'
		       
		    }
		     ]
		
		});
		
		  
	  if(navigator.userAgent.match(/(iPhone|iPod|Android|ios)/i)){//如果是移动端

		 
		  $('#scLogisticsCompanyTable').bootstrapTable("toggleView");
		}
	  
	  $('#scLogisticsCompanyTable').on('check.bs.table uncheck.bs.table load-success.bs.table ' +
                'check-all.bs.table uncheck-all.bs.table', function () {
            $('#remove').prop('disabled', ! $('#scLogisticsCompanyTable').bootstrapTable('getSelections').length);
            $('#view,#edit').prop('disabled', $('#scLogisticsCompanyTable').bootstrapTable('getSelections').length!=1);
        });
		  
		$("#btnImport").click(function(){
			jp.open({
			    type: 2,
                area: [500, 200],
                auto: true,
			    title:"导入数据",
			    content: "${ctx}/tag/importExcel" ,
			    btn: ['下载模板','确定', '关闭'],
				btn1: function(index, layero){
					  jp.downloadFile('${ctx}/logicom/scLogisticsCompany/import/template');
				  },
			    btn2: function(index, layero){
						var iframeWin = layero.find('iframe')[0]; //得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
						iframeWin.contentWindow.importExcel('${ctx}/logicom/scLogisticsCompany/import', function (data) {
							if(data.success){
								jp.success(data.msg);
								refresh();
							}else{
								jp.error(data.msg);
							}
						   jp.close(index);
						});//调用保存事件
						return false;
				  },
				 
				  btn3: function(index){ 
					  jp.close(index);
	    	       }
			}); 
		});
	  $("#export").click(function(){//导出Excel文件
	        var searchParam = $("#searchForm").serializeJSON();
	        searchParam.pageNo = 1;
	        searchParam.pageSize = -1;
            var sortName = $('#scLogisticsCompanyTable').bootstrapTable("getOptions", "none").sortName;
            var sortOrder = $('#scLogisticsCompanyTable').bootstrapTable("getOptions", "none").sortOrder;
            var values = "";
            for(var key in searchParam){
                values = values + key + "=" + searchParam[key] + "&";
            }
            if(sortName != undefined && sortOrder != undefined){
                values = values + "orderBy=" + sortName + " "+sortOrder;
            }

			jp.downloadFile('${ctx}/logicom/scLogisticsCompany/export?'+values);
	  })
	  $("#search").click("click", function() {// 绑定查询按扭
		  $('#scLogisticsCompanyTable').bootstrapTable('refresh');
		});
	 
	 $("#reset").click("click", function() {// 绑定查询按扭
		  $("#searchForm  input").val("");
		  $("#searchForm  select").val("");
		   $("#searchForm  .select-item").html("");
		  $('#scLogisticsCompanyTable').bootstrapTable('refresh');
		});
		
		
	});
		
  function getIdSelections() {
        return $.map($("#scLogisticsCompanyTable").bootstrapTable('getSelections'), function (row) {
            return row.id
        });
    }
  
  function deleteAll(){

		jp.confirm('确认要删除该物流公司记录吗？', function(){
			jp.loading();  	
			jp.get("${ctx}/logicom/scLogisticsCompany/deleteAll?ids=" + getIdSelections(), function(data){
         	  		if(data.success){
         	  			$('#scLogisticsCompanyTable').bootstrapTable('refresh');
         	  			jp.success(data.msg);
         	  		}else{
         	  			jp.error(data.msg);
         	  		}
         	  	})
          	   
		})
  }
  
    //刷新列表
  function refresh() {
      $('#scLogisticsCompanyTable').bootstrapTable('refresh');
  }
  function add(){
	  jp.openSaveDialog('新增物流公司', "${ctx}/logicom/scLogisticsCompany/form",'800px', '500px');
  }
  
   function edit(id){//没有权限时，不显示确定按钮
       if(id == undefined){
	      id = getIdSelections();
	}
	jp.openSaveDialog('编辑物流公司', "${ctx}/logicom/scLogisticsCompany/form?id=" + id, '800px', '500px');
  }

  
 function view(id){//没有权限时，不显示确定按钮
      if(id == undefined){
             id = getIdSelections();
      }
        jp.openViewDialog('查看物流公司', "${ctx}/logicom/scLogisticsCompany/form?id=" + id, '800px', '500px');
 }
  
  
  
  
		   
  function detailFormatter(index, row) {
	  var htmltpl =  $("#scLogisticsCompanyChildrenTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
	  var html = Mustache.render(htmltpl, {
			idx:row.id
		});
	  $.get("${ctx}/logicom/scLogisticsCompany/detail?id="+row.id, function(scLogisticsCompany){
    	var scLogisticsCompanyChild1RowIdx = 0, scLogisticsCompanyChild1Tpl = $("#scLogisticsCompanyChild1Tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
		var data1 =  scLogisticsCompany.scLogisticsPriceList;
		for (var i=0; i<data1.length; i++){
			data1[i].dict = {};
			addRow('#scLogisticsCompanyChild-'+row.id+'-1-List', scLogisticsCompanyChild1RowIdx, scLogisticsCompanyChild1Tpl, data1[i]);
			scLogisticsCompanyChild1RowIdx = scLogisticsCompanyChild1RowIdx + 1;
		}
				
    	var scLogisticsCompanyChild2RowIdx = 0, scLogisticsCompanyChild2Tpl = $("#scLogisticsCompanyChild2Tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
		var data2 =  scLogisticsCompany.scLogisticsUserList;
		for (var i=0; i<data2.length; i++){
			data2[i].dict = {};
			data2[i].dict.status = jp.getDictLabel(${fns:toJson(fns:getDictList('logi_com_user_status'))}, data2[i].status, "-");
			addRow('#scLogisticsCompanyChild-'+row.id+'-2-List', scLogisticsCompanyChild2RowIdx, scLogisticsCompanyChild2Tpl, data2[i]);
			scLogisticsCompanyChild2RowIdx = scLogisticsCompanyChild2RowIdx + 1;
		}
				
      	  			
      })
     
        return html;
    }
  
	function addRow(list, idx, tpl, row){
		$(list).append(Mustache.render(tpl, {
			idx: idx, delBtn: true, row: row
		}));
	}
			
</script>
<script type="text/template" id="scLogisticsCompanyChildrenTpl">//<!--
	<div class="tabs-container">
		<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-{{idx}}-1" aria-expanded="true">物流价格</a></li>
				<li><a data-toggle="tab" href="#tab-{{idx}}-2" aria-expanded="true">快递员</a></li>
		</ul>
		<div class="tab-content">
				 <div id="tab-{{idx}}-1" class="tab-pane fade in active">
						<table class="ani table">
						<thead>
							<tr>
								<th>箱大于几斤</th>
								<th>箱小于几斤</th>
								<th>配送费</th>
								<th>备注信息</th>
							</tr>
						</thead>
						<tbody id="scLogisticsCompanyChild-{{idx}}-1-List">
						</tbody>
					</table>
				</div>
				<div id="tab-{{idx}}-2" class="tab-pane fade">
					<table class="ani table">
						<thead>
							<tr>
								<th>登录用户</th>
								<th>状态</th>
								<th>更新时间</th>
								<th>备注信息</th>
							</tr>
						</thead>
						<tbody id="scLogisticsCompanyChild-{{idx}}-2-List">
						</tbody>
					</table>
				</div>
		</div>//-->
	</script>
	<script type="text/template" id="scLogisticsCompanyChild1Tpl">//<!--
				<tr>
					<td>
						{{row.gtJin}}
					</td>
					<td>
						{{row.ltJin}}
					</td>
					<td>
						{{row.price}}
					</td>
					<td>
						{{row.remarks}}
					</td>
				</tr>//-->
	</script>
	<script type="text/template" id="scLogisticsCompanyChild2Tpl">//<!--
				<tr>
					<td>
						{{row.user.name}}
					</td>
					<td>
						{{row.dict.status}}
					</td>
					<td>
						{{row.updateDate}}
					</td>
					<td>
						{{row.remarks}}
					</td>
				</tr>//-->
	</script>
