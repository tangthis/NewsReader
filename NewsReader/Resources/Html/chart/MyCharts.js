/*version:1.3*/
/*2015-04-01*/
var m_config = {
    chart_width: 730,
    chart_heigh: 400

};
var VersionUtil = {
    showversion: function () { $('#versiontip').show().text('1.3') },
    hideversion: function () { $('#versiontip').hide(); }
};

var MyHighCharts = {
    chart: {},
    title: "",
    xAxis: {},
    yAxis: {},
    tooltip: {
        valueSuffix: "%"
    },
    legend: {},
    plotOptions: {},
    credits: {
        enabled: false
    },
    series: {},
    mycharts: function (v_id, title, xaxis, yaxistext, danwei, v_series, islegend, reporttype) {

        MyHighCharts.chart = {};
        this.title = "";
        this.xAxis = {};
        this.yAxis = {};
        this.tooltip = { valueSuffix: "%" };
        this.plotOptions = {};
        this.series = {};
        if (checkSeriesNull(v_series) == 0) {
            $("#" + v_id).html("<image src='/resources/images/nodata_730.png' id='nodataImg' />");
            return false;
        } else {
            $("#" + v_id).html("");
        }
        if (v_series.length == 1 && !v_series[0].name) {

            $("#chartContent").css({ "marginTop": "30px" })
            islegend = false;
        } else {
            $("#chartContent").css({ "marginTop": "0px" })
        }
        var data2 = { pointWidth: 25 };
        var chart_x_axix_width = 659;
        this.title = title;
        if (yaxistext != "") {
            yaxistext = "(" + yaxistext + ")";
        }
        m_config.chart_heigh = 400;
        this.tooltip.valueSuffix = danwei;
        this.chart = {};
        var newseries = toSeries(v_series, danwei);
        this.series = newseries;
        var v_type = "column";
        var data_length = 0;

        if (v_id == "") {
            v_id = "divchart";
        }
        $("#chartContent").css({ height: m_config.chart_heigh })
        ///////
        this.plotOptions = {
            column: {
                cursor: 'pointer',
                enabled: false,
                borderWidth: 0,

                dataLabels: {
                    crop: false,
                    overflow: "none",
                    inside: false,
                    enabled: true, style: { fontWeight: 'bold' },
                    formatter: function () {
                        if (this.point.isnull == "" || this.point.isnull == null) {
                            return '';
                        } else {

                            if (danwei == "分") {
                                return (this.y).toFixed(1);
                            } else {
                                return (this.y).toFixed(0);
                            }
                        }
                    }
                }
            }
        };
        ////图形判断
        if (xaxis == null) {
            return;
        }
        if (v_series != null) {
            // if (v_series.length > 10 || xaxis.length > 5 || (v_series.length > 5 && xaxis.length > 3)) {
            if ((v_series.length + xaxis.length) > 11) {
                v_type = "bar";
                // $("#chartContent").css({height:"1000px"})
                m_config.chart_heigh = data2.pointWidth * v_series.length * xaxis.length * 1.5 + 1.08 * (xaxis.length - 1);
              //  $("#chartContent").css({ height: m_config.chart_heigh })
                this.plotOptions = {
                    bar: {

                        cursor: 'pointer',
                        enabled: false,
                        borderWidth: 0,
                        pointPadding: 0.08,
                        groupPadding: 0.02,
                        pointWidth: data2.pointWidth,
                        minPointLength: 3,
                        //  connectNulls: true //连接数据为null的前后点
                        dataLabels: {

                            enabled: true,
                            style: {
                                fontWeight: 'bold'

                            }, formatter: function () {

                                if (this.point.isnull == "" || this.point.isnull == null) {
                                    return '';
                                } else {

                                    if (danwei == "分") {
                                        return (this.y).toFixed(1);
                                    } else {
                                        return (this.y).toFixed(0);
                                    }
                                }



                            }
                        }
                    }
                };
            }
        }

        if (reporttype == 2) {
            v_type = "line";
            m_config.chart_heigh = 400;

            this.plotOptions = {
                line: {
                    cursor: 'pointer',
                    enabled: false,
                    borderWidth: 0,
                    series: {

                        connectNulls: true //连接数据为null的前后点
                    },
                    dataLabels: {

                        enabled: true, style: { fontWeight: 'bold' }, formatter: function () {
                            if (danwei == "分") {
                                return this.y === null ? '' : (this.y).toFixed(1);
                            } else {
                                return this.y === null ? '' : (this.y).toFixed(0);
                            }
                        }
                    }
                }
            };
        }
        this.chart = {
            renderTo: v_id,
            type: v_type,
            reflow: true,
            ///spacingTop: 20,
            // plotBackgroundImage: '/resources/images/nodata_' + (chartWidth || 730) + '.png',
            width: m_config.chart_width//,
            //height: m_config.chart_heigh

        };
        ////////
        this.xAxis = {
            categories: xaxis,
            labels: {
                rotation:0
            }
        }
        this.yAxis = {
            min: 0,

            title: { text: yaxistext, align: 'high', rotation: 0 },
            labels: { overflow: 'justify' }


        }
        if (this.chart.type == "bar") {

            this.yAxis.opposite = true;

        }

        /////0刻度位置处理
        var newmax = this.checkseries(v_series);
        if (newmax > 0) {

            /// this.yAxis.max = Math.ceil(newmax);
            if (danwei == "%" && Math.ceil(newmax) >= 100) {
                this.yAxis.max = 100;
            }

            // this.yAxis.tickPixelInterval = 50;
            // this.yAxis.gridLineWidth = 0;
        } else {
            this.yAxis.max = Math.ceil(5);
            // this.yAxis.tickPixelInterval = 50;
        }


        if (this.chart.type == "column") {
            if (v_series.length > 1) {//每组柱子数量大于1

                for (var i = 0; i < v_series.length; i++) {
                    if (v_series[i].data.length >= data_length) {
                        data_length = v_series[i].data.length;
                    }
                }
                this.plotOptions.column.pointWidth = data2.pointWidth;
                this.plotOptions.column.pointPadding = 0.01;
                this.plotOptions.column.groupPadding = 0.02;//Math.max(0, (((chart_x_axix_width - v_series.length * data2.pointWidth * data_length) / (data_length * 2)) * data_length / chart_x_axix_width));
            }
            else {
                this.plotOptions.column.pointWidth = data2.pointWidth;
                this.plotOptions.column.groupPadding = 0;
            }
            if (xaxis != null) {
                if (xaxis.length > 4) {
                    this.xAxis.labels = { rotation: -70 };
                    m_config.chart_heigh += 150
                }

            }
        }
        if (this.chart.type == "line")
        {
            if (xaxis != null) {
                if (xaxis.length > 6) {
                    this.xAxis.labels = { rotation: -70 };
                    m_config.chart_heigh += 150
                }

            }
        }
        $("#chartContent").css({ height: m_config.chart_heigh })
        if (danwei == "分") {
            if (v_series.length == 1 && !v_series[0].name) {

                this.tooltip.headerFormat = '<table style="opacity: 1;">';
                this.tooltip.pointFormat = '<tr><td style="padding:0"><b>{point.y:.1f}' + danwei + '</b></td></tr>';
                this.tooltip.footerFormat = '</table>';
            } else {
                this.tooltip.pointFormat = '<tr style="opacity: 1;"><td style="color{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y:.1f}' + danwei + '</b></td></tr>';
            }
        } else {
            if (v_series.length == 1 && !v_series[0].name) {
                this.tooltip.headerFormat = '<table  style="opacity: 1;">';
                this.tooltip.pointFormat = '<tr><td style="padding:0"><b>{point.y:.0f}' + danwei + '</b></td></tr>';
                this.tooltip.footerFormat = '</table>';
            } else {
                this.tooltip.pointFormat = '<tr style="opacity: 1;"><td style="color{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y:.0f}' + danwei + '</b></td></tr>';
            }
        }
        this.legend = {
            layout: 'horizontal',
            align: 'center',
            verticalAlign: 'top',
            x: 0,
            y: 0,
            itemDistance: 20,
            borderRadius: 10,
            enabled: islegend,
            borderWidth: 1,
            borderColor: "#c9c9c9",
            floating: false,
            useHTML: false,
            backgroundColor: '#FFFFFF',
            itemStyle: { cursor: "pointer", color: "#717171" },
            shadow: false
        };
      
        //if (v_series == null) {
        //    this.series = undefined;
        //} else {
        //    if (v_series.length == 1 && v_series[0].data[0] == 0)
        //    {
        //        this.series = undefined;
        //    }
        //}

        // var v_tojson = JSON.stringify(MyHighCharts);
        var v_chart = new Highcharts.Chart(MyHighCharts)

        //var v_chart = new Highcharts.Chart({
        //    chart: MyHighCharts.chart,
        //    title: MyHighCharts.title,
        //    xaxis: MyHighCharts.xAxis,
        //    yAxis: MyHighCharts.yAxis,
        //    tooltip: MyHighCharts.tooltip,
        //    plotOptions: MyHighCharts.plotOptions,
        //    legend: MyHighCharts.legend,
        //    credits: {
        //        enabled: false
        //    },
        //    series: newseries
        //});

        //var newchart = $("#" + v_id).highcharts();
        //$(function () {
        //newchart.plotOptions.formatter = function () {
        //    return (this.y).toFixed(10);
        //}
        //})
    },
    mychartsphone: function (v_json, reporttype) {
        var islegend = true;
        var json = $.parseJSON(v_json);
        if (json.result != "ok") {

            return json.result;
        }
        if (yaxistext != "") {
            yaxistext = "(" + yaxistext + ")";
        }

        var data2 = { pointWidth: 20 };
        var chart_x_axix_width = $(window).width();
        this.title = "";
        var xaxis = json.data.xaxis;
        var yaxistext = json.data.unit;
        var v_series = json.data.series;
        var danwei = json.data.unit;
        this.tooltip.valueSuffix = danwei;
        this.legend = {};
        this.chart = {};
        var newseries = toSeries(v_series, danwei);
        this.series = newseries;
        var v_type = "column";
        var data_length = 0;

        if (danwei != "") {
            yaxistext = "(" + danwei + ")";
        }
        m_config.chart_width = $(window).width() - 10;
        m_config.chart_heigh = 400;


        var v_id = "divchart";
        if (checkSeriesNull(v_series) == 0) {
            $("#" + v_id).html("<image style='margin: 30% auto 0; width:100%;' src='nodata_730.png'/>");
            return false;
        } else {
            $("#" + v_id).html("");
        }
        this.plotOptions = {
            column: {
                cursor: 'pointer',
                enabled: false,
                borderWidth: 0,
                dataLabels: {
                    crop: false,
                    overflow: "none",
                    enabled: true, style: { fontWeight: 'bold' }, formatter: function () {
                        if (danwei == "分") {
                            return this.y === null ? '' : (this.y).toFixed(1);
                        } else {
                            return this.y === null ? '' : (this.y).toFixed(0);
                        }
                    }
                }
            }
        };
        ////图形判断
        if (xaxis == null) {
            return;
        }
        $("#divchart").css({ height: m_config.chart_heigh });
        if (v_series != null) {
            if ((v_series.length + xaxis.length) > 6) {
                v_type = "bar";
                var v_heights = data2.pointWidth * v_series.length * 2.0; //data2.pointWidth * v_series.length * xaxis.length * 1.5 + 1.08 * (xaxis.length - 1);//data2.pointWidth * v_series.length * 2.0;
             
               // if (v_heights > m_config.chart_heigh)
                {
                    m_config.chart_heigh=v_heights+50
                }
                //  m_config.chart_heigh += 800;
                this.plotOptions = {
                    bar: {

                        cursor: 'pointer',
                        enabled: false,
                        borderWidth: 0,
                       // pointPadding: 0.01,
                        groupPadding:0.01,
                        pointWidth: data2.pointWidth,
                        minPointLength: 3,
                        //  connectNulls: true //连接数据为null的前后点
                        dataLabels: {

                            enabled: true,
                            style: {
                                fontWeight: 'bold'

                            }, formatter: function () {

                                if (this.point.isnull == "" || this.point.isnull == null) {
                                    return '';
                                } else {

                                    if (danwei == "分") {
                                        return (this.y).toFixed(1);
                                    } else {
                                        return (this.y).toFixed(0);
                                    }
                                }



                            }
                        }
                    }
                };
            }
        }

        if (reporttype == 2) {
            m_config.chart_heigh = 400;

            v_type = "line";
            this.plotOptions = {
                line: {
                    cursor: 'pointer',
                    enabled: false,
                    borderWidth: 0,
                    dataLabels: {

                        enabled: true, style: { fontWeight: 'bold' }, formatter: function () {
                            if (danwei == "分") {
                                return this.y === null ? '' : (this.y).toFixed(1);
                            } else {
                                return this.y === null ? '' : (this.y).toFixed(0);
                            }
                        }
                    }
                }
            };
        }

        this.chart = {
            type: v_type,
            renderTo: v_id,
            //  spacingTop: 20,
            width: m_config.chart_width
            // height: m_config.chart_heigh
        }
        ////////
        this.xAxis = {
            categories: xaxis,
            labels: {}
        };
        if (this.chart.type == "column" && reporttype == "2") {
            this.xAxis.labels.enabled = false;
        }
        if (xaxis != null) {

            if (xaxis.length > 4) {
                this.xAxis.labels.rotation = -70;
                m_config.chart_heigh += 150;
            }

        }
        $("#divchart").css({ height: m_config.chart_heigh });
        this.yAxis = {
            min: 0,
            title: { text: yaxistext, align: 'high', rotation: 0 },
            labels: { overflow: 'justify' }

        }
        if (this.chart.type == "bar") {
            this.yAxis.opposite = true;
        }

        if (danwei == "%") {
            this.yAxis.max = 100;
        }
        /////0刻度位置处理
        // alert(this.checkseries(v_series));
        var newmax = this.checkseries(v_series);
        if (newmax > 0) {

            // this.yAxis.max = Math.ceil(newmax);
            if (danwei == "%" && Math.ceil(newmax) >= 100) {
                this.yAxis.max = 100;
            }

            // this.yAxis.tickPixelInterval = 50;
            // this.yAxis.gridLineWidth = 0;
        } else {
            this.yAxis.max = Math.ceil(5);
            // this.yAxis.tickPixelInterval = 50;
        }
        ///////

        if (this.chart.type == "column") {
            if (v_series.length > 1) {//每组柱子数量大于1

                for (var i = 0; i < v_series.length; i++) {
                    if (v_series[i].data.length >= data_length) {
                        data_length = v_series[i].data.length;
                    }
                }
                this.plotOptions.column.pointWidth = data2.pointWidth;
                this.plotOptions.column.pointPadding = 0.08;
                this.plotOptions.column.groupPadding = 0.01;// Math.max(0, (((chart_x_axix_width - v_series.length * data2.pointWidth * data_length) / (data_length * 2)) * data_length / chart_x_axix_width));
            }
            else {
                this.plotOptions.column.pointWidth = data2.pointWidth;
                this.plotOptions.column.groupPadding = 0;
            }
        }
        if (danwei == "分") {
            if (v_series.length == 1) {

                this.tooltip.headerFormat = '<table>';
                this.tooltip.pointFormat = '<tr><td style="padding:0"><b>{point.y:.1f}' + danwei + '</b></td></tr>';
                this.tooltip.footerFormat = '</table>';
            } else {
                this.tooltip.pointFormat = '<tr><td style="color{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y:.1f}' + danwei + '</b></td></tr>';
            }
        } else {
            if (v_series.length == 1) {

                this.tooltip.headerFormat = '<table>';
                this.tooltip.pointFormat = '<tr><td style="padding:0"><b>{point.y:.0f}' + danwei + '</b></td></tr>';
                this.tooltip.footerFormat = '</table>';
            } else {
                this.tooltip.pointFormat = '<tr><td style="color{series.color};padding:0">{series.name}: </td>' + '<td style="padding:0"><b>{point.y:.0f}' + danwei + '</b></td></tr>';
            }
        }
        if (v_series.length == 1) {
            islegend = false;
        }
        this.legend = {
            layout: 'horizontal',
            align: 'center',
            verticalAlign: 'top',
            x: 0,
            y: 40,
            borderRadius: 10,
            enabled: islegend,
            borderWidth: 1,
            borderColor: "#c9c9c9",
            floating: false,
            useHTML: false,
            backgroundColor: '#FFFFFF',
            itemStyle: { cursor: "pointer", color: "#717171" },
            shadow: false
        };
        //var v_tojson = "";
        //if ($.browser.version == "7.0" || $.browser.version == "6.0") {
        //   // v_tojson = jQuery.parseJSON(MyHighCharts);
        //    alert(v_tojson)
        //} else {
        //     v_tojson = jQuery.stringify(MyHighCharts);
        //}

        var v_chart = new Highcharts.Chart(MyHighCharts);


    },
    checkseries: function (v_series) {
        var maxargs = [];
        if (v_series != null) {
            // var v_bool = true;
            $.each(v_series, function (i, item) {
                var v_args = item.data;
                if (v_args != null) {

                    var v_num = Math.max.apply(null, v_args);
                    if (v_num > 0) {
                        maxargs.push(v_num);
                        // v_bool = false;
                        // return false;
                    }
                }

            });
            //return v_bool;
        } else {
            // return false;
        }
        if (maxargs.length > 0) {
            var v_num = Math.max.apply(null, maxargs);
            return v_num;
        } else {
            return 0;
        }
    }
};
function checkSeriesNull(series) {
    var k = 0;
    if (series != null) {
        $.each(series, function (i, item) {
            var v_args = {};
            try {
                v_args = item.data;
            } catch (e) {

            }
            if (v_args != null) {
                $.each(v_args, function (p, pk) {
                    if (pk != null && pk != "") {
                        k++;
                    }
                })
            }

        });

    }
    return k;

}
function toSeries(series, danwei) {

    var newseriesargs = new Array();
    if (series != null) {
        $.each(series, function (i, item) {
            var newseries = {};
            newseries.name = item.name;
            var v_args = item.data;
            newseries.data = [];
            if (v_args != null) {
                $.each(v_args, function (p, pk) {
                    var itemsargs = {};
                    // itemsargs.name = item.name;
                    if (pk != null && pk != "") {
                        var newvalues = 0.0;
                        if (danwei != "分") {
                            newvalues = parseFloat(pk).toFixed(0);
                        } else {
                            newvalues = parseFloat(pk).toFixed(1);
                        }
                        itemsargs.y = parseFloat(newvalues);
                        itemsargs.isnull = newvalues;
                    } else {
                        itemsargs.y = 0;
                        itemsargs.isnull = pk;
                    }
                    newseries.data.push(itemsargs);
                })
            }
            newseriesargs.push(newseries);
        });

    }
    return newseriesargs;

}

