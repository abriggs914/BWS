// Script for quote building form.
// includes Option and BaseSpec classes. 

var CURRENT_COMPANY = -1;
var CURRENT_INDUSTRY = -1;
var CURRENT_CLASS = -1;
var CURRENT_MODEL = -1;
var CURR_MODEL_OBJ = undefined;
var LOADED_MODELS = []
var MAIL_NL = "%0D%0A";


const HTMLFormat = {
	CHECKBOX: "checkbox",
	RADIOBUTTON: "radiobutton",
	INC_DEC: "inc_dec",
	LIST_SELECTION: "list_selection",
	SLIDER: "slider"
}

var MIN_PAD_WIDTH = 10;
var MIN_DESC_WIDTH = 65;

// Called when the option line containing the checkbox is clicked.
// Updates the option's checkStatus value.
function updateCheckStatus(model, opNum) {
	console.log("update check status");
	op = lookUpOption(model, opNum);
	console.log("FOUND: " + op);
	if (op != null) {
		op.checkStatus = document.getElementById(op.checkStatusInputID()).value;
		// op.updateHTML();
	}
}

// Called when the input value of the quantity input field is manually typed in.
// Updates the option's internal quantity and re-displays the HTML.
// Uses a red indicator to alert if non-numeric characters are in the quantity field.
function updateQuantity(model, opNum) {
	console.log("increment");
	op = lookUpOption(model, opNum);
	console.log("FOUND: " + op);
	if (op != null) {
		str = document.getElementById(op.quantityInputID()).value;
		if (isNumeric(str)) {
			document.getElementById(op.quantityInputID()).style.color = "black";
			document.getElementById(op.quantityInputID()).style.backgroundColor = "white";
			op.quantity = Math.max(0, Number(str));
			op.updateHTML();
		}
		else {
			document.getElementById(op.quantityInputID()).style.color = "red";
			document.getElementById(op.quantityInputID()).style.backgroundColor = "rgba(255,180,180,1)";
		}
	}
}

// Set an option's quantity back to 0.
function resetQuantity(model, opNum, attr) {
	console.log("reset " + attr);
	op = lookUpOption(model, opNum);
	console.log("FOUND: " + op);
	if (op != null) {
		op[attr] = 0;
		op.updateHTML();
	}
	
}

// Increment an option's quantity by 1.
function increment(model, opNum, attr) {
	console.log("increment " + attr + " on model: " + model + " for op: " + opNum);
	// console.log("model: " + Object.keys(model));
	op = lookUpOption(model, opNum);
	// console.log("FOUND: " + op);
	if (op != null) {
		op[attr] = Math.max(0, op[attr] + 1);
		op.updateHTML();
	}
}

// Decrement an option's quantity by 1.
function decrement(model, opNum, attr) {
	console.log("decrement " + attr);
	op = lookUpOption(model, opNum);
	console.log("FOUND: " + op);
	if (op != null) {
		op[attr] = Math.max(0, op[attr] - 1);
		op.updateHTML();
	}
}

// Determine if a string value is a valid number.
// https://stackoverflow.com/questions/175739/built-in-way-in-javascript-to-check-if-a-string-is-a-valid-number
function isNumeric(str) {
  if (typeof str != "string") return false // we only process strings!  
  return !isNaN(str) && // use type coercion to parse the _entirety_ of the string (`parseFloat` alone does not do this)...
         !isNaN(parseFloat(str)) // ...and ensure strings of whitespace fail
}

// Iterate the OPTIONS array and return the option with the
// matching option number. Null otherwise.
function lookUpOption(model, opNum) {
	// console.log("\tmodel in: " + model + ", type: " + typeof(model));
	if (typeof(model) == "string") {
		model = lookUpModel(model);
	}
	// console.log("\tmodel out: " + model + ", type: " + typeof(model));
	let options = model.optionsList;
	// console.log("model: " + model + ", model options: " + model.optionsList);
	// console.log("model: " + Object.keys(model));
	// for (let k in Object.keys(model)) {
	// 	console.log("k: " + k + ", model[k]: " + model[k]);
	// }
	for (let i in options) {
		// console.log("\ti: " + i)
		let op = options[i];
		// console.log("\top: " + op)
		// console.log("op.optionNum: " + op.optionNum);
		// console.log("opNum: " + opNum);
		// console.log("op.optionNum == opNum: " + (op.optionNum == opNum));
		if (op.optionNum == opNum) {
			return op;
		}		
	}
	return null;
}


