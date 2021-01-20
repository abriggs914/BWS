// Script for quote building form.
// includes Option and BaseSpec classes. 

var CURRENT_INDUSTRY = -1;
var CURRENT_CLASS = -1;
var CURRENT_MODEL = -1;
var MAIL_NL = "%0D%0A";


const HTMLFormat = {
	CHECKBOX: "checkbox",
	RADIOBUTTON: "radiobutton",
	INC_DEC: "inc_dec",
	LIST_SELECTION: "list_selection"
}

var MIN_PAD_WIDTH = 10;
var MIN_DESC_WIDTH = 65;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Begin Option class
class Option {
	constructor(elementIDIn, optionNum, section, partNum, description, weight, priceCDN, priceUS) {
		this.elementID = elementIDIn;
		this.optionNum = optionNum;
		this.section = section;
		this.partNum = partNum;
		this.description = description;
		this.weight = weight;
		this.priceCDN = priceCDN;
		this.priceUS = priceUS;
		
		this.quantity = 0;
		this.checkedStatus = false;
	}
	
	optionLineID() {
		return "optionLine_" + this.optionNum;
	}
	
	checkStatusInputID() {
		return "checkedStatusInput_" + this.optionNum;
	}
	
	quantityInputID() {
		return "quantityInput_" + this.optionNum;
	}
	
	groupInfo() {
		let str = this.optionNum.padEnd(MIN_PAD_WIDTH);
		str += this.section.padEnd(MIN_PAD_WIDTH);
		str += this.partNum.padEnd(MIN_PAD_WIDTH);
		str += this.description.padEnd(MIN_DESC_WIDTH);
		str += this.weight.padEnd(MIN_PAD_WIDTH);
		str += this.cost.padEnd(MIN_PAD_WIDTH);
		str += this.priceCDN.padEnd(MIN_PAD_WIDTH);
		str += this.priceUS.padEnd(MIN_PAD_WIDTH);
		str += this.priceMaterials.padEnd(MIN_PAD_WIDTH);
		str += this.priceLabour.padEnd(MIN_PAD_WIDTH);
		str += this.optionFlags.padEnd(MIN_PAD_WIDTH);
		// str += this.quantity.toString().padEnd(MIN_PAD_WIDTH);
		return str;
	}
	
	initHTML() {
		return "<tr class='optionLine' id=" + this.optionLineID() + ">" + this.getHTML() + "</tr>";
	}
	
	getHTML() {
		let quantity = "quantity";
		let RefId = 0;
		let html = ""; //"<tr class='optionLine' id=" + this.optionLineID() + ">";
		let d = ((this.description.toLowerCase() == "null")? "NA" : this.description );
		let w = ((this.weight.toLowerCase() == "null")? "NA" : this.weight );
		let p = ((this.priceCDN.toLowerCase() == "null")? "NA" : this.priceCDN );
		p = ((isNumeric(p))? "$ " + parseFloat(p).toFixed(2) : p);
		html += "<td class='description-cell' onclick='increment(\"" + this.optionNum + "\"" + ",\"quantity\")'>" + d + "</td>";
		html += "<td style='text-align:center' onclick='increment(\"" + this.optionNum + "\"" + ",\"quantity\")'>" + w + "</td>";
		html += "<td style='text-align:right' onclick='increment(\"" + this.optionNum + "\"" + ",\"quantity\")'>" + p + "</td>";
		html += "<td>";
		html += "<form action='updateQuantity()' class='inc_dec_widget'>";
		html += "<input type=number, id=" + this.quantityInputID() + " onChange='updateQuantity(\"" + this.optionNum + "\")' value=" + this.quantity + ">";
		html += "</form>";
		html += "<button class=incrementButton onclick='increment(\"" + this.optionNum + "\"" + ",\"" + quantity + "\")'>+</button>";;
		html += "<button class=decrementButton onclick='decrement(\"" + this.optionNum + "\"" + ",\"" + quantity + "\")'>-</button>";
		html += "<button class=resetQuantityButton onclick='resetQuantity(\"" + this.optionNum + "\"" + ",\"" + quantity + "\");'>clear</button>";
		html += "</td>";
		html += "";
		return html;
	}
	
