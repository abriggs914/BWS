
const HTMLFormat = {
	CHECKBOX: "checkbox",
	RADIOBUTTON: "radiobutton",
	INC_DEC: "inc_dec",
	LIST_SELECTION: "list_selection"
}

MIN_PAD_WIDTH = 10;
MIN_DESC_WIDTH = 65;


class Option {
	constructor(optionNum, section, partNum, description, weight, cost, priceCDN, priceUS, priceMaterials, priceLabour, optionFlags, htmlFormat) {
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
		return str;
	}
	
	getHTML() {
		var html = "<p>"
		switch(this.htmlFormat) {
			case HTMLFormat.CHECKBOX 		:	break;
			case HTMLFormat.RADIOBUTTON 	:	break;
			case HTMLFormat.INC_DEC 		:	html += this.groupInfo();
												html += "<button class=incrementButton onclick=increment(this)>+</button>";
												html += "<button class=decrementButton onclick=decrement(this)>-</button>";
												break;
			case HTMLFormat.LIST_SELECTION 	:	break;
			case HTMLFormat.CHECKBOX 		:	console.log("ERROR has occurred");
		}
		html += "</p>";
		return html;
	}
}


var o = new Option("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", HTMLFormat.INC_DEC);
console.log("OPTION: " + o);
console.log("OPTION HTML: " + o.getHTML());
document.getElementById("option001").innerHTML = o.getHTML();