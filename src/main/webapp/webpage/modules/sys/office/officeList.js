<%@ page contentType="text/html;charset=UTF-8" %>
<script>
var $treeTable = null;
	$(document).ready(function() {
        $treeTable = $('#treeTable').treeTable({
            theme: 'vsStyle',
				expandLevel : 8,
				column:0,
				checkbox: false,
            url: '${ctx}/sys/office/getChildren?parentId=',
            callback: function (item) {
	            	var officeItemTpl= $("#officeItemTpl").html();
					item.typeLabel = jp.getDictLabel(${fns:toJson(fns:getDictList('sys_office_type'))}, item.type);
                    var result = laytpl(officeItemTpl).render(item);
                    // setTimeout(function(){
                    // 	$('.vsStyle_last_shut').each(function(){
                    // 	    debugger
					// 		this.click();
					// 	});
					// },500);
	                return result;
            },
            beforeClick: function ($treeTable, id) {
                //异步获取数据 这里模拟替换处理
                $treeTable.refreshPoint(id);
            },
            beforeExpand: function ($treeTable, id) {
            },
            afterExpand: function ($treeTable, id) {
                //layer.closeAll();
            },
            beforeClose: function ($treeTable, id) {

            }
        });

	});

function del(con, id) {
    if (id === '3047aa3389144fc1916cf93fbd68f1d2') {
        jp.alert('根节点不可删除!');
        return;
    }
    if (id === 'e684ba5b88ae4b56b34a0625d9d372a8') {
        jp.alert('物流公司分类不可删除!');
        return;
    }
    if (id === '9330c28235614c8eb5ed146486612a07') {
        jp.alert('水产加工厂分类不可删除!');
        return;
    }
    jp.confirm('警告：如果机构以及子机构下有用户，则删除会导致这些用户出现不可预料的问题，删除前，请确认用户管理中所有用户不再属于机构，确认要删除机构吗？', function () {
        jp.loading();
        $.get("${ctx}/sys/office/delete?id=" + id, function (data) {
       	  		if(data.success){
       	  			$treeTable.del(id);
       	  			jp.success(data.msg);
       	  		}else{
       	  			jp.error(data.msg);
       	  		}
       	  	})

   		});

}

	function refresh(){//刷新
		var index = jp.loading("正在加载，请稍等...");
		$treeTable.refresh();
		jp.close(index);
	}
	function refreshNode(data) {
        var current_id = data.body.office.id;
        var target = $treeTable.get(current_id);
        var old_parent_id = target.attr("pid") == undefined?'0':target.attr("pid");
        var current_parent_id = data.body.office.parentId;
        var current_parent_ids = data.body.office.parentIds;

        if(old_parent_id == current_parent_id){
            if(current_parent_id == '0'){
                $treeTable.refreshPoint(-1);
            }else{
                $treeTable.refreshPoint(current_parent_id);
            }
        }else{
            $treeTable.del(current_id);//刷新删除旧节点
            $treeTable.initParents(current_parent_ids, "0");
        }
    }
</script>
<script type="text/html" id="officeItemTpl">
<td><a  href="#" onclick="jp.openViewDialog('查看机构', '${ctx}/sys/office/form?id={{d.id}}','800px', '600px')">{{d.name}}</a></td>
<td>{{# if(d.area){ }} {{d.area.name}} {{# } }}</td>
<td>{{d.typeLabel === undefined ? "": d.typeLabel }}</td>
<td>{{d.remarks === undefined ? "":d.remarks}}</td>
<td>
	<div class="btn-group">
 		<button type="button" class="btn  btn-primary btn-xs dropdown-toggle" data-toggle="dropdown">
			<i class="fa fa-cog"></i>
			<span class="fa fa-chevron-down"></span>
		</button>
	  <ul class="dropdown-menu" role="menu">
		<shiro:hasPermission name="sys:office:view">
			<li><a href="#" onclick="jp.openViewDialog('查看机构', '${ctx}/sys/office/form?id={{d.id}}','800px', '600px')"  ><i class="fa fa-search-plus"></i>  查看</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="sys:office:edit">
			<li><a href="#" onclick="jp.openSaveDialog('修改机构', '${ctx}/sys/office/form?id={{d.id}}','800px', '600px')" ><i class="fa fa-edit"></i> 修改</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="sys:office:del">
			<li><a  onclick="return del(this, '{{d.id}}')"><i class="fa fa-trash"></i> 删除</a></li>
		</shiro:hasPermission>
		<shiro:hasPermission name="sys:office:add">
			<li><a href="#" onclick="jp.openSaveDialog('添加下级机构', '${ctx}/sys/office/form?parent.id={{d.id}}','800px', '600px')"><i class="fa fa-plus"></i> 添加下级机构</a></li>
		</shiro:hasPermission>
	  </ul>
	</div>
</td>
</script>