function loadXMLDoc() {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
	console.log("this: {" + this + "}");
	console.dir(this)
    if (this.readyState == 4 && this.status == 200) {
      document.getElementById("demo").innerHTML =
      this.responseText;
    }
  };
  let url = new URL("ftp://162.214.152.107:21/");
  // xhr.open('GET', '/article/xmlhttprequest/example/load');
  var op = xhttp.open('GET', url);
  console.log("op: " + op);
  // xhttp.send();
  
}

loadXMLDoc()

// // var file_path = app.activeDocument.fullName
// var file = new File("/d/project/test_file.psd");

// var ftp = new FtpConnection("ftp://162.214.152.107:21/") ;
// ftp.login("files@bwstrailers.com", "c24bghckpb0p");

// // ftp.cd("project")
// // ftp.put(file,"test_file.psd") ;
// var f = ftp.get

// ftp.close() ;
// file.close() ;