// Iterate the BASESPECS array and return the BaseSpec with the
// matching BaseSpec id number. Null otherwise.
function lookUpBaseSpec(model, bsNum) {
	let basespecs = model.baseSpecs
	for (let i in basespecs) {
		let bs = basespecs[i];
		// console.log("op.optionNum: " + op.optionNum);
		// console.log("opNum: " + opNum);
		// console.log("op.optionNum == opNum: " + (op.optionNum == opNum));
		if (bs.idNum == bsNum) {
			return bs;
		}		
	}
	return null;
}


// String name in, returns the model object with same name.
// Returns null if model not found.
function lookUpModel(modelName) {
	console.log("####")
	console.log("model name: " + modelName)
	console.log("Loaded models: " + LOADED_MODELS)
	for (let i in LOADED_MODELS) {
		let model = LOADED_MODELS[i]
		console.log("\t\tmodel in: " + model + ", type: " + typeof(model));
		if (model.modelName.toLowerCase() == modelName.toLowerCase()) {
			return model;
		}
	}
}


function createModel(modelIn) {
	let model = ((new String(modelIn) instanceof String)? modelIn : modelIn.modelName);
	for (let i in LOADED_MODELS) {
		let mod = LOADED_MODELS[i];
		if (mod.modelName.toLowerCase() == model) {
			return mod;
		}
	}
	let mod;
	if (modelIn instanceof Model) {
		mod = modelIn;
	}
	else {
		mod = new Model(model);
	}
	LOADED_MODELS.push(mod)
	return mod;
}


// Use this function to create options.
// This ensures that the option will be included in the OPTIONS array.
function createOption(model, elementID, optionNum, section, partNum, description, weight, cost, priceCDN, priceUS, priceMaterials, priceLabour, optionFlags, htmlFormat) {
	let op = new Option(model, elementID, optionNum, section, partNum, description, weight, cost, priceCDN, priceUS, priceMaterials, priceLabour, optionFlags, htmlFormat);
	model.optionsList.push(op);
	return op;
}


function createBaseSpec(model, idNum, groupName, sectionName, description, sortG, sortSE, sortGV2, sortSEV2) {
	console.log("model: " + model + ", type: " + typeof(model));
	let b = new BaseSpec(model, idNum, groupName, sectionName, description, sortG, sortSE, sortGV2, sortSEV2);
	model.baseSpecs.push(b);
	return b;
}


function generateOptionHeader() {
	let html = "<colgroup><col span='1' style='width: 80%; min-width: 80%; max-width: 80%;'>"
	html += "<col span='1' style='width: 10%; min-width: 10%; max-width: 10%;'>"
	html += "<col span='1' style='width: 10%; min-width: 10%; max-width: 10%;'></colgroup>";
	html += "<thead class='list-header' id='options-header'>";
    html += "<th style='text-align:center'>Description</th>";
    html += "<th style='text-align:center'>Weight (lbs.)</th>";
    html += "<th style='text-align:center'>Price (CDN)</th>";
    html += "<th style='text-align:center'>Quantity</th>";
    html += "<th style='text-align:center'>Comment</th>";
	html += "</thead>";
	// var html = "<p>Description</p>";
	// html += getDescriptionSpan();
	// html += "<p>Weight</p>";
	// html += getWeightSpan();
	// html += "<p>Price</p>";
	// html += getPriceSpan();
	// document.getElementById("optionsHeader").innerHTML = html;
	return html;
}


