
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