module.exports = CrazyFormatter =

  activate: (state) ->
    return

  deactivate: ->
    return

  provideFormatter: ->
    formatter =
      dispose: ->
      selector: '.source.cpp',
      getNewText: (text) =>
        new Promise (resolve) =>
          resolve(@getNextText(text))

  getNextText: (text) ->
    newText = []
    lines = text.split('\n')
    start = 0
    while start < lines.length
      # If several consecutive tokens detected, append to the previous line
      closeEnd = @detectTokenRange(lines, start, '}')
      if closeEnd != start
        newText[newText.length - 1] += '}'.repeat(closeEnd - start)
      else
        # Otherwise, pad the line with the special tokens at the end
        newText.push(@padLine(lines[start], [';', '{']))

      start += if closeEnd == start then 1 else closeEnd - start
    return newText.join('\n')

  detectTokenRange: (lines, start, token) ->
    end = start
    while end < lines.length and lines[end].trim() == token
      end += 1
    return end


  padLine: (line, tokens) ->
    # Check if the line ends with a token
    lastChar = line[line.length - 1]
    token = tokens.find((x) -> x == lastChar)

    # Pad the line and add the token
    if token
      return line.substring(0, line.length - 1).padEnd(80) + token
    else
      return line.padEnd(80)