function generateBaseSpecHeader() {
	let html = "<colgroup><col span='1' style='width: 80%; min-width: 80%; max-width: 80%;'>"
	html += "<col span='1' style='width: 10%; min-width: 10%; max-width: 10%;'>"
	html += "<col span='1' style='width: 10%; min-width: 10%; max-width: 10%;'></colgroup>";
	html += "<thead class='list-header' id='baseSpec-header'>";
    html += "<th>Group</th>";
    html += "<th>Section</th>";
    html += "<th>Description</th>";
	html += "</thead>";
	// var html = "<p>Description</p>";
	// html += getDescriptionSpan();
	// html += "<p>Weight</p>";
	// html += getWeightSpan();
	// html += "<p>Price</p>";
	// html += getPriceSpan();
	// document.getElementById("optionsHeader").innerHTML = html;
	return html;
}


function initAllOptionHTML(model) {
	let options = model.optionsList
	let str = generateOptionHeader();
	for (o in options) {
		let op = options[o];
		str += op.initHTML();
	}
	console.log("str: " + str);
	console.log("document: " + document);
	console.log("Object.keys(document): " + Object.keys(document));
	console.log("document.innerHTML: " + document.innerHTML);
	console.log("document.getElementById(optionsList): " + document.getElementById("optionsList"));
	console.log("document.getElementById(optionsList).innerHTML: " + document.getElementById("optionsList").innerHTML);
	// document.getElementById("optionsList").innerHTML = "";
	document.getElementById("optionsList").innerHTML = str;
}


function initAllBaseSpecHTML(model) {
	console.log("model: " + model + ", type: " + typeof(model));
	let baseSpecs = model.baseSpecs
	let str = generateBaseSpecHeader();
	for (let b in baseSpecs) {
		let bs = baseSpecs[b];
		str += bs.initHTML();
	}
	// console.log("str: " + str);
	// console.log("document: " + document);
	// console.log("Object.keys(document): " + Object.keys(document));
	// console.log("document.innerHTML: " + document.innerHTML);
	// console.log("document.getElementById(optionsList): " + document.getElementById("optionsList"));
	// console.log("document.getElementById(optionsList).innerHTML: " + document.getElementById("optionsList").innerHTML);
	// document.getElementById("baseSpecsList").innerHTML = "";
	document.getElementById("baseSpecsList").innerHTML = str;
}

function printOptions(model) {
	let options = model.optionsList
	console.log("\tOptions:");
	for (let o in options) {
		let op = options[o];
		console.log("op	-	" + op + ", elem: " + op.elementID);
	}
}

function randomHTMLFormat() {
	// return HTMLFormat[Object.keys(HTMLFormat)[Math.round(Math.random() * Object.keys(HTMLFormat).length)]]
	return HTMLFormat.SLIDER
}

//elementIDIn, optionNum, section, partNum, description, weight, priceCDN, priceUS, htmlFormat
//model, elementID, optionNum, section, partNum, description, weight, cost, priceCDN, priceUS, priceMaterials, priceLabour, optionFlags, htmlFormat
var model1 = createModel("53ET3X")
var o1 = createOption(model1, "option001", "A1", "B1", "C1", "D1", "E1", "F1", "G1");
var o2 = createOption(model1, "option002", "A2", "B2", "C2", "D2", "E2", "F2", "G2");
var o3 = createOption(model1, "option003", "A3", "B3", "C3", "D3", "E3", "F3", "G3");
var o4 = createOption(model1, "option004", "A4", "B4", "C4", "D4", "E4", "F4", "G4");

var o5 = createOption(model1, "option005", "A5", "B5", "C5", "D5", "E5", "F5", "G5");
var o6 = createOption(model1, "option006", "A6", "B6", "C6", "D6", "E6", "F6", "G6");
var o7 = createOption(model1, "option007", "A7", "B7", "C7", "D7", "E7", "F7", "G7");
var o8 = createOption(model1, "option008", "A8", "B8", "C8", "D8", "E8", "F8", "G8");
var o9 = createOption(model1, "option009", "A9", "B9", "C9", "D9", "E9", "F9", "G9");
var o10 = createOption(model1, "option010", "A10", "B10", "C10", "D10", "E10", "F10", "G10");
var o11 = createOption(model1, "option011", "A11", "B11", "C11", "D11", "E11", "F11", "G11");

o1.setHTMLFormat(randomHTMLFormat());
o2.setHTMLFormat(randomHTMLFormat());

