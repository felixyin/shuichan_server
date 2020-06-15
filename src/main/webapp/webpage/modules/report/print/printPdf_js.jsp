<%@ page contentType="text/html;charset=UTF-8" %>

<script>

    function exportPayOrder(agent_name, index) {
        console.log(agent_name, index);
        $('input').first().val(agent_name);
        refresh();
        setTimeout(function () {
            $('#scOrderTable>tbody>tr:not(".detail-view")').find('.detail-icon').click();
            setTimeout(function () {
                var preName = $('input').first().val();
                var beginDate = $('#beginDate_laji').val();
                var endDate = $('#endDate_laji').val();
                var fileName = '';
                if (preName) {
                    fileName += preName + ' - ';
                }
                if (beginDate === endDate) {
                    fileName += beginDate;
                } else {
                    fileName += (beginDate + ' - ' + endDate);
                }
                html2pdf().set({
                    margin: [5, 1],
                    filename: fileName + '.pdf',
                    pagebreak: {mode: ['avoid-all', 'legacy']},
                    jsPDF: {format: 'a3', orientation: 'landscape', compress: true}
                }).from(document.body).save();
                setTimeout(function () {
                    $("#reset").click();
                }, 2000);
            }, 2000);
        }, 2000);
    }

    $(function () {

        $('#switchDetail').click(function () {
            $('#scOrderTable>tbody>tr:not(".detail-view")').find('.detail-icon').click();
        });
        $('#printPdf').click(function () {
            var preName = $('input').first().val();
            var beginDate = $('#beginDate_laji').val();
            var endDate = $('#endDate_laji').val();
            var fileName = '';
            if (preName) {
                fileName += preName + ' - ';
            }
            if (beginDate === endDate) {
                fileName += beginDate;
            } else {
                fileName += (beginDate + ' - ' + endDate);
            }
            jp.confirm('仅导出表格?', function () {
                html2pdf().set({
                    margin: [5, 1],
                    filename: fileName + '.pdf',
                    pagebreak: {mode: ['avoid-all', 'legacy']},
                    jsPDF: {format: 'a3', orientation: 'landscape', compress: true}
                }).from(document.getElementById("scOrderTable")).save();
            }, function () {
                html2pdf().set({
                    margin: [5, 1],
                    filename: fileName + '.pdf',
                    pagebreak: {mode: ['avoid-all', 'legacy']},
                    jsPDF: {format: 'a3', orientation: 'landscape', compress: true}
                }).from(document.body).save();
            });
        });

    });
</script>