	updateHTML() {
		// console.log("hey there");
		// console.log("this.optionLineID: " + this.optionLineID());
		// console.log("document.getElementById(this.optionLineID): " + document.getElementById(this.optionLineID()));
		// console.log("document.getElementById(this.optionLineID).innerHTML: " + document.getElementById(this.optionLineID()).innerHTML);
		document.getElementById(this.optionLineID()).innerHTML = "";
		document.getElementById(this.optionLineID()).innerHTML = this.getHTML();
	}
	
	getMailFormat() {
		let str = this.quantity + " x ";
		str += this.description.substring(0, Math.min(this.description.length, 20));
		str += " @ " + "$ " + parseFloat(this.priceCDN).toFixed(2) + " each.";
		return str;
	}
	
	toString() {
		return this.optionNum + " x " + this.quantity;
	}
}
//	End Option class
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Begin BaseSpec class
class BaseSpec {
	
	constructor(idNum, groupName, sectionName, description, sortG, sortSE, sortGV2, sortSEV2) {
		this.idNum = idNum;
		this.groupName = groupName;
		this.sectionName = sectionName;
		this.description = description;
		this.sortG = sortG;
		this.sortSE = sortSE;
		this.sortGV2 = sortGV2;
		this.sortSEV2 = sortSEV2;
	}
	
	baseSpecLineID() {
		return "baseSpecLine_" + this.idNum;
	}
	
	initHTML() {
		return "<tr class=baseSpecLine id=" + this.baseSpecLineID() + ">" + this.getHTML() + "</tr>";
	}
	
	getHTML() {
		let html = "<td>" + titleCase(this.groupName) + "</td>";
		html += "<td>" + titleCase(this.sectionName) + "</td>";
		html += "<td class='description-cell'>" + this.description + "</td>";
		return html;
	}
	
	
}
//	End BaseSpec class
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// Called when the option line containing the checkbox is clicked.
// Updates the option's checkStatus value.
function updateCheckStatus(opNum) {
	console.log("update check status");
	op = lookUpOption(opNum);
	console.log("FOUND: " + op);
	if (op != null) {
		op.checkStatus = document.getElementById(op.checkStatusInputID()).value;
		// op.updateHTML();
	}
}

