class_name Strings

###

# the same as text.lstrip(chars).rstrip(chars) I guess
static func strip(text: String, chars := " \t\n\r") -> String:
	var s_idx := 0
	var l_idx := text.length()
	for t in text:
		if not chars.contains(t): break
		s_idx += 1
	for i in range(l_idx - 1, -1, -1):
		if not chars.contains(text[i]): break
		l_idx -= 1
	return text.substr(s_idx, l_idx - s_idx)

static func get_lines(text: String, omit_empty := false, strip_edges := true) -> Array[String]:
	if text == null or text.is_empty(): return []
	var res: Array[String] = []
	for line in text.split("\n", false): 
		for l in line.split("\r", false):
			l = l.strip_edges()
			if omit_empty and l.is_empty(): continue
			res.append(l if strip_edges else l)
	return res

static func get_words(text: String) -> Array[String]:
	if text == null or text.is_empty(): return []
	var regex := RegEx.new()
	regex.compile("\"[^\"]+\"|[\\S]+") # Negated whitespace character class.
	var res: Array[String] = []
	for rm in regex.search_all(text): res.push_back(rm.get_string())
	return res

static func join(texts: Array, joiner: String, start_idx := 0) -> String:
	if texts == null or texts.is_empty(): return ""
	var res := ""
	for i in range(start_idx, texts.size()):
		if i != start_idx: res += joiner
		res += str(texts[i])
	return res
