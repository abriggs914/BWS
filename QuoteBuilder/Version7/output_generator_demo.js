const delim = "__";
const model_tag = delim + "MODEL";
const contact_tag = delim + "CONTACT";
const name_tag = delim + "CNAME";
const cemail_tag = delim + "CEMAIL";
const cphone_tag = delim + "CPHONE";
const dealer_tag = delim + "DEALER";
const branch_tag = delim + "BRANCH";
const customer_tag = delim + "CUSTOMER";
const option_list_tag = delim + "OPTIONSLIST";
const option_tag = delim + "OPTIONID";
const comment_tag = delim + "COMMENT";
const qcomment_tag = delim + "QCOMMENT";

function raw_format(model, options, option_comments, q_comment, contact, c_email, c_phone, dealer, branch, customer) {
	
	var contents = model_tag + "<" + model + ">";
	contents += contact_tag + "<";
	contents += name_tag  + "<" + contact + ">";
	contents += cemail_tag + "<" + c_email + ">";
	contents += cphone_tag + "<" + c_phone + ">";
	contents += dealer_tag + "<" + dealer + ">";
	contents += branch_tag + "<" + branch + ">";
	contents += customer_tag + "<" + customer + ">";
	contents += ">";
	contents += option_list_tag + "<";
	for (let i = 0; i < options.length; i++) {
		var op_id = options[i];
		var op_comment = option_comments[i];
		contents += option_tag + "<" + op_id[0] + " x " + op_id[1] + "<" + comment_tag + "<" + op_comment + ">>>";
	}
	// contents += "".join([option_tag + "<" + op_id[0] + " x " + op_id[1] + "<" + comment_tag + "<" + op_comment + ">>>" for op_id, op_comment in zip(options, option_comments)])
	contents += ">";
	contents += qcomment_tag + "<" + q_comment + ">";
	
	return contents;
}

function rich_format(model, options, option_comments, q_comment, contact, c_email, c_phone, dealer, branch, customer) {
	var raw = raw_format(model, options, option_comments, q_comment, contact, c_email, c_phone, dealer, branch, customer);
	var content = "";
	let i = 0;
	let nest = 0;
	var joined = raw.split("<").join("<\n\t").split(">").join("\n>")
	while (i < raw.length) {
		if (raw[i] == "<") {
			nest += 1;
			content += "<\n";
			
			var prefix = "";
			for (let j = 0; j < nest; j++) {
				prefix += "\t";
			}
			content += prefix
		}
		else if (raw[i] == ">") {
			nest -= 1;
			
			var prefix = "";
			for (let j = 0; j < nest; j++) {
				prefix += "\t";
			}
			
			content += "\n" + prefix + ">\n" + prefix;
		}
		else {
			content += raw[i];
		}
		i++;
	}
	return content
}


const model = "37DT3X V2018";
const options = [[1, 1], [2, 6], [1, 11], [2, 6]];
const option_comments = ["", "2 pr. GNK, 4 pr. B/T", "", ""];
const q_comment = "Can you also include lead time?";
const contact = "John Doe";
const c_email = "John.Doe@email.com";
const c_phone = "(506)-123-4567-123";
const dealer = "Dealer 1";
const branch = "Branch 1";
const customer = "John Doe Jr.";

console.log("\n\tRaw format\n" + raw_format(
	model,
	options,
	option_comments,
	q_comment,
	contact,
	c_email,
	c_phone,
	dealer,
	branch,
	customer
));

console.log("\n\tRich format\n" + rich_format(
	model,
	options,
	option_comments,
	q_comment,
	contact,
	c_email,
	c_phone,
	dealer,
	branch,
	customer
));