var TeacherHighCharts = {};

(function ($) {
    var SubjectType = {
        单选题: 1,
        多选题: 2,
        填空题: 3,
        打分题: 4,
        矩阵单选: 31,
        矩阵多选: 32,
        矩阵打分: 34,
        拖拉题: 8,
        段落说明: 9
    };

    var reportModule = {};
    var chartWidth = $(window).width();
    var ChartColumn = function (v_id, title, xaxis, yaxistext, danwei, v_series, islegend, disableXlabels) {
        if (yaxistext != "") {
            yaxistext = "(" + yaxistext + ")";
        }
        var totalCount = 0;
        if (v_series) {
            for (var i = 0; i < v_series.length; i++) {
                totalCount += v_series[i].data.length;
            }
        }
        if (checkSeriesNull(v_series) == 0) {
            $("#" + v_id).html("<image style='margin: 30% auto 0; width:100%;' src='nodata_730.png'/>");
            return false;
        } else {
            $("#" + v_id).html("");
        }

        if (totalCount < 7) {
            (function () {
                var chart_x_axix_width = chartWidth;
                var data2 = { pointWidth: 35 };

                this.plotOptions = {
                    column: {
                        cursor: 'pointer',
                        enabled: false,
                        borderWidth: 0,
                        dataLabels: {
                            crop: false,
                            overflow: "none",
                            enabled: true, style: { fontWeight: 'bold', fontsize: 10 }, formatter: function () {
                                if (danwei == "分") {
                                    return this.y === null ? '' : (this.y).toFixed(1);
                                } else {
                                    return this.y === null ? '' : (this.y).toFixed(0);
                                }
                            }
                        }
                    }
                };

                if (v_series.length > 0) {
                    var data_length = 0;
                    for (var i = 0; i < v_series.length; i++) {
                        if (v_series[i].data.length >= data_length) {
                            data_length = v_series[i].data.length;
                        }
                    }
                    if (data2.isFalseGrouping) {
                    }
                    else if (v_series.length > 1) {//每组柱子数量大于1
                        this.plotOptions.column.pointPadding = 0.2;
                        this.plotOptions.column.groupPadding = Math.max(0, (((chart_x_axix_width - v_series.length * data2.pointWidth * data_length) / (data_length * 2)) * data_length / chart_x_axix_width));
                    }
                    else {
                        this.plotOptions.column.pointWidth = data2.pointWidth;
                        this.plotOptions.column.groupPadding = 0;
                    }
                }


                var v_yAxis = { min: 0, title: { text: yaxistext, align: "high", rotation: 0 } };
                var newmax = MyHighCharts.checkseries(v_series);
                if (newmax > 0) {

                    v_yAxis.max = Math.ceil(newmax);
                    if (danwei == "%" && Math.ceil(newmax) >= 100) {
                        v_yAxis.max = 100;
                    }
                } else {
                    v_yAxis.max = Math.ceil(5);
                }

                if (totalCount == 0) {
                    $('#' + v_id).highcharts({
                        chart: {
                            type: 'column',
                            width: chartWidth,
                            height: 400
                        },
                        title: {
                            align: 'left',
                            text: "<div style='white-space:normal;word-break:break-all;'>" + title + "</div>",
                            useHTML: true
                        },
                        tooltip: { valueSuffix: danwei },
                        legend: {
                            layout: 'horizontal',
                            align: 'center',
                            verticalAlign: 'top',
                            x: 0,
                            y: 40,
                            borderRadius: 10,
                            enabled: islegend,
                            borderWidth: 1,
                            borderColor: "#c9c9c9",
                            floating: false,
                            useHTML: false,
                            backgroundColor: '#FFFFFF',
                            itemStyle: { cursor: "pointer", color: "#717171" },
                            shadow: false
                        },
                        xAxis: { categories: xaxis, labels: { enabled: !disableXlabels } },
                        yAxis: v_yAxis,
                        plotOptions: this.plotOptions,
                        series: v_series
                    });
                } else {
                    $('#' + v_id).highcharts({
                        chart: { type: 'column', width: chartWidth, height: 400 },
                        title: {
                            align: 'left',
                            text: "<div style='white-space:normal;word-break:break-all;'>" + title + "</div>",
                            useHTML: true
                        },
                        tooltip: { valueSuffix: danwei },
                        legend: {
                            layout: 'horizontal',
                            align: 'center',
                            verticalAlign: 'top',
                            x: 0,
                            y: 40,
                            borderRadius: 10,
                            enabled: islegend,
                            borderWidth: 1,
                            borderColor: "#c9c9c9",
                            floating: false,
                            useHTML: false,
                            backgroundColor: '#FFFFFF',
                            itemStyle: { cursor: "pointer", color: "#717171" },
                            shadow: false
                        },
                        xAxis: { categories: xaxis, labels: { enabled: !disableXlabels } },
                        yAxis: v_yAxis,
                        plotOptions: this.plotOptions,
                        series: v_series
                    });
                }
            })();
        } else {
            (function () {
                var data_length = 0;
                for (var i = 0; i < v_series.length; i++) {
                    if (v_series[i].data.length >= data_length) {
                        data_length = v_series[i].data.length;
                    }
                }
                var v_yAxis = { min: 0, title: { text: yaxistext, align: "high", rotation: 0 }, labels: { overflow: 'justify' } };
                var newmax = MyHighCharts.checkseries(v_series);
                if (newmax > 0) {

                    v_yAxis.max = Math.ceil(newmax);
                    if (danwei == "%" && Math.ceil(newmax) >= 100) {
                        v_yAxis.max = 100;
                    }
                } else {
                    v_yAxis.max = Math.ceil(5);
                }
                $('#' + v_id).highcharts({
                    chart: { type: 'bar', width: chartWidth, height: xaxis.length * v_series.length * 60 },
                    title: {
                        align: 'left',
                        text: "<div style='white-space:normal;word-break:break-all;'>" + title + "</div>",
                        useHTML: true
                    },
                    xAxis: { categories: xaxis, title: { text: null }, labels: { enabled: !disableXlabels } },
                    yAxis: v_yAxis,
                    tooltip: { valueSuffix: danwei },
                    plotOptions: {
                        bar: {
                            pointPadding: 0.1,
                            dataLabels: {
                                crop: false,
                                overflow: "none",
                                enabled: true, formatter: function () {
                                    if (danwei == "分") {
                                        return this.y === null ? '' : (this.y).toFixed(1);
                                    } else {
                                        return this.y === null ? '' : (this.y).toFixed(0);
                                    }
                                }
                            }
                        }
                    },
                    legend: {
                        layout: 'horizontal',
                        align: 'center',
                        verticalAlign: 'top',
                        x: 0,
                        y: 40,
                        borderRadius: 10,
                        enabled: islegend,
                        borderWidth: 1,
                        borderColor: "#c9c9c9",
                        floating: false,
                        useHTML: false,
                        backgroundColor: '#FFFFFF',
                        itemStyle: { cursor: "pointer", color: "#717171" },
                        shadow: false
                    },
                    credits: {
                        enabled: false
                    },
                    series: v_series
                });
            })();
        }
    };

    var ChartBar = function (v_id, title, xaxis, yaxistext, danwei, v_series, islegend) {
        if (yaxistext != "") {
            yaxistext = "(" + yaxistext + ")";
        }
        if (checkSeriesNull(v_series) == 0) {
            $("#" + v_id).html("<image style='margin: 30% auto 0; width:100%;' src='nodata_730.png'/>");
            return false;
        } else {
            $("#" + v_id).html("");
        }
        var v_yAxis = { min: 0, title: { text: yaxistext, align: "high", rotation: 0 }, labels: { overflow: 'justify' } };
        var newmax = MyHighCharts.checkseries(v_series);
        if (newmax > 0) {

            v_yAxis.max = Math.ceil(newmax);
            if (danwei == "%" && Math.ceil(newmax) >= 100) {
                v_yAxis.max = 100;
            }
        } else {
            v_yAxis.max = Math.ceil(5);
        }
        var newseries = toSeries(v_series, danwei);

        $('#' + v_id).highcharts({
            chart: { type: 'bar', width: chartWidth, height: xaxis.length * v_series.length * 30 },
            title: {
                align: 'left',
                text: "<div style='white-space:normal;word-break:break-all;'>" + title + "</div>",
                useHTML: true
            },
            xAxis: { categories: xaxis, title: { text: null } },
            yAxis: v_yAxis,
            tooltip: { valueSuffix: danwei },
            plotOptions: {
                bar: {

                    cursor: 'pointer',
                    enabled: false,
                    borderWidth: 0,

                    minPointLength: 3,
                    //  connectNulls: true //连接数据为null的前后点
                    dataLabels: {

                        enabled: true,
                        style: {
                            fontWeight: 'bold'

                        }, formatter: function () {

                            if (this.point.isnull == "" || this.point.isnull == null) {
                                return '';
                            } else {

                                if (danwei == "分") {
                                    return (this.y).toFixed(1);
                                } else {
                                    return (this.y).toFixed(0);
                                }
                            }



                        }
                    }


                }
            },
            legend: {
                layout: 'horizontal',
                align: 'center',
                verticalAlign: 'top',
                x: 0,
                y: 40,
                borderRadius: 10,
                enabled: islegend,
                borderWidth: 1,
                borderColor: "#c9c9c9",
                floating: false,
                useHTML: false,
                backgroundColor: '#FFFFFF',
                itemStyle: { cursor: "pointer", color: "#717171" },
                shadow: false
            },
            credits: {
                enabled: false
            },
            series: newseries
        });
    };

    var ChartLine = function (v_id, title, xaxis, yaxistext, danwei, v_series, islegend) {
        var xnum = 0;
        if (yaxistext != "") {
            yaxistext = "(" + yaxistext + ")";
        }
        if (checkSeriesNull(v_series) == 0) {
            $("#" + v_id).html("<image style='margin: 30% auto 0; width:100%;' src='nodata_730.png'/>");
            return false;
        } else {
            $("#" + v_id).html("");
        }

        var yAxis = {
            min: 0,
            title: { text: yaxistext, align: "high", rotation: 0 },
            plotLines: [{ value: 0, width: 1, color: '#808080' }]
        };
        var newmax = MyHighCharts.checkseries(v_series);
        if (newmax > 0) {

            yAxis.max = Math.ceil(newmax);
            if (danwei == "%" && Math.ceil(newmax) >= 100) {
                yAxis.max = 100;
            }
        } else {
            yAxis.max = Math.ceil(5);
        }
        if (xaxis.length > 4) { xnum = -70 }

        if (danwei == "%") {
            yAxis.max = 100;
        }
        var chart = new Highcharts.Chart({
            title: {
                align: 'left',
                text: "<div style='white-space:normal;word-break:break-all;'>" + title + "</div>",
                useHTML: true
            },
            chart: { renderTo: v_id, type: 'line', width: chartWidth, height: 400 },
            xAxis: { categories: xaxis, labels: { rotation: xnum } },
            yAxis: yAxis,
            plotOptions: {
                line: {
                    dataLabels: {
                        enabled: true,
                        formatter: function () {
                            if (danwei == "分") {
                                return this.y === null ? '' : (this.y).toFixed(1);
                            } else {
                                return this.y === null ? '' : (this.y).toFixed(0);
                            }
                        }
                    }
                }
            },
            tooltip: {
                valueSuffix: danwei,
                pointFormat: '<span><b>{point.y:.1f}' + danwei + '</b></span>'
            },
            legend: {
                layout: 'horizontal',
                align: 'center',
                verticalAlign: 'top',
                x: 0,
                y: 40,
                borderRadius: 10,
                enabled: islegend,
                borderWidth: 1,
                borderColor: "#c9c9c9",
                floating: false,
                useHTML: false,
                backgroundColor: '#FFFFFF',
                itemStyle: { cursor: "pointer", color: "#717171" },
                shadow: false
            },
            series: v_series
        });
    };

    var caculatePerc = function (value, total) {
        if (total) {
            return Math.round(value * 1000 / total) / 10;
        } else {
            return 0;
        }
    };

    var splitCaculate = function (value, danwei) {
        if (!value) { return value; }
        var list = value.split(',');
        if (list.length == 1) {
            var arr = value.split('-');
            if (arr.length == 1) { return Math.round(arr[0] * 10) / 10; }
            if (danwei == '%') {
                if (arr[1] == '0') { return 0; }
                return Math.round(arr[0] * 1000 / arr[1]) / 10;
            } else {
                if (arr[1] == '0') { return 0; }
                return Math.round(arr[0] * 10 / arr[1]) / 10;
            }
        } else {
            return splitScoreSubjectCaculate(value, danwei);
        }
    };

    var splitScoreSubjectCaculate = function (value, danwei) {
        var arr = value.split(',');
        arr = arr[2].split('-');
        if (danwei == '%') {
            return Math.round(arr[0] * 1000 / arr[1]) / 10;
        } else {
            return Math.round(arr[0] * 10 / arr[1]) / 10;
        }
    };

    var makeYXSeries = function (data, danwei) {
        if (data) {
            var i = 0,
                j = 0,
                found,
                series = [],
                v_data = [];
            _.each(data.YBannerList, function (y) {
                v_data = [];
                _.each(data.XBannerList, function (x) {
                    found = _.find(data.DataList, function (t) { return t.XItem == x.Code && t.YItem == y.Code && t.StatsType == y.Type; });
                    v_data.push(found ? splitCaculate(found.Value, danwei) : null);
                });
                series.push({ name: y.Name, data: v_data });
            });
            return series;
        } else {
            return [];
        }
    };

    var makeYSeries = function (data, danwei) {
        if (data) {
            var i = 0,
                j = 0,
                found,
                series = [],
                v_data = [];
            _.each(data.YBannerList, function (y) {
                v_data = [];
                found = _.find(data.DataList, function (t) { return t.YItem == y.Code; });
                v_data.push(found ? splitCaculate(found.Value, danwei) : null);
                series.push({ name: y.Name, data: v_data });
            });
            return series;
        } else {
            return [];
        }
    };

    var isDaFenTi = function (subjectType) {
        return subjectType == SubjectType.打分题 || subjectType == SubjectType.矩阵打分 || subjectType == SubjectType.拖拉题;
    };

    var VerticalScoreControl = function () {
        this.update = function (departmentCode) {
            var args = {
                action: 'getresult',
                comparetype: 0,
                computetype: 0,
                sqid: reportModule.sqid,
                classcode: reportModule.classcode,
                departmentcode: departmentCode,
                tasktype: reportModule.tasktype,
                v: Date()
            };

            var self = this;
            mc.loadingdialog.show();
            $.getJSON('/api/admin/ResultReport.ashx', args)
            .done(function (r) {
                if (r.state == '200') {
                    self.renderChart(r.data);
                } else {
                    mc.alert(r.message);
                }
            }).fail(function () {
                mc.alert('加载失败!');
            }).complete(function () {
                mc.loadingdialog.close();
            });
        };

        this.renderChart = function (data) {
            if (data.XBannerList.length > 1) {
                var xaxis = _.map(data.XBannerList, function (t) { return t.Name });
                var series = makeYXSeries(data, '分');
                ChartLine('divchart', reportModule.classname + '得分与历史对比', xaxis, '分', '分', series, true);
            } else {
                var xaxis = ['得分'];
                var series = makeYSeries(data);
                ChartColumn('divchart', reportModule.classname + '得分与历史对比', xaxis, '分', '分', series, true, true);
            }
        };
    };

    var VerticalAnswerRateControl = function () {
        this.update = function (departmentCode) {
            var args = {
                action: 'getresult',
                comparetype: 0,
                computetype: 1,
                sqid: reportModule.sqid,
                classcode: reportModule.classcode,
                departmentcode: departmentCode,
                tasktype: reportModule.tasktype,
                v: Date()
            };

            var self = this;
            mc.loadingdialog.show();
            $.getJSON('/api/admin/ResultReport.ashx', args)
            .done(function (r) {
                if (r.state == '200') {
                    self.renderChart(r.data);
                } else {
                    mc.alert(r.message);
                }
            }).fail(function () {
                mc.alert('加载失败!');
            }).complete(function () {
                mc.loadingdialog.close();
            });
        };

        this.renderChart = function (data) {
            if (data.XBannerList.length > 1) {
                var xaxis = _.map(data.XBannerList, function (t) { return t.Name });
                var series = makeYXSeries(data, '%');
                ChartLine('divchart', reportModule.classname + '答题率与历史对比', xaxis, '%', '%', series, true);
            } else {
                var xaxis = ['答题率'];
                var series = makeYXSeries(data, '%');
                ChartColumn('divchart', reportModule.classname + '答题率与历史对比', xaxis, '%', '%', series, true, true);
            }
        };
    };

    var HorizontalScoreControl = function () {
        this.update = function (departmentCode) {
            var args = {
                action: 'getresult',
                comparetype: 1,
                computetype: 0,
                sqid: reportModule.sqid,
                classcode: reportModule.classcode,
                departmentcode: departmentCode,
                tasktype: reportModule.tasktype,
                v: Date()
            };

            var self = this;
            mc.loadingdialog.show();
            $.getJSON('/api/admin/ResultReport.ashx', args)
            .done(function (r) {
                if (r.state == '200') {
                    self.renderChart(r.data);
                } else {
                    mc.alert(r.message);
                }
            }).fail(function () {
                mc.alert('加载失败!');
            }).complete(function () {
                mc.loadingdialog.close();
            });
        };

        this.renderChart = function (data) {
            var xaxis = ['得分'];
            var series = makeYSeries(data, '分');
            ChartColumn('divchart', reportModule.classname + '总分', xaxis, '分', '分', series, true, true);
        };
    };

    var HorizontalAnswerRateControl = function () {
        this.update = function (departmentCode) {
            var args = {
                action: 'getresult',
                comparetype: 1,
                computetype: 1,
                sqid: reportModule.sqid,
                classcode: reportModule.classcode,
                departmentcode: departmentCode,
                tasktype: reportModule.tasktype,
                v: Date()
            };

            var self = this;
            mc.loadingdialog.show();
            $.getJSON('/api/admin/ResultReport.ashx', args)
            .done(function (r) {
                if (r.state == '200') {
                    self.renderChart(r.data);
                } else {
                    mc.alert(r.message);
                }
            }).fail(function () {
                mc.alert('加载失败!');
            }).complete(function () {
                mc.loadingdialog.close();
            });
        };

        this.renderChart = function (data) {
            var xaxis = ['答题率'];
            var series = makeYSeries(data, '%');
            ChartColumn('divchart', reportModule.classname + '答题率', xaxis, '%', '%', series, true, true);
        };
    };

    reportModule.VerticalScoreControl = new VerticalScoreControl();
    reportModule.VerticalAnswerRateControl = new VerticalAnswerRateControl();
    reportModule.HorizontalScoreControl = new HorizontalScoreControl();
    reportModule.HorizontalAnswerRateControl = new HorizontalAnswerRateControl();

    TeacherHighCharts.mychartsphone = function (v_json, reporttype, tasktype, classname) {
        reportModule.classname = classname;
        var json = JSON.parse(v_json);
        if (reporttype == 2) {
            if (tasktype == 2 || tasktype == 3) {
                reportModule.VerticalScoreControl.renderChart(json.data);
            } else if (tasktype == 4 || tasktype == 5) {
                reportModule.VerticalAnswerRateControl.renderChart(json.data);
            }
        } else {
            if (tasktype == 2 || tasktype == 3) {
                reportModule.HorizontalScoreControl.renderChart(json.data);
            } else if (tasktype == 4 || tasktype == 5) {
                reportModule.HorizontalAnswerRateControl.renderChart(json.data);
            }
        }
    };

})(jQuery);