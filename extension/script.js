const brailleCodes = [
  { "character": "A", "brailleCode": "1", "string": "S" },
  { "character": "B", "brailleCode": "12", "string": "SD" },
  { "character": "C", "brailleCode": "14", "string": "SK" },
  { "character": "D", "brailleCode": "145", "string": "SJK" },
  { "character": "E", "brailleCode": "15", "string": "SK" },
  { "character": "F", "brailleCode": "124", "string": "SJD" },
  { "character": "G", "brailleCode": "1245", "string": "SJKK" },
  { "character": "H", "brailleCode": "125", "string": "SKJ" },
  { "character": "I", "brailleCode": "24", "string": "DJ" },
  { "character": "J", "brailleCode": "245", "string": "DFK" },
  { "character": "K", "brailleCode": "13", "string": "S" },
  { "character": "L", "brailleCode": "123", "string": "SDJ" },
  { "character": "M", "brailleCode": "134", "string": "SDF" },
  { "character": "N", "brailleCode": "1345", "string": "SDFK" },
  { "character": "O", "brailleCode": "135", "string": "SDK" },
  { "character": "P", "brailleCode": "1234", "string": "SDFJ" },
  { "character": "Q", "brailleCode": "12345", "string": "SDFKJ" },
  { "character": "R", "brailleCode": "1235", "string": "SDFK" },
  { "character": "S", "brailleCode": "234", "string": "DF" },
  { "character": "T", "brailleCode": "2345", "string": "DFK" },
  { "character": "U", "brailleCode": "136", "string": "SL" },
  { "character": "V", "brailleCode": "1236", "string": "SDFL" },
  { "character": "W", "brailleCode": "2456", "string": "SDJKL" },
  { "character": "X", "brailleCode": "1346", "string": "SDFKL" },
  { "character": "Y", "brailleCode": "13456", "string": "SDFKK" },
  { "character": "Z", "brailleCode": "1356", "string": "SDKK" }
];

let inputBuffer = "";

document.addEventListener("keydown", function(event) {
  const key = event.key.toLowerCase();

  if (event.ctrlKey && key === "control") {
    event.preventDefault();
    console.log("Ctrl key pressed. Buffer content: ", inputBuffer);
    const transformedText = transformText(inputBuffer.trim());
    console.log("Transformed text: ", transformedText);
    deleteAndInsertTextAtCursor(transformedText);
    inputBuffer = "";
  } else if (key === "backspace") {
    inputBuffer = inputBuffer.slice(0, -1);
    console.log("Backspace pressed. Buffer content: ", inputBuffer);
  } else if (key === " ") {
    inputBuffer += " ";
    console.log("Space pressed. Buffer content: ", inputBuffer);
  } else if (/^[a-z]$/i.test(key)) {
    inputBuffer += key;
    console.log("Key pressed: ", key, ". Buffer content: ", inputBuffer);
  }
});

function transformText(text) {
  console.log("Original text to transform: ", text);
  const words = text.split("  ");
  console.log("Split words: ", words);
  const transformedWords = words.map(word => {
    const transformedWord = word.split(" ").map(seq => {
      const brailleObj = brailleCodes.find(b => b.string.toLowerCase() === seq.toLowerCase());
      return brailleObj ? brailleObj.character : seq;
    }).join("");
    console.log(`Transformed word: ${word} -> ${transformedWord}`);
    return transformedWord;
  });
  const finalText = transformedWords.join(" ");
  console.log("Final transformed text: ", finalText);
  return finalText;
}


function deleteAndInsertTextAtCursor(text) {
    const activeElement = document.activeElement;
    const bufferLength = inputBuffer.length;

        if (activeElement.tagName === "INPUT" || activeElement.tagName === "TEXTAREA") {
        const start = activeElement.selectionStart;
        const end = activeElement.selectionEnd; // Get the end position for deletion

        // Delete text before the cursor
        activeElement.value = activeElement.value.substring(0, start - inputBuffer.length); 
        
        // Insert the transformed text
        activeElement.value += text; 

        // Set the cursor to the end of the inserted text
        activeElement.setSelectionRange(start + text.length, start + text.length); 
    } else if (activeElement.isContentEditable) {
        // Content editable logic (unchanged)
        const range = window.getSelection().getRangeAt(0);
        range.setStart(range.startContainer, range.startOffset - bufferLength);
        range.deleteContents();
        range.insertNode(document.createTextNode(text));
        range.setStart(range.endContainer, range.endOffset);
        range.setEnd(range.endContainer, range.endOffset);
        window.getSelection().removeAllRanges();
        window.getSelection().addRange(range);
    } else if (document.execCommand) {
        // execCommand fallback (unchanged)
        for (let i = 0; i < bufferLength; i++) {
            document.execCommand("delete", false, null);
        }
        document.execCommand("insertText", false, text);
    }
}

