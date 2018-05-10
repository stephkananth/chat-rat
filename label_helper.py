import operator

def json_to_txt(username):
	# Opens the json file with labels for each image
	file_json = open('labels/instagram_%s.json' % (username), 'r')
	label_map = dict()
	for line in file_json:
		# Finds relevant lines and cleans them
		if 'description' in line:
			label = line.replace('"description": ', '').replace(',', '').replace('"', '').strip()
			# Creates a label dictionary with the label as the key and the count of occurances as the value
			if label in label_map:
				label_map[label] += 1
			else:
				label_map[label] = 1
	# Sorts the dictionary and stores it in a 2D array sorted by the frequency in descending order
	label_array = sorted(label_map.items(), key=operator.itemgetter(1))[::-1]
	file_txt = open('labels/instagram_%s.txt' % (username), 'w')
	# Creates the text file as a list of labels
	for label_tuple in label_array:
		file_txt.write(label_tuple[0] + ', ')
	file_txt.close()