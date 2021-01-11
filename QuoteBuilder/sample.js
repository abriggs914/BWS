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
		var html = "<p>"
		switch(this.htmlFormat) {
			case HTMLFormat.CHECKBOX 		:	break;
			case HTMLFormat.RADIOBUTTON 	:	break;
			case HTMLFormat.INC_DEC 		:	html += this.groupInfo();
												html += "<form action='updateQuantity()'><label>quantity: </label><input type=number, id=" + this.quantityInputID() + " onChange='updateQuantity(\"" + this.optionNum + "\")' value=" + this.quantity + "></form>"
												html += "<button class=incrementButton onclick='increment(\"" + this.optionNum + "\"" + ",\"" + quantity + "\");'>+</button>";
												html += "<button class=decrementButton onclick='decrement(\"" + this.optionNum + "\"" + ",\"" + quantity + "\");'>-</button>";
												break;
			case HTMLFormat.LIST_SELECTION 	:	break;
			case HTMLFormat.CHECKBOX 		:	console.log("ERROR has occurred");
		}
		html += "</p>";
		return html;
	}
	
	updateHTML() {
		document.getElementById(this.elementID).innerHTML = this.getHTML();
	}
	
	toString() {
		return this.optionNum + " x " + this.quantity;
	}
}

// Called when the input value of the quantity input field is manually typed in.
// Updates the options internal quantity and redisplays the HTML.
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
		if (OPTIONS[i].optionNum == opNum) {
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


OPTIONS = []
var o = createOption("option001", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", HTMLFormat.INC_DEC);
console.log("OPTION: " + o);
console.log("OPTION HTML: " + o.getHTML());
o.updateHTML();
document.getElementById("option001").innerHTML = o.getHTML();