// Called when the input value of the quantity input field is manually typed in.
// Updates the option's internal quantity and re-displays the HTML.
// Uses a red indicator to alert if non-numeric characters are in the quantity field.
function updateQuantity(opNum) {
	console.log("increment");
	op = lookUpOption(opNum);
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
function resetQuantity(opNum, attr) {
	console.log("reset " + attr);
	op = lookUpOption(opNum);
	console.log("FOUND: " + op);
	if (op != null) {
		op[attr] = 0;
		op.updateHTML();
	}
	
}

// Increment an option's quantity by 1.
function increment(opNum, attr) {
	console.log("increment " + attr);
	op = lookUpOption(opNum);
	console.log("FOUND: " + op);
	if (op != null) {
		op[attr] = Math.max(0, op[attr] + 1);
		op.updateHTML();
	}
}

// Decrement an option's quantity by 1.
function decrement(opNum, attr) {
	console.log("decrement " + attr);
	op = lookUpOption(opNum);
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
function lookUpOption(opNum) {
	for (let i in OPTIONS) {
		let op = OPTIONS[i];
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
function lookUpBaseSpec(bsNum) {
	for (let i in BASESPECS) {
		let bs = BASESPECS[i];
		// console.log("op.optionNum: " + op.optionNum);
		// console.log("opNum: " + opNum);
		// console.log("op.optionNum == opNum: " + (op.optionNum == opNum));
		if (bs.idNum == bsNum) {
			return bs;
		}		
	}
	return null;
}


// Use this function to create options.
// This ensures that the option will be included in the OPTIONS array.
function createOption(elementID, optionNum, section, partNum, description, weight, cost, priceCDN, priceUS, priceMaterials, priceLabour, optionFlags, htmlFormat) {
	let op = new Option(elementID, optionNum, section, partNum, description, weight, cost, priceCDN, priceUS, priceMaterials, priceLabour, optionFlags, htmlFormat);
	OPTIONS.push(op);
	return op;
}

function createBaseSpec(idNum, groupName, sectionName, description, sortG, sortSE, sortGV2, sortSEV2) {
	let b = new BaseSpec(idNum, groupName, sectionName, description, sortG, sortSE, sortGV2, sortSEV2);
	BASESPECS.push(b);
	return b;
}

function generateOptionHeader() {
	let html = "<colgroup><col span='1' style='width: 80%; min-width: 80%; max-width: 80%;'>"
	html += "<col span='1' style='width: 10%; min-width: 10%; max-width: 10%;'>"
	html += "<col span='1' style='width: 10%; min-width: 10%; max-width: 10%;'></colgroup>";
	html += "<thead class='list-header' id='options-header'>";
    html += "<th>Description</th>";
    html += "<th>Weight (lbs.)</th>";
    html += "<th>Price (CDN)</th>";
    html += "<th>Quantity</th>";
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

function initAllOptionHTML() {
	let str = generateOptionHeader();
	for (o in OPTIONS) {
		let op = OPTIONS[o];
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

function initAllBaseSpecHTML() {
	let str = generateBaseSpecHeader();
	for (let b in BASESPECS) {
		let bs = BASESPECS[b];
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

function clearAllOptions() {
	OPTIONS = []
}

function clearAllBaseSpecs() {
	BASESPECS = []
}

function printOptions() {
	console.log("\tOptions:");
	for (let o in OPTIONS) {
		let op = OPTIONS[o];
		console.log("op	-	" + op + ", elem: " + op.elementID);
	}
}

var OPTIONS = [];
//elementIDIn, optionNum, section, partNum, description, weight, priceCDN, priceUS, htmlFormat
var o1 = createOption("option001", "A1", "B1", "C1", "D1", "E1", "F1", "G1");
var o2 = createOption("option002", "A2", "B2", "C2", "D2", "E2", "F2", "G2");
var o3 = createOption("option003", "A3", "B3", "C3", "D3", "E3", "F3", "G3");
var o4 = createOption("option004", "A4", "B4", "C4", "D4", "E4", "F4", "G4");

var o5 = createOption("option005", "A5", "B5", "C5", "D5", "E5", "F5", "G5");
var o6 = createOption("option006", "A6", "B6", "C6", "D6", "E6", "F6", "G6");
var o7 = createOption("option007", "A7", "B7", "C7", "D7", "E7", "F7", "G7");
var o8 = createOption("option008", "A8", "B8", "C8", "D8", "E8", "F8", "G8");
var o9 = createOption("option009", "A9", "B9", "C9", "D9", "E9", "F9", "G9");
var o10 = createOption("option010", "A10", "B10", "C10", "D10", "E10", "F10", "G10");
var o11 = createOption("option011", "A11", "B11", "C11", "D11", "E11", "F11", "G11");
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
initAllOptionHTML();


var BASESPECS = [];
var b1 = createBaseSpec("baseSpec001", "A1", "B1", "C1", "D1", "E1", "F1", "G1", "H1");
initAllBaseSpecHTML();


function populateIndustries() {
	let str = "<ul>";
	// loop industries
	for (let i = 0; i < LINKS.length; i++) {
		let name = LINKS[i][0]
		str += "<li class=\"industryElem\" onclick=\"selectIndustry(" + i + ")\">" + name + "</li>";
	}
	str += "</ul>";
	document.getElementById("industryMenu").innerHTML = str;
}

function populateClasses() {
	let str = "<ul>";
	// loop classes within industry
	for (let i = 0; i < LINKS[CURRENT_INDUSTRY][2].length; i++) {
		let classes = LINKS[CURRENT_INDUSTRY][2][i];
		console.log("classes: " + classes);
		let name = classes[0];
		str += "<li class=\"classElem\" onclick=\"selectClass(" + i + ")\">" + name + "</li>";
	}
	str += "</ul>";
	document.getElementById("classMenu").innerHTML = str;
}

function populateModels() {
	let str = "<ul>";
	// loop models within class
	for (let i = 0; i < LINKS[CURRENT_INDUSTRY][2][CURRENT_CLASS][2].length; i++) {
		let models = LINKS[CURRENT_INDUSTRY][2][CURRENT_CLASS][2][i];
		console.log("models: " + models);
		let name = models[0];
		str += "<li class=\"modelElem\" onclick=\"selectModel(" + i + ")\">" + name + "</li>";
	}
	str += "</ul>";
	document.getElementById("modelMenu").innerHTML = str;
}

// Invoked when an industry is selected via the select industry button.
// Adjusts the text and href values of the industry report string.
function selectIndustry(n) {
	// toggleHide("industryMenu")
	CURRENT_INDUSTRY = n;
	let arr = LINKS[n];
	let txt = "<a id='industrySelectionPLink' href=" + arr[1] + ">" + arr[0] + "</a>";
	populateClasses(n);
	document.getElementById("industrySelectionP").innerHTML = txt;
	console.log("Click select industry, <" + txt + ">");
}

// Invoked when a class is selected via the select class button.
// Adjusts the text and href values of the class report string.
function selectClass(n) {
	// toggleHide("classMenu")
	CURRENT_CLASS = n;
	let arr = LINKS[CURRENT_INDUSTRY][2][n];
	let txt = "<a id='classSelectionPLink' href=" + arr[1] + ">" + arr[0] + "</a>";
	populateModels(n);
	document.getElementById("classSelectionP").innerHTML = txt;
	console.log("Click select class, <" + txt + ">");
}

// Invoked when a model is selected via the select class button.
// Adjusts the text and href values of the model report string.
function selectModel(n) {
	// toggleHide("modelMenu")
	CURRENT_MODEL = n;
	let arr = LINKS[CURRENT_INDUSTRY][2][CURRENT_CLASS][2][n];
	let txt = "<p id='modelSelectionPLink'>" + arr[0] + "</p>";
	document.getElementById("modelSelectionP").innerHTML = txt;
	console.log("Click select model, <" + txt + ">");
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

function collectOptions() {
	let options = "";
	for (let i in OPTIONS) {
		// console.log("i: " + i);
		if (OPTIONS[i].quantity > 0) {
			options += OPTIONS[i].getMailFormat() 
			if (i < OPTIONS.length-1) {
				options += " " + MAIL_NL;
			}
		}
	}
	options = ((options == "")? "NA" : options);
	console.log("options: " + options);
	return options;
}

function collectQuote(event) {
	if (event.ctrlKey) {
		console.log("performing test 1");
		selectIndustry(0);
		selectClass(0);
		selectModel(0);
		document.getElementById("submit-comments-textarea").value = "this is a sample comment,\nplease read these comments,\nbecause they are very long,\nand they need to be split up by newline characters so the text doesn't appear all on one line.\njust like the line immediately above.\nthis comment & this comment\nshould break the parsing.\na\nb\nc\nd\ne\nf\ng\nh\ni\nj\nk\nl\nm\nn\no\np\nq\nr\ns\nt\nu\nv\nw\nx\ny\nz\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n!\n@\n#\n$\n%\n^\n*\n(\n)[]\n{}\n-\n/\n+\n*\n_\n=\n`\n~\n\"dsd\"\n'dsd'\n?\n<>\n,.\ngot to the end";
		for (let i = 0; i < 10; i++) {
			for (let j = 0; j < 10; j++) {
				increment(OPTIONS[i].optionNum, "quantity");
			}
		}
	}
	if (CURRENT_INDUSTRY < 0 || CURRENT_CLASS < 0 || CURRENT_MODEL < 0) {
		alert("Please select an industry, a class, and a model to proceed.");
		return;
	}
	// blankMailTo();
	console.log("collecting the quote in function");
	let href = document.getElementById("mailto-href");
	let currRef = $("#mailto-href").attr('href');
	// currRef += "&body=THIS IS BODY TEXT%0D%0ASO IS THIS";
	
	//You can add newline by writing %0D%0A in the text of the body.
	let industry = document.getElementById("industrySelectionPLink").innerHTML;
	let clazz = document.getElementById("classSelectionPLink").innerHTML;
	let model = document.getElementById("modelSelectionPLink").innerHTML;
	let comments = collectComments();
	let options = collectOptions();
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
			"I am writing to you to express my interest in having a quote done up for the " + model + " model from the " + clazz + " class.",
			"",
			"-- 	  	 Standard options		   --",
			options,
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
