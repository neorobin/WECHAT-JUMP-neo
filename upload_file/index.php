<?php
session_start();
require '../inc/function.php';
check_session("is_login", true, "../login.php");
define("BS_BTN_WIDTH", "100px");
?>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>设置</title>
        <link rel="stylesheet" type="text/css" href="../jquery-easyui-1.5/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="../jquery-easyui-1.5/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="../jquery-easyui-1.5/demo/demo.css">
        <script type="text/javascript" src="../js/jquery-1.10.1.min.js"></script>
        <script type="text/javascript" src="../jquery-easyui-1.5/jquery.easyui.min.1.5.x.js"></script>
        <script type="text/javascript" src="../jquery-easyui-1.5/easyloader.js"></script>
        <style>
            * {
                margin: 0;
                padding: 0;
                /* box-sizing: border-box; */
            }
            /*
            div {
                    border: 3px red solid;
            }
            */
            #full_page {
                /* background-color: yellow;
                border: 3px blue solid; */
                width: 100%;
                height: 100%;
                position: absolute;
                left: 0;
                top: 0;
                text-align: center;
            }
            #verticalAlignBase {
                vertical-align: middle;
                display: inline-block;
                height: 100%;
                /* background-color: red; */
            }
            #div_item {
                display: inline-block;
                vertical-align: middle;
                /*
                height: 100px;
                width: 200px;
                border: 3px red solid;
                */
            }
            .qbtn
            {
                cursor: pointer;
                width: <?= BS_BTN_WIDTH ?>;
                text-align: center;
                vertical-align: middle;
                background-color: #e6e6e6;
                font: 12px/20px Tahoma, Verdana, sans-serif;
                color: #1a438e;
                text-align: center;
                padding: 12px 12px;
                border: 0px solid transparent;
                border-radius: 10px;
                display: inline-block;
            }
            .qbtn:hover {
                background-color:#49aaee;
            }
        </style>
    </head>
    <body>
        <div id=full_page>
            <a id=verticalAlignBase>
                <!--VAB-->
            </a>
            <div id=div_item>
                <h2>上传文件</h2>
                <div class="easyui-panel" title="上传文件" style="width:100%;max-width:600px;padding:30px 60px;">
                    <div style="text-align:center;padding:5px 0">
                        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="submitForm()" style="width:80px">上传</a>
                    </div>
                    <form id="ff" method="post" enctype="multipart/form-data">
                        <div style="margin-bottom:20px">
                            <input class="easyui-textbox" label="Name:" labelPosition="top" style="width:100%">
                        </div>
                        <div style="margin-bottom:20px">
                            <input class="easyui-filebox" id="fileToUpload" name="fileToUpload" label="File1:" labelPosition="top" data-options="prompt:'Choose a file...'" style="width:100%">
                        </div>
                        <!-- 多文件上传用
                        <div style="margin-bottom:40px">
                            <input class="easyui-filebox" label="File2:" labelPosition="top" data-options="prompt:'Choose another file...'" style="width:100%">
                        </div>
                        -->
                    </form>
                    <div style="text-align:center;padding:5px 0">
                        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="submitForm()" style="width:80px">上传</a>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

<script src="../JS/validatebox_extend_rules.js"></script>
<script>

                    $(function () {
                        easyloader.locale = "zh_CN";
                        // $('#ff').form('load', 'get_cfg.php');	// load from URL
                        
                        $('#fileToUpload').filebox({
                            buttonText: '选择文件',
                            buttonAlign: 'right'
                        })

                    });

                    function submitForm() {
                        $.messager.progress();	// display the progress bar
                        $('#ff').form('submit', {
                            url: 'upload.php',
                            // onSubmit: function () {
                                // var isValid = $(this).form('enableValidation').form('validate');
                                // if (!isValid) {
                                    // $.messager.progress('close');	// hide progress bar while the form is invalid
                                // }
                                // return isValid;	// return false will stop the form submission
                            // },
                            success: function (data) {
                                $.messager.progress('close');	// hide progress bar while submit successfully
                                var data = eval('(' + data + ')');  // change the JSON string to javascript object
                                if (data.success) {
                                    tit = '成功';

                                } else {
                                    tit = '失败';
                                }
                                $.messager.show({
                                    title: tit,
                                    msg: data.message,
                                    showType: 'fade',
                                    style: {
                                        right: '',
                                        bottom: ''
                                    }
                                });
                            }
                        });
                    }
</script>
