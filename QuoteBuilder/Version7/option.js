
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Begin Option class

class Option {
	constructor(modelIn, elementIDIn, optionNumIn, sectionIn, partNumIn, descriptionIn, weightIn, priceCDNIn, priceUSIn) {
		this.model = modelIn;
		this.elementID = elementIDIn;
		this.optionNum = optionNumIn;
		this.section = sectionIn;
		this.partNum = partNumIn;
		this.description = descriptionIn;
		this.weight = weightIn;
		this.priceCDN = priceCDNIn;
		this.priceUS = priceUSIn;
		
		this.quantity = 0;
		this.checkedStatus = false;
		this.htmlform = HTMLFormat.INC_DEC;  // default, all options can be incremented to at least 1.
		this.minRange = 0;
		this.maxRange = 1;
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
	
	setHTMLFormat(htmlFormat) {
		this.htmlform = htmlFormat;
	}

    setMinRange(minRangeIn) {
        this.minRange = Math.min(0, minRangeIn)
        if (this.maxRange <= this.minRange) {
            this.maxRange = this.minRange + 1
        }
    }

    setMaxRange(maxRangeIn) {
        this.maxRange = Math.max(0, maxRangeIn)
        if (this.maxRange <= this.minRange) {
            this.minRange = Math.max(0, this.maxRange - 1)
        }
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
		let html = "NONE"; //"<tr class='optionLine' id=" + this.optionLineID() + ">";
		let d = ((this.description.toLowerCase() == "null")? "NA" : this.description );
		let w = ((this.weight.toLowerCase() == "null")? "NA" : this.weight );
		let p = ((this.priceCDN.toLowerCase() == "null")? "NA" : this.priceCDN );
		p = ((isNumeric(p))? "$ " + parseFloat(p).toFixed(2) : p);
		if (this.htmlform == HTMLFormat.INC_DEC) {
			html = "<td class='description-cell' onclick='increment(\"" + this.model.modelName + "\", \"" + this.optionNum + "\"" + ",\"quantity\")'>" + d + "</td>";
			html += "<td style='text-align:center' onclick='increment(\"" + this.model.modelName + "\", \"" + this.optionNum + "\"" + ",\"quantity\")'>" + w + "</td>";
			html += "<td style='text-align:right' onclick='increment(\"" + this.model.modelName + "\", \"" + this.optionNum + "\"" + ",\"quantity\")'>" + p + "</td>";
			html += "<td>";
			html += "<form action='updateQuantity()' class='inc_dec_widget'>";
			html += "<input type=number, id=" + this.quantityInputID() + " onChange='updateQuantity(\"" + this.model.modelName + "\", \"" + this.optionNum + "\")' value=" + this.quantity + ">";
			html += "</form>";
			html += "<button class=incrementButton onclick='increment(\"" + this.model.modelName + "\", \"" + this.optionNum + "\"" + ",\"" + quantity + "\")'>+</button>";
			html += "<button class=decrementButton onclick='decrement(\"" + this.model.modelName + "\", \"" + this.optionNum + "\"" + ",\"" + quantity + "\")'>-</button>";
			html += "<button class=resetQuantityButton onclick='resetQuantity(\"" + this.model.modelName + "\", \"" + this.optionNum + "\"" + ",\"" + quantity + "\");'>clear</button>";
			html += "</td>";
			html += "";
		}
		else if (this.htmlform == HTMLFormat.SLIDER) {
			let half = (this.minRange + this.maxRange) / 2;
			html = "<td>" + d + "</td>";
			html += "<td style='text-align:center'>" + w + "</td>";
			html += "<td style='text-align:right'>" + p + "</td>";
			html += "<td> <input class='slider' type='range' min=" + this.minRange + " max=" + this.maxRange + " value=" + half + " class='slider'></input> </td>";
		}
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