// var o = createOption("option001", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", HTMLFormat.INC_DEC);
console.log("OPTION: " + o1);
console.log("OPTION: " + o2);
console.log("OPTION: " + o3);
console.log("OPTION: " + o4);
console.log("OPTION HTML: " + o1.getHTML());
console.log("OPTION HTML: " + o2.getHTML());
console.log("OPTION HTML: " + o3.getHTML());
console.log("OPTION HTML: " + o4.getHTML());
// document.getElementById("option001").innerHTML = o1.getHTML();
// document.getElementById("option002").innerHTML = o2.getHTML();
initAllOptionHTML(model1);


var b1 = createBaseSpec(model1, "baseSpec001", "A1", "B1", "C1", "D1", "E1", "F1", "G1", "H1");
initAllBaseSpecHTML(model1);


function populateCompanies() {
	let str = "<ul class='menu-elem'>";
	// loop Companies
	for (let i = 0; i < LINKS.length; i++) {
		let name = LINKS[i][0]
		str += "<li class=\"companyElem\" onclick=\"selectCompany(" + i + ")\">" + name + "</li>";
	}
	str += "</ul>";
	document.getElementById("companyMenu").innerHTML = str;
}


function populateIndustries() {
	let str = "<ul class='menu-elem'>";
	// loop industries
	for (let i = 0; i < LINKS[CURRENT_COMPANY][1].length; i++) {
		let name = LINKS[CURRENT_COMPANY][1][i][0]
		str += "<li class=\"industryElem\" onclick=\"selectIndustry(" + i + ")\">" + name + "</li>";
	}
	str += "</ul>";
	document.getElementById("industryMenu").innerHTML = str;
}

function populateClasses() {
	let str = "<ul class='menu-elem'>";
	// loop classes within industry
	for (let i = 0; i < LINKS[CURRENT_COMPANY][1][CURRENT_INDUSTRY][2].length; i++) {
		let classes = LINKS[CURRENT_COMPANY][1][CURRENT_INDUSTRY][2][i];
		console.log("classes: " + classes);
		let name = classes[0];
		str += "<li class='classElem' onclick='selectClass(" + i + ")'>" + name + "</li>";
	}
	str += "</ul>";
	document.getElementById("classMenu").innerHTML = str;
}

function populateModels() {
	let str = "<ul class='menu-elem'>";
	// loop models within class
	for (let i = 0; i < LINKS[CURRENT_COMPANY][1][CURRENT_INDUSTRY][2][CURRENT_CLASS][2].length; i++) {
		let models = LINKS[CURRENT_COMPANY][1][CURRENT_INDUSTRY][2][CURRENT_CLASS][2][i];
		console.log("models: " + models);
		let name = models[0];
		str += "<li class='modelElem' onclick='selectModel(" + i + ")'>" + name + "</li>";
	}
	str += "</ul>";
	document.getElementById("modelMenu").innerHTML = str;
}

// Invoked when a company is selected via the select company button.
// Adjusts the text and href values of the company report string.
function selectCompany(n) {
	// toggleHide("companyMenu")

	CURRENT_COMPANY = n;
	if (CURRENT_INDUSTRY >= 0) {
		clearCurrentIndustry();
	}
	if (CURRENT_CLASS >= 0) {
		clearCurrentClass();
	}
	if (CURRENT_MODEL >= 0) {
		clearCurrentModel();
	}

	let arr = LINKS[n];
	let txt = "<a class='selectionPLink' id='companySelectionPLink' href=" + arr[1] + ">" + arr[0] + "</a>";
	populateIndustries();
	document.getElementById("companySelectionP").innerHTML = txt;
	console.log("Click select company, <" + txt + ">");
}

// Invoked when an industry is selected via the select industry button.
// Adjusts the text and href values of the industry report string.
function selectIndustry(n) {
	// toggleHide("industryMenu")
	if (CURRENT_COMPANY >= 0) {
		CURRENT_INDUSTRY = n;
		if (CURRENT_CLASS >= 0) {
			clearCurrentClass();
		}
		if (CURRENT_MODEL >= 0) {
			clearCurrentModel();
		}
		let arr = LINKS[CURRENT_COMPANY][1][n];
		let txt = "<a class='selectionPLink' id='industrySelectionPLink' href=" + arr[1] + ">" + arr[0] + "</a>";
		populateClasses();
		document.getElementById("industrySelectionP").innerHTML = txt;
		console.log("Click select industry, <" + txt + ">");
	}
}

