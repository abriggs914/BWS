const HTMLFormat = {
	CHECKBOX: "checkbox",
	RADIOBUTTON: "radiobutton",
	INC_DEC: "inc_dec",
	LIST_SELECTION: "list_selection"
}

MIN_PAD_WIDTH = 10;
MIN_DESC_WIDTH = 65;


class Option {
	constructor(elementIDIn, optionNum, section, partNum, description, weight, cost, priceCDN, priceUS, priceMaterials, priceLabour, optionFlags, htmlFormat) {
		this.elementID = elementIDIn;
		this.optionNum = optionNum;
		this.section = section;
		this.partNum = partNum;
		this.description = description;
		this.weight = weight;
		this.cost = cost;
		this.priceCDN = priceCDN;
		this.priceUS = priceUS;
		this.priceMaterials = priceMaterials;
		this.priceLabour = priceLabour;
		this.optionFlags = optionFlags;
		this.htmlFormat = htmlFormat;
		
		this.quantity = 0;
		this.checkedStatus = false;
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
	
	getHTML() {
		var quantity = "quantity";
		var RefId = 0;
		var html = "<tr class='optionLine'>";
		html += "<td>" + this.description + "</td>";
		// html += "<span class='descriptionSpan'></span>";
		html += "<td>" + this.weight + "</td>";
		// html += "<span class='weightSpan'></span>";
		html += "<td>" + this.priceCDN + "</td>";
		// html += "<span class='priceSpan'></span>";
		switch(this.htmlFormat) {
			case HTMLFormat.CHECKBOX 		:	html += "<td><form action='updateCheckStatus()' id=" + this.checkStatusInputID() + "></form>"
												html += "<input class='checkBox' type='checkbox'></td>";
												break;
			case HTMLFormat.RADIOBUTTON 	:	break;
			case HTMLFormat.INC_DEC 		:	html += "<td><form action='updateQuantity()' class='inc_dec_widget'><label>quantity: </label><input type=number, id=" + this.quantityInputID() + " onChange='updateQuantity(\"" + this.optionNum + "\")' value=" + this.quantity + "></form>";
												html += "<button class=incrementButton onclick='increment(\"" + this.optionNum + "\"" + ",\"" + quantity + "\");'>+</button>";
												html += "<button class=decrementButton onclick='decrement(\"" + this.optionNum + "\"" + ",\"" + quantity + "\");'>-</button></td>";
												break;
			case HTMLFormat.LIST_SELECTION 	:	break;
			case HTMLFormat.CHECKBOX 		:	console.log("ERROR has occurred");
		}
		html += "</tr>";
		return html;
	}
	
	updateHTML() {
		console.log("hey there");
		// document.getElementById(this.elementID).innerHTML = this.getHTML();
	}
	
	toString() {
		return this.optionNum + " x " + this.quantity;
	}
}

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
		op.checkStatus = document.getElementById();
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
			op.quantity = Number(str);
			op.updateHTML();
		}
	}
}

function increment(opNum, attr) {
	console.log("increment");
	op = lookUpOption(opNum);
	console.log("FOUND: " + op);
	if (op != null) {
		op[attr]++;
		op.updateHTML();
	}
}

function decrement(opNum, attr) {
	console.log("decrement");
	op = lookUpOption(opNum);
	console.log("FOUND: " + op);
	if (op != null) {
		op[attr]--;
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
	for (i in OPTIONS) {
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


// Use this function to create options.
// This ensures that the option will be included in the OPTIONS array.
function createOption(elementID, optionNum, section, partNum, description, weight, cost, priceCDN, priceUS, priceMaterials, priceLabour, optionFlags, htmlFormat) {
	op = new Option(elementID, optionNum, section, partNum, description, weight, cost, priceCDN, priceUS, priceMaterials, priceLabour, optionFlags, htmlFormat);
	OPTIONS.push(op);
	return op;
}

function generateHeader() {
	var html = "<tr>";
    html += "<th>Description</th>";
    html += "<th>Weight</th>";
    html += "<th>Price</th>";
	html += "</tr>";
	// var html = "<p>Description</p>";
	// html += getDescriptionSpan();
	// html += "<p>Weight</p>";
	// html += getWeightSpan();
	// html += "<p>Price</p>";
	// html += getPriceSpan();
	// document.getElementById("optionsHeader").innerHTML = html;
	return html;
}

function updateAllHTML() {
	var str = generateHeader();
	for (o in OPTIONS) {
		var op = OPTIONS[o];
		str += op.getHTML();
	}
	document.getElementById("optionsList").innerHTML = str;
}

function printOptions() {
	console.log("\tOptions:");
	for (o in OPTIONS) {
		var op = OPTIONS[o];
		console.log("op	-	" + op + ", elem: " + op.elementID);
	}
}


OPTIONS = []
var o1 = createOption("option001", "A1", "B1", "C1", "D1", "E1", "F1", "G1", "H1", "I1", "J1", "K1", HTMLFormat.INC_DEC);
var o2 = createOption("option002", "A2", "B2", "C2", "D2", "E2", "F2", "G2", "H2", "I2", "J2", "K2", HTMLFormat.CHECKBOX);
// var o = createOption("option001", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", HTMLFormat.INC_DEC);
console.log("OPTION: " + o1);
console.log("OPTION: " + o2);
console.log("OPTION HTML: " + o1.getHTML());
console.log("OPTION HTML: " + o2.getHTML());
// document.getElementById("option001").innerHTML = o1.getHTML();
// document.getElementById("option002").innerHTML = o2.getHTML();
updateAllHTML();