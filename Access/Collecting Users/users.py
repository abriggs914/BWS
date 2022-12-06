

def print_by_line(value, do_print=True):
    lines = "\n".join(list(map(str, list(value))))
    if not do_print:
        return lines
    print(lines)


# 1 - BWS
# 2 - STARGATE
# 3 - LEWIS


lst = {
	'Avery Briggs': [1],
	'James Crawford': [1],
	'Jamie Merrithew': [1, 2],
	'Theresa Merrithew': [1, 2],
	'Shelley Holmes': [1, 2],
	'Glen Findlater': [1, 2],
	'Todd Saunders': [1, 2],
	'Ivan Cowperthwaite': [1],
	'Joanna Metherell': [1, 2, 3],
	'Sheila Piper': [1, 2, 3],
	'Jennifer Skarrup': [1],
	'Lori Piper': [1, 2],
	'Barry Blaney': [1],
	'Lloyd Orser': [1],
	'Matt Gillis': [1],
	'Jack Johnson': [1],
	'Yassin Nasser': [1],
	'Mohammad Darzaid': [1],
	'Stephen Boyd': [1],
	'Francis Campbell': [1],
	'Aaron Faulkner': [1],
	'Evan Findlater': [1],
	'Colin Richardson': [1],
	'Emma Bradbury': [1],
	'Rhonda Demerchant': [1],
	'Jason Somerville': [1],
	'Sarah Lord': [1],
	'Janet Orser': [1],
	'Ashlie Brown': [1],
	'Heather Clark': [1],
	'Jason Morgan': [1],
	'Charlie Guest': [1],
	'Mike Guest': [1],
	'Scott McCrae': [1],
	'Arnold Dill': [1],
	'Alfred Cass': [1],
	'Jamie Smith': [1],
	'Kyle Smith': [1],
	'Stephen Smith': [1],
	'Tony Underhill': [1],
	'Lester Brooker': [1],
	'Kyle Brooker': [1],
	'Rick Howard': [1],
	'Warehouse': [1],
	'Parts (Montana)': [1],
	'Joe McAdam': [1],
	'Mike Lyman': [1],
	'Mike Leach': [1],
	'Chelsey Hamilton': [1],
	'Matt Evans': [2],
	'Michele Vautour': [2],
	'Amir Kondri': [2],
	'Andrew Forbes': [2],
	'Asim Basoglu': [2],
	'Bharat Surujbally': [2],
	'Christopher Fallavollita': [2],
	'Darshan _': [2],
	'Glenn Farquhar': [2],
	'Greg Szutka': [2],
	'Hugo St-Cyr': [2],
	'Kishore Shanmugam': [2],
	'Marko Celic': [2],
	'Pamela Khelawan': [2],
	'Ralph Poleska': [2],
	'Saied Parsaeian': [2],
	'Timothy Garraway': [2],
	'Vince Fallavollita': [2],
	'Vishal Vivekanandan': [2],
	'Gary Thomas': [1],
	'Gaylon Smith': [1],
	'Jesse Hess': [1],
	'Larry Berry': [1],
	'Annie Cloutier': [3],
	'Guylaine Beauregard': [3],
}


if __name__ == "__main__":

	bws = {k: v for k, v in lst.items() if 1 in v}
	stargate = {k: v for k, v in lst.items() if 2 in v}
	lewis = {k: v for k, v in lst.items() if 3 in v}

	print(f"\n\n\tBWS\n{print_by_line(sorted(list(bws.keys())), do_print=False)}")
	print(f"\n\n\tSTARGATE\n{print_by_line(sorted(list(stargate.keys())), do_print=False)}")
	print(f"\n\n\tLEWIS\n{print_by_line(sorted(list(lewis.keys())), do_print=False)}")
