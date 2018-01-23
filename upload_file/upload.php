<?php

// $target_dir = "uploads/";
$target_dir = "/xj_project_uploads/";

$fn_mb_encoding = mb_detect_encoding($_FILES["fileToUpload"]["name"], "auto");

$uploadOk = 1;

// basename 对 UTF-8 会造成出错
// $target_file = $target_dir . basename($_FILES["fileToUpload"]["name"]);
$target_file = $target_dir . $_FILES["fileToUpload"]["name"];

$target_file = iconv($fn_mb_encoding, "GB18030", $target_file);

$fileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));

/* 不检测是否为图片
  // Check if image file is a actual image or fake image
  if(isset($_POST["submit"])) {
  $check = getimagesize($_FILES["fileToUpload"]["tmp_name"]);
  if($check !== false) {
  echo "File is an image - " . $check["mime"] . ".";
  $uploadOk = 1;
  } else {
  echo "File is not an image.";
  $uploadOk = 0;
  }
  }
 */
/* 不检测是否已存在
  // Check if file already exists
  if (file_exists($target_file)) {
  echo "Sorry, file already exists.";
  $uploadOk = 0;
  }
 */
// Check file size
if ($_FILES["fileToUpload"]["size"] > 500000) {
    echo "Sorry, your file is too large.";
    $uploadOk = 0;
}
/* 不限制文件扩展名
  // Allow certain file formats
  if($fileType != "jpg" && $fileType != "png" && $fileType != "jpeg"
  && $fileType != "gif" ) {
  echo "Sorry, only JPG, JPEG, PNG & GIF files are allowed.";
  $uploadOk = 0;
  }
 */
// Check if $uploadOk is set to 0 by an error
if ($uploadOk == 0) {
    echo "Sorry, your file was not uploaded.";
// if everything is ok, try to upload file
} else {
    if (move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $target_file)) {
        echo json_encode(array(
            "success" => true,
            "message" => "文件 \"" . $_FILES['fileToUpload']['name'] . "\" 上传成功",
            'fileType' => $fileType,
            'file' => "The file " . $_FILES["fileToUpload"]["name"]
        ));
    } else {
        echo json_encode(array('message' => '文件上传失败, 未知错误 20180123_212708'));
    }
}
?>