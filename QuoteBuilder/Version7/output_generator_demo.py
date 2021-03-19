

# Adjust these to change the output data.
model = "37DT3X V2018"
options = [(1, 1), (2, 6), (1, 11), (2, 6)]
option_comments = ["", "2 pr. GNK, 4 pr. B/T", "", ""]
q_comment = "Can you also include lead time?"
contact = "John Doe"
c_email = "John.Doe@email.com"
c_phone = "(506)-123-4567-123"
dealer = "Dealer 1"
branch = "Branch 1"
customer = "John Doe Jr."

# pre-set data headers, DO NOT CHANGE! These are what the parser will be looking for:
delim = "__"
model_tag = delim + "MODEL"
contact_tag = delim + "CONTACT"
name_tag = delim + "CNAME"
cemail_tag = delim + "CEMAIL"
cphone_tag = delim + "CPHONE"
dealer_tag = delim + "DEALER"
branch_tag = delim + "BRANCH"
customer_tag = delim + "CUSTOMER"
option_list_tag = delim + "OPTIONSLIST"
option_tag = delim + "OPTIONID"
comment_tag = delim + "COMMENT"
qcomment_tag = delim + "QCOMMENT"


# Build the output string
# I tried to maintain a nested data structure as best I could, but settled on 4 main headers in the output: 
# MODEL, CONTACT, OPTIONSLIST, QCOMMENT) inside each tag is a nested data structure.
# Output follows formatting:
# model: 
#	name
# contact:
#	name,	
#	email,
#	phone,	
#	dealer,	
#	branch,	
#	customer
# options list: (max 20)
#	quantity x optionID
#		option comment/description
# quote comment:
#	global quote comment for questions/clarification,

contents = model_tag + "<" + model + ">"
contents += contact_tag + "<" 
contents += name_tag  + "<" + contact + ">" 
contents += cemail_tag + "<" + c_email + ">"
contents += cphone_tag + "<" + c_phone + ">"
contents += dealer_tag + "<" + dealer + ">"
contents += branch_tag + "<" + branch + ">"
contents += customer_tag + "<" + customer + ">"
contents += ">"
contents += option_list_tag + "<" 
contents += "".join([option_tag + "<" + str(op_id[0]) + " x " + str(op_id[1]) + "<" + comment_tag + "<" + op_comment + ">>>" for op_id, op_comment in zip(options, option_comments)])
contents += ">"
contents += qcomment_tag + "<" + q_comment + ">"

# display
print(contents)