// Invoked when a class is selected via the select class button.
// Adjusts the text and href values of the class report string.
function selectClass(n) {
	// toggleHide("classMenu")
	if (CURRENT_COMPANY >= 0 && CURRENT_INDUSTRY >= 0) {
		CURRENT_CLASS = n;
		if (CURRENT_MODEL >= 0) {
			clearCurrentModel();
		}
		let arr = LINKS[CURRENT_COMPANY][1][CURRENT_INDUSTRY][2][n];
		let txt = "<a class='selectionPLink' id='classSelectionPLink' href=" + arr[1] + ">" + arr[0] + "</a>";
		populateModels();
		document.getElementById("classSelectionP").innerHTML = txt;
		console.log("Click select class, <" + txt + ">");
	}
}


// Invoked when a model is selected via the select class button.
// Adjusts the text and href values of the model report string.
function selectModel(n) {
	// toggleHide("modelMenu")
	if (CURRENT_COMPANY >= 0 && CURRENT_INDUSTRY >= 0 && CURRENT_CLASS >= 0) {
		let arr = LINKS[CURRENT_COMPANY][1][CURRENT_INDUSTRY][2][CURRENT_CLASS][2][n];
		let txt = "<a class='selectionPLink' id='modelSelectionPLink' href='" + LINKS[CURRENT_COMPANY][1][CURRENT_INDUSTRY][2][CURRENT_CLASS][1] + "'>" + arr[0] + "</a>";
		document.getElementById("modelSelectionP").innerHTML = txt;
		console.log("Click select model, <" + txt + ">");
		CURRENT_MODEL = n;
		CURR_MODEL_OBJ = lookUpModel(arr[0]);
		
		// parse the returned file here
		$("#submit").click();
	}
}

function clearCurrentIndustry() {
	CURRENT_INDUSTRY = -1;
	document.getElementById("industryMenu").innerHTML = "";
	document.getElementById("industrySelectionP").innerHTML = "<a id='industrySelectionPLink' href='#industrySelection'>Select an Industry</a>";
}

function clearCurrentClass() {
	CURRENT_CLASS = -1;
	document.getElementById("classMenu").innerHTML = "";
	document.getElementById("classSelectionP").innerHTML = "<a id='classSelectionPLink' href='#classSelection'>Select a Class</a>";
}

function clearCurrentModel() {
	CURRENT_MODEL = -1;
	document.getElementById("modelMenu").innerHTML = "";
	document.getElementById("modelSelectionP").innerHTML = "<a id='modelSelectionPLink' href='#modelSelection'>Select a Model</a>";
}

function titleCase(str) {
  str = str.toLowerCase().split(' ');
  for (let i = 0; i < str.length; i++) {
    str[i] = str[i].charAt(0).toUpperCase() + str[i].slice(1); 
  }
  return str.join(' ');
}

function blankMailTo() {
	// var href = document.getElementById("mailto-href");
	// href.innerHTML = "href = 'mailto:avery.briggs@bwstrailers.com?subject=Request for quote' display='hidden'"
	let href = "mailto:avery.briggs@bwstrailers.com?subject=Request for quote display='hidden' data-rel='external'";
	console.log("RESETTING MAILTO: " + $("mailto-href")["href"]);
	// $("mailto-href").html("");
	$("mailto-href").attr("href", "'mailto:avery.briggs@bwstrailers.com?subject=Request for quote' display='hidden'")
	console.log("RESETTING MAILTO: " + $("mailto-href")["href"]);
	return href;
}

function collectComments() {
	let comments = document.getElementById("submit-comments-textarea").value;
	comments = comments.replaceAll("&", "and");
	comments = ((comments == "")? "NA" : comments);
	comments = comments.split("\n");
	comments = comments.join(MAIL_NL);
	return comments;
}

