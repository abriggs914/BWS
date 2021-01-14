const HTMLFormat = {
	CHECKBOX: "checkbox",
	RADIOBUTTON: "radiobutton",
	INC_DEC: "inc_dec",
	LIST_SELECTION: "list_selection"
}

MIN_PAD_WIDTH = 10;
MIN_DESC_WIDTH = 65;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Begin Option class

class Option {
	constructor(elementIDIn, optionNum, section, partNum, description, weight, priceCDN, priceUS, htmlFormat) {
		this.elementID = elementIDIn;
		this.optionNum = optionNum;
		this.section = section;
		this.partNum = partNum;
		this.description = description;
		this.weight = weight;
		this.priceCDN = priceCDN;
		this.priceUS = priceUS;
		this.htmlFormat = htmlFormat;
		
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
		var str = this.optionNum.padEnd(MIN_PAD_WIDTH);
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
	
	
	/*
	
			case HTMLFormat.CHECKBOX 		:	html += "<td><form action='updateCheckStatus()' class='checkbox_widget'>"
												html += "<input class='checkBox' id=" + this.checkStatusInputID() + " type='checkbox' onchange='updateCheckStatus(\"" + this.optionNum + "\")'></form></td>";
												
												case HTMLFormat.INC_DEC 		:	html += "<td><form action='updateQuantity()' class='inc_dec_widget'><label>quantity: </label><input type=number, id=" + this.quantityInputID() + " onChange='updateQuantity(\"" + this.optionNum + "\")' value=" + this.quantity + "></form>";
												html += "<button class=incrementButton onclick='increment(\"" + this.optionNum + "\"" + ",\"" + quantity + "\");'>+</button>";
												html += "<button class=decrementButton onclick='decrement(\"" + this.optionNum + "\"" + ",\"" + quantity + "\");'>-</button></td>";
	*/
	
	
	
	getHTML() {
		var quantity = "quantity";
		var RefId = 0;
		var html = ""; //"<tr class='optionLine' id=" + this.optionLineID() + ">";
		var d = ((this.description.toLowerCase() == "null")? "NA" : this.description );
		var w = ((this.weight.toLowerCase() == "null")? "NA" : this.weight );
		var p = ((this.priceCDN.toLowerCase() == "null")? "NA" : this.priceCDN );
		p = ((isNumeric(p))? "$ " + parseFloat(p).toFixed(2) : p);
		html += "<td>" + d + "</td>";
		html += "<td style='text-align:center'>" + w + "</td>";
		html += "<td style='text-align:right'>" + p + "</td>";
		switch(this.htmlFormat) {
			case HTMLFormat.CHECKBOX 		:	html += "<td>";
												html += "<form action='updateCheckStatus()' class='checkbox_widget'>";
												html += "<input class='checkBox' id=" + this.checkStatusInputID() + " type='checkbox' onchange='updateCheckStatus(\"" + this.optionNum + "\")'>";
												html += "</form>";
												html += "</td>";
												break;
			case HTMLFormat.RADIOBUTTON 	:	break;
			case HTMLFormat.INC_DEC 		:	html += "<td>";
												html += "<form action='updateQuantity()' class='inc_dec_widget'>";
												html += "<input type=number, id=" + this.quantityInputID() + " onChange='updateQuantity(\"" + this.optionNum + "\")' value=" + this.quantity + ">";
												html += "</form>";
												html += "<button class=incrementButton onclick='increment(\"" + this.optionNum + "\"" + ",\"" + quantity + "\");'>+</button>";;
												html += "<button class=decrementButton onclick='decrement(\"" + this.optionNum + "\"" + ",\"" + quantity + "\");'>-</button>";
												html += "<button class=resetQuantityButton onclick='resetQuantity(\"" + this.optionNum + "\"" + ",\"" + quantity + "\");'>clear</button>";
												html += "</td>";
												break;
			case HTMLFormat.LIST_SELECTION 	:	break;
			case HTMLFormat.CHECKBOX 		:	console.log("ERROR has occurred");
		}
		// html += "</tr>";
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
		var html = "<td>" + titleCase(this.groupName) + "</td>";
		html += "<td>" + titleCase(this.sectionName) + "</td>";
		html += "<td>" + this.description + "</td>";
		return html;
	}
	
	
}

//	End BaseSpec class
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function getDescriptionSpan() {
	return "<span class='descriptionSpan'></span>";
}

function getWeightSpan() {
	return "<span class='weightSpan'></span>";
}

function getPriceSpan() {
	return "<span class='priceSpan'></span>";
}

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
// Updates the option's internal quantity and redisplays the HTML.
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

function resetQuantity(opNum, attr) {
	console.log("reset " + attr);
	op = lookUpOption(opNum);
	console.log("FOUND: " + op);
	if (op != null) {
		op[attr] = 0;
		op.updateHTML();
	}
	
}

function increment(opNum, attr) {
	console.log("increment " + attr);
	op = lookUpOption(opNum);
	console.log("FOUND: " + op);
	if (op != null) {
		op[attr] = Math.max(0, op[attr] + 1);
		op.updateHTML();
	}
}

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
	for (var i in OPTIONS) {
		var op = OPTIONS[i];
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
	for (var i in BASESPECS) {
		var bs = BASESPECS[i];
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
	op = new Option(elementID, optionNum, section, partNum, description, weight, cost, priceCDN, priceUS, priceMaterials, priceLabour, optionFlags, htmlFormat);
	OPTIONS.push(op);
	return op;
}

function createBaseSpec(idNum, groupName, sectionName, description, sortG, sortSE, sortGV2, sortSEV2) {
	b = new BaseSpec(idNum, groupName, sectionName, description, sortG, sortSE, sortGV2, sortSEV2);
	BASESPECS.push(b);
	return b;
}

function generateOptionHeader() {
	var html = "<thead>";
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
	var html = "<thead>";
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
	var str = generateOptionHeader();
	for (o in OPTIONS) {
		var op = OPTIONS[o];
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
	var str = generateBaseSpecHeader();
	for (b in BASESPECS) {
		var bs = BASESPECS[b];
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
	for (o in OPTIONS) {
		var op = OPTIONS[o];
		console.log("op	-	" + op + ", elem: " + op.elementID);
	}
}


OPTIONS = [];
//elementIDIn, optionNum, section, partNum, description, weight, priceCDN, priceUS, htmlFormat
var o1 = createOption("option001", "A1", "B1", "C1", "D1", "E1", "F1", "G1", HTMLFormat.INC_DEC);
var o2 = createOption("option002", "A2", "B2", "C2", "D2", "E2", "F2", "G2", HTMLFormat.CHECKBOX);
var o3 = createOption("option003", "A3", "B3", "C3", "D3", "E3", "F3", "G3", HTMLFormat.CHECKBOX);
var o4 = createOption("option004", "A4", "B4", "C4", "D4", "E4", "F4", "G4", HTMLFormat.INC_DEC);
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


BASESPECS = [];
var b1 = createBaseSpec("baseSpec001", "A1", "B1", "C1", "D1", "E1", "F1", "G1", "H1")
initAllBaseSpecHTML();