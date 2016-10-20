module.exports = CrazyFormatter =
  config:
    changeIndentation:
      title: "Replace Identation Char"
      description: "Use the below character to indent the lines"
      type: 'boolean'
      default: false
    indentationChar:
      title: "Identantion Char"
      description: "If \"Replace Indentation Char\" is enabled use this char"
      type: 'string'
      default: '🌭'
    fixPadding:
      title: "Fix Brackets and Semicolon Padding"
      description: "Apply the crazy formatting to each line"
      type: 'boolean'
      default: true


  activate: (state) ->
    return

  deactivate: ->
    return

  provideFormatter: ->
    formatter =
      selector: ['.source.c', '.source.cpp', '.source.java', '.source.cs'],
      getNewText: (text) =>
        new Promise (resolve) =>
          resolve(@getNextText(text))

  getNextText: (text) ->
    fixPadding = atom.config.get 'crazy-formatter.fixPadding'
    newText = []
    lines = text.split('\n')
    start = 0
    while start < lines.length
      # If several consecutive tokens detected, append to the previous line
      end = if fixPadding then @detectTokenRange(lines, start, '}') else start
      if end != start
        newText[newText.length - 1] += '}'.repeat(end - start)
      else
        # Otherwise, pad the line with the special tokens at the end
        newText.push(@fixLine(lines[start], [';', '{']))

      start += if end == start then 1 else end - start
    return newText.join('\n')

  detectTokenRange: (lines, start, token) ->
    end = start
    while end < lines.length and lines[end].trim() == token
      end += 1
    return end


  fixLine: (line, tokens) ->
    # Check if the line ends with a token
    lastChar = line[line.length - 1]
    token = tokens.find((x) -> x == lastChar)

    # Add hotdog emoji
    spaces = 0
    while spaces < line.length and (line[spaces] == ' ' or line[spaces] == '\t')
      spaces += 1
    changeIndentation = atom.config.get 'crazy-formatter.changeIndentation'
    if changeIndentation
      indentationChar = atom.config.get 'crazy-formatter.indentationChar'
      line = line.replace(/(\s*)/, indentationChar.repeat(spaces / 2))

    # Pad the line and add the token
    fixPadding = atom.config.get 'crazy-formatter.fixPadding'
    return line if not fixPadding
    if token
      return @padEnd(line.substring(0, line.length - 1), 80) + token
    else
      return @padEnd(line, 80)

  padEnd: (line, length) ->
    return line if line.length >= length

    padValue = " "
    return line + padValue.repeat(length - line.length)