function collectOptions(model) {
	let options = model.optionsList
	let res = "";
	for (let i in options) {
		// console.log("i: " + i);
		if (options[i].quantity > 0) {
			res += options[i].getMailFormat() 
			if (i < options.length-1) {
				res += " " + MAIL_NL;
			}
		}
	}
	res = ((res == "")? "NA" : res);
	console.log("options: " + res);
	return res;
}

function collectQuote(event, model) {
	console.log("event: " + event)
	console.log("model: " + model)
	if (event.ctrlKey) {
		console.log("performing test 1");
		selectIndustry(0);
		selectClass(0);
		selectModel(0);
		document.getElementById("submit-comments-textarea").value = "this is a sample comment,\nplease read these comments,\nbecause they are very long,\nand they need to be split up by newline characters so the text doesn't appear all on one line.\njust like the line immediately above.\nthis comment & this comment\nshould break the parsing.\na\nb\nc\nd\ne\nf\ng\nh\ni\nj\nk\nl\nm\nn\no\np\nq\nr\ns\nt\nu\nv\nw\nx\ny\nz\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n!\n@\n#\n$\n%\n^\n*\n(\n)[]\n{}\n-\n/\n+\n*\n_\n=\n`\n~\n\"dsd\"\n'dsd'\n?\n<>\n,.\ngot to the end";
		for (let i = 0; i < 10; i++) {
			for (let j = 0; j < 10; j++) {
				increment(model, options[i].optionNum, "quantity");
			}
		}
	}
	if (CURRENT_INDUSTRY < 0 || CURRENT_CLASS < 0 || CURRENT_MODEL < 0) {
		alert("Please select an industry, a class, and a model to proceed.");
		return;
	}
	let options = model.optionsList
	// blankMailTo();
	console.log("collecting the quote in function");
	let href = document.getElementById("mailto-href");
	let currRef = $("#mailto-href").attr('href');
	// currRef += "&body=THIS IS BODY TEXT%0D%0ASO IS THIS";
	
	//You can add newline by writing %0D%0A in the text of the body.
	let industry = document.getElementById("industrySelectionPLink").innerHTML;
	let clazz = document.getElementById("classSelectionPLink").innerHTML;
	let mod = document.getElementById("modelSelectionPLink").innerHTML;
	let comments = collectComments();
	let ops = collectOptions();
	console.log("INDUSTRY: " + industry);
	console.log("CLAZZ: " + clazz);
	console.log("MODEL: " + model);
	
	// ATTENTION!
	// maximum size of body can only be 1969 characters.
	// MAIL_NL contains 6 characters.
	lines = [
			currRef,
			"&body=Dear BWS sales,",
			"",
			"I am writing to you to express my interest in having a quote done up for the " + mod + " model from the " + clazz + " class.",
			"",
			"-- 	  	 Standard options		   --",
			ops,
			// "----------------------------------------",
			"",
			"-- 		Comments and concerns	   --",
			comments,
			// "----------------------------------------",
			"",
			"Thank you."
	]
	let msg = lines.join(MAIL_NL);
	$("#mailto-href").attr('href', msg);
	document.getElementById("mailto-href").click();
	$("#mailto-href").attr('href', blankMailTo());
}

// // elem is the id of the given element.
// function toggleHide(elem) {
	// var x = document.getElementById(elem);
	// if (x.style.display === "none") {
		// x.style.display = "inline-block";
	// }
	// else {
		// x.style.display = "none";
	// }
// }


// Generating and saving a text file of the filled quote form.
function genQuoteText(){
	if (CURR_MODEL_OBJ == undefined){
		console.log("Select a model first!")
		return;
	}
	let industry = document.getElementById("industrySelectionPLink").innerHTML;
	let clazz = document.getElementById("classSelectionPLink").innerHTML;
	let mod = document.getElementById("modelSelectionPLink").innerHTML;
	let comments = collectComments();
	let ops = collectOptions(CURR_MODEL_OBJ);

	console.log("industry: " + industry + "\nclazz: " + clazz + "\nmod: " + mod + "\ncomments: " + comments + "\nops: " + ops)
}
